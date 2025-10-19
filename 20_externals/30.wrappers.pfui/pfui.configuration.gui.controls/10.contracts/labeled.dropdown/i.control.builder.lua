--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local IPfuiLabeledDropdownControlBuilder = using "[declare] [interface] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.Dropdown.IPfuiLabeledDropdownControlBuilder" {
    "IPfuiGuiBaseControlBuilder", using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.BaseBuilder.IPfuiGuiBaseControlBuilder",
}


--- @param menuItems table an array-table of menu items, each item is a table with the following structure: "<value-nickname>:<human-readable-description>"
function IPfuiLabeledDropdownControlBuilder:ChainSet_MenuItems(menuItems)
end

--- function IPfuiLabeledDropdownControlBuilder:Build() -- inherited from IPfuiGuiBaseControlBuilder
--- end
