local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Scopify    = using "System.Scopify"
local EScopes    = using "System.EScopes"
local Reflection = using "System.Reflection"

local U = using "[built-in]" [[ VWoWUnit ]] -- @formatter:on

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup { Name = "System.Core.Tests.Reflection.IsInstanceImplementing.Testbed" }

Scopify(EScopes.Function, {})

TestsGroup:AddDynamicTheory("T010.Reflection.IsInstanceImplementing.GivenVariousDirectInheritancePairs.ShouldReturnExpectedVerdict", -- @formatter:off
        function()
            local testCases = {}

            do
                local IFoo0 = using "[declare] [interface]" "REF.IIMPL.GVDIP.SREV.0000.IFoo0"
                local Bar0  = using "[declare] [blend]"     "REF.IIMPL.GVDIP.SREV.0000.Bar0" { ["IFoo0"] = IFoo0 }

                function Bar0:New()
                    return self:Instantiate()
                end

                testCases["REF.IIMPL.GVDIP.SREV.0000"] = {
                    Interface       = IFoo0,
                    ClassInstance   = Bar0:New(),
                    ExpectedVerdict = true
                }
            end

            do
                local IFoo1 = using "[declare] [interface]" "REF.IIMPL.GVDIP.SREV.0010.IFoo1"
                local Bar1  = using "[declare] [blend]"     "REF.IIMPL.GVDIP.SREV.0010.Bar1" {
                    ["IPing1"] = using "[declare] [interface] [blend]" "REF.IIMPL.GVDIP.SREV.0010.IPing1" {
                        ["IFoo1"] = IFoo1
                    }
                }

                function Bar1:New()
                    return self:Instantiate()
                end

                testCases["REF.IIMPL.GVDIP.SREV.0010"] = {
                    Interface       = IFoo1,
                    ClassInstance   = Bar1:New(),
                    ExpectedVerdict = true
                }
            end

            return testCases
        end, -- @formatter:on
        function(specs)
            -- ARRANGE

            -- ACT
            local action = function()
                return Reflection.IsInstanceImplementing(specs.ClassInstance, specs.Interface)
            end

            -- ASSERT
            local verdict = U.Should.Not.Throw(action)

            U.Should.Be.PlainlyEqual(verdict, specs.ExpectedVerdict)
        end
)
