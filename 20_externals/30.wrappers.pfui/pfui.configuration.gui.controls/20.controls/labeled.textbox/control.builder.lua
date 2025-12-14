--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local A = using "System.Helpers.Arrays"
local T = using "System.Helpers.Tables"
local S = using "System.Helpers.Strings"

local Guard  = using "System.Guard"

local Event  = using "System.Event"
local Fields = using "System.Classes.Fields"

local PfuiGui                            = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.RawBindings.PfuiGui"
local PfuiGuiBaseControlBuilder          = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.BaseBuilder.PfuiGuiBaseControlBuilder"
local TextboxTextChangedEventArgs        = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.LabeledTextbox.TextboxTextChangedEventArgs"
local IPfuiLabeledTextboxControlBuilder  = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.LabeledTextbox.IPfuiLabeledTextboxControlBuilder"

local PfuiLabeledTextboxControl          = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.LabeledTextbox.PfuiLabeledTextboxControl"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.LabeledTextbox.PfuiLabeledTextboxControlBuilder" { --[[@formatter:on]]
    "PfuiGuiBaseControlBuilder", PfuiGuiBaseControlBuilder,

    "IPfuiLabeledTextboxControlBuilder", IPfuiLabeledTextboxControlBuilder,
}

Fields(function(upcomingInstance)
    -- upcomingInstance._caption = "" --    provided from the base class
    -- upcomingInstance._xposNudging = 0 -- provided from the base class
    -- upcomingInstance._yposNudging = 0 -- provided from the base class
    
    upcomingInstance._text = ""
    upcomingInstance._isMultiLine = false
    upcomingInstance._isAutofocus = false
    upcomingInstance._justifyHorizontallyMode = "RIGHT" -- LEFT, CENTER, RIGHT

    upcomingInstance._eventTextChanged = Event:New() -- todo   we should replace this with an INotifyPropertyChanged event directly on pfuiCurrentValueTable["__dummy_keyname_for_value__"]

    return upcomingInstance
end)


function Class:ChainSet_Text(text)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(text, "text")

    _text = text

    return self
end

function Class:ChainSet_JustifyHorizontally(mode)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(mode, "mode") -- todo   introduce a strenum and use it here

    _justifyHorizontallyMode = mode

    return self
end

function Class:ChainSet_IsMultiLine(isMultiLine)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBoolean(isMultiLine, "isMultiLine")

    _isMultiLine = isMultiLine

    return self
end

function Class:ChainSet_IsAutofocus(isAutofocus)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBoolean(isAutofocus, "isAutofocus")

    _isAutofocus = isAutofocus

    return self
end


function Class:BuildImpl()
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(_text, "_text")

    local pfuiCurrentValueTable = {}
    local pfuiCurrentValueKeyName = "__dummy_keyname_for_value__"
    
    pfuiCurrentValueTable[pfuiCurrentValueKeyName] = _text -- set the initial text before building the control

    local nativePfuiControlFrame = PfuiGui.CreateConfig(
        function() -- this function is called each time the textbox text changes
            _eventTextChanged:Raise(self, TextboxTextChangedEventArgs:New():ChainSet_NewText(pfuiCurrentValueTable[pfuiCurrentValueKeyName]))
        end,
        _caption,
        pfuiCurrentValueTable,
        pfuiCurrentValueKeyName,
        "text",
        nil, --     event-values (ignored for textboxes)
        false, --   skip
        false, --   named (ignored in general)
        "string" -- type must be set to string otherwise pfui will not even fire the text-changed-event
    )

    --@formatter:off
    return PfuiLabeledTextboxControl:New(
                                            nativePfuiControlFrame,
                                            _eventTextChanged,
                                            pfuiCurrentValueTable,
                                            pfuiCurrentValueKeyName
                                    )
                                    :ChainSet_Autofocus(_isAutofocus)
                                    :ChainSet_IsMultiLine(_isMultiLine)
                                    :ChainSet_JustifyHorizontally(_justifyHorizontallyMode)
    --@formatter:on

end

