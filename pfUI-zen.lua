pfUI:RegisterModule("Zen", "vanilla:tbc", function()
    local _ = {
        T = T,
        F = F,
        linq = linq,
        pfUI = pfUI,
        GetAddOnInfo = GetAddOnInfo,
    }

    _.pfUI.gui.dropdowns.Zen_green_items_roll = {
        "need:" .. _.T["Need"],
        "greed:" .. _.T["Greed"],
        "pass:" .. _.T["Pass"]
    }

    local addonpath = _.linq({ "", "-dev", "-master", "-tbc", "-wotlk" }) -- @formatter:off   detect current addon path
            :select(function (postfix) return _.GetAddOnInfo("pfUI-zen"..postfix) end)
            :where(function (_, title) return type(title) == "string" end)
            :first() -- @formatter:on
    
    print(addonpath)

end)
