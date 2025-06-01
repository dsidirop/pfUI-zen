local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Scopify    = using "System.Scopify"
local EScopes    = using "System.EScopes"
local Reflection = using "System.Reflection"

local Exception                  = using "System.Exceptions.Exception"
local NotImplementedException    = using "System.Exceptions.NotImplementedException"
local ValueIsOutOfRangeException = using "System.Exceptions.ValueIsOutOfRangeException"

local U = using "[built-in]" [[ VWoWUnit ]] -- @formatter:on

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Core.Tests.Reflection.IsInstanceOf.Testbed",
    Tags = { "system", "core", "reflection", "is-instance-of" },
}

Scopify(EScopes.Function, {})

TestsGroup:AddTheory("T010.Reflection.IsInstanceOf.GivenVariousDirectInheritancePairs.ShouldReturnExpectedVerdict", -- @formatter:off
        {
            ["REF.IIO.GVDRIP.SREV.0000"] = { Base = Exception,  Subclass = 10,                                        ExpectedVerdict = false },
            ["REF.IIO.GVDRIP.SREV.0005"] = { Base = Exception,  Subclass = Exception, --[[not an instance really]]    ExpectedVerdict = false },
            ["REF.IIO.GVDRIP.SREV.0010"] = { Base = Exception,  Subclass = Exception:New("foobar"),                   ExpectedVerdict = true  },
            ["REF.IIO.GVDRIP.SREV.0020"] = { Base = Exception,  Subclass = NotImplementedException:New("foobar"),     ExpectedVerdict = true  },
            ["REF.IIO.GVDRIP.SREV.0030"] = { Base = Exception,  Subclass = ValueIsOutOfRangeException:New("foobar"),  ExpectedVerdict = true  },
            ["REF.IIO.GVDRIP.SREV.0035"] = { Base = Exception,  Subclass = (using "[declare]" "REF.IIO.GVDRIP.SREV.0035"), ExpectedVerdict = false },
        }, -- @formatter:on
        function(specs)
            -- ARRANGE

            -- ACT
            local action = function()
                return Reflection.IsInstanceOf(specs.Subclass, specs.Base)
            end

            -- ASSERT
            local verdict = U.Should.Not.Throw(action)

            U.Should.Be.PlainlyEqual(verdict, specs.ExpectedVerdict)
        end
)
