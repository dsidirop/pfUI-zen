--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local A      = using "System.Helpers.Arrays"
local T      = using "System.Helpers.Tables"
local S      = using "System.Helpers.Strings"

local Guard  = using "System.Guard"

local Event  = using "System.Event"
local Fields = using "System.Classes.Fields"

local PfuiGui                            = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.RawBindings.PfuiGui"
local PfuiGuiBaseControlBuilder          = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.BaseBuilder.PfuiGuiBaseControlBuilder"
local DropdownSelectionChangedEventArgs  = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.Dropdown.DropdownSelectionChangedEventArgs"
local IPfuiLabeledDropdownControlBuilder = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.Dropdown.IPfuiLabeledDropdownControlBuilder"

local PfuiLabeledDropdownControl         = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.LabeledDropdown.PfuiLabeledDropdownControl"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.LabeledDropdown.PfuiLabeledDropdownControlBuilder" { --[[@formatter:on]]
    "PfuiGuiBaseControlBuilder", PfuiGuiBaseControlBuilder,

    "IPfuiLabeledDropdownControlBuilder", IPfuiLabeledDropdownControlBuilder,
}

Fields(function(upcomingInstance)
    upcomingInstance._nativePfuiControlFrame = nil

    -- upcomingInstance._caption = "" --    provided from the base class
    -- upcomingInstance._xposNudging = 0 -- provided from the base class
    -- upcomingInstance._yposNudging = 0 -- provided from the base class

    upcomingInstance._menuItems = {}
    upcomingInstance._menuEntryValuesToIndexes = {}
    upcomingInstance._menuIndexesToMenuValuesArray = {}

    upcomingInstance._eventSelectionChanged = Event:New() -- todo   we should replace this with an INotifyPropertyChanged event directly on on pfuiCurrentValueTable["__dummy_keyname_for_value__"]

    return upcomingInstance
end)


function Class:ChainSet_MenuItems(menuItems)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsTable(menuItems, "menuItems")

    _menuItems = menuItems
    _, _menuIndexesToMenuValuesArray = self:ParseMenuItems_(menuItems)

    Guard.Assert.Explained.IsNotNil(_menuIndexesToMenuValuesArray, "menuItems contains duplicate values which is not allowed")

    return self
end

function Class:BuildImpl()
    Scopify(EScopes.Function, self)

    Guard.Assert.IsTable(_menuItems, "_menuItems")
    Guard.Assert.IsNonDudString(_caption, "_caption")
    
    local pfuiCurrentValueTable = {}
    local pfuiCurrentValueKeyName = "__dummy_keyname_for_value__"

    _nativePfuiControlFrame = PfuiGui.CreateConfig(
        function() -- this function is called when the dropdown is shown and only then
            _eventSelectionChanged:Raise(
                self,
                DropdownSelectionChangedEventArgs:New():ChainSet_New(pfuiCurrentValueTable[pfuiCurrentValueKeyName])
            )
        end,
        _caption,
        pfuiCurrentValueTable,
        pfuiCurrentValueKeyName,
        "dropdown",
        _menuItems
    )

    return PfuiLabeledDropdownControl:New(
        _nativePfuiControlFrame,
        _eventSelectionChanged,
        _menuIndexesToMenuValuesArray,
        pfuiCurrentValueTable,
        pfuiCurrentValueKeyName
    )
end

-- privates

function Class:ParseMenuItems_(menuItemsArray)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsTable(menuItemsArray, "menuItemsArray")

    local menuIndexesToMenuValues = {}
    local menuEntryValuesToIndexes = {}
    for i, k in T.GetPairs(menuItemsArray) do
        local value, __ = A.Unpack(S.Split(k, ":", 2))

        value = value or ""
        if menuEntryValuesToIndexes[value] ~= nil then
            return nil, nil -- error   duplicate values are not allowed
        end

        menuIndexesToMenuValues[i] = value
        menuEntryValuesToIndexes[value] = i
    end

    return menuEntryValuesToIndexes, menuIndexesToMenuValues
end
