--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]


local Guard = using "System.Guard"
local Fields = using "System.Classes.Fields"

local EKeyEventType = using "Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Enums.EKeyEventType"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.EventArgs.KeyEventArgs"

Scopify(EScopes.Function, Class)

Fields(function(upcomingInstance)
    upcomingInstance._key = ""
    upcomingInstance._eventType = nil
    upcomingInstance._hasModifierAlt = false
    upcomingInstance._hasModifierShift = false
    upcomingInstance._hasModifierControl = false

    upcomingInstance._stringified = nil

    return upcomingInstance
end)

function Class:New(key, hasModifierAlt, hasModifierShift, hasModifierControl, eventType)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrStringOfMaxLength(key, 1, "key")

    Guard.Assert.IsBoolean(hasModifierAlt, "hasModifierAlt")
    Guard.Assert.IsBoolean(hasModifierShift, "hasModifierShift")
    Guard.Assert.IsBoolean(hasModifierControl, "hasModifierControl")
    Guard.Assert.IsEnumValue(EKeyEventType, eventType, "eventType")

    local instance = self:Instantiate()

    instance._key = key or ""
    instance._eventType = eventType
    instance._hasModifierAlt = hasModifierAlt
    instance._hasModifierShift = hasModifierShift
    instance._hasModifierControl = hasModifierControl

    return instance
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

