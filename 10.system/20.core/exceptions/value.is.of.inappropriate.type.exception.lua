local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard              = using "System.Guard" --               @formatter:off
local Scopify            = using "System.Scopify"
local EScopes            = using "System.EScopes"
local Reflection         = using "System.Reflection"
local StringsHelpers     = using "System.Helpers.Strings" --     @formatter:on

local Class = using "[declare] [blend]" "System.Exceptions.ValueIsOfInappropriateTypeException [Partial]" {
    ["Exception"] = using "System.Exceptions.Exception",
}

Scopify(EScopes.Function, {})

function Class:New(value, optionalArgumentName, optionalExpectationOrExpectedType)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrString(optionalArgumentName, "optionalArgumentName")
    Guard.Assert.IsNilOrTableOrNonDudString(optionalExpectationOrExpectedType, "optionalExpectationOrExpectedType")

    local newInstance = self:Instantiate()

    return Class.base.New(newInstance, _.FormulateMessage_(value, optionalArgumentName, optionalExpectationOrExpectedType))
end

function Class:NewWithMessage(value, customMessage, optionalArgumentName, optionalExpectationOrExpectedType)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNonDudString(customMessage, "customMessage")
    Guard.Assert.IsNilOrString(optionalArgumentName, "optionalArgumentName")
    Guard.Assert.IsNilOrTableOrNonDudString(optionalExpectationOrExpectedType, "optionalExpectationOrExpectedType")

    local newInstance = self:Instantiate()

    return Class.base.New(
            newInstance,
            customMessage .. " because " .. _.FormulateMessage_(value, optionalArgumentName, optionalExpectationOrExpectedType)
    )
end

--- @private
function Class._.FormulateMessage_(value, optionalArgumentName, optionalExpectationOrExpectedType)
    Scopify(EScopes.Function, Class)

    local message = optionalArgumentName == nil
            and "Value is of inappropriate type"
            or "'" .. optionalArgumentName .. "' is of inappropriate type"

    local expectationString = _.GetExpectationMessage_(optionalExpectationOrExpectedType)
    if expectationString ~= nil then
        message = StringsHelpers.Format("%s (expected %s - got %s)", message, expectationString, Reflection.TryGetNamespaceWithFallbackToRawType(value)) 
    else
        message = StringsHelpers.Format("%s (its type is %s)", message, Reflection.TryGetNamespaceWithFallbackToRawType(value))
    end
    
    return message
end

--- @private
function Class._.GetExpectationMessage_(optionalExpectationOrExpectedType)
    Scopify(EScopes.Function, Class)

    if optionalExpectationOrExpectedType == nil or optionalExpectationOrExpectedType == "" then
        return nil
    end

    if Reflection.IsString(optionalExpectationOrExpectedType) then
        return optionalExpectationOrExpectedType
    end

    local namespace = Reflection.TryGetNamespaceIfClassProto(optionalExpectationOrExpectedType) -- this is to account for enums and strenums
    if namespace ~= nil then
        return namespace
    end

    return optionalExpectationOrExpectedType
end
