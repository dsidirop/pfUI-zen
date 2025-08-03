--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local A = using "System.Helpers.Arrays"
local T = using "System.Helpers.Tables"

local Guard  = using "System.Guard"
local Event  = using "System.Event"
local Fields = using "System.Classes.Fields"
local FrameX = using "Pavilion.Warcraft.Foundation.UI.Frames.FrameX"

local DropdownSelectionChangedEventArgs = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.Dropdown.DropdownSelectionChangedEventArgs"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.LabeledDropdown.PfuiLabeledDropdownControl" { --[[@formatter:on]]
    "FrameX", FrameX,
}

Fields(function(upcomingInstance)
    -- upcomingInstance._rawWoWFrame = nil -- inherited

    upcomingInstance._menuEntryValuesToIndexes = {}
    upcomingInstance._menuIndexesToMenuValuesArray = {}

    upcomingInstance._pfuiCurrentValueTable = {}
    upcomingInstance._pfuiCurrentValueKeyName = ""

    upcomingInstance._eventSelectionChanged = nil

    return upcomingInstance
end)

function Class:New(rawWoWFrame, eventSelectionChanged, menuIndexesToMenuValuesArray, pfuiCurrentValueTable, pfuiCurrentValueKeyName)
    Scopify(EScopes.Constructor, self)

    Guard.Assert.IsMereFrame(rawWoWFrame, "rawWoWFrame")

    Guard.Assert.IsTableray(menuIndexesToMenuValuesArray, "menuIndexesToMenuValuesArray")
    Guard.Assert.IsInstanceOf(eventSelectionChanged, Event, "eventSelectionChanged")    
    
    Guard.Assert.IsTable(pfuiCurrentValueTable, "pfuiCurrentValueTable")
    Guard.Assert.IsNonDudString(pfuiCurrentValueKeyName, "pfuiCurrentValueKeyName")

    local newInstance = self:Instantiate()
    
    newInstance = newInstance.asBase.FrameX.New(newInstance, rawWoWFrame)

    newInstance._eventSelectionChanged = eventSelectionChanged

    newInstance._menuEntryValuesToIndexes = T.ConvertTablerayIntoKeysToIndexesTable(menuIndexesToMenuValuesArray)
    newInstance._menuIndexesToMenuValuesArray = menuIndexesToMenuValuesArray
    
    newInstance._pfuiCurrentValueTable = pfuiCurrentValueTable --        unfortunately this is the only way to get this to work
    newInstance._pfuiCurrentValueKeyName = pfuiCurrentValueKeyName --    based on how pfui value-storage is structured under the hood

    return newInstance
end


function Class:TrySetSelectedOptionByValue(optionValue)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(optionValue, "optionValue")

    local index = _menuEntryValuesToIndexes[optionValue]
    if index == nil then
        return false -- given option doesnt exist
    end

    local success = self:TrySetSelectedOptionByIndex(index)
    Guard.Assert.Explained.IsTrue(success, "failed to set the selection to option '" .. optionValue .. "' (index=" .. index .. " - but how did this happen?)")

    return true
end

function Class:TrySetSelectedOptionByIndex(index)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsPositiveInteger(index, "index")

    if index > A.Count(_menuIndexesToMenuValuesArray) then
        -- we dont want to subject this to an assertion
        return false
    end

    if _rawWoWFrame.input.id == index then
        return true -- already selected   nothing to do
    end

    local newValue = _menuIndexesToMenuValuesArray[index] --                    order
    local originalValue = _pfuiCurrentValueTable[_pfuiCurrentValueKeyName] --   order

    _pfuiCurrentValueTable[_pfuiCurrentValueKeyName] = newValue --   order
    _rawWoWFrame.input:SetSelection(index) --                        order

    Guard.Assert.Explained.IsTrue(_rawWoWFrame.input.id == index, "failed to set the selection to option#" .. index .. " (how did this happen?)")

    self:OnSelectionChanged_(
        DropdownSelectionChangedEventArgs -- 00
        :New()
        :ChainSet_Old(originalValue)
        :ChainSet_New(newValue)
    )

    return true

    --00  we have to emulate the selectionchanged event because the underlying pfui control doesnt fire it automatically on its own
end

function Class:EventSelectionChanged_Subscribe(handler, owner)
    Scopify(EScopes.Function, self)

    _eventSelectionChanged:Subscribe(handler, owner)

    return self
end

function Class:EventSelectionChanged_Unsubscribe(handler)
    Scopify(EScopes.Function, self)

    _eventSelectionChanged:Unsubscribe(handler)

    return self
end

-- privates
function Class:OnSelectionChanged_(ea)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsTable(ea, "ea")

    _eventSelectionChanged:Raise(self, ea)
end
