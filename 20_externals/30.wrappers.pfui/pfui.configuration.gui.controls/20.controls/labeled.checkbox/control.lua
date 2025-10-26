--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local A = using "System.Helpers.Arrays"
local T = using "System.Helpers.Tables"

local Guard  = using "System.Guard"
local Event  = using "System.Event"
local Fields = using "System.Classes.Fields"
local FrameX = using "Pavilion.Warcraft.Foundation.UI.Frames.FrameX"

local CheckboxStateChangedEventArgs = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.LabeledCheckbox.CheckboxStateChangedEventArgs"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.LabeledCheckbox.PfuiLabeledCheckboxControl" { --[[@formatter:on]]
    "FrameX", FrameX,
}

Fields(function(upcomingInstance)
    -- upcomingInstance._rawWoWFrame = nil -- inherited

    upcomingInstance._eventStateChanged = nil
    upcomingInstance._pfuiCurrentValueTable = {}
    upcomingInstance._pfuiCurrentValueKeyName = ""

    return upcomingInstance
end)

function Class:New(rawWoWFrame, eventStateChanged, pfuiCurrentValueTable, pfuiCurrentValueKeyName)
    Scopify(EScopes.Constructor, self)

    Guard.Assert.IsMereFrame(rawWoWFrame, "rawWoWFrame")
    Guard.Assert.IsInstanceOf(eventStateChanged, Event, "eventStateChanged")    
    
    Guard.Assert.IsTable(pfuiCurrentValueTable, "pfuiCurrentValueTable")
    Guard.Assert.IsNonDudString(pfuiCurrentValueKeyName, "pfuiCurrentValueKeyName")

    local newInstance = self:Instantiate()
    
    newInstance = Class.asBase.FrameX.New(newInstance, rawWoWFrame)

    newInstance._eventStateChanged = eventStateChanged
    newInstance._pfuiCurrentValueTable = pfuiCurrentValueTable --        unfortunately this is the only way to get this to work
    newInstance._pfuiCurrentValueKeyName = pfuiCurrentValueKeyName --    based on how pfui value-storage is structured under the hood

    return newInstance
end

function Class:ChainSet_State(desiredState)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBoolean(desiredState, "desiredState")

    if _rawWoWFrame.input:GetChecked() == desiredState then
        return self -- already in desired state   nothing to do
    end

    _pfuiCurrentValueTable[_pfuiCurrentValueKeyName] = desiredState -- order
    _rawWoWFrame.input:SetChecked(desiredState) --                     order

    self:OnStateChanged_(
            CheckboxStateChangedEventArgs -- 00
                    :New()
                    :ChainSet_NewState(desiredState)
    )

    return self
end

function Class:eventStateChanged_Subscribe(handler, owner)
    Scopify(EScopes.Function, self)

    _eventStateChanged:Subscribe(handler, owner)

    return self
end

function Class:eventStateChanged_Unsubscribe(handler)
    Scopify(EScopes.Function, self)

    _eventStateChanged:Unsubscribe(handler)

    return self
end

-- privates
function Class:OnStateChanged_(ea)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsInstanceOf(ea, CheckboxStateChangedEventArgs, "ea")

    _eventStateChanged:Raise(self, ea)
end
