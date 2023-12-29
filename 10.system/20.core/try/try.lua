local _setfenv, _pcall, _importer, _namespacer_bind = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _pcall = _assert(_g.pcall)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer_bind = _assert(_g.pvl_namespacer_bind)

    return _setfenv, _pcall, _importer, _namespacer_bind
end)()

_setfenv(1, {}) --                                                                                         @formatter:off

local Guard              = _importer("System.Guard")
local Scopify            = _importer("System.Scopify")
local EScopes            = _importer("System.EScopes")
local Classify           = _importer("System.Classify")
local Reflection         = _importer("System.Reflection")

local Rethrow                          = _importer("System.Exceptions.Rethrow")
local Exception                        = _importer("System.Exceptions.Exception")
local ExceptionsDeserializationFactory = _importer("System.Try.ExceptionsDeserializationFactory") --       @formatter:on

local Class = {}
local ExceptionsDeserializationFactorySingleton = ExceptionsDeserializationFactory:New()

_namespacer_bind("System.Try", function(action)
    return Class:New(action, ExceptionsDeserializationFactorySingleton)
end)

function Class:New(action, exceptionsDeserializationFactory)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsFunction(action, "action")
    Guard.Assert.IsInstanceOf(exceptionsDeserializationFactory, ExceptionsDeserializationFactory, "exceptionsDeserializationFactory")

    return Classify(self, {
        _action = action,
        _allExceptionHandlers = {},
        _exceptionsDeserializationFactory = exceptionsDeserializationFactory,
    })
end

-- for specific exceptions
function Class:Catch(specificExceptionTypeOrExceptionNamespaceString, specificExceptionHandler)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsFunction(specificExceptionHandler, "specificExceptionHandler")
    Guard.Assert.IsNamespaceStringOrRegisteredType(specificExceptionTypeOrExceptionNamespaceString, "specificExceptionType")

    local exceptionNamespaceString = Reflection.IsString(specificExceptionTypeOrExceptionNamespaceString)
            and specificExceptionTypeOrExceptionNamespaceString
            or Reflection.TryGetNamespaceOfType(specificExceptionTypeOrExceptionNamespaceString)

    Guard.Assert.IsUnset(_allExceptionHandlers[exceptionNamespaceString], "Exception handler for " .. exceptionNamespaceString)

    _allExceptionHandlers[exceptionNamespaceString] = specificExceptionHandler

    return self
end

function Class:Run()
    Scopify(EScopes.Function, self)

    local success, result = _pcall(_action)
    if success then
        return result
    end

    local exception = _exceptionsDeserializationFactory:DeserializeFromRawExceptionMessage(result)
    
    local properExceptionHandler = self:GetAppropriateExceptionHandler_(exception)
    if properExceptionHandler ~= nil then
        return properExceptionHandler(exception)
    end

    Rethrow(exception) -- 10

    -- 00  raw errors also fall through here   by raw errors we mean errors like calling a non existent function or dividing by zero etc
    -- 10  its crucial to bubble the exception upwards if there is no handler in this particular try/catch block
end

Class.NamespaceOfBasePlatformException = Reflection.TryGetNamespaceOfType(Exception)
function Class:GetAppropriateExceptionHandler_(exception)
    Scopify(EScopes.Function, self)

    local fullNamespaceOfException = Reflection.TryGetNamespaceOfClassInstance(exception)
    local specificExceptionHandler = _allExceptionHandlers[fullNamespaceOfException]
    if specificExceptionHandler ~= nil then
        return specificExceptionHandler
    end

    local possibleCatchAllExceptionHandler = _allExceptionHandlers[Class.NamespaceOfBasePlatformException]
    
    return possibleCatchAllExceptionHandler
end
