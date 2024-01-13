local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[ VWoWUnit = VWoWUnit ]]

local Namespacer = using "System.Namespacer"

Namespacer:Bind("Pavilion.Warcraft.Addons.Zen.Externals.WoW.VWoWUnit", B.VWoWUnit)

Namespacer:Bind("[testgroup]", function(name)
    local testGroup = B.VWoWUnit.TestsEngine:CreateOrUpdateGroup { Name = name }
    
    return testGroup, B.VWoWUnit
end)

Namespacer:Bind("[testgroup.tagged]", function(name)
    local testGroup = B.VWoWUnit.TestsEngine:CreateOrUpdateGroup { Name = name }

    return function(tags)
        B.VWoWUnit.TestsEngine:AssociateTestGroupWithTags(testGroup, tags)
        return testGroup, B.VWoWUnit
    end
end)
