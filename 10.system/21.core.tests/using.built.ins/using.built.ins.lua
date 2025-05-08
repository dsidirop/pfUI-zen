local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Global = using "System.Global"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Validation = using "System.Validation"

-- DO NOT EMPLOY   using "[built-in]"   HERE BECAUSE IT IS WHAT WE ARE ACTUALLY TESTING!!  
local U = Validation.Assert(Global.VWoWUnit)

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup {
    Name = "Using.Builtins",
    Tags = { "system", "using", "built-ins" },
}

Scopify(EScopes.Function, {})

TestsGroup:AddTheory("Using.Builtins.GivenRedInput.ShouldThrow",
        {
            ["UBINS.GRA.ST.0000"] = { String = nil },
            ["UBINS.GRA.ST.0010"] = { String = function() return 123; end },
            ["UBINS.GRA.ST.0020"] = { String = 1 },
            ["UBINS.GRA.ST.0030"] = { String = {} },
            ["UBINS.GRA.ST.0040"] = { String = true },
            ["UBINS.GRA.ST.0045"] = { String = "  " },
            ["UBINS.GRA.ST.0050"] = { String = "getfenv" },
            ["UBINS.GRA.ST.0060"] = { String = "getfenv, unpack" },
            ["UBINS.GRA.ST.0070"] = { String = "A = table.sort, table.insert" },
            ["UBINS.GRA.ST.0080"] = { String = "table.sort, B = table.insert" },
            ["UBINS.GRA.ST.0090"] = { String = "table.sort, B = table.insert == nil" },
            ["UBINS.GRA.ST.0100"] = { String = "A = table.sort2" },
            ["UBINS.GRA.ST.0110"] = { String = "A = table2.sort" },
        },
        function(options)
            -- ACT + ASSERT
            U.Should.Throw(function()
                using "[built-ins]" (options.String)
            end)
        end
)

TestsGroup:AddTheory("Using.Builtins.GivenGreenInput.ShouldReturnExpectedResults",
        { --@formatter:off
            ["UBINS.GGA.SRER.0000"] = {
                String          = [[ A = getfenv        ]],
                ExpectedResults =  { A = Global.getfenv },
            },
            ["UBINS.GGA.SRER.0010"] = {
                String          = [[ A = getfenv,        B = setfenv        ]],
                ExpectedResults =  { A = Global.getfenv, B = Global.setfenv },
            },
            ["UBINS.GGA.SRER.0020"] = {
                String          = [[ A = getfenv,        B = setfenv,       ]],
                ExpectedResults =  { A = Global.getfenv, B = Global.setfenv },
            },
            ["UBINS.GGA.SRER.0030"] = {
                String          = [[ A = getfenv,        B = setfenv2 or setfenv, ]],
                ExpectedResults =  { A = Global.getfenv, B = Global.setfenv },
            },
        }, --@formatter:on
        function(options)
            -- ACT
            local results = U.Should.Not.Throw(function()
                return using "[built-ins]" (options.String)
            end)
            
            -- ASSERT
            U.Should.Be.Equivalent(results, options.ExpectedResults)
        end
)

TestsGroup:AddTheory("Using.Builtin.GivenRedInput.ShouldThrow",
        { --@formatter:off
            ["UBIN.GRI.ST.0000"] = { String = [[ getfenv2 ]] },
        }, --@formatter:on
        function(options)
            -- ACT + ASSERT
            U.Should.Throw(function()
                using "[built-in]" (options.String)
            end)
        end
)

TestsGroup:AddTheory("Using.Builtin.GivenGreenInput.ShouldReturnExpectedResults",
        { --@formatter:off
            ["UBIN.GGI.SRER.0000"] = {
                String          = [[ getfenv ]],
                ExpectedResults =  Global.getfenv,
            },
        }, --@formatter:on
        function(options)
            -- ACT
            local results = U.Should.Not.Throw(function()
                return using "[built-in]" (options.String)
            end)

            -- ASSERT
            U.Should.Be.PlainlyEqual(results, options.ExpectedResults)
        end
)
