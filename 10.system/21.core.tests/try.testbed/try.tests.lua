--[[@formatter:off]] local _g = assert((_G or getfenv(0) or {})); local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Try = using "System.Try"
local Throw = using "System.Exceptions.Throw"
local Exception = using "System.Exceptions.Exception"

local TG, U = using "[testgroup] [tagged]" "System.Core.Tests.Try.Testbed" { "system", "try" }

TG:AddFact("T000.Try.GivenCatchAll.ShouldNotThrowException",
        function()
            -- ARRANGE

            -- ACT
            function action()
                Try(function() Throw(Exception:New("foobar")) end)
                        :CatchAll()
                        :Run()
            end

            -- ASSERT
            U.Should.Not.Throw(action)
        end
)
