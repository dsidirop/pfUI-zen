--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Throw = using "System.Exceptions.Throw"
local Exception = using "System.Exceptions.Exception"

local TG, U = using "[testgroup] [tagged]" "System.Core.Tests.Throw.Testbed" { "system", "throw" }

TG:AddFact("T000.Throw.GivenExceptionToThrow.ShouldThrowException",
        function()
            -- ARRANGE

            -- ACT
            function action()
                Throw(Exception:New("foobar"))
            end

            -- ASSERT
            U.Should.Throw(action, "*foobar*")
        end
)

TG:AddTheory("T010.Throw.GivenInvalidExceptionToThrow.ShouldTriggerGuardAssertion",
        {
            ["THR.GIETT.STGA.000"] = { BadException = 1 },
            ["THR.GIETT.STGA.010"] = { BadException = nil },
            ["THR.GIETT.STGA.020"] = { BadException = true },
            ["THR.GIETT.STGA.030"] = { BadException = false },
            ["THR.GIETT.STGA.040"] = { BadException = function() end },
        },
        function(specs)
            -- ARRANGE

            -- ACT
            function action()
                Throw(specs.BadException)
            end

            -- ASSERT
            U.Should.Throw(action, "*[THR.CLL.010]*")
        end
)
