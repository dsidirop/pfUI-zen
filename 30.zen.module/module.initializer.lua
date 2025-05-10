local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local S = using "System.Helpers.Strings"

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Throw = using "System.Exceptions.Throw"
local Exception = using "System.Exceptions.Exception"

local Pfui = using "Pavilion.Warcraft.Addons.Zen.Externals.Pfui"
local PfuiGui = using "Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Gui"
local Enumerable = using "Pavilion.Warcraft.Addons.Zen.Externals.MTALuaLinq.Enumerable"

local AddonsService = using "Pavilion.Warcraft.Addons.AddonsService"
local TranslationsService = using "Pavilion.Warcraft.Addons.Zen.Foundation.Internationalization.TranslationsService"
local ZenEngineCommandHandlersService = using "Pavilion.Warcraft.Addons.Zen.Domain.CommandingServices.ZenEngineCommandHandlersService"
local UserPreferencesQueryableService = using "Pavilion.Warcraft.Addons.Zen.Persistence.Services.AddonSettings.UserPreferences.QueryableService"

local UserPreferencesForm = using "Pavilion.Warcraft.Addons.Zen.Controllers.UI.Pfui.Forms.UserPreferencesForm"
local StartZenEngineCommand = using "Pavilion.Warcraft.Addons.Zen.Controllers.Contracts.Commands.ZenEngine.RestartEngineCommand"

Pfui:RegisterModule("Zen", "vanilla:tbc", function()
    Scopify(EScopes.Function, {})

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
                :New(TranslationsService:New())
                :EventRequestingCurrentUserPreferences_Subscribe(function(_, ea_)
                    Guard.Assert.IsNotNil(ea_, "ea")
                    Guard.Assert.IsNotNil(ea_.Response, "ea.Response")

                    ea_.Response.UserPreferences = UserPreferencesQueryableService:New():GetAllUserPreferences()
                end)
                :Initialize() -- @formatter:on

    ZenEngineCommandHandlersService:New():Handle_RestartEngineCommand(StartZenEngineCommand:New())
end)
