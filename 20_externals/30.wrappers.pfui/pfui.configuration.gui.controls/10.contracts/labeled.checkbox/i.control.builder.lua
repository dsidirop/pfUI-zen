--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local IPfuiLabeledCheckboxControlBuilder = using "[declare] [interface] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.LabeledCheckbox.IPfuiLabeledCheckboxControlBuilder" {
    "IPfuiGuiBaseControlBuilder", using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.BaseBuilder.IPfuiGuiBaseControlBuilder",
}  --[[@formatter:off]]


--- @param initialState boolean  The initial checked state of the checkbox.
--- @return IPfuiLabeledCheckboxControlBuilder
function IPfuiLabeledCheckboxControlBuilder:ChainSet_InitialState(initialState) end;

--- function IPfuiLabeledCheckboxControlBuilder:Build() end; -- inherited from IPfuiGuiBaseControlBuilder
