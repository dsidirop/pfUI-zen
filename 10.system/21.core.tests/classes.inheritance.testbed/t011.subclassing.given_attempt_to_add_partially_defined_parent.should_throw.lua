local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Inheritance.Testbed"

TG:AddFact("T011.Inheritance.Subclassing.GivenAttemptToAddPartiallyDefinedParent.ShouldThrow",
        function()
            -- ARRANGE

            -- ACT
            function action()
                local Foo = using "[declare]" "T011.Inheritance.Subclassing.GivenAttemptToAddPartiallyDefinedParent.ShouldThrow.Foo [Partial]"

                local _ = using "[declare] [blend]" "T011.Inheritance.Subclassing.GivenAttemptToAddPartiallyDefinedParent.ShouldThrow.Bar" {
                    "Foo", Foo
                }
            end

            -- ASSERT
            U.Should.Throw(action, "*[NR.BM.064]*")
        end
)
