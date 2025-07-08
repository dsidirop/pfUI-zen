--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local WowNativeGetAddOnInfo = using "[built-in]" "GetAddOnInfo"

using "[declare] [bind]" "Pavilion.Warcraft.Foundation.Natives.GetAddonInfo" (WowNativeGetAddOnInfo)
