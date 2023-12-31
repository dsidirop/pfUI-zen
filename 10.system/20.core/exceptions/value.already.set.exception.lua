local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard              = using "System.Guard" --                            @formatter:off
local Scopify            = using "System.Scopify"
local EScopes            = using "System.EScopes"
local Classify           = using "System.Classes.Classify"
local Reflection         = using "System.Reflection"
local ExceptionUtilities = using "System.Exceptions.Utilities" --             @formatter:on

local Class = using "[declare]" "System.Exceptions.ValueAlreadySetException [Partial]"

Scopify(EScopes.Function, {})

function Class:New(optionalArgumentName)
    Scopify(EScopes.Function, self)
  
    Guard.Assert.IsNilOrNonDudString(optionalArgumentName, "optionalArgumentName")

    return Classify(self, {
        _message = Class.FormulateMessage_(optionalArgumentName),
        _stacktrace = "",

        _stringified = nil
    })
end

-- getters
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
    
    Guard.Assert.IsNilOrNonDudString(message, "message")

    _message = message or "(exception message not available)"
    _stringified = nil
    
    return self
end

-- this is called by throw() right before actually throwing the exception 
function Class:ChainSetStacktrace(stacktrace)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrNonDudString(stacktrace, "stacktrace")

    _stacktrace = stacktrace or ""
    _stringified = nil

    return self
end

function Class:ToString()
    Scopify(EScopes.Function, self)

    return self:__tostring()
end

-- private space
function Class.FormulateMessage_(optionalArgumentName)
    Scopify(EScopes.Function, Class)

    local message = optionalArgumentName == nil
            and "Property/field has already been set"
            or "'" .. optionalArgumentName .. "' has already been set"

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
