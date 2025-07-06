local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local Reflection = using "System.Reflection"

local Exception                  = using "System.Exceptions.Exception"
local NotImplementedException    = using "System.Exceptions.NotImplementedException"

local TG, U = using "[testgroup]" "System.Core.Tests.Reflection.IsInstanceOf.Testbed"

TG:AddDynamicTheory("T020.Reflection.IsInstanceOf.GivenVariousDeepInheritancePairs.ShouldReturnExpectedVerdict", -- @formatter:off
        function()
            return {

                ["REF.IIO.GVDPIP.SREV.0000"] = (function()
                    local GrandChildException = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0000.GrandChildException" {
                        "NotImplementedException", NotImplementedException,
                    }

                    function GrandChildException:New()
                        local newInstance = self:Instantiate()

                        return GrandChildException.base.New(newInstance, "GrandChildException")
                    end

                    return {
                        SpawnObjectFunc = function() return GrandChildException:New() end,
                        Parent          = Exception,
                        ExpectedVerdict = true,
                    }
                end)(),

                ["REF.IIO.GVDPIP.SREV.0010"] = (function()
                    local GrandChildException = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0010.GrandChildException" {
                        "Foobar", using "[declare]" "REF.IIO.GVDPIP.SREV.0010.Parent.Foobar",
                        "GrandChildException", using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0010.Parent.GrandChildException" {
                            "ChildException", using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0010.GrandParent.ChildException" {
                                "NotImplementedException", NotImplementedException,
                            },
                        },
                    }

                    function GrandChildException:New()
                        local newInstance = self:Instantiate()

                        return GrandChildException.base.New(newInstance, "GrandChildException")
                    end

                    return {
                        SpawnObjectFunc = function() return GrandChildException:New() end,
                        Parent          = Exception,
                        ExpectedVerdict = true,
                    }
                end)(),

                ["REF.IIO.GVDPIP.SREV.0020"] = (function()
                    local RandomClass = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0020.RandomClass" {
                        "Foo1", using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0020.Parent.Foo1" {
                            "Bar1", using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0020.GrandParent.Bar1" {
                                "Ping1", using "[declare]" "REF.IIO.GVDPIP.SREV.0020.GrandParent.Ping1"
                            },
                        },
                        "Foo2", using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0020.Parent.Foo2" {
                            "Bar2", using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0020.GrandParent.Bar2" {
                                "Ping2", using "[declare]" "REF.IIO.GVDPIP.SREV.0020.GrandParent.Ping2"
                            },
                        },
                    }

                    function RandomClass:New()
                        return self:Instantiate()
                    end

                    return {
                        SpawnObjectFunc = function() return RandomClass:New() end,
                        Parent          = Exception,
                        ExpectedVerdict = false,
                    }
                end)(),

                ["REF.IIO.GVDPIP.SREV.0030"] = (function() -- interface
                    local IFoo = using "[declare] [interface]" "REF.IIO.GVDPIP.SREV.0030.IFoo"
                    
                    local SomeClass = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0030.SomeClass" {
                        "Foo1", using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0030.Parent.Foo1" {
                            "IFoo", IFoo,
                        },
                    }

                    function SomeClass:New()
                        return self:Instantiate()
                    end

                    return {
                        SpawnObjectFunc = function() return SomeClass:New() end,
                        Parent          = IFoo,
                        ExpectedVerdict = true,
                    }
                end)(),

                ["REF.IIO.GVDPIP.SREV.0040"] = (function()
                    local IrrelevantException = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0040.IrrelevantException" {
                        "Foo1", using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0040.Parent.Foo1" {
                            "Bar1", using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0040.GrandParent.Bar1" {
                                "Ping1", using "[declare]" "REF.IIO.GVDPIP.SREV.0040.GrandParent.Ping1"
                            },
                        },
                        "Foo2", using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0040.Parent.Foo2" {
                            "Bar2", using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0040.GrandParent.Bar2" {
                                "Ping2", using "[declare]" "REF.IIO.GVDPIP.SREV.0040.GrandParent.Ping2"
                            },
                        },
                    }

                    function IrrelevantException:New()
                        return self:Instantiate()
                    end
                    
                    return {
                        SpawnObjectFunc = function() return IrrelevantException:New() end,
                        Parent          = Exception,
                        ExpectedVerdict = false,
                    }
                end)(),
            }
        end, -- @formatter:on
        function(specs)
            -- ARRANGE

            -- ACT
            local action = function()
                return Reflection.IsInstanceOf(specs.SpawnObjectFunc(), specs.Parent)
            end

            -- ASSERT
            local verdict = U.Should.Not.Throw(action)

            U.Should.Be.PlainlyEqual(verdict, specs.ExpectedVerdict)
        end
)
