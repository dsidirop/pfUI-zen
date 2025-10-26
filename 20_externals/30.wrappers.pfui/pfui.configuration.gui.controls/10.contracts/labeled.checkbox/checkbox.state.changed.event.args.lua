--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Guard = using "System.Guard"

local Fields = using "System.Classes.Fields"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.LabeledCheckbox.CheckboxStateChangedEventArgs"


Fields(function(upcomingInstance)
    upcomingInstance._new = nil

    return upcomingInstance
end)


function Class:New()
    Scopify(EScopes.Function, self)

    return self:Instantiate()
end

function Class:GetNewState()
    Scopify(EScopes.Function, self)

    return _new
end

function Class:ChainSet_NewState(new)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBoolean(new, "new")
    
    _new = new

    return self
end
