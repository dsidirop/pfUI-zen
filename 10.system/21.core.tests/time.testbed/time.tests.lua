local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Time = using "System.Time"

local TG, U = using "[testgroup] [tagged]" "System.Time" { "system", "time" }

TG:AddFact("Time.Now.GivenSimpleCall.ShouldReturnCurrentTime", function()
    -- ACT + ASSERT
    U.Should.Not.Throw(function()
        Time.Now()
    end)
end)
