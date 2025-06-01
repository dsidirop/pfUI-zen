local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) --@formatter:off

local S          = using "System.Helpers.Strings"

local Math       = using "System.Math"
local Guard      = using "System.Guard"
local Scopify    = using "System.Scopify"
local EScopes    = using "System.EScopes"

local TablesHelper = using "System.Helpers.Tables"

local STypes              = using "System.Reflection.STypes"
local SRawTypes           = using "System.Language.SRawTypes"
local RawTypeSystem       = using "System.Language.RawTypeSystem"

local Namespacer          = using "System.Namespacer"
local EManagedSymbolTypes = using "System.Namespacer.EManagedSymbolTypes"

local Throw                   = using "System.Exceptions.Throw"
local NotImplementedException = using "System.Exceptions.NotImplementedException"

local Reflection = using "[declare] [static]" "System.Reflection [Partial]" --@formatter:on

Scopify(EScopes.Function, {})

Reflection.IsNil = RawTypeSystem.IsNil
Reflection.IsTable = RawTypeSystem.IsTable
Reflection.IsNumber = RawTypeSystem.IsNumber
Reflection.IsString = RawTypeSystem.IsString
Reflection.IsBoolean = RawTypeSystem.IsBoolean
Reflection.IsFunction = RawTypeSystem.IsFunction
Reflection.GetRawType = RawTypeSystem.GetRawType -- for the sake of completeness   just in case someone needs it

--- @return STypes, string, Proto, boolean   (type, namespace, proto, isClassInstance)
function Reflection.GetInfo(valueOrClassInstanceOrProto)
    if valueOrClassInstanceOrProto == nil then
        return STypes.Nil, nil, nil, false
    end

    local rawType = RawTypeSystem.GetRawType(valueOrClassInstanceOrProto) -- 00
    if rawType ~= SRawTypes.Table then
        return Reflection.ConvertSRawTypeToSType_(rawType), nil, nil, false
    end

    local protoTidbits = Namespacer:TryGetProtoTidbitsViaSymbolProto(valueOrClassInstanceOrProto.__index) -- 10   class-instance?
    if protoTidbits == nil then
        protoTidbits = Namespacer:TryGetProtoTidbitsViaSymbolProto(valueOrClassInstanceOrProto) -- proto maybe?
    end

    if protoTidbits ~= nil then
        local proto = protoTidbits:GetSymbolProto()
        local overallSymbolType = Reflection.ConvertEManagedSymbolTypeToSType_(protoTidbits:GetManagedSymbolType(), valueOrClassInstanceOrProto)
        local isActuallyClassInstance = overallSymbolType == STypes.NonStaticClass and valueOrClassInstanceOrProto ~= proto

        return overallSymbolType, protoTidbits:GetNamespace(), proto, isActuallyClassInstance
    end

    return SRawTypes.Table, nil, nil, false -- just a plain table

    -- 00  value can be a primitive type or a class-instance or a class-proto or an enum-proto or an interface-proto
    -- 10  if we have a table we need to check if its a class-instance or a class-proto or an enum-proto or an interface-proto
end

function Reflection.ConvertEManagedSymbolTypeToSType_(managedSymbolType, valueOrClassInstanceOrProto)
    Guard.Assert.IsEnumValue(EManagedSymbolTypes, managedSymbolType, "managedSymbolType")
    
    if managedSymbolType == EManagedSymbolTypes.Enum then
        return STypes.Enum
    end
    
    if managedSymbolType == EManagedSymbolTypes.NonStaticClass then
        return STypes.NonStaticClass
    end

    if managedSymbolType == EManagedSymbolTypes.StaticClass then
        return STypes.StaticClass
    end

    if managedSymbolType == EManagedSymbolTypes.Interface then
        return STypes.Interface
    end

    if managedSymbolType == EManagedSymbolTypes.Keyword then
        -- this should never happen but just in case
        return STypes.Keyword
    end
    
    if managedSymbolType == EManagedSymbolTypes.RawSymbol then
        local rawType = RawTypeSystem.GetRawType(valueOrClassInstanceOrProto)
        return Reflection.ConvertSRawTypeToSType_(rawType)
    end

    Throw(NotImplementedException:New(S.Format(
            "[REF.CEMSTTST.010] [!!!CORE BUG!!!] Lacking support for converting managed-symbol-type %q to an STypes value.", managedSymbolType
    )))
end

function Reflection.ConvertSRawTypeToSType_(rawType)
    Guard.Assert.IsEnumValue(SRawTypes, rawType, "rawType")

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

    Throw(NotImplementedException:New(S.Format(
            "[REF.CERTTEST.010] [!!!CORE BUG!!!] Lacking support for converting RawType %q to an SRawTypes value", rawType
    )))
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
    Guard.Assert.Explained.IsTrue(Reflection.IsNonStaticClassProtoOrInterfaceProto(desiredClassProto), "desiredClassProto was expected to be a non-static-class-proto or an interface but it's not")

    local _, _, proto, isClassInstance = Reflection.GetInfo(object)
    if not isClassInstance then
        return false -- interfaces are not instances
    end

    if proto == desiredClassProto then -- optimization
        return true
    end

    local queue = { proto }
    local currentProto
    while true do
        currentProto = TablesHelper.Dequeue(queue) -- dequeue   breadth first search
        if currentProto == nil then
            break -- we have exhausted the queue
        end

        if currentProto == desiredClassProto then
            return true
        end

        -- if we have a class-proto then we can check its asBase.* for mixins
        for mixinKey, _ in TablesHelper.GetPairs(currentProto.asBase or {}) do
            if mixinKey == desiredClassProto then
                return true
            end

            if Reflection.IsNonStaticClassProtoOrInterfaceProto(mixinKey) then
                TablesHelper.Append(queue, mixinKey) -- append enqueue
            end
        end
    end

    return false
end

function Reflection.IsInstanceImplementing(object, desiredInterfaceProto)
    Guard.Assert.Explained.IsTrue(Reflection.IsInterfaceProto(desiredInterfaceProto), "desiredInterfaceProto was expected to be an interface-proto but it's not")

    local _, _, proto, isClassInstance = Reflection.GetInfo(object)
    if not isClassInstance then
        return false -- interfaces are not instances
    end

    if proto == desiredInterfaceProto then -- optimization
        return true
    end

    local queue = { proto }
    local currentProto
    while true do
        currentProto = TablesHelper.Dequeue(queue) -- dequeue   breadth first search
        if currentProto == nil then
            break -- we have exhausted the queue
        end

        if currentProto == desiredInterfaceProto then
            return true
        end

        -- if we have a class-proto then we can check its asBase.* for mixins
        for mixinKey, _ in TablesHelper.GetPairs(currentProto.asBase or {}) do
            if mixinKey == desiredInterfaceProto then
                return true
            end

            if Reflection.IsNonStaticClassProtoOrInterfaceProto(mixinKey) then
                TablesHelper.Append(queue, mixinKey) -- append enqueue
            end
        end
    end

    return false
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
    --         a static-class-proto
    --         or just a mere raw type (number, string, boolean, function, table)
    --
end

function Reflection.IsClassInstance(object)
    return Reflection.TryGetNamespaceIfClassInstance(object) ~= nil
end

function Reflection.IsInterfaceProto(object)
    return Reflection.GetInfo(object) == STypes.Interface
end

function Reflection.IsNonStaticClassProto(object)
    return Reflection.GetInfo(object) == STypes.NonStaticClass
end

function Reflection.IsNonStaticClassProtoOrInterfaceProto(object)
    local type = Reflection.GetInfo(object)
    
    return type == STypes.NonStaticClass or type == STypes.Interface
end

function Reflection.TryGetNamespaceIfClassInstance(object)
    if not Reflection.IsTable(object) or object.__index == nil then
        return nil
    end
    
    return Reflection.TryGetNamespaceIfNonStaticClassProto(object.__index)
end

function Reflection.TryGetProtoViaClassNamespace(namespacePath)
    local symbolProto, symbolType = Reflection.TryGetProtoTidbitsViaNamespace(namespacePath)
    if symbolProto == nil
            or symbolType == nil
            or (symbolType ~= EManagedSymbolTypes.StaticClass and symbolType ~= EManagedSymbolTypes.NonStaticClass) then
        return nil
    end

    return symbolProto
end

-- covers both non-static-classes and static-classes
function Reflection.TryGetNamespaceIfClassProto(value)
    local protoTidbits = Namespacer:TryGetProtoTidbitsViaSymbolProto(value)
    if protoTidbits == nil or not protoTidbits:IsClassEntry() then -- if the proto is found but it doesnt belong to a class then we dont care
        return nil
    end

    return protoTidbits:GetNamespace()
end

-- covers only non-static-classes
function Reflection.IsNonStaticClassProto(allegedClassProto)
    local protoTidbits = Namespacer:TryGetProtoTidbitsViaSymbolProto(allegedClassProto)
    return protoTidbits ~= nil and protoTidbits:IsNonStaticClassEntry()
end

function Reflection.TryGetNamespaceIfNonStaticClassProto(allegedClassProto)
    local protoTidbits = Namespacer:TryGetProtoTidbitsViaSymbolProto(allegedClassProto)
    if protoTidbits == nil or not protoTidbits:IsNonStaticClassEntry() then -- if the proto is found but it doesnt belong to a class then we dont care
        return nil
    end

    return protoTidbits:GetNamespace()
end

function Reflection.TryGetProtoTidbitsViaNamespace(value)
    return Namespacer:TryGetProtoTidbitsViaNamespace(value) -- keep it like this   dont try to inline this ala   Reflection.TryGetProtoTidbitsViaNamespace = Namespacer.TryGetProtoTidbitsViaNamespace!!
end
