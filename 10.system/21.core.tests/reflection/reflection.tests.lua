local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Global = using "System.Global"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Reflection = using "System.Reflection"
local Validation = using "System.Validation"

local STypes = using "System.Reflection.STypes"

local U = Validation.Assert(Global.VWoWUnit)

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Reflection",
    Tags = { "system", "reflection" },
}

Scopify(EScopes.Function, {})

TestsGroup:AddTheory("Reflection.GetInfo.GivenVariousGreenValues.ShouldReturnCorrectTypes", -- @formatter:on
        {
            ["REF.GI.GVGV.SRCT.0000"] = {   Value = nil,               Expected = { Type = STypes.Nil,       Namespace = nil }   },
            ["REF.GI.GVGV.SRCT.0010"] = {   Value = "",                Expected = { Type = STypes.String,    Namespace = nil }   },
            ["REF.GI.GVGV.SRCT.0020"] = {   Value =  1,                Expected = { Type = STypes.Number,    Namespace = nil }   },
            ["REF.GI.GVGV.SRCT.0030"] = {   Value = {},                Expected = { Type = STypes.Table,     Namespace = nil }   },
            ["REF.GI.GVGV.SRCT.0040"] = {   Value = function() end,    Expected = { Type = STypes.Function,  Namespace = nil }   },
        }, -- @formatter:off
        function(options)
            -- ARRANGE
            
            -- ACT
            local type, namespace = U.Should.Not.Throw(function()
                return Reflection.GetInfo(options.Value)
            end)
            
            -- ASSERT
            U.Should.Be.PlainlyEqual(options.Expected.Type, type)
            U.Should.Be.PlainlyEqual(options.Expected.Namespace, namespace)
        end
)
