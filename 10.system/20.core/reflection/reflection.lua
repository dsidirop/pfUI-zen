local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Math = using "System.Math"
local STypes = using "System.Reflection.STypes"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local ESymbolType = using "System.Namespacing.ESymbolType"

local Reflection = using "[declare]" "System.Reflection [Partial]"

Scopify(EScopes.Function, {})

Reflection.GetRawType = using "System.GetRawType"
Reflection.TryGetNamespaceOfClassProto = using "System.Namespacing.TryGetNamespaceOfClassProto"
Reflection.TryGetSymbolProtoViaNamespace = using "System.Importing.TryGetSymbolProtoViaNamespace"

function Reflection.IsTable(value)
    return Reflection.GetRawType(value) == STypes.Table
end

function Reflection.IsOptionallyTable(value)
    return value == nil or Reflection.GetRawType(value) == STypes.Table
end

function Reflection.IsFunction(value)
    return Reflection.GetRawType(value) == STypes.Function
end

function Reflection.IsOptionallyFunction(value)
    return value == nil or Reflection.GetRawType(value) == STypes.Function
end

function Reflection.IsNumber(value)
    return Reflection.GetRawType(value) == STypes.Number
end

function Reflection.IsOptionallyNumber(value)
    return value == nil or Reflection.GetRawType(value) == STypes.Number
end

function Reflection.IsBoolean(value)
    return Reflection.GetRawType(value) == STypes.Boolean
end

function Reflection.IsOptionallyBoolean(value)
    return value == nil or Reflection.GetRawType(value) == STypes.Boolean
end

function Reflection.IsInteger(value)
    return Reflection.IsNumber(value) and Math.Floor(value) == value
end

function Reflection.IsOptionallyInteger(value)
    return value == nil or Reflection.IsInteger(value)
end

function Reflection.IsString(value)
    return Reflection.GetRawType(value) == STypes.String
end

function Reflection.IsOptionallyString(value)
    return value == nil or Reflection.GetRawType(value) == STypes.String
end

function Reflection.IsTableOrString(value)
    return Reflection.GetRawType(value) == STypes.Table or Reflection.GetRawType(value) == STypes.String
end

function Reflection.IsOptionallyTableOrString(value)
    return value == nil or Reflection.IsTableOrString(value)
end

function Reflection.IsInstanceOf(object, desiredClassProto)
    if object == nil then
        return false
    end

    return Reflection.TryGetNamespaceOfClassInstance(object) == Reflection.TryGetNamespaceOfClassProto(desiredClassProto)
end

function Reflection.TryGetNamespaceFromObjectOrItsRawType(object)
    return Reflection.TryGetNamespaceOfObject(object) or Reflection.GetRawType(object)    
end

function Reflection.TryGetNamespaceOfObject(object)
    if object == nil then
        return nil
    end
    
    return Reflection.TryGetNamespaceOfClassInstance(object) or Reflection.TryGetNamespaceOfClassProto(object)
end

function Reflection.TryGetNamespaceOfClassInstance(object)
    if not Reflection.IsTable(object) or object.__index == nil then
        return nil
    end
    
    return Reflection.TryGetNamespaceOfClassProto(object.__index)
end

function Reflection.TryGetClassProtoViaNamespace(namespacePath)
    local proto, symbolType = Reflection.TryGetSymbolProtoViaNamespace(namespacePath)
    if proto == nil or symbolType == nil or symbolType ~= ESymbolType.Class then
        return nil
    end
    
    return proto
end
