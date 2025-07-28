--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local IPfuiHeaderBuilder = using "[declare] [interface] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.Header.IPfuiHeaderBuilder" {
    "IPfuiGuiControlBuilder", using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.IPfuiGuiControlBuilder",
}

--- @param caption string the caption of the dropdown control
function IPfuiHeaderBuilder:ChainSet_Caption(caption)
end

--- function IPfuiHeaderBuilder:Build() -- inherited from IPfuiGuiControlBuilder
--- end
