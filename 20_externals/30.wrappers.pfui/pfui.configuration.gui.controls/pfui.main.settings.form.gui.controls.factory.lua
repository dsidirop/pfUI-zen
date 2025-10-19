--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard = using "System.Guard"

local PfuiHeaderControlBuilder                 = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.Header.PfuiHeaderControlBuilder"
local PfuiLabeledDropdownControlBuilder        = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.LabeledDropdown.PfuiLabeledDropdownControlBuilder"
local PfuiNestedTabFrameWithAreaControlBuilder = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.NestedTabFrameWithArea.PfuiNestedTabFrameWithAreaControlBuilder"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.PfuiMainSettingsFormGuiControlsFactory" { --[[@formatter:on]]
    "IPfuiMainSettingsFormGuiControlsFactory", using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.IPfuiMainSettingsFormGuiControlsFactory",
}


function Class:SpawnNestedTabFrameWithAreaControlBuilder() -- pfUI.gui.frames[][*].area
    Scopify(EScopes.Function, self)

    return PfuiNestedTabFrameWithAreaControlBuilder:New()
end

function Class:SpawnLabeledDropdownControlBuilder()
    Scopify(EScopes.Function, self)

    return PfuiLabeledDropdownControlBuilder:New()
end

function Class:SpawnHeaderControlBuilder()
    Scopify(EScopes.Function, self)

    return PfuiHeaderControlBuilder:New()
end
