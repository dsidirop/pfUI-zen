--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Fields.Testbed"

TG:AddFact("T020.Classes.AutocallAttr.GivenMismatchedAutocallAttribute.ShouldError",
        function()
            -- ARRANGE

            -- ACT
            function action()
                local Class = using "[declare]" "T020.Classes.AutocallAttr.GivenMismatchedAutocallAttribute.ShouldError.Foobar"

                using "[autocall]" "Ping"
                function Class:Ping2() -- should throw due to method name mismatch
                    return "ping"
                end

                local instance = Class:New()

                return instance()
            end

            -- ASSERT
            U.Should.Throw(action, "*[NR.NSCPF.SNIF.FNSC.020]*")
        end
)
