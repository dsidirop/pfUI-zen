local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[  ProtectedCall = pcall  ]]

local Guard              = using "System.Guard" --                                                    @formatter:off
local Scopify            = using "System.Scopify"
local EScopes            = using "System.EScopes"
local Reflection         = using "System.Reflection"
local Fields             = using "System.Classes.Fields"

local A                  = using "System.Helpers.Arrays"

local Throw              = using "System.Exceptions.Throw"
local Exception          = using "System.Exceptions.Exception"

local ExceptionsDeserializationFactory = using "System.Try.ExceptionsDeserializationFactory" --       @formatter:on

local Class = using "[declare]" "System.Try [Partial]"

Scopify(EScopes.Function, {})

Class.DefaultExceptionsDeserializationFactory = ExceptionsDeserializationFactory:New()

Fields(function(upcomingInstance)
    upcomingInstance._action                           = nil
    upcomingInstance._allExceptionHandlers             = nil
    upcomingInstance._exceptionsDeserializationFactory = nil

    return upcomingInstance
end)

function Class:New(action, optionalExceptionsDeserializationFactory)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsFunction(action, "action")
    Guard.Assert.IsNilOrInstanceOf(optionalExceptionsDeserializationFactory, ExceptionsDeserializationFactory, "exceptionsDeserializationFactory")
    
    local instance = self:Instantiate()
    
    instance._action                           = action
    instance._allExceptionHandlers             = {}
    instance._exceptionsDeserializationFactory = optionalExceptionsDeserializationFactory or instance.DefaultExceptionsDeserializationFactory

    return instance
end

-- for specific exceptions
function Class:Catch(specificExceptionTypeOrExceptionNamespaceString, specificExceptionHandler)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsFunction(specificExceptionHandler, "specificExceptionHandler")
    Guard.Assert.IsNamespaceStringOrRegisteredNonStaticClassProto(specificExceptionTypeOrExceptionNamespaceString, "specificExceptionTypeOrExceptionNamespaceString")

    local exceptionNamespaceString = Reflection.IsString(specificExceptionTypeOrExceptionNamespaceString)
            and specificExceptionTypeOrExceptionNamespaceString
            or Reflection.TryGetNamespaceIfNonStaticClassProto(specificExceptionTypeOrExceptionNamespaceString)

    Guard.Assert.IsUnset(_allExceptionHandlers[exceptionNamespaceString], "Exception handler for " .. exceptionNamespaceString)

    _allExceptionHandlers[exceptionNamespaceString] = specificExceptionHandler

    return self
end

function Class:Run()
    Scopify(EScopes.Function, self)

    local returnedValuesArray = { B.ProtectedCall(_action) }

    local success = A.PopFirst(returnedValuesArray)
    if success then
        return A.Unpack(returnedValuesArray)
    end

    local exceptionMessage = A.PopFirst(returnedValuesArray)
    local deserializedException = _exceptionsDeserializationFactory:DeserializeFromRawExceptionMessage(exceptionMessage)
    local properExceptionHandler = self:GetAppropriateExceptionHandler_(deserializedException)
    if properExceptionHandler ~= nil then
        return properExceptionHandler(deserializedException)
    end

    Throw(deserializedException) -- 10 no catch block matched  rethrowing then!

    -- 00  raw errors also fall through here   by raw errors we mean errors like calling a non existent function or dividing by zero etc
    -- 10  its crucial to bubble the exception upwards if there is no handler in this particular try/catch block
end

Class.NamespaceOfBasePlatformException = Reflection.TryGetNamespaceIfNonStaticClassProto(Exception)
function Class:GetAppropriateExceptionHandler_(exception)
    Scopify(EScopes.Function, self)

    local fullNamespaceOfException = Reflection.TryGetNamespaceIfClassInstance(exception)
    local specificExceptionHandler = _allExceptionHandlers[fullNamespaceOfException]
    if specificExceptionHandler ~= nil then
        return specificExceptionHandler
    end

    local possibleCatchAllExceptionHandler = _allExceptionHandlers[Class.NamespaceOfBasePlatformException]
    
    return possibleCatchAllExceptionHandler
end
