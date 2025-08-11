--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local B = using "[built-ins]" [[  ProtectedCall = pcall  ]]

local Guard              = using "System.Guard"
local Reflection         = using "System.Reflection"
local Fields             = using "System.Classes.Fields"

local A                  = using "System.Helpers.Arrays"

local Throw              = using "System.Exceptions.Throw"
local Exception          = using "System.Exceptions.Exception"

local ExceptionsDeserializationFactory = using "System.Try.ExceptionsDeserializationFactory" --@formatter:on

local Class = using "[declare]" "System.Try"


Class._.DefaultExceptionsDeserializationFactory = ExceptionsDeserializationFactory:New()

Fields(function(upcomingInstance)
    upcomingInstance._tryFunc                          = nil
    upcomingInstance._allExceptionHandlers             = nil
    upcomingInstance._exceptionsDeserializationFactory = nil

    return upcomingInstance
end)

using "[autocall]" "New" -- just be explicit about it
function Class:New(tryFunc, optionalExceptionsDeserializationFactory)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsFunction(tryFunc, "tryFunc")
    Guard.Assert.IsNilOrInstanceOf(optionalExceptionsDeserializationFactory, ExceptionsDeserializationFactory, "exceptionsDeserializationFactory")

    local instance = self:Instantiate()

    instance._tryFunc                          = tryFunc
    instance._allExceptionHandlers             = {}
    instance._exceptionsDeserializationFactory = optionalExceptionsDeserializationFactory or instance._.DefaultExceptionsDeserializationFactory

    return instance
end

function Class:CatchAll(optionalFunc)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrFunction(optionalFunc, "optionalFunc")
    
    local catchAllExceptionHandler = _allExceptionHandlers[Class.NamespaceOfBasePlatformException]
    if catchAllExceptionHandler ~= nil then
        Throw(Exception:NewWithMessage("Catch-all exception handler already set"))
    end

    _allExceptionHandlers[Class.NamespaceOfBasePlatformException] = optionalFunc or function() end

    return self
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

    local returnedValuesArray = { B.ProtectedCall(_tryFunc) }

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
