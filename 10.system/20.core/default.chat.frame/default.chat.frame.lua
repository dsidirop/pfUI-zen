local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local WoWUIGlobalFrames = using "[declare]" "System.Externals.WoW.UI.GlobalFrames [Partial]"

WoWUIGlobalFrames.DefaultChatFrame = using "[global]" "DEFAULT_CHAT_FRAME"
