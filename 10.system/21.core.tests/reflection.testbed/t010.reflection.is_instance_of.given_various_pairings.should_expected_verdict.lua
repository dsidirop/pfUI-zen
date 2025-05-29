local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Scopify    = using "System.Scopify"
local EScopes    = using "System.EScopes"
local Reflection = using "System.Reflection"

local Exception                  = using "System.Exceptions.Exception"
local NotImplementedException    = using "System.Exceptions.NotImplementedException"
local ValueIsOutOfRangeException = using "System.Exceptions.ValueIsOutOfRangeException"

local U = using "[built-in]" [[ VWoWUnit ]] -- @formatter:on

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Core.Tests.Reflection.Testbed",
    Tags = { "system", "reflection", "instance-of" },
}

Scopify(EScopes.Function, {})

TestsGroup:AddTheory("T010.Reflection.IsInstanceOf.GivenVariousPairings.ShouldReturnExpectedVerdict", -- @formatter:off
        {
            ["REF.IIO.GVGV.SRT.0000"] = { Value = 10,                                       Proto = Exception, ExpectedVerdict = false },
            ["REF.IIO.GVGV.SRT.0010"] = { Value = Exception:New("foobar"),                  Proto = Exception, ExpectedVerdict = true  },
            ["REF.IIO.GVGV.SRT.0020"] = { Value = NotImplementedException:New("foobar"),    Proto = Exception, ExpectedVerdict = true  },
            ["REF.IIO.GVGV.SRT.0030"] = { Value = ValueIsOutOfRangeException:New("foobar"), Proto = Exception, ExpectedVerdict = true  },
        }, -- @formatter:on
        function(specs)
            -- ARRANGE

            -- ACT
            local action = function()
                return Reflection.IsInstanceOf(specs.Value, specs.Proto)
            end

            -- ASSERT
            local verdict = U.Should.Not.Throw(action)

            U.Should.Be.PlainlyEqual(verdict, specs.ExpectedVerdict)
        end
)
