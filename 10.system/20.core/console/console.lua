local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]) -- @formatter:off

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local GenericTextWriter = using "System.IO.GenericTextWriter"
local WoWUIGlobalFrames = using "System.Externals.WoW.UI.GlobalFrames"

local Console = using "[declare] [static]" "System.Console" -- @formatter:on

Scopify(EScopes.Function, {})

local function SpawnOptimalWriteCallback(chatFrame, standardPrefix)
    local chatFrameAddMessage = chatFrame.AddMessage
    return function(message_)
        return chatFrameAddMessage(chatFrame, standardPrefix .. message_) 
    end
end

-- @formatter:off
Console.Out   = GenericTextWriter:New(SpawnOptimalWriteCallback(WoWUIGlobalFrames.DefaultChatFrame, "|cffffff55"))
Console.Error = GenericTextWriter:New(SpawnOptimalWriteCallback(WoWUIGlobalFrames.DefaultChatFrame, "|cffff5555"))
-- @formatter:on
