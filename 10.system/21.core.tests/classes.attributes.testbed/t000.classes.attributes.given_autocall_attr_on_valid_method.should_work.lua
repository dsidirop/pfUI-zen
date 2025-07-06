local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local TG, U = using "[testgroup] [tagged]" "System.Core.Tests.Classes.Fields.Testbed" { "system", "system-core", "classes", "autocall" }

TG:AddFact("T000.Classes.Attributes.GivenAutoCallAttributeOnValidMethod.ShouldWork",
        function()
            -- ARRANGE

            -- ACT
            function action()
                local Class = using "[declare]" "T000.Classes.Attributes.GivenAutoCallAttributeOnValidMethod.ShouldWork.Foobar"

                using "[autocall]"
                function Class:Ping()
                    return "ping"
                end

                local instance = Class:New()

                return instance()
            end

            -- ASSERT
            local result = U.Should.Not.Throw(action)

            U.Should.Be.PlainlyEqual(result, "ping")
        end
)
