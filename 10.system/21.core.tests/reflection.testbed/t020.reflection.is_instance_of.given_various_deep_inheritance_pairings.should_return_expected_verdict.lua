local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Scopify    = using "System.Scopify"
local EScopes    = using "System.EScopes"

local Reflection = using "System.Reflection"

local Exception                  = using "System.Exceptions.Exception"
local NotImplementedException    = using "System.Exceptions.NotImplementedException"

local U = using "[built-in]" [[ VWoWUnit ]] -- @formatter:on

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup { Name = "System.Core.Tests.Reflection.IsInstanceOf.Testbed" }

Scopify(EScopes.Function, {})

TestsGroup:AddDynamicTheory("T020.Reflection.IsInstanceOf.GivenVariousDeepInheritancePairs.ShouldReturnExpectedVerdict", -- @formatter:off
        function()
            return {

                ["REF.IIO.GVDPIP.SREV.0000"] = (function()
                    local GrandChildException = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0000.GrandChildException" {
                        ["NotImplementedException"] = NotImplementedException,
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

                --["REF.IIO.GVDPIP.SREV.0010"] = (function()
                --    local GrandChildException = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0010.GrandChildException" {
                --        ["Foobar"] = using "[declare]" "REF.IIO.GVDPIP.SREV.0010.Parent.Foobar",
                --        ["GrandChildException"] = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0010.Parent.GrandChildException" {
                --            ["ChildException"] = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0010.GrandParent.ChildException" {
                --                ["NotImplementedException"] = NotImplementedException,
                --            },
                --        },
                --    }
                --
                --    function GrandChildException:New()
                --        local newInstance = self:Instantiate()
                --
                --        return GrandChildException.base.New(newInstance, "GrandChildException")
                --    end
                --    
                --    return {
                --        SpawnObjectFunc = function() return GrandChildException:New() end,
                --        Parent          = Exception,
                --        ExpectedVerdict = true,
                --    }
                --end)(),

                -- todo  fix these tests so that they will spawn instances like we do on the first test
                --["REF.IIO.GVDPIP.SREV.0020"] = {
                --    SpawnObjectFunc = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0020.IrrelevantException" {
                --        ["Foo1"] = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0020.Parent.Foo1" {
                --            ["Bar1"] = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0020.GrandParent.Bar1" {
                --                ["Ping1"] = using "[declare]" "REF.IIO.GVDPIP.SREV.0020.GrandParent.Ping1"
                --            },
                --        },
                --        ["Foo2"] = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0020.Parent.Foo2" {
                --            ["Bar2"] = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0020.GrandParent.Bar2" {
                --                ["Ping2"] = using "[declare]" "REF.IIO.GVDPIP.SREV.0020.GrandParent.Ping2"
                --            },
                --        },
                --    },
                --    Parent          = Exception,
                --    ExpectedVerdict = false,
                --},
                --["REF.IIO.GVDPIP.SREV.0030"] = (function() -- interface
                --    local IFoo = using "[declare] [interface]" "REF.IIO.GVDPIP.SREV.0030.IFoo"
                --
                --    return {
                --        SpawnObjectFunc = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0030.IrrelevantException" {
                --            ["Foo1"] = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0030.Parent.Foo1" {
                --                ["IFoo"] = IFoo,
                --            },
                --        },
                --        Parent          = IFoo,
                --        ExpectedVerdict = true,
                --    }
                --end)(),
                --["REF.IIO.GVDPIP.SREV.0040"] = (function()
                --    return {
                --        SpawnObjectFunc = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0040.IrrelevantException" {
                --            ["Foo1"] = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0040.Parent.Foo1" {
                --                ["Bar1"] = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0040.GrandParent.Bar1" {
                --                    ["Ping1"] = using "[declare]" "REF.IIO.GVDPIP.SREV.0040.GrandParent.Ping1"
                --                },
                --            },
                --            ["Foo2"] = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0040.Parent.Foo2" {
                --                ["Bar2"] = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0040.GrandParent.Bar2" {
                --                    ["Ping2"] = using "[declare]" "REF.IIO.GVDPIP.SREV.0040.GrandParent.Ping2"
                --                },
                --            },
                --        },
                --        Parent          = Exception,
                --        ExpectedVerdict = false,
                --    }
                --end)(),
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
