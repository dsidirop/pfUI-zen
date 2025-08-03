--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local B        = using "System.Helpers.Booleans"
local Guard    = using "System.Guard"
local Fields   = using "System.Classes.Fields"

local IFrameX = using "Pavilion.Warcraft.Foundation.UI.Frames.Contracts.IFrameX"

local IPfuiGuiBaseControlBuilder = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.BaseBuilder.IPfuiGuiBaseControlBuilder"

-- [abstract] 
local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.BaseBuilder.PfuiGuiBaseControlBuilder" { --[[@formatter:on]]
    "IPfuiGuiBaseControlBuilder", IPfuiGuiBaseControlBuilder,
}


Fields(function(upcomingInstance)
    upcomingInstance._caption = ""

    upcomingInstance._height          = nil
    upcomingInstance._xposNudging     = 0
    upcomingInstance._yposNudging     = 0
    upcomingInstance._visibleOrHidden = true

    return upcomingInstance
end)


function Class:ChainSet_Caption(caption)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(caption, "caption")

    _caption = caption

    return self
end


function Class:ChainSet_Height(height)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNumber(height, "height")

    _height = height

    return self
end

function Class:ChainApply_NudgingX(xposNudging) -- +/-px horizontally from the default position
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNumber(xposNudging, "xposNudging")

    _xposNudging = xposNudging

    return self
end

function Class:ChainApply_NudgingY(yposNudging) -- +/-px vertically from the default position
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNumber(yposNudging, "yposNudging")

    _yposNudging = yposNudging

    return self
end

function Class:ChainSet_Visibility(visibleOrHidden)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBooleanizable(visibleOrHidden, "visibleOrHidden")

    _visibleOrHidden = B.Booleanize(visibleOrHidden)

    return self
end

function Class:Build()
    Scopify(EScopes.Function, self)
    
    local frxControl = self:BuildImpl()
    
    Guard.Assert.IsInstanceImplementing(frxControl, IFrameX, "frxControl")
    
    if _height ~= nil then
        frxControl:ChainSet_Height(_height)
    end

    return frxControl -- :ChainSet_Caption(_caption) the caption is set via :BuildImpl()
        :ChainSet_Visibility(_visibleOrHidden)
        :ChainApply_NudgingXY(_xposNudging, _yposNudging)
end

using "[abstract]"
function Class:BuildImpl()
end
