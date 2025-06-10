local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local DefaultChatFrame = using "[built-in]" "DEFAULT_CHAT_FRAME"

local WoWUIGlobalFrames = using "[declare] [static]" "System.Externals.WoW.UI.GlobalFrames"

WoWUIGlobalFrames.DefaultChatFrame = DefaultChatFrame
