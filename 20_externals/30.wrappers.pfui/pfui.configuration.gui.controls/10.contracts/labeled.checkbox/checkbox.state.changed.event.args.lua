--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Guard    = using "System.Guard"
local Booleans = using "System.Helpers.Booleans"

local Fields = using "System.Classes.Fields"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.LabeledCheckbox.CheckboxStateChangedEventArgs"


Fields(function(upcomingInstance)
    upcomingInstance._newState = nil

    return upcomingInstance
end)

function Class:GetNewState()
    Scopify(EScopes.Function, self)

    return _newState
end

function Class:ChainSet_NewState(newState) -- might be nil, 0, 1, "0", "1", "y", "n", "Y", "N", "TRUE", "FALSE", "true", "false", true, false, etc.
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBooleanizable(newState, "newState")
    
    _newState = Booleans.Booleanize(newState)

    return self
end
