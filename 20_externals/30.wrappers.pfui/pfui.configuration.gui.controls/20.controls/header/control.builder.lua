--[[@formatter:off]] local _G = assert((_G or getfenv(0) or {})); local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard     = using "System.Guard"
local Fields    = using "System.Classes.Fields"

local PfuiGui                = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.RawBindings.PfuiGui"
local PfuiGuiBaseControlBuilder = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.BaseBuilder.PfuiGuiBaseControlBuilder"

local PfuiHeaderControl          = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.Header.PfuiHeaderControl"
local IPfuiHeaderControlBuilder  = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.Header.IPfuiHeaderControlBuilder"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.Header.PfuiHeaderControlBuilder" { --[[@formatter:on]]
    "PfuiGuiBaseControlBuilder", PfuiGuiBaseControlBuilder,

    "IPfuiHeaderControlBuilder", IPfuiHeaderControlBuilder,
}

Fields(function(upcomingInstance)
    -- upcomingInstance._caption    <- inherited from PfuiGuiBaseControlBuilder
    return upcomingInstance
end)

function Class:BuildImpl()
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNonDudString(_caption, "_caption")

    local rawWowFrame = PfuiGui.CreateConfig(
        nil, -- todo   explore when this 'ufunc' is getting fired   I suspect its when it is shown or first-shown
        _caption,
        nil, -- ignored
        nil, -- ignored
        "header" -- hardcoded
    )

    return PfuiHeaderControl:New(rawWowFrame)
end
