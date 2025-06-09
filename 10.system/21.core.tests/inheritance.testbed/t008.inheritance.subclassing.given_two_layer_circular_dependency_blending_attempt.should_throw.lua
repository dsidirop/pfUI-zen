local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Inheritance.Testbed"

TG:AddFact("T008.Inheritance.Subclassing.GivenTwoLayerCircularDependencyBlendingAttempt.ShouldThrow",
        function()
            -- ARRANGE
            do
                local GreatGrandParent = using "[declare]" "T008.Inheritance.Subclassing.GivenTwoLayerCircularDependencyBlendingAttempt.ShouldThrow.GreatGrandParent"

                local GrantParent = using "[declare] [blend]" "T008.Inheritance.Subclassing.GivenTwoLayerCircularDependencyBlendingAttempt.ShouldThrow.GrantParent" {
                    ["GGParent"] = GreatGrandParent,
                }

                local Parent = using "[declare] [blend]" "T008.Inheritance.Subclassing.GivenTwoLayerCircularDependencyBlendingAttempt.ShouldThrow.Parent" {
                    ["GParent"] = GrantParent,
                }

                local GreatGrandChild = using "[declare] [blend]" "T008.Inheritance.Subclassing.GivenTwoLayerCircularDependencyBlendingAttempt.ShouldThrow.GreatGrandChild" {
                    ["Parent"] = Parent,
                }
            end

            -- ACT
            function action()
                local GreatGrandChild = using "T008.Inheritance.Subclassing.GivenTwoLayerCircularDependencyBlendingAttempt.ShouldThrow.GreatGrandChild"

                local GreatGrandParent = using "[declare] [blend]" "T008.Inheritance.Subclassing.GivenTwoLayerCircularDependencyBlendingAttempt.ShouldThrow.GreatGrandParent [Partial]" {
                    ["GrandChild"] = GreatGrandChild,
                }
            end

            -- ASSERT
            U.Should.Throw(action, "*[NR.BM.053]*")
        end
)
