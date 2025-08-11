--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

--- A managed wrapper-gui-factory over 'pfUI.gui' 
---
--- @class Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Gui.IPfuiMainSettingsFormGuiControlsFactory
---
local IPfuiMainSettingsFormGuiControlsFactory = using "[declare] [interface]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.IPfuiMainSettingsFormGuiControlsFactory"

--- @return IPfuiHeaderControlBuilder IPfuiHeaderControlBuilder a builder for a header-label control - upon being build it will get plugged into the pfui-config-form automatically
function IPfuiMainSettingsFormGuiControlsFactory:SpawnHeaderControlBuilder()
end

--- @return IPfuiLabeledDropdownControlBuilder IPfuiLabeledDropdownControlBuilder a builder for a labeled dropdown control - upon being build it will get plugged into the pfui-config-form automatically
function IPfuiMainSettingsFormGuiControlsFactory:SpawnLabeledDropdownControlBuilder()
end

--- Creates a builder for {nested-tab-frame + area-frame} that will be automatically get plugged into the pfui-config-form when build.<br/>
---
--- @return IPfuiNestedTabFrameWithAreaControlBuilder IPfuiNestedTabFrameWithAreaControlBuilder a builder of type `Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Gui.Controls.IPfuiNestedTabFrameWithAreaControlBuilder`
function IPfuiMainSettingsFormGuiControlsFactory:SpawnNestedTabFrameWithAreaControlBuilder() -- pfUI.gui.frames[][*].area
end
