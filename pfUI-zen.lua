-- todo#1   move pfUI:RegisterModule() to a separate file called addon.lua and refactor the corelogic of the callback into a separate class
-- todo#2   add artwork at the top of readme.md and inside the configuration page of the addon as a faint watermark

pfUI:RegisterModule("Zen", "vanilla:tbc", function()
    -- inspired by pfUI-eliteOverlay.lua
    local __ = {
        C = assert(C),
        T = assert(T),
        pfUI = assert(pfUI),
        
        U = assert(pfUI.gui.UpdaterFunctions),
        RollOnLoot = assert(RollOnLoot),
        Enumerable = assert(Enumerable),
        GetAddOnInfo = assert(GetAddOnInfo),
        GetItemQualityColor = assert(GetItemQualityColor),
        GetLootRollItemLink = assert(GetLootRollItemLink),
        GetLootRollItemInfo = assert(GetLootRollItemInfo),
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

    if (not __.pfUI.gui.CreateGUIEntry) then
        error(string.format("[PFUIZ.IM010] %s : The addon needs a recent version of pfUI (2023+) to work as intended - please update pfUI and try again!", addon.fullNameColoredForErrors))
        return
    end

    __.pfUI.gui.dropdowns.Zen__greenies__autogambling__modes = {
        "roll_need:" .. __.T["Roll '|cFFFF4500Need|r'"],
        "roll_greed:" .. __.T["Roll '|cFFFFD700Greed|r'"],
        "pass:" .. __.T["Just '|cff888888Pass|r'"],
        "let_user_choose:" .. __.T["Let me handle it myself"],
    }

    __.pfUI.gui.dropdowns.Zen__greenies__autogambling__keybinds = {
        "none:" .. __.T["Just roll immediately"],
        "alt:" .. __.T["Alt"],
        "ctrl:" .. __.T["Ctrl"],
        "shift:" .. __.T["Shift"],
        "ctrl_alt:" .. __.T["Ctrl + Alt"],
        "ctrl_shift:" .. __.T["Ctrl + Shift"],
        "alt_shift:" .. __.T["Alt + Shift"],
        "ctrl_alt_shift:" .. __.T["Ctrl + Alt + Shift"],
    }

    local settingsNicknames = {
        GreeniesLoot = {
            Mode = "v1.greenies_loot_autogambling.v1.mode",
            Keybind = "v1.greenies_loot_autogambling.v1.keybind"
        }
    }

    __.pfUI.gui.CreateGUIEntry(
            __.T["Thirdparty"],
            __.T[addon.ownNameColored],
            function()
                local lblLootSectionHeader = __.pfUI.gui.CreateConfig(nil, __.T["Loot"], nil, nil, "header")
                lblLootSectionHeader:GetParent().objectCount = lblLootSectionHeader:GetParent().objectCount - 1
                lblLootSectionHeader:SetHeight(20)

                local ddlGreenItemsAutogamblingMode = __.pfUI.gui.CreateConfig(
                        function()
                            -- print("** mode='" .. (__.C.Zen[settingsNicknames.Greenies.Mode] or "nil") .. "'")
                        end,
                        __.T["When looting |cFF228B22Green|r items always ..."],
                        __.C.Zen,
                        settingsNicknames.GreeniesLoot.Mode,
                        "dropdown",
                        __.pfUI.gui.dropdowns.Zen__greenies__autogambling__modes
                )

                local ddlGreenItemsAutogamblingKeybind = __.pfUI.gui.CreateConfig(
                        nil,
                        __.T["Upon pressing ..."],
                        __.C.Zen,
                        settingsNicknames.GreeniesLoot.Keybind,
                        "dropdown",
                        __.pfUI.gui.dropdowns.Zen__greenies__autogambling__keybinds
                )
            end
    )

    -- set default values for the first time we load the addon
    __.pfUI:UpdateConfig(addon.ownName, nil, settingsNicknames.GreeniesLoot.Mode, "roll_greed")
    __.pfUI:UpdateConfig(addon.ownName, nil, settingsNicknames.GreeniesLoot.Keybind, "none")
    
    local QUALITY_GREEN = 2
    local _, _, _, greeniesQualityHex = __.GetItemQualityColor(QUALITY_GREEN)
    
    local _hookUpdateLootRoll = __.pfUI.roll.UpdateLootRoll
    function __.pfUI.roll:UpdateLootRoll(i)
        _hookUpdateLootRoll(i)

        local rollMode = TranslateAutogamblingModeSettingToLuaRollMode(__.C.Zen[settingsNicknames.GreeniesLoot.Mode])
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
            __.RollOnLoot(frame.rollID, rollMode)

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
