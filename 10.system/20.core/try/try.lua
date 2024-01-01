local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard              = using "System.Guard" --                                                    @formatter:off
local Global             = using "System.Global"
local Scopify            = using "System.Scopify"
local EScopes            = using "System.EScopes"
local Reflection         = using "System.Reflection"
local Validation         = using "System.Validation"
local ArraysHelper       = using "System.Helpers.Arrays"

local Rethrow                          = using "System.Exceptions.Rethrow"
local Exception                        = using "System.Exceptions.Exception"
local ExceptionsDeserializationFactory = using "System.Try.ExceptionsDeserializationFactory" --       @formatter:on

local Class = using "[declare]" "System.Try [Partial]"

Scopify(EScopes.Function, {})

Class.ProtectedCall = Validation.Assert(Global.pcall, "Debug.pcall() is undefined (how did this even happen?)")
Class.ExceptionsDeserializationFactorySingleton = ExceptionsDeserializationFactory:New()

function Class:New(action, exceptionsDeserializationFactory)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsFunction(action, "action")
    Guard.Assert.IsNilOrInstanceOf(exceptionsDeserializationFactory, ExceptionsDeserializationFactory, "exceptionsDeserializationFactory")

    return self:Instantiate({
        _action = action,
        _allExceptionHandlers = {},
        _exceptionsDeserializationFactory = exceptionsDeserializationFactory or Class.ExceptionsDeserializationFactorySingleton,
    })
end

-- for specific exceptions
function Class:Catch(specificExceptionTypeOrExceptionNamespaceString, specificExceptionHandler)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsFunction(specificExceptionHandler, "specificExceptionHandler")
    Guard.Assert.IsNamespaceStringOrRegisteredClassProto(specificExceptionTypeOrExceptionNamespaceString, "specificExceptionTypeOrExceptionNamespaceString")

    local exceptionNamespaceString = Reflection.IsString(specificExceptionTypeOrExceptionNamespaceString)
            and specificExceptionTypeOrExceptionNamespaceString
            or Reflection.TryGetNamespaceIfClassProto(specificExceptionTypeOrExceptionNamespaceString)

    Guard.Assert.IsUnset(_allExceptionHandlers[exceptionNamespaceString], "Exception handler for " .. exceptionNamespaceString)

    _allExceptionHandlers[exceptionNamespaceString] = specificExceptionHandler

    return self
end

function Class:Run()
    Scopify(EScopes.Function, self)

    local returnValuesTable = {Class.ProtectedCall(_action)}

    local success = ArraysHelper.PopFirst(returnValuesTable)
    if success then
        return ArraysHelper.Unpack(returnValuesTable)
    end

    local exceptionMessage = ArraysHelper.PopFirst(returnValuesTable)
    local exception = _exceptionsDeserializationFactory:DeserializeFromRawExceptionMessage(exceptionMessage)
    
    local properExceptionHandler = self:GetAppropriateExceptionHandler_(exception)
    if properExceptionHandler ~= nil then
        return properExceptionHandler(exception)
    end

    Rethrow(exception) -- 10

    -- 00  raw errors also fall through here   by raw errors we mean errors like calling a non existent function or dividing by zero etc
    -- 10  its crucial to bubble the exception upwards if there is no handler in this particular try/catch block
end

Class.NamespaceOfBasePlatformException = Reflection.TryGetNamespaceIfClassProto(Exception)
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
