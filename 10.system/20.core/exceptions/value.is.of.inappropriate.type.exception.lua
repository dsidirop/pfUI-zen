local _setfenv, _tostring, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _tostring = _assert(_g.tostring)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    
    return _setfenv, _tostring, _importer, _namespacer
end)()

_setfenv(1, {}) --                                                                 @formatter:off

local Debug              = _importer("System.Debug")
local Scopify            = _importer("System.Scopify")
local EScopes            = _importer("System.EScopes")
local Classify           = _importer("System.Classes.Classify")
local Reflection         = _importer("System.Reflection")
local ExceptionUtilities = _importer("System.Exceptions.Utilities") --             @formatter:on

local Class = _namespacer("System.Exceptions.ValueIsOfInappropriateTypeException [Partial]")

function Class:New(value, optionalArgumentName, optionalExpectationOrExpectedType)
    Scopify(EScopes.Function, self)

    Debug.Assert(Reflection.IsOptionallyString(optionalArgumentName), "optionalArgumentName must be a string or nil")
    Debug.Assert(Reflection.IsOptionallyTableOrString(optionalExpectationOrExpectedType), "optionalExpectationOrExpectedType must be a type (table) or a description (string) or nil")

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

    Debug.Assert(Reflection.IsOptionallyString(message), "message must be a string or nil")

    _message = message or "(exception message not available)"
    _stringified = nil

    return self
end

-- this is called by throw() right before actually throwing the exception 
function Class:ChainSetStacktrace(stacktrace)
    Scopify(EScopes.Function, self)

    Debug.Assert(Reflection.IsOptionallyString(stacktrace), "stacktrace must be a string or nil")

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
        message = message .. " (expected " .. _tostring(expectationString) .. " - got '" .. Reflection.TryGetNamespaceWithFallbackToRawType(value) .. "')"
    else
        message = message .. " (its type is '" .. Reflection.TryGetNamespaceWithFallbackToRawType(value) .. "')"
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
