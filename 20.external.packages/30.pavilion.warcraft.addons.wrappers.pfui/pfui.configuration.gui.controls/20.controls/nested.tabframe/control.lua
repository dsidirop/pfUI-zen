--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard  = using "System.Guard"
local Fields = using "System.Classes.Fields"

local FrameX = using "Pavilion.Warcraft.Foundation.UI.Frames.FrameX"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.NestedTabFrameWithArea.PfuiNestedTabFrameWithAreaControl" { --[[@formatter:on]]
    "FrameX", FrameX,
}

Fields(function(upcomingInstance)
    upcomingInstance._areaSubframe = nil

    return upcomingInstance
end)

function Class:New(nativeFrame)
    Scopify(EScopes.Constructor, self)

    Guard.Assert.Explained.IsMereFrame(nativeFrame, "the creation of the desired nested-tab-frame succeeded but the resulting nativeFrame is not a simple frame as expected")
    Guard.Assert.Explained.IsMereFrame(nativeFrame.area, "the creation of the desired nested-tab-frame succeeded but the resulting nativeFrame.area is not a simple frame as expected")

    local newInstance = self:Instantiate()
    
    newInstance = newInstance.asBase.FrameX.New(newInstance, nativeFrame)
    
    newInstance._areaSubframe = FrameX:New(nativeFrame.area)

    return newInstance
end

function Class:GetArea()
    Scopify(EScopes.Function, self)

    return _areaSubframe
end
