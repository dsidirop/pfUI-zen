local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Event      = using "System.Event"
local Reflection = using "System.Reflection"

local STypes = using "System.Reflection.STypes"
local EManagedSymbolTypes = using "System.Namespacer.EManagedSymbolTypes"

local U = using "[built-in]" [[ VWoWUnit ]]

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Core.Tests.Reflection.GetInfo.Testbed",
    Tags = { "system", "core", "reflection", "get-info" },
}

Scopify(EScopes.Function, {})

TestsGroup:AddDynamicTheory("T000.Reflection.GetInfo.GivenVariousGreenValues.ShouldReturnCorrectTypes", -- @formatter:off
        function()
            return {
                ["REF.GI.GVGV.SRCT.0000"] = {   Value = nil,                   Expected = { SymbolType = STypes.Nil,             SymbolNamespace = nil,                                      SymbolProto = nil,  IsInstance = false }  },
                ["REF.GI.GVGV.SRCT.0010"] = {   Value = "",                    Expected = { SymbolType = STypes.String,          SymbolNamespace = nil,                                      SymbolProto = nil,  IsInstance = false }  },
                ["REF.GI.GVGV.SRCT.0020"] = {   Value = 1,                     Expected = { SymbolType = STypes.Number,          SymbolNamespace = nil,                                      SymbolProto = nil,  IsInstance = false }  },
                ["REF.GI.GVGV.SRCT.0030"] = {   Value = {},                    Expected = { SymbolType = STypes.Table,           SymbolNamespace = nil,                                      SymbolProto = nil,  IsInstance = false }  },
                ["REF.GI.GVGV.SRCT.0040"] = {   Value = function() end,        Expected = { SymbolType = STypes.Function,        SymbolNamespace = nil,                                      SymbolProto = nil,  IsInstance = false }  },
                ["REF.GI.GVGV.SRCT.0050"] = {   Value = true,                  Expected = { SymbolType = STypes.Boolean,         SymbolNamespace = nil,                                      SymbolProto = nil,  IsInstance = false }  },
                ["REF.GI.GVGV.SRCT.0060"] = {   Value = Reflection,            Expected = { SymbolType = STypes.StaticClass,     SymbolNamespace = "System.Reflection",                      SymbolProto = (using "System.Reflection"                      ),  IsInstance = false }  },
                ["REF.GI.GVGV.SRCT.0065"] = {   Value = Event,                 Expected = { SymbolType = STypes.NonStaticClass,  SymbolNamespace = "System.Event",                           SymbolProto = (using "System.Event"                           ),  IsInstance = false }  },
                ["REF.GI.GVGV.SRCT.0067"] = {   Value = Event:New(),           Expected = { SymbolType = STypes.NonStaticClass,  SymbolNamespace = "System.Event",                           SymbolProto = (using "System.Event"                           ),  IsInstance = true  }  },
                ["REF.GI.GVGV.SRCT.0070"] = {   Value = EManagedSymbolTypes,   Expected = { SymbolType = STypes.Enum,            SymbolNamespace = "System.Namespacer.EManagedSymbolTypes",  SymbolProto = (using "System.Namespacer.EManagedSymbolTypes"  ),  IsInstance = false }  },
                ["REF.GI.GVGV.SRCT.0080"] = (function()
                    local ITestInterface = using "[declare] [interface]" "REF.GI.GVGV.SRCT.0080.ITestInterface"
            
                    return {
                        Value = ITestInterface,
                        Expected = {
                            SymbolType      = STypes.Interface,
                            IsInstance      = false,
                            SymbolProto     = ITestInterface,
                            SymbolNamespace = "REF.GI.GVGV.SRCT.0080.ITestInterface",
                        }
                    }
                end)(),
            }
        end, -- @formatter:on
        function(options)
            -- ARRANGE
            local symbolType, symbolNamespace, symbolProto, isInstance

            -- ACT
            U.Should.Not.Throw(function()
                symbolType, symbolNamespace, symbolProto, isInstance = Reflection.GetInfo(options.Value)
            end)

            -- ASSERT
            U.Should.Be.PlainlyEqual(symbolType, options.Expected.SymbolType)
            U.Should.Be.PlainlyEqual(isInstance, options.Expected.IsInstance)
            U.Should.Be.PlainlyEqual(symbolProto, options.Expected.SymbolProto)
            U.Should.Be.PlainlyEqual(symbolNamespace, options.Expected.SymbolNamespace)
        end
)
