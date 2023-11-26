-- todo   adapt and adopt middleclass to implement inheritance and mixins https://github.com/kikito/middleclass/blob/master/middleclass.lua
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

        local Enumerable = _importer("Pavilion.Warcraft.Addons.Zen.Externals.MTALuaLinq.Enumerable")        
        local UserPreferencesForm = _importer("Pavilion.Warcraft.Addons.Zen.UI.Pfui.UserPreferencesForm")
        local ZenEngineCommandsService = _importer("Pavilion.Warcraft.Addons.Zen.Domain.CommandingServices.ZenEngineCommandsService")
        local AddonSettingsQueryingService = _importer("Pavilion.Warcraft.Addons.Zen.Domain.QueryingServices.AddonSettingsQueryingService")

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

        local addonPfuiRawPreferences = EnsureAddonDefaultPreferencesAreRegistered(addonPfuiRawPreferencesSchemaV1)

        UserPreferencesForm
                :New(_t, _pfuiGui)
                :EventRequestingCurrentUserPreferences_Subscribe(function(_, ea) -- @formatter:off  todo  use a query-action here instead
                    ea.Response.UserPreferences = AddonSettingsQueryingService:New():GetAllUserPreferences()
                end)
                :EventGreenItemsAutolootingModeChanged_Subscribe(function(_, ea) -- todo   we should have commands here instead
                    ZenEngineCommandsService:New():GreeniesAutolooting_SwitchMode(ea:GetNew())
                end)
                :EventGreenItemsAutolootingActOnKeybindChanged_Subscribe(function(_, ea) -- todo   we should have commands here instead
                    ZenEngineCommandsService:New():GreeniesAutolooting_SwitchActOnKeybind(ea:GetNew())
                end) -- @formatter:on
                :Initialize()
        

    end)
end

Main(assert(pfUI))
