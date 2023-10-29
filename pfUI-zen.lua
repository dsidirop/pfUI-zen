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

    local addonPath = __.linq({ "", "-dev", "-master", "-tbc", "-wotlk" }) -- @formatter:off   detect current addon path
            :select(function (postfix)
                local name, _, _, enabled = __.GetAddOnInfo("pfUI-zen" .. postfix)
                return { path = name, enabled = enabled or 0 } 
             end)
            :where(function (x) return x.enabled == 1 end)
            :select(function (x) return x.path end)
            :first() -- @formatter:on

    if (not __.pfUI.gui.CreateGUIEntry) then
        print("[PFUIZ.IM000] pfUI-zen needs a recent version of pfUI (2023+) to work as intended - please update pfUI and try again!")
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
                __.pfUI.gui.CreateConfig(
                        function()
                            -- print("** mode='" .. (C.Zen[props.loot.green_items_autogambling_mode] or "nil") .. "'")
                        end,
                        __.T["When looting |cFF228B22Green|r items always ..."],
                        __.C.Zen,
                        preferences.loot.green_items_autogambling_mode,
                        "dropdown",
                        __.pfUI.gui.dropdowns.Zen__loot__green_items_autogambling_modes
                )
            end
    )
    
    pfUI:UpdateConfig("Zen", "Loot", preferences.loot.green_items_autogambling_mode, "roll_greed")

end)
