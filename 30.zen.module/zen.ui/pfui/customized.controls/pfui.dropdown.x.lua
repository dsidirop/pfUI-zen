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

local Event = _importer("System.Event")
local PfuiGui = _importer("Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Gui")
local StringUtils  = _importer("Pavilion.Warcraft.Addons.Zen.Externals.String.Utils")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.UI.Pfui.CustomizedControls.PfuiDropdownX")

function Class:New()
    _setfenv(1, self)

    local instance = {
        _nativePfuiControl = nil,

        _caption = nil,
        _menuItems = {},
        _menuEntryValuesToIndexes = {},

        _oldValue = nil,        
        _dummyCornerstone = {},
        _dummyCornerstoneKeyname = "dummy_keyname_for_value",

        _eventSelectionChanged = Event:New(),
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
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
    _menuEntryValuesToIndexes, _menuIndexesToMenuValues = self:_ParseMenuItems(menuItems)

    return self
end

function Class:Initialize()
    _setfenv(1, self)

    _assert(_type(_caption) == "string")
    _assert(_type(_menuItems) == "table")

    _nativePfuiControl = PfuiGui.CreateConfig(
            function()
                self:_OnSelectionChanged({
                    Old = _oldValue,
                    New = _dummyCornerstone[_dummyCornerstoneKeyname],
                }) 
            end,
            _caption,
            _dummyCornerstone,
            _dummyCornerstoneKeyname,
            "dropdown",
            _menuItems
    )

    return self
end

function Class:SetSelectedOptionByValue(optionValue)
    _setfenv(1, self)

    _assert(_type(optionValue) == "string")
    _assert(_nativePfuiControl ~= nil, "control is not initialized - call Initialize() first")

    local index = _menuEntryValuesToIndexes[optionValue]
    _assert(index ~= nil, "invalid optionValue " .. (optionValue or "nil") .. " - must be one of the menu-values")

    self:SetSelectedOptionByIndex(index)

    return self, true
end

function Class:SetSelectedOptionByIndex(index)
    _setfenv(1, self)

    _assert(_type(index) == "number" and index >= 1 and index <= _getn(_menuIndexesToMenuValues), "index must be a number >= 1")
    _assert(_nativePfuiControl ~= nil, "control is not initialized - call Initialize() first")
    
    local newValue = _menuIndexesToMenuValues[index]
    local originalValue = _dummyCornerstone[_dummyCornerstoneKeyname]
    if newValue == originalValue then
        return self -- nothing to do
    end

    _dummyCornerstone[_dummyCornerstoneKeyname] = newValue --00 order
    _nativePfuiControl.input:SetSelection(index)
 
    self:_OnSelectionChanged({
        Old = originalValue,
        New = newValue,
    })
    
    return self
    
    --00  we have to emulate the selectionchanged event because the pfui control itself does not fire it
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

function Class:EventSelectionChanged_Subscribe(handler)
    _setfenv(1, self)

    _eventSelectionChanged:Subscribe(handler)

    return self
end

function Class:EventSelectionChanged_Unsubscribe(handler)
    _setfenv(1, self)

    _eventSelectionChanged:Unsubscribe(handler)

    return self
end

-- privates
function Class:_OnSelectionChanged(eventArgs)
    _setfenv(1, self)
    
    _assert(_type(eventArgs) == "table", "event-args is not an object")

    _oldValue = _eventSelectionChanged:Raise(self, eventArgs).New
end

function Class:_ParseMenuItems(menuItems)
    _setfenv(1, self)

    _assert(_type(menuItems) == "table")

    local menuIndexesToMenuValues = {}
    local menuEntryValuesToIndexes = {}
    for i, k in _pairs(menuItems) do
        local value, _ = _unpack(StringUtils.Split(k, ":"))

        menuIndexesToMenuValues[i] = value or ""
        menuEntryValuesToIndexes[value or ""] = i
    end

    return menuEntryValuesToIndexes, menuIndexesToMenuValues
end
