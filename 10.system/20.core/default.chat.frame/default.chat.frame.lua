local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Global = using "System.Global"
local Validation = using "System.Validation"

local WoWUIGlobalFrames = using "[declare]" "System.Externals.WoW.UI.GlobalFrames [Partial]"

WoWUIGlobalFrames.DefaultChatFrame = Validation.Assert(Global.DEFAULT_CHAT_FRAME)
