pfUI:RegisterModule("Zen", "vanilla:tbc", function()
    local __ = {
        T = T,
        F = F,
        linq = linq,
        pfUI = pfUI,
        GetAddOnInfo = GetAddOnInfo,
    }

    __.pfUI.gui.dropdowns.Zen_green_items_roll = {
        "need:" .. __.T["Need"],
        "greed:" .. __.T["Greed"],
        "pass:" .. __.T["Pass"]
    }

    local addonPath = __.linq({ "", "-dev", "-master", "-tbc", "-wotlk" }) -- @formatter:off   detect current addon path
            :select(function (postfix)
                local name, _, _, enabled = __.GetAddOnInfo("pfUI-zen" .. postfix)
                return { path = name, enabled = enabled or 0 } 
             end)
            :where(function (x) return x.enabled == 1 end)
            :select(function (x) return x.path end)
            :first() -- @formatter:on
    
    print(addonPath)

end)
