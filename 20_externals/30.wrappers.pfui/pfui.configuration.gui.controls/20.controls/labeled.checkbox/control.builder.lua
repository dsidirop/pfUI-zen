--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local A = using "System.Helpers.Arrays"
local T = using "System.Helpers.Tables"
local S = using "System.Helpers.Strings"

local Guard  = using "System.Guard"

local Event  = using "System.Event"
local Fields = using "System.Classes.Fields"

local PfuiGui                            = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.RawBindings.PfuiGui"
local PfuiGuiBaseControlBuilder          = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.BaseBuilder.PfuiGuiBaseControlBuilder"
local CheckboxStateChangedEventArgs      = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.LabeledCheckbox.CheckboxStateChangedEventArgs"
local IPfuiLabeledCheckboxControlBuilder = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.LabeledCheckbox.IPfuiLabeledCheckboxControlBuilder"

local PfuiLabeledCheckboxControl         = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.LabeledCheckbox.PfuiLabeledCheckboxControl"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.LabeledCheckbox.PfuiLabeledCheckboxControlBuilder" { --[[@formatter:on]]
    "PfuiGuiBaseControlBuilder", PfuiGuiBaseControlBuilder,

    "IPfuiLabeledCheckboxControlBuilder", IPfuiLabeledCheckboxControlBuilder,
}

Fields(function(upcomingInstance)
    -- upcomingInstance._caption = "" --    provided from the base class
    -- upcomingInstance._xposNudging = 0 -- provided from the base class
    -- upcomingInstance._yposNudging = 0 -- provided from the base class

    upcomingInstance._state = false
    upcomingInstance._eventSelectionChanged = Event:New() -- todo   we should replace this with an INotifyPropertyChanged event directly on pfuiCurrentValueTable["__dummy_keyname_for_value__"]

    return upcomingInstance
end)


function Class:ChainSet_InitialState(state)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBoolean(state, "state")

    _state = state

    return self
end

function Class:BuildImpl()
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBoolean(_state, "_state")

    local pfuiCurrentValueTable = {}
    local pfuiCurrentValueKeyName = "__dummy_keyname_for_value__"
    
    pfuiCurrentValueTable[pfuiCurrentValueKeyName] = _state -- set the initial state before building the control

    local nativePfuiControlFrame = PfuiGui.CreateConfig(
        function() -- this function is called when the Checkbox changes state via user interaction
            _eventSelectionChanged:Raise(
                self,
                CheckboxStateChangedEventArgs:New():ChainSet_NewState(pfuiCurrentValueTable[pfuiCurrentValueKeyName])
            )
        end,
        _caption,
        pfuiCurrentValueTable,
        pfuiCurrentValueKeyName,
        "checkbox"
    )

    return PfuiLabeledCheckboxControl:New(
        nativePfuiControlFrame,
        _eventSelectionChanged,
        pfuiCurrentValueTable,
        pfuiCurrentValueKeyName
    )
end
