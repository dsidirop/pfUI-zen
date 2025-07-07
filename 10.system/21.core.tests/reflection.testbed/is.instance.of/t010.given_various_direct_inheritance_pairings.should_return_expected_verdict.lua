--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Reflection = using "System.Reflection"

local Exception                  = using "System.Exceptions.Exception"
local NotImplementedException    = using "System.Exceptions.NotImplementedException"
local ValueIsOutOfRangeException = using "System.Exceptions.ValueIsOutOfRangeException" --@formatter:on

local TG, U = using "[testgroup] [tagged]" "System.Core.Tests.Reflection.IsInstanceOf.Testbed" { "system", "core", "reflection", "is-instance-of" }

TG:AddDynamicTheory("T010.Reflection.IsInstanceOf.GivenVariousDirectInheritancePairs.ShouldReturnExpectedVerdict", --@formatter:off
        function()
            return {
                ["REF.IIO.GVDRIP.SREV.0000"] = { Base = Exception,  Subclass = 10,                                                      ExpectedVerdict = false },
                ["REF.IIO.GVDRIP.SREV.0005"] = { Base = Exception,  Subclass = Exception, --[[not an instance really]]                  ExpectedVerdict = false },
                ["REF.IIO.GVDRIP.SREV.0010"] = { Base = Exception,  Subclass = Exception:New("foobar"),                                 ExpectedVerdict = true  },
                ["REF.IIO.GVDRIP.SREV.0020"] = { Base = Exception,  Subclass = NotImplementedException:New("foobar"),                   ExpectedVerdict = true  },
                ["REF.IIO.GVDRIP.SREV.0030"] = { Base = Exception,  Subclass = ValueIsOutOfRangeException:New("foobar"),                ExpectedVerdict = true  },
                ["REF.IIO.GVDRIP.SREV.0035"] = { Base = Exception,  Subclass = (using "[declare]" "REF.IIO.GVDRIP.SREV.0035.Subclass"), ExpectedVerdict = false },

                ["REF.IIO.GVDRIP.SREV.0040"] = { -- subclassing an abstract class

                    Base            = (function()
                        local BaseFoo1 = using "[declare] [abstract]" "REF.IIO.GVDRIP.SREV.0040.BaseFoo1"

                        function BaseFoo1:New()
                            return self:Instantiate()
                        end

                        return BaseFoo1
                    end)(),
                    
                    Subclass        = (function()
                        local BaseFoo1 = using "REF.IIO.GVDRIP.SREV.0040.BaseFoo1"
                        
                        local SomeOtherBaseFoo2 = using "[declare] [abstract]" "REF.IIO.GVDRIP.SREV.0040.SomeOtherBaseFoo2"

                        function SomeOtherBaseFoo2:New()
                            return self:Instantiate()
                        end
                        
                        -------
                        
                        function SomeOtherBaseFoo2:New()
                            return self:Instantiate()
                        end

                        local Class = using "[declare] [blend]" "REF.IIO.GVDRIP.SREV.0040.Subclass" {
                            "BaseFoo1", BaseFoo1,
                            "SomeOtherBaseFoo2", SomeOtherBaseFoo2,
                        }
                        
                        function Class:New()
                            local newInstance = self:Instantiate()
                            
                            return newInstance
                                    .asBase.BaseFoo1.New(newInstance) --           calling the abstract constructors from
                                    .asBase.SomeOtherBaseFoo2.New(newInstance) --  the subclass shouldnt throw
                        end
                        
                        return Class:New()
                    end)(),

                    ExpectedVerdict = true
                },
            }
        end, --@formatter:on
        function(specs)
            -- ARRANGE

            -- ACT
            local action = function()
                return Reflection.IsInstanceOf(specs.Subclass, specs.Base)
            end

            -- ASSERT
            local verdict = U.Should.Not.Throw(action)

            U.Should.Be.PlainlyEqual(verdict, specs.ExpectedVerdict)
        end
)
