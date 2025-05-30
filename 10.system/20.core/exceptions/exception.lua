local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Nils = using "System.Nils"
local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Fields = using "System.Classes.Fields"
local ExceptionUtilities = using "System.Exceptions.Utilities"

local Class = using "[declare]" "System.Exceptions.Exception [Partial]"

Scopify(EScopes.Function, {})

Fields(function(upcomingInstance)
    upcomingInstance._message = nil
    upcomingInstance._stacktrace = ""
    upcomingInstance._stringified = nil

    return upcomingInstance
end)

function Class:New(message)
    Scopify(EScopes.Function, self)
   
    Guard.Assert.IsNilOrNonDudString(message, "message")

    return self:Instantiate():ChainSetMessage(message)
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

    Guard.Assert.IsNilOrString(message, "message")

    _message = Nils.Coalesce(message, "(no exception message available)")
    _stringified = nil

    return self
end

-- this is called by throw() right before actually throwing the exception 
function Class:ChainSetStacktrace(stacktrace)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrString(stacktrace, "stacktrace")

    _stacktrace = Nils.Coalesce(stacktrace, "")
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
