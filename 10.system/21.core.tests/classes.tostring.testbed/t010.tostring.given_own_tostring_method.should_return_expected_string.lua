--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local S = using "System.Helpers.Strings"

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.ToString.Testbed"

TG:AddFact("T010.ToString.GivenOwnToStringMethod.ShouldReturnExpectedString",
        function()
            -- ARRANGE

            -- ACT
            function action()
                local Class = using "[declare]" "T010.ToString.GivenOwnToStringMethod.ShouldReturnExpectedString.Foobar"
                
                function Class:ToString()
                    return 123 -- this should be converted to a string automatically by the mechanism
                end
                
                return S.Format("%s", Class:New())
            end

            -- ASSERT
            local result = U.Should.Not.Throw(action)
            
            U.Should.Be.PlainlyEqual(result, "123")
        end
)
