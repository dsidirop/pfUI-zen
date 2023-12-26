local _setfenv, _importer, _debugstack, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _importer = _assert(_g.pvl_namespacer_get)
    local _debugstack = _assert(_g.debugstack)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    
    return _setfenv, _importer, _debugstack, _namespacer
end)()

_setfenv(1, {})

local Scopify = _importer("System.Scopify")
local EScopes = _importer("System.EScopes")
local Classify = _importer("System.Classify")

local N = "System.Exceptions.ArgumentNilException"
local Class = _namespacer(N)

function Class:New()
    Scopify(EScopes.Function, self)

    return Classify(self, {
        _message = "Argument cannot be nil",
        _stacktrace = _debugstack(2),
        
        _stringified = nil
    })
end

function Class:__tostring()
    Scopify(EScopes.Function, self)
    
    if _stringified ~= nil then
        return _stringified
    end

    _stringified = "[" .. N .. "] " .. _message .. "\n\n--------------[ Stacktrace ]--------------\n" .. _stacktrace .. "------------[ End Stacktrace ]------------\n "
    return _stringified
end
