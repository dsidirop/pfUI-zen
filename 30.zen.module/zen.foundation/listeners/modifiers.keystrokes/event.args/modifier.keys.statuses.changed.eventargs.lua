local _assert, _setfenv, _type, _getn, _error, _print, _unpack, _pairs, _importer, _namespacer, _stringLength, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _getn = _assert(_g.table.getn)
    local _error = _assert(_g.error)
    local _print = _assert(_g.print)
    local _pairs = _assert(_g.pairs)
    local _unpack = _assert(_g.unpack)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _stringLength = _assert(_g.string.len)
    local _setmetatable = _assert(_g.setmetatable)

    return _assert, _setfenv, _type, _getn, _error, _print, _unpack, _pairs, _importer, _namespacer, _stringLength, _setmetatable
end)()

_setfenv(1, {})

local Scopify = _importer("System.Scopify")
local EScopes = _importer("System.EScopes")
local Classify = _importer("System.Classify")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Listeners.ModifiersKeystrokes.EventArgs.ModifierKeysStatusesChangedEventArgs")

function Class:New(hasModifierAlt, hasModifierShift, hasModifierControl)
    Scopify(EScopes.Function, self)

    _assert(_type(hasModifierAlt) == "boolean")
    _assert(_type(hasModifierShift) == "boolean")
    _assert(_type(hasModifierControl) == "boolean")
    
    return Classify(self, {
        _stringified = nil,
        _hasModifierAlt = hasModifierAlt,
        _hasModifierShift = hasModifierShift,
        _hasModifierControl = hasModifierControl,
    })
end

function Class:HasModifierAlt()
    Scopify(EScopes.Function, self)

    return _hasModifierAlt
end

function Class:HasModifierShift()
    Scopify(EScopes.Function, self)

    return _hasModifierShift
end

function Class:HasModifierControl()
    Scopify(EScopes.Function, self)

    return _hasModifierControl
end

function Class:ToString()
    return self:__tostring()
end

function Class:__tostring()
    Scopify(EScopes.Function, self)
    
    if _stringified then
        return _stringified
    end
    
    local result = ""

    if _hasModifierControl then
        result = "Ctrl"
    end
    
    if _hasModifierAlt then
        result = result == ""
                and "Alt"
                or (result .. "+Alt")
    end
    
    if _hasModifierShift then
        result = result == ""
                and "Shift"
                or (result .. "+Shift")
    end

    _stringified = result
    return result
end
