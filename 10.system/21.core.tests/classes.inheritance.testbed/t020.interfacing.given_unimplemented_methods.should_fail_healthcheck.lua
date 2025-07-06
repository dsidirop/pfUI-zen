local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Inheritance.Testbed"

TG:AddDynamicTheory("T020.Inheritance.Interfacing.GivenUnimplementedMethods.ShouldFailHealthcheck",
        function()
            return {
                ["INH.INTF.GUM.SFH.010"] = {
                    Action = function()
                        local IFoo = using "[declare] [interface]" "INH.INTF.GUM.SFH.010.IFoo"

                        function IFoo:Ping()
                            -- Throw(NotImplementedException:New()) -- this is not needed because the infrastructure already auto-sets the methods properly 
                        end

                        local Bar = using "[declare] [blend]" "INH.INTF.GUM.SFH.010.Bar" {
                            "Foo", IFoo
                        }

                        function Bar:New()
                            return self:Instantiate()
                        end

                        using "[healthcheck]" -- this should throw        
                    end,

                    ErrorGlob = ""
                            .. "*[NR.HCR.RN.020]" -- healthcheck failed
                            .. "*[NR.ENT.HCI.010]" -- class lacks implementation of interface methods
                            .. "*[INH.INTF.GUM.SFH.010.Bar]"
                            .. "*[INH.INTF.GUM.SFH.010.IFoo:Ping()]*"
                },

                ["INH.INTF.GUM.SFH.020"] = {
                    Action = function()
                        local IFoo1 = using "[declare] [interface]" "INH.INTF.GUM.SFH.020.IFoo1"

                        function IFoo1:Ping()
                            -- Throw(NotImplementedException:New()) -- this is not needed because the infrastructure already auto-sets the methods properly
                        end

                        local IFoo2 = using "[declare] [interface] [blend]" "INH.INTF.GUM.SFH.020.IFoo2" {
                            "Foo1", IFoo1
                        }

                        local Bar = using "[declare] [blend]" "INH.INTF.GUM.SFH.020.Bar" {
                            "Foo2", IFoo2
                        }

                        function Bar:New()
                            return self:Instantiate()
                        end

                        using "[healthcheck]" -- this should throw
                    end,

                    ErrorGlob = ""
                            .. "*[NR.HCR.RN.020]" -- healthcheck failed
                            .. "*[NR.ENT.HCI.010]" -- class lacks implementation of interface methods
                            .. "*[INH.INTF.GUM.SFH.020.Bar]"
                            .. "*[INH.INTF.GUM.SFH.020.IFoo2:Ping()]*"
                },
            }
        end,
        function(options)
            -- ARRANGE

            -- ACT + ASSERT
            U.Should.Throw(options.Action, options.ErrorGlob)
        end
)
