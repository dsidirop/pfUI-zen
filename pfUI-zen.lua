-- todo#1   move pfUI:RegisterModule() to a separate file called addon.lua and refactor the corelogic of the callback into a separate class
-- todo#2   add artwork at the top of readme.md and inside the configuration page of the addon as a faint watermark

pfUI:RegisterModule("Zen", "vanilla:tbc", function()
    -- inspired by pfUI-eliteOverlay.lua
    local __ = {
        C = C,
        T = T,
        F = F,
        U = pfUI.gui.UpdaterFunctions,
        linq = linq,
        pfUI = pfUI,
        Enumerable = Enumerable,
        GetAddOnInfo = GetAddOnInfo,
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

    __.pfUI.gui.dropdowns.Zen__loot__green_items_autogambling__modes = {
        "roll_need:" .. __.T["Roll '|cFFFF4500Need|r'"],
        "roll_greed:" .. __.T["Roll '|cFFFFD700Greed|r'"],
        "pass:" .. __.T["Just '|cff888888Pass|r'"],
        "disabled:" .. __.T["Let me handle it myself"],
    }

    __.pfUI.gui.dropdowns.Zen__loot__green_items_autogambling__keybinds = {
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
        Greenies = {
            Mode = "loot__green_items_autogambling__mode",
            Keybind = "loot__green_items_autogambling__keybind"
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
                            print("** mode='" .. (__.C.Zen[settingsNicknames.Greenies.Mode] or "nil") .. "'")
                        end,
                        __.T["When looting |cFF228B22Green|r items always ..."],
                        __.C.Zen,
                        settingsNicknames.Greenies.Mode,
                        "dropdown",
                        __.pfUI.gui.dropdowns.Zen__loot__green_items_autogambling__modes
                )

                local ddlGreenItemsAutogamblingKeybind = __.pfUI.gui.CreateConfig(
                        nil,
                        __.T["Upon pressing ..."],
                        __.C.Zen,
                        settingsNicknames.Greenies.Keybind,
                        "dropdown",
                        __.pfUI.gui.dropdowns.Zen__loot__green_items_autogambling__keybinds
                )
            end
    )

    __.pfUI:UpdateConfig(addon.ownName, nil, settingsNicknames.Greenies.Mode, "roll_greed")
    __.pfUI:UpdateConfig(addon.ownName, nil, settingsNicknames.Greenies.Keybind, "none")

    ----------------

    -- how often is 'onupdate' being triggered?
    -- consult pfui -> roll.lua
    --  maybe we should intercept function pfUI.loot:UpdateLootFrame()

    --function LazyPig_GreenRoll()
    --    RollReturn = function()
    --        local txt = ""
    --        if LPCONFIG.GREEN == 1 then
    --            txt = "NEED"
    --        elseif LPCONFIG.GREEN == 2 then
    --            txt = "GREED"
    --        elseif LPCONFIG.GREEN == 0 then
    --            txt = "PASS"
    --        end
    --        return txt
    --    end
    --
    --    local pass = nil
    --    if LPCONFIG.GREEN then
    --        for i=1, NUM_GROUP_LOOT_FRAMES do
    --            local frame = getglobal("GroupLootFrame"..i);
    --            if frame:IsVisible() then
    --                local id = frame.rollID
    --                local _, name, _, quality = GetLootRollItemInfo(id);
    --                if quality == 2 then
    --                    RollOnLoot(id, LPCONFIG.GREEN); -- https://wowwiki-archive.fandom.com/wiki/API_RollOnLoot
    --                    local _, _, _, hex = GetItemQualityColor(quality)
    --                    greenrolltime = GetTime() + 1
    --                    DEFAULT_CHAT_FRAME:AddMessage("LazyPig: "..hex..RollReturn().."|cffffffff Roll "..GetLootRollItemLink(id))
    --                    pass = true
    --                end
    --            end
    --        end
    --    end
    --    return pass
    --end

end)
