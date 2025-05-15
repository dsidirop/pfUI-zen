local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local U = using "[built-in]" [[ VWoWUnit ]]

Scopify(EScopes.Function, {})

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Guard.Assert.IsTableray",
    Tags = { "system", "guard", "guard-check", "guard-check-tablerays" }
}

TestsGroup:AddTheory("T000.Guard.Assert.IsTableray.GivenGreenInput.ShouldReturnTrue",
        {
            ["GRD.SRT.ITR.GGI.SNT.0000"] = { Value = {} },
            ["GRD.SRT.ITR.GGI.SNT.0010"] = { Value = { 1, } },
            ["GRD.SRT.ITR.GGI.SNT.0020"] = { Value = { 1, 2 } },
            ["GRD.SRT.ITR.GGI.SNT.0030"] = { Value = { 1, 2, 3 } }, -- the istableray() function intentionally checks only the first few elements
        },
        function(options)
            -- ACT + ASSERT
            local result = U.Should.Not.Throw(function()
                return Guard.Assert.IsTableray(options.Value, "options.Value")
            end)

            U.Should.Be.TypeOfTable(result)
        end
)

TestsGroup:AddTheory("T000.Guard.Assert.IsTableray.GivenRedInput.ShouldThrow",
        {
            ["GRD.SRT.ITR.GRI.ST.0000"] = { Value = nil },
            ["GRD.SRT.ITR.GRI.ST.0010"] = { Value = 1.5 },
            ["GRD.SRT.ITR.GRI.ST.0020"] = { Value = "abc" },
            ["GRD.SRT.ITR.GRI.ST.0030"] = { Value = { x = 123 } },
            ["GRD.SRT.ITR.GRI.ST.0040"] = { Value = { 1, x = 123, 2 } },
            ["GRD.SRT.ITR.GRI.ST.0050"] = { Value = { 1, x = 123, 3 } },
            ["GRD.SRT.ITR.GRI.ST.0060"] = { Value = function()
                return 123
            end },
        },
        function(options)
            -- ACT + ASSERT
            U.Should.Throw(function()
                Guard.Assert.IsTableray(options.Value, "options.Value")
            end)
        end
)
