--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local DefaultChatFrame = using "[built-in]" "DEFAULT_CHAT_FRAME"

local WoWUIGlobalFrames = using "[declare] [static]" "System.Externals.WoW.UI.GlobalFrames"

WoWUIGlobalFrames.DefaultChatFrame = DefaultChatFrame
