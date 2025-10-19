--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Guard = using "System.Guard"

local TG, U = using "[testgroup] [tagged]" "System.Guard.Assert.IsBooleanizable" { "system", "guard", "guard-check", "guard-check-booleanizables" }

TG:AddTheory("T010.Guard.Assert.IsBooleanizable.GivenGreenInput.ShouldNotThrow",
        {
            ["GRD.SRT.IB.GGI.SNT.0000"] = { Value = 0 },
            ["GRD.SRT.IB.GGI.SNT.0010"] = { Value = 1 },
            ["GRD.SRT.IB.GGI.SNT.0020"] = { Value = -1 },

            ["GRD.SRT.IB.GGI.SNT.0030"] = { Value = true },
            ["GRD.SRT.IB.GGI.SNT.0040"] = { Value = false },

            ["GRD.SRT.IB.GGI.SNT.0050"] = { Value = "y" },
            ["GRD.SRT.IB.GGI.SNT.0060"] = { Value = "Y" },
            ["GRD.SRT.IB.GGI.SNT.0070"] = { Value = "Yes" },
            ["GRD.SRT.IB.GGI.SNT.0080"] = { Value = "YES" },
            ["GRD.SRT.IB.GGI.SNT.0090"] = { Value = "T" },
            ["GRD.SRT.IB.GGI.SNT.0100"] = { Value = "True" },
            ["GRD.SRT.IB.GGI.SNT.0110"] = { Value = "TRUE" },

            ["GRD.SRT.IB.GGI.SNT.0120"] = { Value = "n" },
            ["GRD.SRT.IB.GGI.SNT.0130"] = { Value = "N" },
            ["GRD.SRT.IB.GGI.SNT.0140"] = { Value = "No" },
            ["GRD.SRT.IB.GGI.SNT.0150"] = { Value = "NO" },
            ["GRD.SRT.IB.GGI.SNT.0160"] = { Value = "F" },
            ["GRD.SRT.IB.GGI.SNT.0170"] = { Value = "False" },
            ["GRD.SRT.IB.GGI.SNT.0180"] = { Value = "FALSE" },
        },
        function(options)
            -- ACT + ASSERT
            U.Should.Not.Throw(function()
                Guard.Assert.IsBooleanizable(options.Value, "options.Value")
            end)
        end
)

TG:AddTheory("T010.Guard.Assert.IsBooleanizable.GivenRedInput.ShouldThrow",
        {
            ["GRD.SRT.IB.GRI.ST.0000"] = { Value = nil },
            ["GRD.SRT.IB.GRI.ST.0010"] = { Value = 0.3 },
            ["GRD.SRT.IB.GRI.ST.0020"] = { Value = 1.5 },
            ["GRD.SRT.IB.GRI.ST.0030"] = { Value = -1.5 },
            ["GRD.SRT.IB.GRI.ST.0040"] = { Value = "abc" },
            ["GRD.SRT.IB.GRI.ST.0050"] = { Value = { x = 123 } },
            ["GRD.SRT.IB.GRI.ST.0060"] = { Value = function()
                return 123
            end },
        },
        function(options)
            -- ACT + ASSERT
            U.Should.Throw(function()
                Guard.Assert.IsBooleanizable(options.Value, "options.Value")
            end)
        end
)
