local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Math = using "System.Math"
local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local ESymbolType = using "System.Namespacing.ESymbolType"
local RawTypeSystem = using "System.Language.RawTypeSystem"

local Reflection = using "[declare]" "System.Reflection [Partial]"

Scopify(EScopes.Function, {})

Reflection.TryGetNamespaceIfClassProto = using "System.Namespacing.TryGetNamespaceIfClassProto"
Reflection.TryGetSymbolProtoViaNamespace = using "System.Importing.TryGetSymbolProtoViaNamespace"

Reflection.IsNil = RawTypeSystem.IsNil
Reflection.IsTable = RawTypeSystem.IsTable
Reflection.IsNumber = RawTypeSystem.IsNumber
Reflection.IsString = RawTypeSystem.IsString
Reflection.IsBoolean = RawTypeSystem.IsBoolean
Reflection.IsFunction = RawTypeSystem.IsFunction
Reflection.GetRawType = RawTypeSystem.GetRawType -- for the sake of completeness   just in case someone needs it

function Reflection.IsOptionallyTable(value)
    return value == nil or RawTypeSystem.IsTable(value)
end

function Reflection.IsOptionallyFunction(value)
    return value == nil or RawTypeSystem.IsFunction(value)
end

function Reflection.IsOptionallyNumber(value)
    return value == nil or RawTypeSystem.IsNumber(value)
end

function Reflection.IsOptionallyBoolean(value)
    return value == nil or RawTypeSystem.IsBoolean(value)
end

function Reflection.IsInteger(value)
    return Reflection.IsNumber(value) and Math.Floor(value) == value
end

function Reflection.IsOptionallyInteger(value)
    return value == nil or Reflection.IsInteger(value)
end

function Reflection.IsOptionallyString(value)
    return value == nil or RawTypeSystem.IsString(value)
end

function Reflection.IsTableOrString(value)
    return RawTypeSystem.IsTable(value) or RawTypeSystem.IsString(value)
end

function Reflection.IsOptionallyTableOrString(value)
    return value == nil or Reflection.IsTableOrString(value)
end

function Reflection.IsInstanceOf(object, desiredClassProto)
    local desiredNamespace = Guard.Assert.Explained.IsNotNil(Reflection.TryGetNamespaceIfClassProto(desiredClassProto), "desiredClassProto was expected to be a class-proto but it's not")

    if object == nil then
        return false
    end
    
    local objectNamespace = Reflection.TryGetNamespaceIfClassInstance(object)
    if objectNamespace == nil then
        return false
    end

    return objectNamespace == desiredNamespace
end

function Reflection.TryGetNamespaceWithFallbackToRawType(object) --00

    return Reflection.TryGetNamespaceIfClassInstance(object) --   order    
            or Reflection.TryGetNamespaceIfClassProto(object) --  order
            or RawTypeSystem.GetRawType(object) --                order    keep last

    -- 00  the object might be anything
    --
    --         nil
    --         a class-instance
    --         a class-proto
    --         or just a mere raw type (number, string, boolean, function, table)
    --
end

function Reflection.IsClassInstance(object)
    return Reflection.TryGetNamespaceIfClassInstance(object) ~= nil
end

function Reflection.IsClassProto(object)
    return Reflection.TryGetNamespaceIfClassProto(object) ~= nil
end

function Reflection.TryGetNamespaceIfClassInstance(object)
    if not Reflection.IsTable(object) or object.__index == nil then
        return nil
    end
    
    return Reflection.TryGetNamespaceIfClassProto(object.__index)
end

function Reflection.TryGetClassProtoViaNamespace(namespacePath)
    local proto, symbolType = Reflection.TryGetSymbolProtoViaNamespace(namespacePath)
    if proto == nil or symbolType == nil or symbolType ~= ESymbolType.Class then
        return nil
    end
    
    return proto
end
