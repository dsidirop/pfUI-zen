local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Foundation.Listeners.ModifiersKeystrokes.EventArgs.ModifierKeysStatusesChangedEventArgs"

Scopify(EScopes.Function, {})

function Class._.EnrichInstanceWithFields(upcomingInstance)
    upcomingInstance._stringifiedCached = nil

    upcomingInstance._hasModifierAlt = nil
    upcomingInstance._hasModifierShift = nil
    upcomingInstance._hasModifierControl = nil

    return upcomingInstance
end

function Class:New(hasModifierAlt, hasModifierShift, hasModifierControl)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBoolean(hasModifierAlt, "hasModifierAlt")
    Guard.Assert.IsBoolean(hasModifierShift, "hasModifierShift")
    Guard.Assert.IsBoolean(hasModifierControl, "hasModifierControl")
    
    local instance = self:Instantiate()

    instance._hasModifierAlt = hasModifierAlt
    instance._hasModifierShift = hasModifierShift
    instance._hasModifierControl = hasModifierControl

    return instance
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
    
    if _stringifiedCached ~= nil then
        return _stringifiedCached
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

    _stringifiedCached = result
    return result
end
Class.__tostring = Class.ToString
