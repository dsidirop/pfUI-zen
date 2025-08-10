--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Try = using "System.Try"

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Inheritance.Testbed"

TG:AddFact("T009.Inheritance.Subclassing.GivenSameNicknameForTwoParents.ShouldThrow",
        function()
            -- ARRANGE
            Try(function() using "[healthcheck]" end):CatchAll():Run() -- vital to set a milestone before we run the test

            -- ACT
            function action()
                -- in the first partial file of the Bar definition we blend-in Foo1
                local Foo1 = using "[declare]" "T009.Inheritance.Subclassing.GivenSameNicknameForTwoParents.ShouldThrow.Foo1"

                local __ = using "[declare] [blend]" "T009.Inheritance.Subclassing.GivenSameNicknameForTwoParents.ShouldThrow.Bar [Partial]" {
                    "Foo", Foo1
                }

                -- in another partial file we continue adding to the Bar definition ...
                local Foo2 = using "[declare]" "T009.Inheritance.Subclassing.GivenSameNicknameForTwoParents.ShouldThrow.Foo2"

                local ___ = using "[declare] [blend]" "T009.Inheritance.Subclassing.GivenSameNicknameForTwoParents.ShouldThrow.Bar [Partial]" {
                    "Foo", Foo2 -- same key should cause an exception
                }
            end

            -- ASSERT
            U.Should.Throw(action, "*[NR.BM.062]*") -- order

            Try(function() using "[healthcheck]" end):CatchAll():Run() -- order   vital  todo we should support removing faulty classes altogether
        end
)
