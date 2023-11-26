-- todo   tweak pfui so that it wont autocommit the settings when the user tweaks the ui-controls    we want to be able to do that ourselves using standard patterns: commands + unit-of-work + repositories!
-- todo   introduce commands, command-handlers and command-results
-- todo   add reset-to-defaults button
-- todo   add artwork at the top of readme.md and inside the configuration page of the addon as a faint watermark

-- inspired by pfUI-eliteOverlay.lua
local function Main(_pfUI)
    _pfUI:RegisterModule("Zen", "vanilla:tbc", function()
        setfenv(1, {}) -- we deliberately disable any and all implicit access to global variables inside this function    

        local _g = _pfUI:GetEnvironment()        

        local _c = _g.assert(_g.pfUI.env.C) -- pfUI config
        local _t = _g.assert(_g.pfUI.env.T) -- pfUI translations
        local _print = _g.assert(_g.print)
        local _pfuiGui = _g.assert(_g.pfUI.gui)
        local _setfenv = _g.assert(_g.setfenv)
        local _importer = _g.assert(_g.pvl_namespacer_get)

        local _getAddOnInfo = _g.assert(_g.GetAddOnInfo) -- wow api   todo  put this in a custom class called Zen.AddonsHelpers or something
        
        local _rollOnLoot = _g.assert(_g.RollOnLoot) -- wow api   todo  put this in a custom class called Zen.LootHelpers or something        
        local _getItemQualityColor = _g.assert(_g.GetItemQualityColor)
        local _getLootRollItemLink = _g.assert(_g.GetLootRollItemLink)
        local _getLootRollItemInfo = _g.assert(_g.GetLootRollItemInfo)

        local _enumerable = _g.assert(_g.Enumerable) -- addon specific
        
        local UserPreferencesForm = _importer("Pavilion.Warcraft.Addons.Zen.UI.Pfui.UserPreferencesForm")
        local UserPreferencesUnitOfWork = _importer("Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.UnitOfWork")
        local AddonSettingsQueryingService = _importer("Pavilion.Warcraft.Addons.Zen.Domain.QueryingServices.AddonSettingsQueryingService")

        local addon = {
            ownName = "Zen",
            fullName = "pfUI [Zen]",
            folderName = "pfUI-Zen",

            ownNameColored = "|cFF7FFFD4Zen|r",
            fullNameColored = "|cff33ffccpf|r|cffffffffUI|r|cffaaaaaa [|r|cFF7FFFD4Zen|r|cffaaaaaa]|r",

            fullNameColoredForErrors = "|cff33ffccpf|r|cffffffffUI|r|cffaaaaaa [|r|cFF7FFFD4Zen|r|cffaaaaaa]|r|cffff5555"
        }

        local addonPath = _enumerable -- @formatter:off   detect current addon path
                            .FromList({ "", "-dev", "-master", "-tbc", "-wotlk" })
                            :Select(function (postfix)
                                local name, _, _, enabled = _getAddOnInfo(addon.folderName .. postfix)
                                return { path = name, enabled = enabled or 0 }
                            end)
                            :Where(function (x) return x.enabled == 1 end)
                            :Select(function (x) return x.path end)
                            :FirstOrDefault() -- @formatter:on

        if (not addonPath) then
            error(string.format("[PFUIZ.IM000] %s : Failed to find addon folder - please make sure that the addon is installed correctly!", addon.fullNameColoredForErrors))
            return
        end

        if (not _pfuiGui.CreateGUIEntry) then
            error(string.format("[PFUIZ.IM010] %s : The addon needs a recent version of pfUI (2023+) to work as intended - please update pfUI and try again!", addon.fullNameColoredForErrors))
            return
        end

        local addonPfuiRawPreferencesSchemaV1 = {
            -- todo  take this into account in the future when we have new versions that we have to smoothly upgrade the preexisting versions to
            addonPreferencesKeyname = "zen.config.v1", -- must be hardcoded right here   its an integral part of the settings specs and not of the addon specs 

            greenies_autolooting = {
                mode = {
                    keyname = "greenies_autolooting.v1.mode",
                    default = "roll_greed",
                },

                act_on_keybind = {
                    keyname = "greenies_autolooting.v1.keybind",
                    default = "automatic",
                },
            }
        }

        --if true then
        --    _c.ZenV1 = nil
        --    _c.Zen_v1 = nil
        --
        --    _c["zen.v1"] = nil
        --    _c["zen.config.v1"] = nil
        --    _c["zen.settings.v1"] = nil
        --
        --    _c.Zen = nil  -- this resets the entire settings tree for this addon
        --    _c.Zen2 = nil
        --    _c.Zen3 = nil
        --    return
        --end


        function EnsureAddonDefaultPreferencesAreRegistered(specs)
            local isFirstTimeLoading = _c[specs.addonPreferencesKeyname] == nil -- keep this first

            _pfUI:UpdateConfig(specs.addonPreferencesKeyname, nil, specs.greenies_autolooting.mode.keyname, specs.greenies_autolooting.mode.default) -- 00
            _pfUI:UpdateConfig(specs.addonPreferencesKeyname, nil, specs.greenies_autolooting.act_on_keybind.keyname, specs.greenies_autolooting.act_on_keybind.default)

            if isFirstTimeLoading then
                -- todo   search for settings from previous versions and run the upgraders on them to get to the latest version
            end

            return _c[specs.addonPreferencesKeyname]

            -- 00  set default values for the first time we load the addon    this also creates _c[_addonPreferencesKeyname]={} if it doesnt already exist
        end

        -- local zenEngineCommandsService = ZenEngineCommandsService:New()
        local addonSettingsQueryingService = AddonSettingsQueryingService:New()

        local addonPfuiRawPreferences = EnsureAddonDefaultPreferencesAreRegistered(addonPfuiRawPreferencesSchemaV1)

        UserPreferencesForm
                :New(_t, _pfuiGui)
                :EventRequestingCurrentUserPreferences_Subscribe(function(_, ea) -- @formatter:off  todo  use a query-action here instead
                    ea.Response.UserPreferences = addonSettingsQueryingService:GetAllUserPreferences()
                end)
                :EventGreenItemsAutolootingModeChanged_Subscribe(function(_, ea) -- todo   we should have commands here instead
                    -- zenEngineCommandsService:GreeniesAutolooting_SwitchMode(ea:GetNew())

                    local userPreferencesUnitOfWork = UserPreferencesUnitOfWork:New()
                    userPreferencesUnitOfWork:GetUserPreferencesRepository():GreeniesAutolooting_ChainUpdateMode(ea:GetNew())
                    userPreferencesUnitOfWork:SaveChanges()
                end)
                :EventGreenItemsAutolootingActOnKeybindChanged_Subscribe(function(_, ea) -- todo   we should have commands here instead
                    -- zenEngineCommandsService:GreeniesAutolooting_SwitchActOnKeybind(ea:GetNew())

                    local userPreferencesUnitOfWork = UserPreferencesUnitOfWork:New()
                    userPreferencesUnitOfWork:GetUserPreferencesRepository():GreeniesAutolooting_ChainUpdateActOnKeybind(ea:GetNew())
                    userPreferencesUnitOfWork:SaveChanges()
                end) -- @formatter:on
                :Initialize()
        
        local QUALITY_GREEN = 2
        local _, _, _, greeniesQualityHex = _getItemQualityColor(QUALITY_GREEN)

        local _base_pfuiRoll_UpdateLootRoll = _pfUI.roll.UpdateLootRoll
        function _pfUI.roll:UpdateLootRoll(i)
            -- override pfUI:UpdateLootRoll()
            _base_pfuiRoll_UpdateLootRoll(i)

            local rollMode = TranslateAutogamblingModeSettingToLuaRollMode(addonPfuiRawPreferences[addonPfuiRawPreferencesSchemaV1.greenies_autolooting.mode.keyname])
            if not rollMode or rollMode == "let_user_choose" then --todo  use strongly typed enums here
                return -- let the user choose
            end

            local frame = _pfUI.roll.frames[i]
            if not frame or not frame.rollID or not frame:IsShown() then
                -- shouldnt happen but just in case
                return
            end

            local _, _, _, quality = _getLootRollItemInfo(frame.rollID) -- todo   this could be optimized if we convince pfui to store the loot properties in the frame
            if quality == QUALITY_GREEN and frame:IsVisible() then -- todo   add take into account CANCEL_LOOT_ROLL event at some point
                -- todo   get keybind activation into account here   addonPfuiRawPreferences[addonPfuiRawPreferencesSchemaV1.greenies_autolooting.act_on_keybind.keyname]

                _rollOnLoot(frame.rollID, rollMode) -- todo   ensure that pfUI reacts accordingly to this by hiding the green item roll frame

                DEFAULT_CHAT_FRAME:AddMessage(addon.fullNameColored .. " " .. greeniesQualityHex .. rollMode .. "|cffffffff Roll " .. _getLootRollItemLink(frame.rollID))
            end
        end

        function TranslateAutogamblingModeSettingToLuaRollMode(greeniesAutogamblingMode)
            if greeniesAutogamblingMode == "just_pass" then
                return "PASS"
            end

            if greeniesAutogamblingMode == "roll_need" then
                return "NEED"
            end

            if greeniesAutogamblingMode == "roll_greed" then
                return "GREED"
            end

            return nil -- let_user_choose
        end

    end)
end

Main(assert(pfUI))
