local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Math = using "System.Math"
local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Validation = using "System.Validation"
local Namespacer = using "System.Namespacer"

local STypes = using "System.Reflection.STypes"

local SRawTypes = using "System.Language.SRawTypes"
local RawTypeSystem = using "System.Language.RawTypeSystem"

local EManagedSymbolTypes = using "System.Namespacer.EManagedSymbolTypes"

local Reflection = using "[declare]" "System.Reflection [Partial]"

Scopify(EScopes.Function, {})

Reflection.IsNil = RawTypeSystem.IsNil
Reflection.IsTable = RawTypeSystem.IsTable
Reflection.IsNumber = RawTypeSystem.IsNumber
Reflection.IsString = RawTypeSystem.IsString
Reflection.IsBoolean = RawTypeSystem.IsBoolean
Reflection.IsFunction = RawTypeSystem.IsFunction
Reflection.GetRawType = RawTypeSystem.GetRawType -- for the sake of completeness   just in case someone needs it

-- returns   { STypes (strenum), Namespace (string) }
function Reflection.GetInfo(valueOrClassInstanceOrProto)
    if valueOrClassInstanceOrProto == nil then
        return STypes.Nil, nil
    end
    
    local protoTidbits = Namespacer:TryGetProtoTidbitsViaSymbolProto(valueOrClassInstanceOrProto) -- 00
    if protoTidbits ~= nil then
        local overallSymbolType = Reflection.ConvertEManagedSymbolTypeToESymbolType_(protoTidbits:GetManagedSymbolType(), valueOrClassInstanceOrProto)
        return overallSymbolType, protoTidbits:GetNamespace()
    end

    local rawType = RawTypeSystem.GetRawType(valueOrClassInstanceOrProto) -- 10

    return Reflection.ConvertERawTypeToESymbolType_(rawType), nil

    -- 00  if we have a table we need to check if its a class-instance or a class-proto or an enum-proto or an interface-proto
    -- 10  value can be a primitive type or a class-instance or a class-proto or an enum-proto or an interface-proto
end

function Reflection.ConvertEManagedSymbolTypeToESymbolType_(managedSymbolType, valueOrClassInstanceOrProto)
    if managedSymbolType == EManagedSymbolTypes.Enum then
        return STypes.Enum
    end
    
    if managedSymbolType == EManagedSymbolTypes.Class then
        return STypes.Class
    end

    if managedSymbolType == EManagedSymbolTypes.Interface then
        return STypes.Interface
    end
    
    if managedSymbolType == EManagedSymbolTypes.RawSymbol then
        local rawType = RawTypeSystem.GetRawType(valueOrClassInstanceOrProto)
        return Reflection.ConvertERawTypeToESymbolType_(rawType)
    end
    
    Validation.FailFormatted("managedSymbolType has value %q which is out of range and cannot be converted into a EManagedSymbolTypes", managedSymbolType) -- cant throw an exception here
end

function Reflection.ConvertERawTypeToESymbolType_(rawType)
    if rawType == SRawTypes.Nil then
        return STypes.Nil
    end
    
    if rawType == SRawTypes.Table then
        return STypes.Table
    end
    
    if rawType == SRawTypes.Number then
        return STypes.Number
    end
    
    if rawType == SRawTypes.String then
        return STypes.String
    end
    
    if rawType == SRawTypes.Boolean then
        return STypes.Boolean
    end
    
    if rawType == SRawTypes.Function then
        return STypes.Function
    end

    if rawType == SRawTypes.Userdata then
        return STypes.Userdata
    end

    if rawType == SRawTypes.Thread then
        return STypes.Thread
    end

    Validation.FailFormatted("rawType has value %q which is out of range and cannot be converted into an SRawTypes value", rawType) -- cant throw an exception here
end

function Reflection.IsNilOrTable(value)
    return value == nil or RawTypeSystem.IsTable(value)
end

function Reflection.IsNilOrFunction(value)
    return value == nil or RawTypeSystem.IsFunction(value)
end

function Reflection.IsNilOrNumber(value)
    return value == nil or RawTypeSystem.IsNumber(value)
end

function Reflection.IsNilOrBoolean(value)
    return value == nil or RawTypeSystem.IsBoolean(value)
end

function Reflection.IsInteger(value)
    return Reflection.IsNumber(value) and Math.Floor(value) == value
end

function Reflection.IsNilOrInteger(value)
    return value == nil or Reflection.IsInteger(value)
end

function Reflection.IsNilOrString(value)
    return value == nil or RawTypeSystem.IsString(value)
end

function Reflection.IsTableOrString(value)
    return RawTypeSystem.IsTable(value) or RawTypeSystem.IsString(value)
end

function Reflection.IsNilOrTableOrString(value)
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
    if symbolProto == nil or symbolType == nil or symbolType ~= EManagedSymbolTypes.Class then
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
