local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local U = using "[built-in]" [[ VWoWUnit ]] -- @formatter:on         

local TG = U.TestsEngine:CreateOrUpdateGroup { Name = "System.Core.Tests.Classes.Inheritance.Testbed" }

Scopify(EScopes.Function, {})

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
