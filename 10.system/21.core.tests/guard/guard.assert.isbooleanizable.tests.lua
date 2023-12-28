local U, _setfenv, _importer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local U = _assert(_g.VWoWUnit)
    local _importer = _assert(_g.pvl_namespacer_get)

    return U, _setfenv, _importer
end)()

_setfenv(1, {})

local Try = _importer("System.Try")
local Guard = _importer("System.Guard")
local Exception = _importer("System.Exceptions.Exception")

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Guard.Assert.IsBooleanizable",
    Tags = { "guard", "guard-check", "guard-check-booleanizables" }
}

TestsGroup:AddTheory("Guard.Assert.IsBooleanizable.GivenGreenInput.ShouldNotThrow",
        {
            ["GRD.SRT.IB.GGI.SNT.0000"] = { Value = 0 },
            ["GRD.SRT.IB.GGI.SNT.0010"] = { Value = 1 },
            ["GRD.SRT.IB.GGI.SNT.0020"] = { Value = -1 },

            ["GRD.SRT.IB.GGI.SNT.0020"] = { Value = true },
            ["GRD.SRT.IB.GGI.SNT.0020"] = { Value = false },

            ["GRD.SRT.IB.GGI.SNT.0030"] = { Value = "y" },
            ["GRD.SRT.IB.GGI.SNT.0030"] = { Value = "Y" },
            ["GRD.SRT.IB.GGI.SNT.0030"] = { Value = "Yes" },
            ["GRD.SRT.IB.GGI.SNT.0030"] = { Value = "YES" },
            ["GRD.SRT.IB.GGI.SNT.0030"] = { Value = "T" },
            ["GRD.SRT.IB.GGI.SNT.0030"] = { Value = "True" },
            ["GRD.SRT.IB.GGI.SNT.0030"] = { Value = "TRUE" },

            ["GRD.SRT.IB.GGI.SNT.0030"] = { Value = "n" },
            ["GRD.SRT.IB.GGI.SNT.0030"] = { Value = "N" },
            ["GRD.SRT.IB.GGI.SNT.0030"] = { Value = "No" },
            ["GRD.SRT.IB.GGI.SNT.0030"] = { Value = "NO" },
            ["GRD.SRT.IB.GGI.SNT.0030"] = { Value = "F" },
            ["GRD.SRT.IB.GGI.SNT.0030"] = { Value = "False" },
            ["GRD.SRT.IB.GGI.SNT.0030"] = { Value = "FALSE" },
        },
        function(options)
            -- ARRANGE
            local gotException = false

            -- ACT
            Try(function() --@formatter:off
                Guard.Assert.IsBooleanizable(options.Value, "options.Value")
            end)
            :Catch(Exception, function()
                gotException = true
            end)
            :Run() --@formatter:on

            -- ASSERT
            U.Should.Be.Falsy(gotException, options.GuardShouldThrowException)
        end
)

TestsGroup:AddTheory("Guard.Assert.IsBooleanizable.GivenRedInput.ShouldThrow",
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
            -- ARRANGE
            local gotException = false

            -- ACT
            Try(function() --@formatter:off
                Guard.Assert.IsBooleanizable(options.Value, "options.Value")
            end)
            :Catch(Exception, function()
                gotException = true
            end)
            :Run() --@formatter:on

            -- ASSERT
            U.Should.Be.Truthy(gotException)
        end
)
