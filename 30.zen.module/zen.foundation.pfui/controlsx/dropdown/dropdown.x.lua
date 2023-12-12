-- the main reason we introduce this class is to be able to set the selected option by nickname  on top of that
-- the original pfui dropdown control has a counter-intuitive api surface that is not fluent enough for day to day use 

local _assert, _setfenv, _type, _getn, _, _, _unpack, _pairs, _importer, _namespacer, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _getn = _assert(_g.table.getn)
    local _error = _assert(_g.error)
    local _print = _assert(_g.print)
    local _pairs = _assert(_g.pairs)
    local _unpack = _assert(_g.unpack)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _setmetatable = _assert(_g.setmetatable)

    return _assert, _setfenv, _type, _getn, _error, _print, _unpack, _pairs, _importer, _namespacer, _setmetatable
end)()

_setfenv(1, {})

local Classify = _importer("System.Classify")

local Event = _importer("Pavilion.System.Event")
local TablesHelper = _importer("Pavilion.Helpers.Tables")
local ArraysHelper = _importer("Pavilion.Helpers.Arrays")
local StringsHelpers = _importer("Pavilion.Helpers.Strings")

local PfuiGui = _importer("Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Gui")
local SelectionChangedEventArgs = _importer("Pavilion.Warcraft.Addons.Zen.UI.Pfui.ControlsX.Dropdown.SelectionChangedEventArgs")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.UI.Pfui.ControlsX.Dropdown.DropdownX")

function Class:New()
    _setfenv(1, self)

    return Classify(self, {
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
    _setfenv(1, self)

    _assert(_type(caption) == "string")

    _caption = caption

    return self
end

function Class:ChainSetMenuItems(menuItems)
    _setfenv(1, self)

    _assert(_type(menuItems) == "table")

    _menuItems = menuItems
    _menuEntryValuesToIndexes, _menuIndexesToMenuValuesArray = self:ParseMenuItems_(menuItems)
    _assert(_menuEntryValuesToIndexes ~= nil, "menuItems contains duplicate values which is not allowed")

    return self
end

function Class:Initialize()
    _setfenv(1, self)

    _assert(_type(_caption) == "string")
    _assert(_type(_menuItems) == "table")

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
    _setfenv(1, self)

    _assert(_type(optionValue) == "string")
    _assert(_nativePfuiControl ~= nil, "control is not initialized - call Initialize() first")

    local index = _menuEntryValuesToIndexes[optionValue]
    if index == nil then
        return false -- given option doesnt exist
    end

    local success = self:TrySetSelectedOptionByIndex(index)
    _assert(success, "failed to set the selection to option '" .. optionValue .. "' (index=" .. index .. " - but how did this happen?)")

    return true
end

function Class:TrySetSelectedOptionByIndex(index)
    _setfenv(1, self)

    _assert(_type(index) == "number" and index >= 1, "index must be a number >= 1")
    _assert(_nativePfuiControl ~= nil, "control is not initialized - call Initialize() first")

    if index > ArraysHelper.Count(_menuIndexesToMenuValuesArray) then
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
    _assert(_nativePfuiControl.input.id == index, "failed to set the selection to option#" .. index .. " (how did this happen?)")

    self:OnSelectionChanged_( -- 00
            SelectionChangedEventArgs:New()
                                     :ChainSetOld(originalValue)
                                     :ChainSetNew(newValue)
    )

    return true

    --00  we have to emulate the selectionchanged event because the underlying pfui control doesnt fire it automatically on its own
end

function Class:SetVisibility(showNotHide)
    _setfenv(1, self)

    if showNotHide then
        self:Show()
    else
        self:Hide()
    end

    return self
end

function Class:Show()
    _setfenv(1, self)
    _assert(_nativePfuiControl ~= nil, "control is not initialized - call Initialize() first")

    _nativePfuiControl:Show()

    return self
end

function Class:Hide()
    _setfenv(1, self)
    _assert(_nativePfuiControl ~= nil, "control is not initialized - call Initialize() first")

    _nativePfuiControl:Hide()

    return self
end

function Class:EventSelectionChanged_Subscribe(handler, owner)
    _setfenv(1, self)

    _eventSelectionChanged:Subscribe(handler, owner)

    return self
end

function Class:EventSelectionChanged_Unsubscribe(handler)
    _setfenv(1, self)

    _eventSelectionChanged:Unsubscribe(handler)

    return self
end

-- privates
function Class:OnSelectionChanged_(ea)
    _setfenv(1, self)

    _assert(_type(ea) == "table", "event-args is not an object")

    _oldValue = ea:GetNewValue()
    _eventSelectionChanged:Raise(self, ea)
end

function Class:ParseMenuItems_(menuItemsArray)
    _setfenv(1, self)

    _assert(_type(menuItemsArray) == "table")

    local menuIndexesToMenuValues = {}
    local menuEntryValuesToIndexes = {}
    for i, k in TablesHelper.GetKeyValuePairs(menuItemsArray) do
        local value, _ = TablesHelper.Unpack(StringsHelpers.Split(k, ":"))

        value = value or ""
        if menuEntryValuesToIndexes[value] ~= nil then
            return nil, nil
        end

        menuIndexesToMenuValues[i] = value
        menuEntryValuesToIndexes[value] = i
    end

    return menuEntryValuesToIndexes, menuIndexesToMenuValues
end
