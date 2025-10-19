--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Inheritance.Testbed"

TG:AddDynamicTheory("T020.Inheritance.Abstraction.GivenPartialParentAbstract.ShouldThrow",
        function()
            return {
                ["INH.ABS.GPPA.ST.010"] = {
                    Action = function()
                        local AFoo = using "[declare] [abstract]" "INH.ABS.GPPA.ST.010.AFoo [Partial]"

                        local __ = using "[declare] [blend]" "INH.ABS.GPPA.ST.010.Bar" {
                            "Foo", AFoo -- AFoo is still partial so this should throw
                        }        
                    end,
                    
                    ErrorGlob = "*[NR.BM.064]*"
                },

                ["INH.ABS.GPPA.ST.020"] = {
                    Action = function()
                        local AFoo = using "[declare] [abstract] [blend]" "INH.ABS.GPPA.ST.020.AFoo [Partial]" {
                            "APing", using "[declare] [abstract]" "INH.ABS.GPPA.ST.020.APing"
                        }

                        local __ = using "[declare] [blend]" "INH.ABS.GPPA.ST.020.Bar" {
                            "Foo", AFoo -- AFoo is still partial so this should throw
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
