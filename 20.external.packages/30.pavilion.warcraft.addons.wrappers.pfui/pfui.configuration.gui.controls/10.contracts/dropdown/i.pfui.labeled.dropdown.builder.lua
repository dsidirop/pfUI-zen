--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local IPfuiLabeledDropdownBuilder = using "[declare] [interface] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.Dropdown.IPfuiLabeledDropdownBuilder" {
    "IPfuiGuiControlBuilder", using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.IPfuiGuiControlBuilder",
}


--- @param caption string the caption of the dropdown control
function IPfuiLabeledDropdownBuilder:ChainSet_Caption(caption)
end

--- @param menuItems table an array-table of menu items, each item is a table with the following structure: "<value-nickname>:<human-readable-description>"
function IPfuiLabeledDropdownBuilder:ChainSet_MenuItems(menuItems)
end

--- @param xposNudging number +/-px horizontally from the default position
function IPfuiLabeledDropdownBuilder:ChainSet_CaptionXPositionNudging(xposNudging)
end

--- @param yposNudging number +/-px vertically from the default position
function IPfuiLabeledDropdownBuilder:ChainSet_CaptionYPositionNudging(yposNudging)
end

--- function IPfuiLabeledDropdownBuilder:Build() -- inherited from IPfuiGuiControlBuilder
--- end


-- todo   all these methods should be moved to the control class itself

--- @param optionValue string the value-nickname of the option to select
function IPfuiLabeledDropdownBuilder:TrySetSelectedOptionByValue(optionValue)
end

--- @param index number the index of the option to select
--- @return boolean boolean true if the selection was changed, false if the index is out of bounds
function IPfuiLabeledDropdownBuilder:TrySetSelectedOptionByIndex(index)
end

--- @param showNotHide boolean the visibility of the control, true to show, false to hide
function IPfuiLabeledDropdownBuilder:ChainSet_Visibility(showNotHide)
end

--- @return frame frame the native pfUI control frame that is built by this builder
function IPfuiLabeledDropdownBuilder:Show()
end

--- @return frame frame the native pfUI control frame that is built by this builder
function IPfuiLabeledDropdownBuilder:Hide()
end

--- @param handler function the event-handler function to subscribe to the selection-changed event
--- @param owner any the owner of the event-handler, it will be passed as the first argument to the handler
--- @return frame frame the native pfUI control frame that is built by this builder
function IPfuiLabeledDropdownBuilder:EventSelectionChanged_Subscribe(handler, owner)
end

--- @param handler function the event-handler function to unsubscribe from the selection-changed event
--- @return frame frame the native pfUI control frame that is built by this builder
function IPfuiLabeledDropdownBuilder:EventSelectionChanged_Unsubscribe(handler)
end
