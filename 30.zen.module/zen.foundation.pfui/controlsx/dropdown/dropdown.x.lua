-- the main reason we introduce this class is to be able to set the selected option by nickname  on top of that
-- the original pfui dropdown control has a counter-intuitive api surface that is not fluent enough for day to day use 

local _assert, _setfenv, _type, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _assert, _setfenv, _type, _importer, _namespacer
end)()

_setfenv(1, {})

local Scopify = _importer("System.Scopify")
local EScopes = _importer("System.EScopes")

local A = _importer("System.Helpers.Arrays")
local T = _importer("System.Helpers.Tables")
local S = _importer("System.Helpers.Strings")

local Event = _importer("System.Event")
local PfuiGui = _importer("Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Gui")
local SelectionChangedEventArgs = _importer("Pavilion.Warcraft.Addons.Zen.UI.Pfui.ControlsX.Dropdown.SelectionChangedEventArgs")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.UI.Pfui.ControlsX.Dropdown.DropdownX")

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

    _assert(_type(caption) == "string")

    _caption = caption

    return self
end

function Class:ChainSetMenuItems(menuItems)
    Scopify(EScopes.Function, self)

    _assert(_type(menuItems) == "table")

    _menuItems = menuItems
    _menuEntryValuesToIndexes, _menuIndexesToMenuValuesArray = self:ParseMenuItems_(menuItems)
    _assert(_menuEntryValuesToIndexes ~= nil, "menuItems contains duplicate values which is not allowed")

    return self
end

function Class:Initialize()
    Scopify(EScopes.Function, self)

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
    Scopify(EScopes.Function, self)

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
    Scopify(EScopes.Function, self)

    _assert(_type(index) == "number" and index >= 1, "index must be a number >= 1")
    _assert(_nativePfuiControl ~= nil, "control is not initialized - call Initialize() first")

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
    _assert(_nativePfuiControl.input.id == index, "failed to set the selection to option#" .. index .. " (how did this happen?)")

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

    _assert(_nativePfuiControl ~= nil, "control is not initialized - call Initialize() first")

    _nativePfuiControl:Show()

    return self
end

function Class:Hide()
    Scopify(EScopes.Function, self)
    _assert(_nativePfuiControl ~= nil, "control is not initialized - call Initialize() first")

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

    _assert(_type(ea) == "table", "event-args is not an object")

    _oldValue = ea:GetNewValue()
    _eventSelectionChanged:Raise(self, ea)
end

function Class:ParseMenuItems_(menuItemsArray)
    Scopify(EScopes.Function, self)

    _assert(_type(menuItemsArray) == "table")

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
