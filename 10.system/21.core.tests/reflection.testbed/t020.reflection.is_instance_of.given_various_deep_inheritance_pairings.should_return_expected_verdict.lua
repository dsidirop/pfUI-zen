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
                ["REF.IIO.GVDPIP.SREV.0000"] = {
                    Value           = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0000.GrandChildException" {
                        ["NotImplementedException"] = NotImplementedException,
                    },
                    Parent          = Exception,
                    ExpectedVerdict = true
                },
                ["REF.IIO.GVDPIP.SREV.0010"] = {
                    Value           = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0010.GreatGrandChildException" {
                        ["Foobar"]              = using "[declare]" "REF.IIO.GVDPIP.SREV.0010.Parent.Foobar",
                        ["GrandChildException"] = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0010.Parent.GrandChildException" {
                            ["ChildException"] = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0010.GrandParent.ChildException" {
                                ["NotImplementedException"] = NotImplementedException,
                            },
                        },
                    },
                    Parent          = Exception,
                    ExpectedVerdict = true
                },
                ["REF.IIO.GVDPIP.SREV.0020"] = {
                    Value           = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0020.IrrelevantException" {
                        ["Foo1"] = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0020.Parent.Foo1" {
                            ["Bar1"] = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0020.GrandParent.Bar1" {
                                ["Ping1"] = using "[declare]" "REF.IIO.GVDPIP.SREV.0020.GrandParent.Ping1"
                            },
                        },
                        ["Foo2"] = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0020.Parent.Foo2" {
                            ["Bar2"] = using "[declare] [blend]" "REF.IIO.GVDPIP.SREV.0020.GrandParent.Bar2" {
                                ["Ping2"] = using "[declare]" "REF.IIO.GVDPIP.SREV.0020.GrandParent.Ping2"
                            },
                        },
                    },
                    Parent          = Exception,
                    ExpectedVerdict = false
                },
            }
        end, -- @formatter:on
        function(specs)
            -- ARRANGE

            -- ACT
            local action = function()
                return Reflection.IsInstanceOf(specs.Value, specs.Parent)
            end

            -- ASSERT
            local verdict = U.Should.Not.Throw(action)

            U.Should.Be.PlainlyEqual(verdict, specs.ExpectedVerdict)
        end
)
