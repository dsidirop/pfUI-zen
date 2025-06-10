local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

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
