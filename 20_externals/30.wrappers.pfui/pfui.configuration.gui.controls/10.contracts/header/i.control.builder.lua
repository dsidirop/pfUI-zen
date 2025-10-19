--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local IPfuiHeaderControlBuilder = using "[declare] [interface] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.Header.IPfuiHeaderControlBuilder" {
    "IPfuiGuiBaseControlBuilder", using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.BaseBuilder.IPfuiGuiBaseControlBuilder",
}

-- inherits everything it needs from IPfuiGuiBaseControlBuilder really
