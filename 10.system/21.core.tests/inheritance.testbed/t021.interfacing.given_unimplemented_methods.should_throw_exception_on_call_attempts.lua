local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Inheritance.Testbed"

TG:AddDynamicTheory("T021.Inheritance.Interfacing.GivenUnimplementedMethods.ShouldThrowExceptionOnCallAttempts",
        function()
            return {
                ["INH.INTF.GUM.STEOCA.010"] = {
                    Action = function()
                        local IFoo = using "[declare] [interface]" "INH.INTF.GUM.STEOCA.010.IFoo"

                        function IFoo:Ping(a, b, c)
                            -- Throw(NotImplementedException:New()) -- this is not needed because the infrastructure already auto-sets the methods properly 
                        end

                        local Bar = using "[declare] [blend]" "INH.INTF.GUM.STEOCA.010.Bar" {
                            ["Foo"] = IFoo,
                        }

                        function Bar:New()
                            return self:Instantiate()
                        end
                        
                        local barInstance = Bar:New()
                        
                        barInstance:Ping() -- this should throw
                    end,

                    ErrorGlob = ""
                            .. "*[System.Exceptions.NotImplementedException]" -- healthcheck failed
                            .. "*[INH.INTF.GUM.STEOCA.010.IFoo:Ping()]"
                            .. "*[INH.INTF.GUM.STEOCA.010.Bar]*"
                },

                ["INH.INTF.GUM.STEOCA.020"] = {
                    Action = function()
                        local IFoo1 = using "[declare] [interface]" "INH.INTF.GUM.STEOCA.020.IFoo1"

                        function IFoo1:Ping(a, b, c)
                            -- Throw(NotImplementedException:New()) -- this is not needed because the infrastructure already auto-sets the methods properly
                        end

                        local IFoo2 = using "[declare] [interface] [blend]" "INH.INTF.GUM.STEOCA.020.IFoo2" {
                            ["Foo1"] = IFoo1,
                        }

                        local Bar = using "[declare] [blend]" "INH.INTF.GUM.STEOCA.020.Bar" {
                            ["Foo2"] = IFoo2,
                        }

                        function Bar:New()
                            return self:Instantiate()
                        end

                        local barInstance = Bar:New()

                        barInstance.Ping() -- this should throw too
                    end,

                    ErrorGlob = ""
                            .. "*[System.Exceptions.NotImplementedException]" -- healthcheck failed
                            .. "*[INH.INTF.GUM.STEOCA.020.IFoo2:Ping()]*"
                },
            }
        end,
        function(options)
            -- ARRANGE

            -- ACT + ASSERT
            U.Should.Throw(options.Action, options.ErrorGlob)
        end
)
