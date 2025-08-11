--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Inheritance.Testbed"

TG:AddDynamicTheory("T020.Inheritance.Interfacing.GivenPartialParentInterface.ShouldThrow",
        function()
            return {
                ["INH.INTF.GPPI.ST.010"] = {
                    Action = function()
                        local IFoo = using "[declare] [interface]" "INH.INTF.GPPI.ST.010.IFoo [Partial]"

                        local __ = using "[declare] [blend]" "INH.INTF.GPPI.ST.010.Bar" {
                            "Foo", IFoo -- IFoo is still partial so this should throw
                        }        
                    end,

                    ErrorGlob = "*[NR.BM.064]*"
                },

                ["INH.INTF.GPPI.ST.020"] = {
                    Action = function()
                        local IFoo = using "[declare] [interface] [blend]" "INH.INTF.GPPI.ST.020.IFoo [Partial]" {
                            "IPing", using "[declare] [interface]" "INH.INTF.GPPI.ST.020.IPing"
                        }

                        local __ = using "[declare] [blend]" "INH.INTF.GPPI.ST.020.Bar" {
                            "Foo", IFoo -- IFoo is still partial so this should throw
                        }
                    end,

                    ErrorGlob = "*[NR.BM.064]*"
                },
            }
        end,
        function(options)
            -- ARRANGE

            -- ACT + ASSERT
            U.Should.Throw(options.Action, options.ErrorGlob)
        end
)
