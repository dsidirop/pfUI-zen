local using = assert(_G or getfenv(0) or {}).pvl_namespacer_get

local Math = using "System.Math"
local STypes = using "System.Reflection.STypes"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Reflection = using "[namespace]" "System.Reflection"

Scopify(EScopes.Function, {})

Reflection.GetRawType = using "System.GetRawType"
Reflection.TryGetNamespaceOfType = using "System.Namespacing.TryGetNamespaceOfType"
Reflection.TryFindTypeViaNamespace = using "System.Importing.TryFindTypeViaNamespace"

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
    return Reflection.IsNumber(value) and Math.floor(value) == value
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

function Reflection.IsInstanceOf(object, desiredType)
    if object == nil then
        return false
    end

    return Reflection.TryGetNamespaceOfClassInstance(object) == Reflection.TryGetNamespaceOfType(desiredType)
end

function Reflection.TryGetNamespaceFromObjectOrItsRawType(object)
    return Reflection.TryGetNamespaceOfObject(object) or Reflection.GetRawType(object)    
end

function Reflection.TryGetNamespaceOfObject(object)
    if object == nil then
        return nil
    end
    
    return Reflection.TryGetNamespaceOfClassInstance(object) or Reflection.TryGetNamespaceOfType(object)
end

function Reflection.TryGetNamespaceOfClassInstance(object)
    if not Reflection.IsTable(object) or object.__index == nil then
        return nil
    end
    
    return Reflection.TryGetNamespaceOfType(object.__index)
end

function Reflection.TryFindClassTypeViaNamespace(namespacePath)
    local classType = Reflection.TryFindTypeViaNamespace(namespacePath)
    if not Reflection.IsTable(classType) then
        return nil
    end
    
    return classType
end
