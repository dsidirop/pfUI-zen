pfUI:RegisterModule("Zen", "vanilla:tbc", function() -- inspired by pfUI-eliteOverlay.lua
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
        -- new pfUI
        print("[PFUIZ.IM000] pfUI-zen needs a recent version of pfUI (2023+) to work as intended - please update pfUI and try again!")
        return
    end

    __.pfUI.gui.dropdowns.Zen_green_items_loot_gambling_mode = {
        "gamble_need:" .. __.T["Gamble Need"],
        "gamble_greed:" .. __.T["Gamble Greed"],
        "pass:" .. __.T["Pass"],
        "disabled:" .. __.T["Let me handle it!"],
    }

    __.pfUI.gui.CreateGUIEntry(
            __.T["Thirdparty"],
            __.T["Zen"],
            function()
                __.pfUI.gui.CreateConfig(
                        __.U["target"], -- nil causes a ui-reload whenever the setting changes
                        __.T["On Green items always ..."],
                        __.C.Zen,
                        "green_items_loot_gambling_mode",
                        "dropdown",
                        __.pfUI.gui.dropdowns.Zen_green_items_loot_gambling_mode
                )
            end
    )

    pfUI:UpdateConfig("Zen", nil, "green_items_loot_gambling_mode", "gamble_greed")

end)
