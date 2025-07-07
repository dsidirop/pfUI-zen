--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Inheritance.Testbed"

TG:AddFact("T005.Inheritance.Subclassing.GivenRawRogueObjectToBlend.ShouldThrow",
        function()
            -- ARRANGE

            -- ACT
            function action()
                _ = using "[declare] [blend]" "T005.Inheritance.Subclassing.GivenRawRogueObjectToBlend.ShouldThrow.Foo" {
                    { "Bar", { a = 1, b = 2 } },
                }
            end

            -- ASSERT
            U.Should.Throw(action, "*[NR.BM.020]*")
        end
)
