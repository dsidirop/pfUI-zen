--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local IPfuiLabeledTextboxControlBuilder = using "[declare] [interface] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.LabeledTextbox.IPfuiLabeledTextboxControlBuilder" {
    "IPfuiGuiBaseControlBuilder", using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.BaseBuilder.IPfuiGuiBaseControlBuilder",
}  --[[@formatter:off]]


function IPfuiLabeledTextboxControlBuilder:ChainSet_Text(text) end;
function IPfuiLabeledTextboxControlBuilder:ChainSet_IsMultiLine(isMultiLine) end;
function IPfuiLabeledTextboxControlBuilder:ChainSet_IsAutofocus(isAutofocus) end;
function IPfuiLabeledTextboxControlBuilder:ChainSet_JustifyHorizontally(mode) end;

--- function IPfuiLabeledTextboxControlBuilder:Build() end; -- inherited from IPfuiGuiBaseControlBuilder
