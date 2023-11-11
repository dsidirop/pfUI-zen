-- todo   add artwork at the top of readme.md and inside the configuration page of the addon as a faint watermark

-- inspired by pfUI-eliteOverlay.lua
local function Main(_pfUI)
    _pfUI:RegisterModule("Zen", "vanilla:tbc", function()
        setfenv(1, _pfUI:GetEnvironment()) -- order        
        local _g = assert(_G) --              order    dont resort to getfenv(0)   this ought to succeed considering that we called setfenv right above 

        local _c = assert(_g.pfUI.env.C) -- pfUI config
        local _t = assert(_g.pfUI.env.T) -- pfUI translations
        local _pfuiGui = assert(_g.pfUI.gui)

        local _getAddOnInfo = assert(_g.GetAddOnInfo) -- wow api   todo  put this in a custom class called Zen.AddonsHelpers or something
        
        local _rollOnLoot = assert(_g.RollOnLoot) -- wow api   todo  put this in a custom class called Zen.LootHelpers or something        
        local _getItemQualityColor = assert(_g.GetItemQualityColor)
        local _getLootRollItemLink = assert(_g.GetLootRollItemLink)
        local _getLootRollItemInfo = assert(_g.GetLootRollItemInfo)

        local _enumerable = assert(_g.Enumerable) -- addon specific
        local _zenSettingsPfuiForm = assert(_g.ZenSettingsPfuiForm)

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

        local settingsSpecsV1 = {
            v = "v1", -- todo  take this into account in the future when we have new versions that we have to smoothly upgrade the preexisting versions to 

            greenies_loot_autogambling = {
                mode = {
                    keyname = "v1.greenies_loot_autogambling.v1.mode",
                    default = "roll_greed",
                    options = {
                        "roll_need:" .. _t["Roll '|cFFFF4500Need|r'"],
                        "roll_greed:" .. _t["Roll '|cFFFFD700Greed|r'"],
                        "pass:" .. _t["Just '|cff888888Pass|r'"],
                        "let_user_choose:" .. _t["Let me handle it myself"],
                    },
                },

                roll_on_keybind = {
                    keyname = "v1.greenies_loot_autogambling.v1.keybind",
                    default = "automatic",
                    options = {
                        "automatic:" .. _t["|cff888888(Automatic)|r"],
                        "alt:" .. _t["Alt"],
                        "ctrl:" .. _t["Ctrl"],
                        "shift:" .. _t["Shift"],
                        "ctrl_alt:" .. _t["Ctrl + Alt"],
                        "ctrl_shift:" .. _t["Ctrl + Shift"],
                        "alt_shift:" .. _t["Alt + Shift"],
                        "ctrl_alt_shift:" .. _t["Ctrl + Alt + Shift"],
                    },
                },
            }
        }

        --if true then
        --    _C.Zen = nil  -- this resets the entire settings tree for this addon
        --    _C.Zen2 = nil
        --    _C.Zen3 = nil
        --    return
        --end

        -- set default values for the first time we load the addon    this also creates _C[addon.ownName]={} if it doesnt already exist 
        _pfUI:UpdateConfig(addon.ownName, nil, settingsSpecsV1.greenies_loot_autogambling.mode.keyname, settingsSpecsV1.greenies_loot_autogambling.mode.default)
        _pfUI:UpdateConfig(addon.ownName, nil, settingsSpecsV1.greenies_loot_autogambling.roll_on_keybind.keyname, settingsSpecsV1.greenies_loot_autogambling.roll_on_keybind.default)

        _pfuiGui.CreateGUIEntry(
                _t["Thirdparty"],
                _t[addon.ownNameColored],
                function()
                    -- this only gets called during a user session the very first time that the user explicitly
                    -- navigates to the "thirtparty" section and clicks on the "zen" tab   otherwise it never gets called

                    _zenSettingsPfuiForm:New(
                            _t,
                            _pfuiGui,
                            _c[addon.ownName], -- addonRawPfuiSettings
                            settingsSpecsV1
                    )                   :Initialize()
                end
        )

        local QUALITY_GREEN = 2
        local _, _, _, greeniesQualityHex = _getItemQualityColor(QUALITY_GREEN)

        local _base_pfuiRoll_UpdateLootRoll = _pfUI.roll.UpdateLootRoll
        function _pfUI.roll:UpdateLootRoll(i)
            -- override pfUI's UpdateLootRoll
            _base_pfuiRoll_UpdateLootRoll(i)

            local rollMode = TranslateAutogamblingModeSettingToLuaRollMode(_c[addon.ownName][settingsSpecsV1.greenies_loot_autogambling.mode])
            if not rollMode then
                return -- let the user choose
            end

            local frame = _pfUI.roll.frames[i]
            if not frame or not frame.rollID or not frame:IsShown() then
                -- shouldnt happen but just in case
                return
            end

            local _, _, _, quality = _getLootRollItemInfo(frame.rollID) -- todo   this could be optimized if we convince pfui to store the loot properties in the frame
            if quality == QUALITY_GREEN and frame:IsVisible() then
                -- todo   get keybind activation into account here
                _rollOnLoot(frame.rollID, rollMode) -- todo   ensure that pfUI reacts accordingly to this by hiding the green item roll frame

                DEFAULT_CHAT_FRAME:AddMessage(addon.fullNameColored .. " " .. greeniesQualityHex .. rollMode .. "|cffffffff Roll " .. _getLootRollItemLink(frame.rollID))
            end
        end

        function TranslateAutogamblingModeSettingToLuaRollMode(greeniesAutogamblingMode)
            if greeniesAutogamblingMode == "pass" then
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

        -- todo   add take into account CANCEL_LOOT_ROLL event at some point

    end)
end

Main(assert(pfUI))
