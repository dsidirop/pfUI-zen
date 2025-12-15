--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

using "[healthcheck] [all]"

local S = using "System.Helpers.Strings"

local Guard     = using "System.Guard"
local Throw     = using "System.Exceptions.Throw"
local Exception = using "System.Exceptions.Exception"

local Enumerable = using "Pavilion.Warcraft.Addons.PfuiZen.Externals.MTALuaLinq.Enumerable"

local Pfui                                   = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.RawBindings.Pfui" -- todo  replace this with a service
local PfuiMainSettingsFormGuiControlsFactory = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.PfuiMainSettingsFormGuiControlsFactory"

local AddonsService                  = using "Pavilion.Warcraft.Foundation.Addons.AddonsService"
local ComboTranslationsService       = using "Pavilion.Warcraft.Foundation.Internationalization.ComboTranslationsService"

local AutolootEngineMediatorService   = using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Mediators.ForAutolootEngine.AutolootEngineMediatorService"
local UserPreferencesQueryableService = using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Persistence.Services.AddonSettings.UserPreferences.QueryableService"

local PfuiTranslatorService   = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.PfuiTranslatorService"
local ZenOwnTranslatorService = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Internationalization.OwnTranslatorService"

local UserPreferencesForm                      = using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Controllers.ViaPfui.Forms.AutolootUserPreferencesForm"
local RestartAutolootEngineIfApplicableCommand = using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Controllers.Contracts.Commands.EngineControl.RestartEngineIfApplicableCommand"  --[[@formatter:on]]

Pfui:RegisterModule("ZenAutoloot", "vanilla:tbc", function()

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

    if not addonPath then
        Throw(Exception:New(S.Format("[PFUIZA.IM000] %s : Failed to find addon folder - please make sure that the addon is installed correctly!", addon.fullNameColoredForErrors)))
    end

    local comboTranslationsService = ComboTranslationsService:New(ZenOwnTranslatorService:NewForActiveUILanguage(), PfuiTranslatorService:New()) -- todo   put all of these in di
    local autolootEngineMediatorService = AutolootEngineMediatorService:New() -- todo   put this in di (probably as singleton)
    local pfuiMainSettingsFormGuiControlsFactory = PfuiMainSettingsFormGuiControlsFactory:New()
    
    UserPreferencesForm -- @formatter:off   todo  consolidate this into the gui-service
                :New(pfuiMainSettingsFormGuiControlsFactory, autolootEngineMediatorService, comboTranslationsService)
                :EventRequestingCurrentUserPreferences_Subscribe(function(_, ea_)
                    Guard.Assert.IsNotNil(ea_, "ea")
                    Guard.Assert.IsNotNil(ea_.Response, "ea.Response")

                    ea_.Response.UserPreferences = UserPreferencesQueryableService:New():GetAllUserPreferences()
                end)
                :Initialize() -- @formatter:on

    autolootEngineMediatorService:Handle_RestartEngineIfApplicableCommand(RestartAutolootEngineIfApplicableCommand:New())
end)
