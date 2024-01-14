local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Event = using "System.Event"
local PfuiGui = using "Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Gui"
local SelectionChangedEventArgs = using "Pavilion.Warcraft.Addons.Zen.UI.Pfui.ControlsX.Dropdown.SelectionChangedEventArgs"

local A = using "System.Helpers.Arrays"
local T = using "System.Helpers.Tables"
local S = using "System.Helpers.Strings"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.UI.Pfui.ControlsX.Dropdown.DropdownX"

Scopify(EScopes.Function, {})

function Class:New()
    Scopify(EScopes.Function, self)

    return self:Instantiate({
        _nativePfuiControl = nil,

        _caption = nil,
        _menuItems = {},
        _menuEntryValuesToIndexes = {},
        _menuIndexesToMenuValuesArray = {},

        _oldValue = nil,
        _singlevalue = {},
        _valuekeyname = "dummy_keyname_for_value",

        _eventSelectionChanged = Event:New(),
    })
end

function Class:ChainSetCaption(caption)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsString(caption, "caption")

    _caption = caption

    return self
end

function Class:ChainSetMenuItems(menuItems)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsTable(menuItems, "menuItems")

    _menuItems = menuItems
    _menuEntryValuesToIndexes, _menuIndexesToMenuValuesArray = self:ParseMenuItems_(menuItems)

    Guard.Assert.Explained.IsNotNil(_menuEntryValuesToIndexes, "menuItems contains duplicate values which is not allowed")

    return self
end

function Class:Initialize()
    Scopify(EScopes.Function, self)

    Guard.Assert.IsTable(_menuItems, "_menuItems")
    Guard.Assert.IsString(_caption, "_caption")

    _nativePfuiControl = PfuiGui.CreateConfig(
            function()
                self:OnSelectionChanged_(
                        SelectionChangedEventArgs:New()
                                                 :ChainSetOld(_oldValue)
                                                 :ChainSetNew(_singlevalue[_valuekeyname])
                )
            end,
            _caption,
            _singlevalue,
            _valuekeyname,
            "dropdown",
            _menuItems
    )

    return self
end

function Class:TrySetSelectedOptionByValue(optionValue)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(optionValue, "optionValue")
    Guard.Assert.Explained.IsNotNil(_nativePfuiControl, "control is not initialized - call Initialize() first")

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
    Guard.Assert.Explained.IsNotNil(_nativePfuiControl, "control is not initialized - call Initialize() first")

    if index > A.Count(_menuIndexesToMenuValuesArray) then
        -- we dont want to subject this to an assertion
        return false
    end

    if _nativePfuiControl.input.id == index then
        return true -- already selected   nothing to do
    end

    local newValue = _menuIndexesToMenuValuesArray[index] --   order
    local originalValue = _singlevalue[_valuekeyname] --       order

    _singlevalue[_valuekeyname] = newValue --             order
    _nativePfuiControl.input:SetSelection(index) --       order

    Guard.Assert.Explained.IsTrue(_nativePfuiControl.input.id == index, "failed to set the selection to option#" .. index .. " (how did this happen?)")

    self:OnSelectionChanged_(
            SelectionChangedEventArgs:New() -- 00
                                     :ChainSetOld(originalValue)
                                     :ChainSetNew(newValue)
    )

    return true

    --00  we have to emulate the selectionchanged event because the underlying pfui control doesnt fire it automatically on its own
end

function Class:SetVisibility(showNotHide)
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

    Guard.Assert.Explained.IsNotNil(_nativePfuiControl, "control is not initialized - call Initialize() first")
    
    _nativePfuiControl:Show()

    return self
end

function Class:Hide()
    Scopify(EScopes.Function, self)

    Guard.Assert.Explained.IsNotNil(_nativePfuiControl, "control is not initialized - call Initialize() first")

    _nativePfuiControl:Hide()

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
