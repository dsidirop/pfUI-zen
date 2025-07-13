--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Fields.Testbed"

TG:AddFact("T000.Classes.Attributes.GivenAutoCallAttributeOnValidMethod.ShouldWork",
        function()
            -- ARRANGE

            -- ACT
            function action()
                local IFooInterface = using "[declare] [interface]" "T000.Classes.Attributes.GivenAutoCallAttributeOnValidMethod.ShouldWork.IFooInterface"
                
                function IFooInterface:Ping()
                end
                
                local Class = using "[declare] [blend]" "T000.Classes.Attributes.GivenAutoCallAttributeOnValidMethod.ShouldWork.Foobar" {
                    "IFooInterface", IFooInterface
                }

                using "[autocall]" "Ping"
                function Class:Ping()
                    return "ping"
                end
            
                using "[autocall]" "Pong"
                function Class:Pong()
                    return "pong"
                end

                local instance = Class:New()

                return instance()
            end

            -- ASSERT
            local result = U.Should.Not.Throw(action)

            U.Should.Be.PlainlyEqual(result, "pong")
        end
)
