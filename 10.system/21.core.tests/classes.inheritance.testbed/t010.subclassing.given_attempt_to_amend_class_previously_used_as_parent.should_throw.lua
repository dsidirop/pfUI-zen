--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Inheritance.Testbed"

TG:AddFact("T010.Inheritance.Subclassing.GivenAttemptToAmendClassPreviouslyUsedAsParent.ShouldThrow",
        function()
            -- ARRANGE

            -- ACT
            function action()
                do
                    -- in one file ...
                    local Foo = using "[declare]" "T010.Inheritance.Subclassing.GivenAttemptToAmendClassPreviouslyUsedAsParent.ShouldThrow.Foo"

                    local _ = using "[declare] [blend]" "T010.Inheritance.Subclassing.GivenAttemptToAmendClassPreviouslyUsedAsParent.ShouldThrow.Bar" {
                        "Foo", Foo
                    }
                end

                do -- in another file we try to amend the class Foo through [partial] after it has been used as a parent above!
                    local _ = using "[declare]" "T010.Inheritance.Subclassing.GivenAttemptToAmendClassPreviouslyUsedAsParent.ShouldThrow.Foo [Partial]"    
                end
            end

            -- ASSERT
            U.Should.Throw(action, "*[NR.ASR.HNBEAPCY.010]*")
        end
)
