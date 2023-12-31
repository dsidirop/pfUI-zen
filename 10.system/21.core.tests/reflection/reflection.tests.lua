local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Global = using "System.Global"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Reflection = using "System.Reflection"
local Validation = using "System.Validation"

local STypes = using "System.Reflection.STypes"
local EManagedSymbolTypes = using "System.Namespacer.EManagedSymbolTypes"

local U = Validation.Assert(Global.VWoWUnit)

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Reflection",
    Tags = { "system", "reflection" },
}

Scopify(EScopes.Function, {})

TestsGroup:AddTheory("Reflection.GetInfo.GivenVariousGreenValues.ShouldReturnCorrectTypes", -- @formatter:on
        {
            ["REF.GI.GVGV.SRCT.0000"] = {   Value = nil,                   Expected = { SymbolType = STypes.Nil,       SymbolNamespace = nil                                     }   },
            ["REF.GI.GVGV.SRCT.0010"] = {   Value = "",                    Expected = { SymbolType = STypes.String,    SymbolNamespace = nil                                     }   },
            ["REF.GI.GVGV.SRCT.0020"] = {   Value =  1,                    Expected = { SymbolType = STypes.Number,    SymbolNamespace = nil                                     }   },
            ["REF.GI.GVGV.SRCT.0030"] = {   Value = {},                    Expected = { SymbolType = STypes.Table,     SymbolNamespace = nil                                     }   },
            ["REF.GI.GVGV.SRCT.0040"] = {   Value = function() end,        Expected = { SymbolType = STypes.Function,  SymbolNamespace = nil                                     }   },
            ["REF.GI.GVGV.SRCT.0050"] = {   Value = true,                  Expected = { SymbolType = STypes.Boolean,   SymbolNamespace = nil                                     }   },
            ["REF.GI.GVGV.SRCT.0060"] = {   Value = Reflection,            Expected = { SymbolType = STypes.Class,     SymbolNamespace = "System.Reflection"                     }   },
            ["REF.GI.GVGV.SRCT.0070"] = {   Value = EManagedSymbolTypes,   Expected = { SymbolType = STypes.Enum,      SymbolNamespace = "System.Namespacer.EManagedSymbolTypes" }   },
        }, -- @formatter:off
        function(options)
            -- ARRANGE
            
            -- ACT
            local symbolType, symbolNamespace = U.Should.Not.Throw(function()
                return Reflection.GetInfo(options.Value)
            end)
            
            -- ASSERT
            U.Should.Be.PlainlyEqual(symbolType, options.Expected.SymbolType)
            U.Should.Be.PlainlyEqual(symbolNamespace, options.Expected.SymbolNamespace)
        end
)
