local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Debug = using "System.Debug"
local GlobalEnvironment = using "System.Global"

local WoWUIGlobalFrames = using "[declare]" "System.Externals.WoW.UI.GlobalFrames [Partial]"

WoWUIGlobalFrames.DefaultChatFrame = Debug.Assert(GlobalEnvironment.DEFAULT_CHAT_FRAME)
