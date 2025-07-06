local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local S = using "System.Helpers.Strings"

local TG, U = using "[testgroup] [tagged]" "System.Core.Tests.Classes.ToString.Testbed" { "system", "system-core", "classes", "tostring" }

TG:AddFact("T005.ToString.GivenNoStringMethod.ShouldPrintNamespace",
        function()
            -- ARRANGE

            -- ACT
            function action()
                local Class = using "[declare]" "T005.ToString.GivenNoStringMethod.ShouldPrintNamespace.Foobar"
                
                return S.Format("%s", Class:New())
            end

            -- ASSERT
            local result = U.Should.Not.Throw(action)
            
            U.Should.Be.PlainlyEqual(result, "T005.ToString.GivenNoStringMethod.ShouldPrintNamespace.Foobar")
        end
)
