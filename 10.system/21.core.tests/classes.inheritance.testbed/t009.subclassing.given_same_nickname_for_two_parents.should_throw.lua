--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Inheritance.Testbed"

TG:AddFact("T009.Inheritance.Subclassing.GivenSameNicknameForTwoParents.ShouldThrow",
        function()
            -- ARRANGE

            -- ACT
            function action()
                -- in the first partial file of the Bar definition we blend-in Foo1
                local Foo1 = using "[declare]" "T009.Inheritance.Subclassing.GivenSameNicknameForTwoParents.ShouldThrow.Foo1"

                local __ = using "[declare] [blend]" "T009.Inheritance.Subclassing.GivenSameNicknameForTwoParents.ShouldThrow.Bar [Partial]" {
                    "Foo", Foo1
                }

                -- in another partial file we continue adding to the Bar definition ...
                local Foo2 = using "[declare]" "T009.Inheritance.Subclassing.GivenSameNicknameForTwoParents.ShouldThrow.Foo2"

                local __ = using "[declare] [blend]" "T009.Inheritance.Subclassing.GivenSameNicknameForTwoParents.ShouldThrow.Bar [Partial]" {
                    "Foo", Foo2 -- same key should cause an exception
                }
            end

            -- ASSERT
            U.Should.Throw(function() __ = using "[healthcheck]" end, "*[NR.ENT.HCP.010]*") -- vital  todo we should support removing faulty classes altogether

            U.Should.Throw(action, "*[NR.BM.062]*")
        end
)
