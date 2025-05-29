local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard              = using "System.Guard" --                            @formatter:off
local Scopify            = using "System.Scopify"
local EScopes            = using "System.EScopes"
local Reflection         = using "System.Reflection"
local StringsHelper      = using "System.Helpers.Strings"

local Exception          = using "System.Exceptions.Exception" --             @formatter:on

local Class = using "[declare] [blend]" "System.Exceptions.ValueIsOutOfRangeException [Partial]" {
    ["Exception"] = Exception
}

Scopify(EScopes.Function, {})

function Class:New(value, optionalArgumentName, optionalExpectationOrExpectedType)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrNonDudString(optionalArgumentName, "optionalArgumentName")
    Guard.Assert.IsNilOrTableOrNonDudString(optionalExpectationOrExpectedType, "optionalExpectationOrExpectedType")

    local instance = self:Instantiate()

    instance._message = instance._.FormulateMessage_(value, optionalArgumentName, optionalExpectationOrExpectedType)

    return instance
end

function Class:NewWithMessage(customMessage)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNonDudString(customMessage, "customMessage")

    local instance = self:Instantiate()
    
    instance._message = customMessage
    
    return instance
end

-- private space
function Class._.FormulateMessage_(value, optionalArgumentName, optionalExpectationOrExpectedType)
    Scopify(EScopes.Function, Class)

    local message = optionalArgumentName == nil
            and "Value out of range"
            or "Value of '" .. optionalArgumentName .. "' is out of range"

    local expectationString = Class._.GetExpectationMessage_(optionalExpectationOrExpectedType)
    if expectationString ~= nil then
        StringsHelper.Format("%s (expected %s - got %q)", message, expectationString, value)
    else
        StringsHelper.Format("%s (got %q)", message, value)
    end

    return message
end

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

