--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Class = using "[declare] [interface] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.Dropdown.IPfuiLabeledDropdownBuilder" {
    "IPfuiGuiControlBuilder", using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.IPfuiGuiControlBuilder",
}


--- @param caption string the caption of the dropdown control
function Class:ChainSet_Caption(caption)
end

--- @param menuItems table an array-table of menu items, each item is a table with the following structure: "<value-nickname>:<human-readable-description>"
function Class:ChainSet_MenuItems(menuItems)
end

--- @param xposNudging number +/-px horizontally from the default position
function Class:ChainSet_CaptionXPositionNudging(xposNudging)
end

--- @param yposNudging number +/-px vertically from the default position
function Class:ChainSet_CaptionYPositionNudging(yposNudging)
end

--- function Class:Build() -- inherited from IPfuiGuiControlBuilder
--- end


-- todo   all these methods should be moved to the control class itself

--- @param optionValue string the value-nickname of the option to select
function Class:TrySetSelectedOptionByValue(optionValue)
end

--- @param index number the index of the option to select
--- @return boolean boolean true if the selection was changed, false if the index is out of bounds
function Class:TrySetSelectedOptionByIndex(index)
end

--- @param showNotHide boolean the visibility of the control, true to show, false to hide
function Class:SetVisibility(showNotHide)
end

--- @return frame frame the native pfUI control frame that is built by this builder
function Class:Show()
end

--- @return frame frame the native pfUI control frame that is built by this builder
function Class:Hide()
end

--- @param handler function the event-handler function to subscribe to the selection-changed event
--- @param owner any the owner of the event-handler, it will be passed as the first argument to the handler
--- @return frame frame the native pfUI control frame that is built by this builder
function Class:EventSelectionChanged_Subscribe(handler, owner)
end

--- @param handler function the event-handler function to unsubscribe from the selection-changed event
--- @return frame frame the native pfUI control frame that is built by this builder
function Class:EventSelectionChanged_Unsubscribe(handler)
end
