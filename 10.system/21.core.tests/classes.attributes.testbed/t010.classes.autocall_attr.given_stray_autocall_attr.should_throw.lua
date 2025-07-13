--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Fields.Testbed"

TG:AddFact("T010.Classes.AutocallAttr.GivenStrayAutocallAttribute.ShouldError",
        function()
            -- ARRANGE

            -- ACT
            function action()
                local IFooInterface = using "[declare] [interface]" "T010.Classes.AutocallAttr.GivenStrayAutocallAttribute.ShouldError.IFooInterface"
                
                function IFooInterface:Ping()
                end
                
                local Class = using "[declare] [blend]" "T010.Classes.AutocallAttr.GivenStrayAutocallAttribute.ShouldError.Foobar" {
                    "IFooInterface", IFooInterface
                }

                using "[autocall]" "Ping"
                -- missing the class:method here ...
                
                local NextClass = using "[declare]" "T010.Classes.AutocallAttr.GivenStrayAutocallAttribute.ShouldError.NextClass" -- should error out due to the stray autocall attribute

                local instance = Class:New()

                return instance()
            end

            -- ASSERT
            U.Should.Throw(action, "*[NR.ASR.NSPA.010]*")
        end
)
