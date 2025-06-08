local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Scopify    = using "System.Scopify"
local EScopes    = using "System.EScopes"
local Reflection = using "System.Reflection"

local Exception  = using "System.Exceptions.Exception"

local U = using "[built-in]" [[ VWoWUnit ]] -- @formatter:on

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Core.Tests.Reflection.IsInstanceImplementing.Testbed",
    Tags = { "system", "core", "reflection", "is-implementing" },
}

Scopify(EScopes.Function, {})

TestsGroup:AddDynamicTheory("T000.Reflection.IsInstanceImplementing.GivenNonInterfaceInterface.ShouldThrowException", -- @formatter:off
        function()
            return {
                ["REF.IIMPL.GNIB.STE.0000"] = { ClassInstance = 10, --[[not an instance]]                                          Interface = ( using "[declare] [interface]" "REF.IIMPL.GNIB.STE.0000.IFoo" ) },
                ["REF.IIMPL.GNIB.STE.0010"] = { ClassInstance = ( using "[declare] [interface]" "REF.IIMPL.GNIB.STE.0010.IFoo1" ), Interface = ( using "[declare] [interface]" "REF.IIMPL.GNIB.STE.0010.IFoo2" ) },
                ["REF.IIMPL.GNIB.STE.0020"] = { ClassInstance = Exception, --[[not an instance]]                                   Interface = ( using "[declare] [interface]" "REF.IIMPL.GNIB.STE.0020.IFoo" ) },
                ["REF.IIMPL.GNIB.STE.0030"] = { ClassInstance = Exception:New("foobar"),                                           Interface = ( using "[declare]" "REF.IIMPL.GNIB.STE.0030.Bar"              ) },
                ["REF.IIMPL.GNIB.STE.0040"] = { ClassInstance = Exception:New("foobar"),                                           Interface = 10 --[[not an interface]]                                        },
                ["REF.IIMPL.GNIB.STE.0050"] = { ClassInstance = Exception:New("foobar"),                                           Interface = Exception:New("foobar") --[[not an interface]]                   },
            }
        end, -- @formatter:on
        function(specs)
            -- ARRANGE

            -- ACT
            local action = function()                
                return Reflection.IsInstanceImplementing(specs.ClassInstance, specs.Interface)
            end

            -- ASSERT
            U.Should.Throw(action, "*[System.Exceptions.ValueIsOfInappropriateTypeException]*")
        end
)
