--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Global = using "System.Global"

local TG, U = using "[testgroup] [tagged]" "System.Time" { "system", "time" }

TG:AddTheory("Using.Builtins.GivenRedInput.ShouldThrow",
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

TG:AddTheory("Using.Builtins.GivenGreenInput.ShouldReturnExpectedResults",
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

TG:AddTheory("Using.Builtin.GivenRedInput.ShouldThrow",
        { --@formatter:off
            ["UBINS.GRI.ST.0000"] = { String = [[ getfenv2 ]] },
        }, --@formatter:on
        function(options)
            -- ACT + ASSERT
            U.Should.Throw(function()
                using "[built-in]" (options.String)
            end)
        end
)

TG:AddTheory("Using.Builtin.GivenGreenInput.ShouldReturnExpectedResults",
        { --@formatter:off
            ["UBINS.GGI.SRER.0000"] = {
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
