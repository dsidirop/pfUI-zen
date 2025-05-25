local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

-- the main reason we introduce this class is to be able to set the selected option by nickname  on top of that
-- the original pfui dropdown control has a counter-intuitive api surface that is not fluent enough for day to day use 

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.UI.Pfui.ControlsX.Dropdown.SelectionChangedEventArgs"

Scopify(EScopes.Function, {})

function Class._.EnrichInstanceWithFields(upcomingInstance)
    upcomingInstance._old = nil
    upcomingInstance._new = nil

    return upcomingInstance
end

function Class:New()
    Scopify(EScopes.Function, self)

    return self:Instantiate()
end

function Class:GetOldValue()
    Scopify(EScopes.Function, self)

    return _old
end

function Class:GetNewValue()
    Scopify(EScopes.Function, self)

    return _new
end

function Class:ChainSetOld(old)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrString(old, "old")

    _old = old

    return self
end

function Class:ChainSetNew(new)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(new, "new")
    
    _new = new

    return self
end
