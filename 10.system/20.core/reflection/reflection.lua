local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Math = using "System.Math"
local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Types = using "System.Primitives.Types"

local STypes = using "System.Reflection.STypes"
local ESymbolType = using "System.Namespacing.ESymbolType"

local Reflection = using "[declare]" "System.Reflection [Partial]"

Scopify(EScopes.Function, {})

Reflection.GetRawType = Types.GetRawType -- for the sake of completeness   just in case someone needs it
Reflection.TryGetNamespaceOfClassProto = using "System.Namespacing.TryGetNamespaceOfClassProto"
Reflection.TryGetSymbolProtoViaNamespace = using "System.Importing.TryGetSymbolProtoViaNamespace"

function Reflection.IsTable(value)
    return Types.GetRawType(value) == STypes.Table
end

function Reflection.IsOptionallyTable(value)
    return value == nil or Types.GetRawType(value) == STypes.Table
end

function Reflection.IsFunction(value)
    return Types.GetRawType(value) == STypes.Function
end

function Reflection.IsOptionallyFunction(value)
    return value == nil or Types.GetRawType(value) == STypes.Function
end

function Reflection.IsNumber(value)
    return Types.GetRawType(value) == STypes.Number
end

function Reflection.IsOptionallyNumber(value)
    return value == nil or Types.GetRawType(value) == STypes.Number
end

function Reflection.IsBoolean(value)
    return Types.GetRawType(value) == STypes.Boolean
end

function Reflection.IsOptionallyBoolean(value)
    return value == nil or Types.GetRawType(value) == STypes.Boolean
end

function Reflection.IsInteger(value)
    return Reflection.IsNumber(value) and Math.Floor(value) == value
end

function Reflection.IsOptionallyInteger(value)
    return value == nil or Reflection.IsInteger(value)
end

function Reflection.IsString(value)
    return Types.GetRawType(value) == STypes.String
end

function Reflection.IsOptionallyString(value)
    return value == nil or Types.GetRawType(value) == STypes.String
end

function Reflection.IsTableOrString(value)
    return Types.GetRawType(value) == STypes.Table or Types.GetRawType(value) == STypes.String
end

function Reflection.IsOptionallyTableOrString(value)
    return value == nil or Reflection.IsTableOrString(value)
end

function Reflection.IsInstanceOf(object, desiredClassProto)
    local desiredNamespace = Guard.Assert.Explained.IsNotNil(Reflection.TryGetNamespaceOfClassProto(desiredClassProto), "desiredClassProto was expected to be a class-proto but it's not")

    if object == nil then
        return false
    end
    
    local objectNamespace = Reflection.TryGetNamespaceOfClassInstance(object)
    if objectNamespace == nil then
        return false
    end

    return objectNamespace == desiredNamespace
end

function Reflection.TryGetType(object) -- the object might be anything: nil, a class-instance or a class-proto or just a mere raw type (number, string, boolean, function, table)
    return Reflection.TryGetNamespaceOfClassInstance(object) --   order    
            or Reflection.TryGetNamespaceOfClassProto(object) --  order
            or Types.GetRawType(object) --                   order    keep last
end

function Reflection.IsClassInstance(object)
    return Reflection.TryGetNamespaceOfClassInstance(object) ~= nil
end

function Reflection.IsClassProto(object)
    return Reflection.TryGetNamespaceOfClassProto(object) ~= nil
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
