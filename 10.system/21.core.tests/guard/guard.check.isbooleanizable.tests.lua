local _setfenv, _importer, _VWoWUnit = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _VWoWUnit = _assert(_g.VWoWUnit)
    local _importer = _assert(_g.pvl_namespacer_get)

    return _setfenv, _importer, _VWoWUnit
end)()

_setfenv(1, {})

local Try = _importer("System.Try")
local Guard = _importer("System.Guard")
local Exception = _importer("System.Exceptions.Exception")

local TestsGroup = _VWoWUnit.I:CreateOrUpdateGroup {
    Name = "System.Guard.Check.IsBooleanizable",
    Tags = { "guard", "guard-check", "guard-check-booleanizables" }
}

TestsGroup:AddTheory("Guard.Check.IsBooleanizable.GivenGreenInput.ShouldNotThrow",
        {
            ["GRD.CHK.IB.GGI.SNT.0000"] = { Value = 0 },
            ["GRD.CHK.IB.GGI.SNT.0010"] = { Value = 1 },
            ["GRD.CHK.IB.GGI.SNT.0020"] = { Value = -1 },

            ["GRD.CHK.IB.GGI.SNT.0020"] = { Value = true },
            ["GRD.CHK.IB.GGI.SNT.0020"] = { Value = false },

            ["GRD.CHK.IB.GGI.SNT.0030"] = { Value = "y" },
            ["GRD.CHK.IB.GGI.SNT.0030"] = { Value = "Y" },
            ["GRD.CHK.IB.GGI.SNT.0030"] = { Value = "Yes" },
            ["GRD.CHK.IB.GGI.SNT.0030"] = { Value = "YES" },
            ["GRD.CHK.IB.GGI.SNT.0030"] = { Value = "T" },
            ["GRD.CHK.IB.GGI.SNT.0030"] = { Value = "True" },
            ["GRD.CHK.IB.GGI.SNT.0030"] = { Value = "TRUE" },

            ["GRD.CHK.IB.GGI.SNT.0030"] = { Value = "n" },
            ["GRD.CHK.IB.GGI.SNT.0030"] = { Value = "N" },
            ["GRD.CHK.IB.GGI.SNT.0030"] = { Value = "No" },
            ["GRD.CHK.IB.GGI.SNT.0030"] = { Value = "NO" },
            ["GRD.CHK.IB.GGI.SNT.0030"] = { Value = "F" },
            ["GRD.CHK.IB.GGI.SNT.0030"] = { Value = "False" },
            ["GRD.CHK.IB.GGI.SNT.0030"] = { Value = "FALSE" },
        },
        function(options)
            -- ARRANGE
            local gotException = false

            -- ACT
            Try(function() --@formatter:off
                Guard.Check.IsBooleanizable(options.Value, "options.Value")
            end)
            :Catch(Exception, function()
                gotException = true
            end)
            :Run() --@formatter:on

            -- ASSERT
            _VWoWUnit.IsFalse(gotException, options.GuardShouldThrowException)
        end
)

TestsGroup:AddTheory("Guard.Check.IsBooleanizable.GivenRedInput.ShouldThrow",
        {
            ["GRD.CHK.IB.GRI.ST.0000"] = { Value = nil },
            ["GRD.CHK.IB.GRI.ST.0010"] = { Value = 0.3 },
            ["GRD.CHK.IB.GRI.ST.0020"] = { Value = 1.5 },
            ["GRD.CHK.IB.GRI.ST.0030"] = { Value = -1.5 },
            ["GRD.CHK.IB.GRI.ST.0040"] = { Value = "abc" },
            ["GRD.CHK.IB.GRI.ST.0050"] = { Value = { x = 123 } },
            ["GRD.CHK.IB.GRI.ST.0060"] = { Value = function()
                return 123
            end },
        },
        function(options)
            -- ARRANGE
            local gotException = false

            -- ACT
            Try(function() --@formatter:off
                Guard.Check.IsBooleanizable(options.Value, "options.Value")
            end)
            :Catch(Exception, function()
                gotException = true
            end)
            :Run() --@formatter:on

            -- ASSERT
            _VWoWUnit.IsTrue(gotException)
        end
)
