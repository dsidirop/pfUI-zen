local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local TG, U = using "[testgroup] [tagged]" "System.Core.Tests.Classes.Fields.Testbed" { "system", "system-core", "classes", "autocall" }

TG:AddFact("T010.Classes.Attributes.GivenInvalidAttributeOnValidMethod.ShouldThrow",
        function()
            -- ARRANGE

            -- ACT
            function action()
                local Class = using "[declare]" "T010.Classes.Attributes.GivenInvalidAttributeOnValidMethod.ShouldThrow.Foobar"

                using "[abstract]" -- invalid
                function Class:Ping()
                    return "ping"
                end
            end

            -- ASSERT
            U.Should.Throw(action, "*[NR.NSCPF.SNIF.FNSC.030]*[T010.Classes.Attributes.GivenInvalidAttributeOnValidMethod.ShouldThrow.Foobar:Ping()]*")
        end
)
