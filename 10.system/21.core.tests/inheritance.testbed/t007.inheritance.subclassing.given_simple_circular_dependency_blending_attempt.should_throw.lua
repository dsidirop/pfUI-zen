local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Inheritance.Testbed"

TG:AddFact("T007.Inheritance.Subclassing.GivenSimpleCircularDependencyBlendingAttempt.ShouldThrow",
        function()
            -- ARRANGE
            do
                local Foo = using "[declare]" "T007.Inheritance.Subclassing.GivenSimpleCircularDependencyBlendingAttempt.ShouldThrow.Foo"

                local _ = using "[declare] [blend]" "T007.Inheritance.Subclassing.GivenSimpleCircularDependencyBlendingAttempt.ShouldThrow.Bar" {
                    ["Foo"] = Foo,
                }
            end

            -- ACT
            function action()
                local Bar = using "T007.Inheritance.Subclassing.GivenSimpleCircularDependencyBlendingAttempt.ShouldThrow.Bar"

                using "[declare] [blend]" "T007.Inheritance.Subclassing.GivenSimpleCircularDependencyBlendingAttempt.ShouldThrow.Foo [Partial]" {
                    ["Bar"] = Bar, -- circular dependency
                }
            end

            -- ASSERT
            U.Should.Throw(action, "*[NR.BM.053]*")
        end
)
