--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

--- base interface for all pfUI-GUI-control-builders
local IPfuiGuiBaseControlBuilder = using "[declare] [interface]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.BaseBuilder.IPfuiGuiBaseControlBuilder" --[[@formatter:on]]

--- @param height number the caption of the dropdown control
function IPfuiGuiBaseControlBuilder:ChainSet_Height(height)
end

--- @param caption string the caption of the dropdown control
function IPfuiGuiBaseControlBuilder:ChainSet_Caption(caption)
end

--- @param xposNudging number +/-px horizontally from the default position
function IPfuiGuiBaseControlBuilder:ChainApply_NudgingX(xposNudging)
end

--- @param yposNudging number +/-px vertically from the default position
function IPfuiGuiBaseControlBuilder:ChainApply_NudgingY(yposNudging)
end

function IPfuiGuiBaseControlBuilder:Build()
end
