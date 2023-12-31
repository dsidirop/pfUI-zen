local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Math = using "System.Math"
local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Namespacer = using "System.Namespacer"
local ESymbolType = using "System.Namespacer.ESymbolType"
local RawTypeSystem = using "System.Language.RawTypeSystem"

local Reflection = using "[declare]" "System.Reflection [Partial]"

Scopify(EScopes.Function, {})

Reflection.IsNil = RawTypeSystem.IsNil
Reflection.IsTable = RawTypeSystem.IsTable
Reflection.IsNumber = RawTypeSystem.IsNumber
Reflection.IsString = RawTypeSystem.IsString
Reflection.IsBoolean = RawTypeSystem.IsBoolean
Reflection.IsFunction = RawTypeSystem.IsFunction
Reflection.GetRawType = RawTypeSystem.GetRawType -- for the sake of completeness   just in case someone needs it

-- local SRawTypes = using "System.Language.SRawTypes"
--
-- returns   { ESymbolType, Namespace }
-- function Reflection.GetInfo(value) -- value can be a primitive type or a class-instance or a class-proto or an enum-proto or an interface-proto
--    todo  if we ever actually need this
--
--    local rawType = RawTypeSystem.GetRawType(value)
--    if rawType ~= SRawTypes.Table then
--        local symbolType = ConvertRawTypeToESymbolType(rawType)
--        return symbolType, nil
--    end
--
--    if we have a table we need to check if its a class-instance or a class-proto or an enum-proto or an interface-proto
--    local symbolType, namespace = using "System.Namespacer.TryGetInfo"(value.__index or value)
--    if symbolType ~= nil then
--         return symbolType, namespace
--    end
--
--    return ESymbolType.Table, nil
-- end

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

function Reflection.TryGetProtoViaClassNamespace(namespacePath)
    local symbolProto, symbolType = Reflection.TryGetProtoTidbitsViaNamespace(namespacePath)
    if symbolProto == nil or symbolType == nil or symbolType ~= ESymbolType.Class then
        return nil
    end
    
    return symbolProto
end

function Reflection.TryGetNamespaceIfClassProto(value)
    local protoTidbits = Namespacer:TryGetProtoTidbitsViaSymbolProto(value)
    if protoTidbits == nil or not protoTidbits:IsClassEntry() then -- if the proto is found but it doesnt belong to a class then we dont care
        return nil
    end

    return protoTidbits:GetNamespace()
end

function Reflection.TryGetProtoTidbitsViaNamespace(value)
    return Namespacer:TryGetProtoTidbitsViaNamespace(value) -- keep it like this   dont try to inline this ala   Reflection.TryGetProtoTidbitsViaNamespace = Namespacer.TryGetProtoTidbitsViaNamespace!!
end
