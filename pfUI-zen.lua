-- todo   add artwork at the top of readme.md and inside the configuration page of the addon as a faint watermark

function pfUIZenMain()
    -- inspired by pfUI-eliteOverlay.lua
    pfUI:RegisterModule("Zen", "vanilla:tbc", function()

        local __ = {
            pfUI = assert(_G.pfUI),
            pfuiEnv = assert(_G.pfUI.env),
            pfuiGui = assert(_G.pfUI.gui),

            C = assert(_G.pfUI.env.C), -- pfUI config
            T = assert(_G.pfUI.env.T), -- pfUI translations

            RollOnLoot = assert(_G.RollOnLoot),
            Enumerable = assert(_G.Enumerable),
            GetAddOnInfo = assert(_G.GetAddOnInfo),
            GetItemQualityColor = assert(_G.GetItemQualityColor),
            GetLootRollItemLink = assert(_G.GetLootRollItemLink),
            GetLootRollItemInfo = assert(_G.GetLootRollItemInfo),

            ZenSettingsPfuiForm = assert(_G.ZenSettingsPfuiForm),
        }

        local addon = {
            ownName = "Zen",
            fullName = "pfUI [Zen]",
            folderName = "pfUI-Zen",

            ownNameColored = "|cFF7FFFD4Zen|r",
            fullNameColored = "|cff33ffccpf|r|cffffffffUI|r|cffaaaaaa [|r|cFF7FFFD4Zen|r|cffaaaaaa]|r",

            fullNameColoredForErrors = "|cff33ffccpf|r|cffffffffUI|r|cffaaaaaa [|r|cFF7FFFD4Zen|r|cffaaaaaa]|r|cffff5555"
        }

        local addonPath = __.Enumerable -- @formatter:off   detect current addon path
                            .FromList({ "", "-dev", "-master", "-tbc", "-wotlk" })
                            :Select(function (postfix)
                                local name, _, _, enabled = __.GetAddOnInfo(addon.folderName .. postfix)
                                return { path = name, enabled = enabled or 0 }
                            end)
                            :Where(function (x) return x.enabled == 1 end)
                            :Select(function (x) return x.path end)
                            :FirstOrDefault() -- @formatter:on

        if (not addonPath) then
            error(string.format("[PFUIZ.IM000] %s : Failed to find addon folder - please make sure that the addon is installed correctly!", addon.fullNameColoredForErrors))
            return
        end

        if (not __.pfuiGui.CreateGUIEntry) then
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
                        "roll_need:" .. __.T["Roll '|cFFFF4500Need|r'"],
                        "roll_greed:" .. __.T["Roll '|cFFFFD700Greed|r'"],
                        "pass:" .. __.T["Just '|cff888888Pass|r'"],
                        "let_user_choose:" .. __.T["Let me handle it myself"],
                    },
                },

                roll_on_keybind = {
                    keyname = "v1.greenies_loot_autogambling.v1.keybind",
                    default = "automatic",
                    options = {
                        "automatic:" .. __.T["|cff888888(Automatic)|r"],
                        "alt:" .. __.T["Alt"],
                        "ctrl:" .. __.T["Ctrl"],
                        "shift:" .. __.T["Shift"],
                        "ctrl_alt:" .. __.T["Ctrl + Alt"],
                        "ctrl_shift:" .. __.T["Ctrl + Shift"],
                        "alt_shift:" .. __.T["Alt + Shift"],
                        "ctrl_alt_shift:" .. __.T["Ctrl + Alt + Shift"],
                    },
                },
            }
        }

        --if true then
        --    __.C.Zen = nil  -- this resets the entire settings tree for this addon
        --    __.C.Zen2 = nil
        --    __.C.Zen3 = nil
        --    return
        --end

        -- set default values for the first time we load the addon    this also creates __.C[addon.ownName]={} if it doesnt already exist 
        __.pfUI:UpdateConfig(addon.ownName, nil, settingsSpecsV1.greenies_loot_autogambling.mode.keyname, settingsSpecsV1.greenies_loot_autogambling.mode.default)
        __.pfUI:UpdateConfig(addon.ownName, nil, settingsSpecsV1.greenies_loot_autogambling.roll_on_keybind.keyname, settingsSpecsV1.greenies_loot_autogambling.roll_on_keybind.default)
        
        __.pfuiGui.CreateGUIEntry(
                __.T["Thirdparty"],
                __.T[addon.ownNameColored],
                function()
                    -- this only gets called during a user session the very first time that the user explicitly
                    -- navigates to the "thirtparty" section and clicks on the "zen" tab   otherwise it never gets called
                    
                    print("** creating settings form **")

                    __.ZenSettingsPfuiForm:New(
                            __.T,
                            __.pfuiGui,
                            __.C[addon.ownName], -- addonRawPfuiSettings
                            settingsSpecsV1
                    ) :InitializeControls()
                end
        )

        local QUALITY_GREEN = 2
        local _, _, _, greeniesQualityHex = __.GetItemQualityColor(QUALITY_GREEN)

        local _base_pfuiRoll_UpdateLootRoll = __.pfUI.roll.UpdateLootRoll
        function __.pfUI.roll:UpdateLootRoll(i)
            -- override pfUI's UpdateLootRoll
            _base_pfuiRoll_UpdateLootRoll(i)

            local rollMode = TranslateAutogamblingModeSettingToLuaRollMode(__.C[addon.ownName][settingsSpecsV1.greenies_loot_autogambling.mode])
            if not rollMode then
                return -- let the user choose
            end

            local frame = __.pfUI.roll.frames[i]
            if not frame or not frame.rollID or not frame:IsShown() then
                -- shouldnt happen but just in case
                return
            end

            local _, _, _, quality = __.GetLootRollItemInfo(frame.rollID) -- todo   this could be optimized if we convince pfui to store the loot properties in the frame
            if quality == QUALITY_GREEN and frame:IsVisible() then
                -- todo   get keybind activation into account here
                __.RollOnLoot(frame.rollID, rollMode) -- todo   ensure that pfUI reacts accordingly to this by hiding the green item roll frame

                DEFAULT_CHAT_FRAME:AddMessage(addon.fullNameColored .. " " .. greeniesQualityHex .. rollMode .. "|cffffffff Roll " .. __.GetLootRollItemLink(frame.rollID))
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

pfUIZenMain()