-- todo#0   the linq lib needs to be refactored into being wow1.12 compatible: replace match() and refactor format() for starters
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
        GetAddOnInfo = GetAddOnInfo,
    }

    --local addonPaths = __.linq({ "-dev", "", "-master", "-tbc", "-wotlk" }) -- @formatter:off   detect current addon path
    --        :select(function (postfix)
    --            local name, _, _, enabled = __.GetAddOnInfo("pfUI-zen" .. postfix)
    --            return { path = name, enabled = enabled or 0 } 
    --         end)
    --        :where(function (x) return x.enabled == 1 end)
    --        :select(function (x) return x.path end)
    --        :toArray() -- @formatter:on
    --
    --print("[PFUIZ.IM000] addonPath='" .. table.getn(addonPaths) .. "'")

    if (not __.pfUI.gui.CreateGUIEntry) then
        print("[PFUIZ.IM010] pfUI-zen needs a recent version of pfUI (2023+) to work as intended - please update pfUI and try again!")
        return
    end

    __.pfUI.gui.dropdowns.Zen__loot__green_items_autogambling_modes = {
        "roll_need:" .. __.T["Roll '|cFFFF4500Need|r'"],
        "roll_greed:" .. __.T["Roll '|cFFFFD700Greed|r'"],
        "pass:" .. __.T["Just '|cff888888Pass|r'"],
        "disabled:" .. __.T["Let me handle it myself"],
    }

    local preferences = {
        loot = {
            green_items_autogambling_mode = "loot__green_items_autogambling_mode"
        }
    }

    __.pfUI.gui.CreateGUIEntry(
            __.T["Thirdparty"],
            __.T["|cFF7FFFD4Zen"],
            function()
                local lootHeader = __.pfUI.gui.CreateConfig(nil, __.T["Loot"], nil, nil, "header")
                lootHeader:GetParent().objectCount = lootHeader:GetParent().objectCount - 1
                lootHeader:SetHeight(20)
                
                __.pfUI.gui.CreateConfig(
                        function()
                            -- print("** mode='" .. (__C.Zen[props.loot.green_items_autogambling_mode] or "nil") .. "'")
                        end,
                        __.T["When looting |cFF228B22Green|r items always ..."],
                        __.C.Zen,
                        preferences.loot.green_items_autogambling_mode,
                        "dropdown",
                        __.pfUI.gui.dropdowns.Zen__loot__green_items_autogambling_modes
                )
            end
    )
    
    pfUI:UpdateConfig("Zen", nil, preferences.loot.green_items_autogambling_mode, "roll_greed")
    
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
