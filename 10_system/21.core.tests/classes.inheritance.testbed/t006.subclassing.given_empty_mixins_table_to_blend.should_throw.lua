--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Inheritance.Testbed"

TG:AddFact("T006.Inheritance.Subclassing.GivenEmptyMixinsTableToBlend.ShouldThrow",
        function()
            -- ARRANGE

            -- ACT
            function action()
                using "[declare] [blend]" "T006.Inheritance.Subclassing.GivenEmptyMixinsTableToBlend.ShouldThrow.Ping" {}
            end

            -- ASSERT
            U.Should.Throw(action, "*[NR.BM.010]*")
        end
)
