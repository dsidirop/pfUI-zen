local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard              = using "System.Guard" --                            @formatter:off
local Scopify            = using "System.Scopify"
local EScopes            = using "System.EScopes"
local ExceptionUtilities = using "System.Exceptions.Utilities" --             @formatter:on

local Class = using "[declare]" "System.Exceptions.ValueCannotBeNilException [Partial]"

Scopify(EScopes.Function, {})

function Class:New(optionalArgumentName)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrNonDudString(optionalArgumentName, "optionalArgumentName")

    return self:Instantiate({
        _message = Class.FormulateMessage_(optionalArgumentName),
        _stacktrace = "",
        
        _stringified = nil
    })
end

function Class:NewWithMessage(customMessage)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNonDudString(customMessage, "customMessage")

    return self:Instantiate({
        _message = customMessage,
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

    if _stringified ~= nil then
        return _stringified
    end

    _stringified = ExceptionUtilities.FormulateFullExceptionMessage(self)
    return _stringified
end
Class.__tostring = Class.ToString

-- private space
function Class.FormulateMessage_(optionalArgumentName)
    Scopify(EScopes.Function, Class)

    local message = optionalArgumentName == nil
            and "Value cannot be nil"
            or "'" .. optionalArgumentName .. "' cannot be nil"

    return message
end
