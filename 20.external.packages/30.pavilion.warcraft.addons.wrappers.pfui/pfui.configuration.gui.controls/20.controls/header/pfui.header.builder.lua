--[[@formatter:off]] local _G = assert((_G or getfenv(0) or {})); local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard               = using "System.Guard"
local Fields              = using "System.Classes.Fields"

local PfuiGui             = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.RawBindings.PfuiGui"

local FrameX              = using "Pavilion.Warcraft.Foundation.UI.Frames.FrameX"
local IPfuiHeaderBuilder  = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.Header.IPfuiHeaderBuilder"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.Header.PfuiHeaderBuilder" { --[[@formatter:on]]
    "IPfuiHeaderBuilder", IPfuiHeaderBuilder,
}

Fields(function(upcomingInstance)
    upcomingInstance._caption = nil

    return upcomingInstance
end)

function Class:ChainSet_Caption(caption)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(caption, "caption")

    _caption = caption

    return self
end

function Class:Build()
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNonDudString(_caption, "_caption")

    local rawWowFrame = PfuiGui.CreateConfig(
        nil, -- todo   explore when this 'ufunc' is getting fired   I suspect its when it is shown or first-shown
        _caption,
        nil, -- ignored
        nil, -- ignored
        "header" -- hardcoded
    )

    return FrameX:New(rawWowFrame)
end
