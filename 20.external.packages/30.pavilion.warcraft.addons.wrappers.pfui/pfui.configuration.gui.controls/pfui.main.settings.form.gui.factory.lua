--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard = using "System.Guard"

local PfuiHeaderBuilder                 = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.Header.PfuiHeaderBuilder"
local PfuiLabeledDropdownBuilder        = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.LabeledDropdown.PfuiLabeledDropdownBuilder"
local PfuiNestedTabFrameWithAreaBuilder = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.PfuiNestedTabFrameWithAreaBuilder"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.PfuiMainSettingsFormGuiFactory" { --[[@formatter:on]]
    "IPfuiMainSettingsFormGuiFactory", using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.IPfuiMainSettingsFormGuiFactory",
}


function Class:SpawnNestedTabFrameWithAreaBuilder() -- pfUI.gui.frames[][*].area
    Scopify(EScopes.Function, self)

    return PfuiNestedTabFrameWithAreaBuilder:New()
end

function Class:SpawnLabeledDropdownBuilder()
    Scopify(EScopes.Function, self)

    return PfuiLabeledDropdownBuilder:New()
end

function Class:SpawnHeaderBuilder()
    Scopify(EScopes.Function, self)

    return PfuiHeaderBuilder:New()
end
