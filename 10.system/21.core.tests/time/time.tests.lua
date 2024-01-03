local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local U = using "[global]" "VWoWUnit"

local Time = using "System.Time"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Time",
    Tags = { "system", "time" },
}

Scopify(EScopes.Function, {})

TestsGroup:AddFact("Time.Now.GivenSimpleCall.ShouldReturnCurrentTime", function()
    -- ACT + ASSERT
    U.Should.Not.Throw(function()
        Time.Now()
    end)
end)
