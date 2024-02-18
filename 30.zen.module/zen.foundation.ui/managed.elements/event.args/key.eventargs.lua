local _assert, _setfenv, _type, _importer, _namespacer, _stringLength = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _stringLength = _assert(_g.string.len)

    return _assert, _setfenv, _type, _importer, _namespacer, _stringLength
end)()

_setfenv(1, {})

local Scopify = _importer("System.Scopify")
local EScopes = _importer("System.EScopes")
local EKeyEventType = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Enums.EKeyEventType")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.EventArgs.KeyEventArgs")

function Class:New(key, hasModifierAlt, hasModifierShift, hasModifierControl, eventType)
    Scopify(EScopes.Function, self)

    _assert(key == nil or _type(key) == "string" and _stringLength(key) <= 1)
    _assert(_type(hasModifierAlt) == "boolean")
    _assert(_type(hasModifierShift) == "boolean")
    _assert(_type(hasModifierControl) == "boolean")
    _assert(EKeyEventType:IsValid(eventType))

    return self:Instantiate({
        _key = key or "",
        _eventType = eventType,
        _hasModifierAlt = hasModifierAlt,
        _hasModifierShift = hasModifierShift,
        _hasModifierControl = hasModifierControl,

        _stringified = nil,
    })
end

function Class:GetType()
    Scopify(EScopes.Function, self)

    return _eventType
end

function Class:GetKey()
    Scopify(EScopes.Function, self)

    return _key
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
    
    if _key then
        result = result == ""
                and _key
                or (result .. "+" .. _key)
    end

    _stringified = result
    return result
end
Class.__tostring = Class.ToString

