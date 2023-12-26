local _setfenv, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    
    return _setfenv, _importer, _namespacer
end)()

_setfenv(1, {}) --                                                         @formatter:off

local Debug              = _importer("System.Debug")
local Scopify            = _importer("System.Scopify")
local EScopes            = _importer("System.EScopes")
local Classify           = _importer("System.Classify")
local ExceptionUtilities = _importer("System.Exceptions.Utilities") --     @formatter:on

local N = "System.Exceptions.ArgumentNilException"
local Class = _namespacer(N)

function Class:New()
    Scopify(EScopes.Function, self)

    return Classify(self, {
        _message = "Argument cannot be nil",
        _stacktrace = Debug.Stacktrace(1),
        
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

function Class:GetOwnNamespace()
    Scopify(EScopes.Function, self)

    return N
end

function Class:ToString()
    Scopify(EScopes.Function, self)

    return self:__tostring()
end

-- private space
function Class:__tostring()
    Scopify(EScopes.Function, self)

    if _stringified ~= nil then
        return _stringified
    end

    _stringified = ExceptionUtilities.FormulateFullExceptionMessage(self)
    return _stringified
end
