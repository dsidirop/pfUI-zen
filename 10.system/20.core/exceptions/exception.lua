local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Reflection = using "System.Reflection"
local Validation = using "System.Validation"

local Classify = using "System.Classes.Classify"
local ExceptionUtilities = using "System.Exceptions.Utilities"

local Class = using "[declare]" "System.Exceptions.Exception [Partial]"

Scopify(EScopes.Function, {})

function Class:New(message)
    Scopify(EScopes.Function, self)
   
    Guard.Assert.IsNilOrNonDudString(message, "message")

    return Classify(self, {
        _message = nil,
        _stacktrace = "",

        _stringified = nil,
    }):ChainSetMessage(message)
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

    Validation.Assert(Reflection.IsNilOrString(message), "message must be a string or nil")

    _message = message or "(exception message not available)"
    _stringified = nil

    return self
end

-- this is called by throw() right before actually throwing the exception 
function Class:ChainSetStacktrace(stacktrace)
    Scopify(EScopes.Function, self)

    Validation.Assert(Reflection.IsNilOrString(stacktrace), "stacktrace must be a string or nil")

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
