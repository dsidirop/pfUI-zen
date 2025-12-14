--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local A = using "System.Helpers.Arrays"
local T = using "System.Helpers.Tables"

local Guard  = using "System.Guard"
local Event  = using "System.Event"
local Fields = using "System.Classes.Fields"
local FrameX = using "Pavilion.Warcraft.Foundation.UI.Frames.FrameX"

local TextboxTextChangedEventArgs = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.LabeledTextbox.TextboxTextChangedEventArgs"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.LabeledTextbox.PfuiLabeledTextboxControl" { --[[@formatter:on]]
    "FrameX", FrameX,
}

Fields(function(upcomingInstance)
    -- upcomingInstance._rawWoWFrame = nil -- inherited

    upcomingInstance._eventTextChanged = nil
    upcomingInstance._pfuiCurrentValueTable = {}
    upcomingInstance._pfuiCurrentValueKeyName = ""

    return upcomingInstance
end)

function Class:New(rawWoWFrame, eventTextChanged, pfuiCurrentValueTable, pfuiCurrentValueKeyName)
    Scopify(EScopes.Constructor, self)

    Guard.Assert.IsMereFrame(rawWoWFrame, "rawWoWFrame")
    Guard.Assert.IsInstanceOf(eventTextChanged, Event, "eventTextChanged")    
    
    Guard.Assert.IsTable(pfuiCurrentValueTable, "pfuiCurrentValueTable")
    Guard.Assert.IsNonDudString(pfuiCurrentValueKeyName, "pfuiCurrentValueKeyName")

    local newInstance = self:Instantiate()
    
    newInstance = Class.asBase.FrameX.New(newInstance, rawWoWFrame)

    newInstance._eventTextChanged = eventTextChanged
    newInstance._pfuiCurrentValueTable = pfuiCurrentValueTable --        unfortunately this is the only way to get this to work
    newInstance._pfuiCurrentValueKeyName = pfuiCurrentValueKeyName --    based on how pfui value-storage is structured under the hood

    return newInstance
end

function Class:GetText(desiredText)
    Scopify(EScopes.Function, self)

    return _rawWoWFrame.input:GetText()
end

function Class:ChainSet_Text(desiredText)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(desiredText, "desiredText")

    if _rawWoWFrame.input:GetText() == desiredText then
        return self -- already set properly
    end

    _pfuiCurrentValueTable[_pfuiCurrentValueKeyName] = desiredText -- order
    _rawWoWFrame.input:SetText(desiredText) --                        order

    self:OnTextChanged_(TextboxTextChangedEventArgs:New():ChainSet_NewText(desiredText))

    return self
end

function Class:ChainSet_IsMultiLine(mode)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBoolean(mode, "mode")

    _rawWoWFrame.input:SetMultiLine(mode)

    return self
end

function Class:ChainSet_JustifyHorizontally(mode)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(mode, "mode") -- todo   introduce strenum and use it here

    _rawWoWFrame.input:SetJustifyH(mode)

    return self
end

function Class:ChainSet_Autofocus(autofocus)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBoolean(autofocus, "autofocus")

    _rawWoWFrame.input:SetAutoFocus(autofocus)

    return self
end


function Class:EventTextChanged_Subscribe(handler, owner)
    Scopify(EScopes.Function, self)

    _eventTextChanged:Subscribe(handler, owner)

    return self
end

function Class:EventTextChanged_Unsubscribe(handler)
    Scopify(EScopes.Function, self)

    _eventTextChanged:Unsubscribe(handler)

    return self
end

-- privates
function Class:OnTextChanged_(ea)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsInstanceOf(ea, TextboxTextChangedEventArgs, "ea")

    _eventTextChanged:Raise(self, ea)
end
