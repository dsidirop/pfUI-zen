local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[
    ProtectedCall = pcall
]]

local Guard              = using "System.Guard" --                                                    @formatter:off
local Scopify            = using "System.Scopify"
local EScopes            = using "System.EScopes"
local Reflection         = using "System.Reflection"

local A                  = using "System.Helpers.Arrays"

local Rethrow                          = using "System.Exceptions.Rethrow"
local Exception                        = using "System.Exceptions.Exception"
local ExceptionsDeserializationFactory = using "System.Try.ExceptionsDeserializationFactory" --       @formatter:on

local Class = using "[declare]" "System.Try [Partial]"

Scopify(EScopes.Function, {})

Class.ExceptionsDeserializationFactorySingleton = ExceptionsDeserializationFactory:New()

function Class:New(action, exceptionsDeserializationFactory)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsFunction(action, "action")
    Guard.Assert.IsNilOrInstanceOf(exceptionsDeserializationFactory, ExceptionsDeserializationFactory, "exceptionsDeserializationFactory")

    return self:Instantiate({
        _action = action,
        _finallyHandler = nil,
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

function Class:Finally(finallyHandler)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsFunction(finallyHandler, "finallyHandler")
    
    _finallyHandler = finallyHandler
    
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
    local exception = _exceptionsDeserializationFactory:DeserializeFromRawExceptionMessage(exceptionMessage)
    
    local properExceptionHandler = self:GetAppropriateExceptionHandler_(exception)
    if properExceptionHandler ~= nil then
        local returnedValuesArray2 = {
            B.ProtectedCall(function()
                properExceptionHandler(exception)
            end)
        }

        if _finallyHandler ~= nil then
            _finallyHandler()
        end
        
        local success2 = A.PopFirst(returnedValuesArray2)
        if success2 then
            return A.Unpack(returnedValuesArray2)
        end

        local exceptionMessage2 = A.PopFirst(returnedValuesArray2)
        local exception2 = _exceptionsDeserializationFactory:DeserializeFromRawExceptionMessage(exceptionMessage2)

        Rethrow(exception2)
        return
    end

    if _finallyHandler ~= nil then
        _finallyHandler()
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
