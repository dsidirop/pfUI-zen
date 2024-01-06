local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local S = using "System.Helpers.Strings"

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Throw = using "System.Exceptions.Throw"
local Exception = using "System.Exceptions.Exception"

local PfuiGui = using "Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Gui"
local Enumerable = using "Pavilion.Warcraft.Addons.Zen.Externals.MTALuaLinq.Enumerable"

local TranslationsService = using "Pavilion.Warcraft.Addons.Zen.Foundation.Internationalization.TranslationsService"

local UserPreferencesForm = using "Pavilion.Warcraft.Addons.Zen.Controllers.UI.Pfui.Forms.UserPreferencesForm"
local StartZenEngineCommand = using "Pavilion.Warcraft.Addons.Zen.Controllers.Contracts.Commands.ZenEngine.RestartEngineCommand"
local ZenEngineCommandHandlersService = using "Pavilion.Warcraft.Addons.Zen.Domain.CommandingServices.ZenEngineCommandHandlersService"
local UserPreferencesServiceQueryable = using "Pavilion.Warcraft.Addons.Zen.Persistence.Services.AddonSettings.UserPreferences.ServiceQueryable"

-- inspired by pfUI-eliteOverlay.lua
local function Main(_pfUI)
    _pfUI:RegisterModule("Zen", "vanilla:tbc", function()
        Scopify(EScopes.Function, {})

        local _g = _pfUI:GetEnvironment()

        local _t = _g.assert(_g.pfUI.env.T) -- pfUI translations
        local _getAddOnInfo = _g.assert(_g.GetAddOnInfo) -- wow api   todo  put this in a custom class called Zen.AddonsHelpers or something

        local addon = {
            ownName = "Zen",
            fullName = "pfUI [Zen]",
            folderName = "pfUI-Zen",

            ownNameColored = "|cFF7FFFD4Zen|r",
            fullNameColored = "|cff33ffccpf|r|cffffffffUI|r|cffaaaaaa [|r|cFF7FFFD4Zen|r|cffaaaaaa]|r",

            fullNameColoredForErrors = "|cff33ffccpf|r|cffffffffUI|r|cffaaaaaa [|r|cFF7FFFD4Zen|r|cffaaaaaa]|r|cffff5555"
        }

        local addonPath = Enumerable -- @formatter:off   detect current addon path
                            .FromList({ "", "-dev", "-master", "-tbc", "-wotlk" })
                            :Select(function (postfix)
                                local name, _, _, enabled = _getAddOnInfo(addon.folderName .. postfix)
                                return { path = name, enabled = enabled or 0 }
                            end)
                            :Where(function (x) return x.enabled == 1 end)
                            :Select(function (x) return x.path end)
                            :FirstOrDefault() -- @formatter:on

        if (not addonPath) then
            Throw(Exception:New(S.Format("[PFUIZ.IM000] %s : Failed to find addon folder - please make sure that the addon is installed correctly!", addon.fullNameColoredForErrors)))
        end

        if (not PfuiGui.CreateGUIEntry) then
            Throw(Exception:New(S.Format("[PFUIZ.IM010] %s : The addon needs a recent version of pfUI (2023+) to work as intended - please update pfUI and try again!", addon.fullNameColoredForErrors)))
        end
        
        local translationsService = TranslationsService:New()

        UserPreferencesForm -- @formatter:off
                :New(translationsService)
                :EventRequestingCurrentUserPreferences_Subscribe(function(_, ea)
                    ea.Response.UserPreferences = UserPreferencesServiceQueryable:New():GetAllUserPreferences()
                end)
                :Initialize() -- @formatter:on

        ZenEngineCommandHandlersService:New():Handle_RestartEngineCommand(StartZenEngineCommand:New())
    end)
end

Main(assert(pfUI))
