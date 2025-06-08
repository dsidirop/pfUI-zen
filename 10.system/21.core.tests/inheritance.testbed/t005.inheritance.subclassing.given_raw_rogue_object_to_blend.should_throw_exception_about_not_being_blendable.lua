local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Inheritance.Testbed"

TG:AddFact("T005.Inheritance.Subclassing.GivenRawRogueObjectToBlend.ShouldThrowExceptionAboutNotBeingBlendable",
        function()
            -- ARRANGE

            -- ACT
            function action()
                _ = using "[declare] [blend]" "T005.Inheritance.Subclassing.GivenRawRogueObjectToBlend.ShouldThrowExceptionAboutNotBeingBlendable.Foo" {
                    ["Bar"] = {
                        a = 1,
                        b = 2,
                    },
                }
            end

            -- ASSERT
            U.Should.Throw(action, "*[NR.BM.060]*")
        end
)
