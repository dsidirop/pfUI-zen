--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

-- the main reason we introduce this class is to be able to set the selected option by nickname  on top of that
-- the original pfui dropdown control has a counter-intuitive api surface that is not fluent enough for day to day use 

local Guard = using "System.Guard"

local Fields = using "System.Classes.Fields"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.Dropdown.DropdownSelectionChangedEventArgs"


Fields(function(upcomingInstance)
    upcomingInstance._old = nil
    upcomingInstance._new = nil

    return upcomingInstance
end)

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

function Class:ChainSet_Old(old)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrString(old, "old")

    _old = old

    return self
end

function Class:ChainSet_New(new)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(new, "new")
    
    _new = new

    return self
end
