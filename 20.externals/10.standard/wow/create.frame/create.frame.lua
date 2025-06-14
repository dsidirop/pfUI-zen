--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local WowNativeCreateFrameFunc = using "[built-in]" "CreateFrame"

using "[declare] [bind]" "Pavilion.Warcraft.Addons.Zen.Externals.WoW.CreateFrame" (WowNativeCreateFrameFunc)
