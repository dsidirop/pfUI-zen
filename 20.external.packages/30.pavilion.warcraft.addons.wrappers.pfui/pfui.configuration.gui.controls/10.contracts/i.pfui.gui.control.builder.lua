--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

--- base interface for all pfUI-GUI-control-builders
local IPfuiGuiControlBuilder = using "[declare] [interface]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.IPfuiGuiControlBuilder" --[[@formatter:on]]

function IPfuiGuiControlBuilder:Build()
end
