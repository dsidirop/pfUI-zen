--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local A                                 = using "System.Helpers.Arrays"
local T                                 = using "System.Helpers.Tables"
local S                                 = using "System.Helpers.Strings"

local Guard                             = using "System.Guard"

local Event                             = using "System.Event"
local Fields                            = using "System.Classes.Fields"

local PfuiGui                           = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.RawBindings.PfuiGui"
local IPfuiLabeledDropdownBuilder       = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.Dropdown.IPfuiLabeledDropdownBuilder"
local DropdownSelectionChangedEventArgs = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.Dropdown.DropdownSelectionChangedEventArgs"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.LabeledDropdown.PfuiLabeledDropdownBuilder" { --[[@formatter:on]]
    "IPfuiLabeledDropdownBuilder", IPfuiLabeledDropdownBuilder,
}

Fields(function(upcomingInstance)
    upcomingInstance._nativePfuiControlFrame = nil

    upcomingInstance._caption = ""
    upcomingInstance._xposNudging = 0
    upcomingInstance._yposNudging = 0

    upcomingInstance._menuItems = {}
    upcomingInstance._menuEntryValuesToIndexes = {}
    upcomingInstance._menuIndexesToMenuValuesArray = {}

    upcomingInstance._oldValue = nil
    upcomingInstance._singlevalue = {}
    upcomingInstance._valuekeyname = "dummy_keyname_for_value"

    upcomingInstance._eventSelectionChanged = Event:New()

    return upcomingInstance
end)

function Class:ChainSet_Caption(caption)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(caption, "caption")

    _caption = caption

    return self
end

function Class:ChainSet_MenuItems(menuItems)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsTable(menuItems, "menuItems")

    _menuItems = menuItems
    _menuEntryValuesToIndexes, _menuIndexesToMenuValuesArray = self:ParseMenuItems_(menuItems)

    Guard.Assert.Explained.IsNotNil(_menuEntryValuesToIndexes, "menuItems contains duplicate values which is not allowed")

    return self
end

function Class:ChainSet_CaptionXPositionNudging(xposNudging) -- +/-px horizontally from the default position
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNumber(xposNudging, "xposNudging")

    _xposNudging = xposNudging

    return self
end

function Class:ChainSet_CaptionYPositionNudging(yposNudging) -- +/-px vertically from the default position
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNumber(yposNudging, "yposNudging")

    _yposNudging = yposNudging

    return self
end

function Class:Build()
    Scopify(EScopes.Function, self)

    Guard.Assert.IsTable(_menuItems, "_menuItems")
    Guard.Assert.IsNonDudString(_caption, "_caption")

    _nativePfuiControlFrame = PfuiGui.CreateConfig(
        function()
            self:OnSelectionChanged_(
                DropdownSelectionChangedEventArgs
                :New()
                :ChainSet_Old(_oldValue)
                :ChainSet_New(_singlevalue[_valuekeyname])
            )
        end,
        _caption,
        _singlevalue,
        _valuekeyname,
        "dropdown",
        _menuItems
    )
    if _xposNudging or _yposNudging then -- todo  extract this on a base-class
        local anchor, relativeControl, relativeAnchor, xpos, ypos = _nativePfuiControlFrame.caption:GetPoint()

        _nativePfuiControlFrame.caption:SetPoint(anchor, relativeControl, relativeAnchor, xpos + _xposNudging, ypos + _yposNudging)
    end

    return self -- todo  we should return a wrapped _nativePfuiControlFrame and move the :TrySetSelectedOptionByValue() and other methods in that wrapper
end

-- todo   all these methods should be moved to the control class itself
function Class:TrySetSelectedOptionByValue(optionValue)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(optionValue, "optionValue")
    Guard.Assert.Explained.IsNotNil(_nativePfuiControlFrame, "control has not beed built - call Build() first")

    local index = _menuEntryValuesToIndexes[optionValue]
    if index == nil then
        return false -- given option doesnt exist
    end

    local success = self:TrySetSelectedOptionByIndex(index)
    Guard.Assert.Explained.IsTrue(success,
        "failed to set the selection to option '" ..
        optionValue .. "' (index=" .. index .. " - but how did this happen?)")

    return true
end

function Class:TrySetSelectedOptionByIndex(index)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsPositiveInteger(index, "index")
    Guard.Assert.Explained.IsNotNil(_nativePfuiControlFrame, "control has not beed built - call Build() first")

    if index > A.Count(_menuIndexesToMenuValuesArray) then
        -- we dont want to subject this to an assertion
        return false
    end

    if _nativePfuiControlFrame.input.id == index then
        return true -- already selected   nothing to do
    end

    local newValue = _menuIndexesToMenuValuesArray[index] --   order
    local originalValue = _singlevalue[_valuekeyname]     --   order

    _singlevalue[_valuekeyname] = newValue                --   order
    _nativePfuiControlFrame.input:SetSelection(index)     --   order

    Guard.Assert.Explained.IsTrue(_nativePfuiControlFrame.input.id == index,
        "failed to set the selection to option#" .. index .. " (how did this happen?)")

    self:OnSelectionChanged_(
        DropdownSelectionChangedEventArgs -- 00
        :New()
        :ChainSet_Old(originalValue)
        :ChainSet_New(newValue)
    )

    return true

    --00  we have to emulate the selectionchanged event because the underlying pfui control doesnt fire it automatically on its own
end

function Class:ChainSet_Visibility(showNotHide)
    Scopify(EScopes.Function, self)

    if showNotHide then
        self:Show()
    else
        self:Hide()
    end

    return self
end

function Class:Show()
    Scopify(EScopes.Function, self)

    Guard.Assert.Explained.IsNotNil(_nativePfuiControlFrame, "control has not beed built - call Build() first")

    _nativePfuiControlFrame:Show()

    return self
end

function Class:Hide()
    Scopify(EScopes.Function, self)

    Guard.Assert.Explained.IsNotNil(_nativePfuiControlFrame, "control has not beed built - call Build() first")

    _nativePfuiControlFrame:Hide()

    return self
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

    _oldValue = ea:GetNewValue()
    _eventSelectionChanged:Raise(self, ea)
end

function Class:ParseMenuItems_(menuItemsArray)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsTable(menuItemsArray, "menuItemsArray")

    local menuIndexesToMenuValues = {}
    local menuEntryValuesToIndexes = {}
    for i, k in T.GetPairs(menuItemsArray) do
        local value, _ = A.Unpack(S.Split(k, ":", 2))

        value = value or ""
        if menuEntryValuesToIndexes[value] ~= nil then
            return nil, nil
        end

        menuIndexesToMenuValues[i] = value
        menuEntryValuesToIndexes[value] = i
    end

    return menuEntryValuesToIndexes, menuIndexesToMenuValues
end
