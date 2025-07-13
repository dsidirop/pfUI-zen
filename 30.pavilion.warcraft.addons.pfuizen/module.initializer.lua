--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

using "[healthcheck] [all]"

local S = using "System.Helpers.Strings"

local Guard = using "System.Guard"

local Throw = using "System.Exceptions.Throw"
local Exception = using "System.Exceptions.Exception"

local Pfui = using "Pavilion.Warcraft.Addons.Bindings.Pfui.Pfui"
local PfuiGui = using "Pavilion.Warcraft.Addons.Bindings.Pfui.PfuiGui"
local Enumerable = using "Pavilion.Warcraft.Addons.PfuiZen.Externals.MTALuaLinq.Enumerable"

local AddonsService = using "Pavilion.Warcraft.Foundation.Addons.AddonsService"
local ComboTranslationsService = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Internationalization.ComboTranslationsService"
local ZenEngineCommandHandlersService = using "Pavilion.Warcraft.Addons.PfuiZen.Mediators.ForZenEngine.ZenEngineMediatorService"
local UserPreferencesQueryableService = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Services.AddonSettings.UserPreferences.QueryableService"

local UserPreferencesForm = using "Pavilion.Warcraft.Addons.PfuiZen.Controllers.UI.Pfui.Forms.UserPreferencesForm"
local StartZenEngineCommand = using "Pavilion.Warcraft.Addons.PfuiZen.Controllers.Contracts.Commands.ZenEngine.RestartEngineCommand"

Pfui:RegisterModule("Zen", "vanilla:tbc", function()
    
    local addon = {
        folderName = "pfUI-Zen",
        fullNameColoredForErrors = "|cff33ffccpf|r|cffffffffUI|r|cffaaaaaa [|r|cFF7FFFD4Zen|r|cffaaaaaa]|r|cffff5555"

        -- ownName = "Zen",
        -- fullName = "pfUI [Zen]",
        -- ownNameColored = "|cFF7FFFD4Zen|r",
        -- fullNameColored = "|cff33ffccpf|r|cffffffffUI|r|cffaaaaaa [|r|cFF7FFFD4Zen|r|cffaaaaaa]|r",
    }

    local addonsService = AddonsService:New()

    local addonPath = Enumerable -- @formatter:off   detect current addon path   todo  consolidate this into the healthcheck-service
                            .FromList({ "", "-dev", "-master", "-tbc", "-wotlk" })
                            :Select(function (postfix) return addonsService:TryGetAddonInfoByFolderName(addon.folderName .. postfix) end)
                            :Where(function (addonInfo) return addonInfo and addonInfo:IsLoaded() end)
                            :Select(function (addonInfo) return addonInfo:GetFolderName() end)
                            :FirstOrDefault() -- @formatter:on

    if (not addonPath) then
        Throw(Exception:New(S.Format("[PFUIZ.IM000] %s : Failed to find addon folder - please make sure that the addon is installed correctly!", addon.fullNameColoredForErrors)))
    end

    if (not PfuiGui.CreateGUIEntry) then
        Throw(Exception:New(S.Format("[PFUIZ.IM010] %s : The addon needs a recent version of pfUI (2023+) to work as intended - please update pfUI and try again!", addon.fullNameColoredForErrors)))
    end

    UserPreferencesForm -- @formatter:off   todo  consolidate this into the gui-service
                :New(ComboTranslationsService:New())
                :EventRequestingCurrentUserPreferences_Subscribe(function(_, ea_)
                    Guard.Assert.IsNotNil(ea_, "ea")
                    Guard.Assert.IsNotNil(ea_.Response, "ea.Response")

                    ea_.Response.UserPreferences = UserPreferencesQueryableService:New():GetAllUserPreferences()
                end)
                :Initialize() -- @formatter:on

    ZenEngineCommandHandlersService:New():Handle_RestartEngineCommand(StartZenEngineCommand:New())
end)
