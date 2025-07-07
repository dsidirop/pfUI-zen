--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Inheritance.Testbed"

TG:AddFact("T007.Inheritance.Subclassing.GivenSimpleCircularDependencyBlendingAttempt.ShouldThrow",
        function()
            -- ARRANGE
            do
                local Foo = using "[declare]" "T007.Inheritance.Subclassing.GivenSimpleCircularDependencyBlendingAttempt.ShouldThrow.Foo"

                local _ = using "[declare] [blend]" "T007.Inheritance.Subclassing.GivenSimpleCircularDependencyBlendingAttempt.ShouldThrow.Bar" {
                    "Foo", Foo
                }
            end

            -- ACT
            function action()
                local Bar = using "T007.Inheritance.Subclassing.GivenSimpleCircularDependencyBlendingAttempt.ShouldThrow.Bar"

                using "[declare] [blend]" "T007.Inheritance.Subclassing.GivenSimpleCircularDependencyBlendingAttempt.ShouldThrow.Foo [Partial]" {
                    "Bar", Bar -- circular dependency
                }
            end

            -- ASSERT    we dont get [NR.BM.053] here because [NR.ASR.HNBEAPCY.010] gets detected first by merit of the fact that we are trying amend a class that was already used as a parent beforehand!
            U.Should.Throw(action, "*[NR.ASR.HNBEAPCY.010]*")
        end
)
