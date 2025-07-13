--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Fields.Testbed"

TG:AddFact("T025.Classes.AutocallAttr.GivenMismatchedAutocallAttribute.ShouldError",
        function()
            -- ARRANGE

            -- ACT
            function action()
                local IFooInterface = using "[declare] [interface]" "T025.Classes.AutocallAttr.GivenMismatchedAutocallAttribute.ShouldError.IFooInterface"
                
                function IFooInterface:Ping()
                end
            
                local Zip = using "[declare]" "T025.Classes.AutocallAttr.GivenMismatchedAutocallAttribute.ShouldError.Zip"
                
                local Class = using "[declare] [blend]" "T025.Classes.AutocallAttr.GivenMismatchedAutocallAttribute.ShouldError.Foobar" {
                    "IFooInterface", IFooInterface
                }

                using "[autocall]" "Ping"
                function Zip:Ping() -- should throw due to class mismatch
                    return "ping"
                end

                local instance = Class:New()

                return instance()
            end

            -- ASSERT
            U.Should.Throw(action, "*[NR.NSCPF.SNIF.FNSC.020]*")
        end
)
