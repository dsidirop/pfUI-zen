--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard  = using "System.Guard"
local Fields = using "System.Classes.Fields"

local FrameX = using "Pavilion.Warcraft.Foundation.UI.Frames.FrameX"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.Header.PfuiHeaderControl" { --[[@formatter:on]]
    "FrameX", FrameX,
}

function Class:New(nativeFrame)
    Scopify(EScopes.Constructor, self)

    Guard.Assert.IsMereFrame(nativeFrame, "nativeFrame")

    local newInstance = self:Instantiate()
    
    newInstance = newInstance.asBase.FrameX.New(newInstance, nativeFrame)

    return newInstance
end
