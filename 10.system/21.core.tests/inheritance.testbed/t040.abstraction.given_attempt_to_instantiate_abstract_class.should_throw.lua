local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Inheritance.Testbed"

-- 
TG:AddDynamicTheory("T040.Inheritance.Abstraction.GivenAttemptToInstantiateAbstractClass.ShouldThrow",
        function()
            return {
                ["INH.ABS.GATIAC.ST.010"] = {
                    Action = function()
                        local AbstractFoo = using "[declare] [abstract]" "INH.ABS.GATIAC.ST.010.AbstractFoo"

                        function AbstractFoo:New()
                            return self:Instantiate()
                        end

                        AbstractFoo:New() -- this should throw        
                    end,

                    ErrorGlob = ""
                            .. "*[NR.NSCPF.SI.020]*"
                            .. "*[INH.ABS.GATIAC.ST.010.AbstractFoo]*"
                },

                ["INH.ABS.GATIAC.ST.020"] = {
                    Action = function()
                        local AbstractFoo1 = using "[declare] [abstract]" "INH.ABS.GATIAC.ST.020.AbstractFoo1"

                        local AbstractFoo2 = using "[declare] [abstract] [blend]" "INH.ABS.GATIAC.ST.020.AbstractFoo2" {
                            ["AbstractFoo1"] = AbstractFoo1,
                        }

                        function AbstractFoo2:New()
                            return self:Instantiate()
                        end

                        AbstractFoo2:New() -- this should throw        
                    end,

                    ErrorGlob = ""
                            .. "*[NR.NSCPF.SI.020]*"
                            .. "*[INH.ABS.GATIAC.ST.020.AbstractFoo2]*"
                },
            }
        end,
        function(options)
            -- ARRANGE

            -- ACT + ASSERT
            U.Should.Throw(options.Action, options.ErrorGlob)
        end
)
