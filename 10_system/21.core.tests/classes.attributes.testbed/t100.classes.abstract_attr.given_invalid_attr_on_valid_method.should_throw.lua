--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Fields.Testbed"

TG:AddFact("T100.Classes.AbstractAttr.GivenInvalidAttributeOnValidMethod.ShouldThrow",
        function()
            -- ARRANGE

            -- ACT
            function action()
                local Class = using "[declare]" "T100.Classes.AbstractAttr.GivenInvalidAttributeOnValidMethod.ShouldThrow.Foobar"

                using "[abstract]" "Ping" -- invalid
                function Class:Ping()
                    return "ping"
                end
            end

            -- ASSERT
            U.Should.Throw(action, "*[NR.MA.NFABST.CTOR.015]*[T100.Classes.AbstractAttr.GivenInvalidAttributeOnValidMethod.ShouldThrow.Foobar:Ping()]*")
        end
)
