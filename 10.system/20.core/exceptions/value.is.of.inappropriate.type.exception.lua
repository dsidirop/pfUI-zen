local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard              = using "System.Guard" --                            @formatter:off
local Scopify            = using "System.Scopify"
local EScopes            = using "System.EScopes"
local Reflection         = using "System.Reflection"
local StringsHelpers     = using "System.Helpers.Strings"

local Classify           = using "System.Classes.Classify"
local ExceptionUtilities = using "System.Exceptions.Utilities" --             @formatter:on

local Class = using "[declare]" "System.Exceptions.ValueIsOfInappropriateTypeException [Partial]"

Scopify(EScopes.Function, {})

function Class:New(value, optionalArgumentName, optionalExpectationOrExpectedType)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsOptionallyString(optionalArgumentName, "optionalArgumentName")
    Guard.Assert.IsOptionallyTableOrString(optionalExpectationOrExpectedType, "optionalExpectationOrExpectedType")

    return Classify(self, {
        _message = Class.FormulateMessage_(value, optionalArgumentName, optionalExpectationOrExpectedType),
        _stacktrace = "",

        _stringified = nil
    })
end

function Class:GetMessage()
    Scopify(EScopes.Function, self)

    return _message
end

function Class:GetStacktrace()
    Scopify(EScopes.Function, self)

    return _stacktrace
end

-- setters   used by the exception-deserialization-factory
function Class:ChainSetMessage(message)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsOptionallyNonDudString(message, "message")

    _message = message or "(exception message not available)"
    _stringified = nil

    return self
end

-- this is called by throw() right before actually throwing the exception 
function Class:ChainSetStacktrace(stacktrace)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsOptionallyNonDudString(stacktrace, "stacktrace")

    _stacktrace = stacktrace or ""
    _stringified = nil

    return self
end

function Class:ToString()
    Scopify(EScopes.Function, self)
    
    return self:__tostring()
end

-- private space
function Class.FormulateMessage_(value, optionalArgumentName, optionalExpectationOrExpectedType)
    Scopify(EScopes.Function, Class)

    local message = optionalArgumentName == nil
            and "Value is of inappropriate type"
            or "'" .. optionalArgumentName .. "' is of inappropriate type"

    local expectationString = Class.GetExpectationMessage_(optionalExpectationOrExpectedType)
    if expectationString ~= nil then
        message = StringsHelpers.Format("%s (expected %s - got %q)", message, expectationString, Reflection.TryGetNamespaceWithFallbackToRawType(value)) 
    else
        message = StringsHelpers.Format("%s (its type is %q)", message, Reflection.TryGetNamespaceWithFallbackToRawType(value))
    end
    
    return message
end

function Class.GetExpectationMessage_(optionalExpectationOrExpectedType)
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

function Class:__tostring()
    Scopify(EScopes.Function, self)

    if _stringified ~= nil then
        return _stringified
    end

    _stringified = ExceptionUtilities.FormulateFullExceptionMessage(self)
    return _stringified
end
