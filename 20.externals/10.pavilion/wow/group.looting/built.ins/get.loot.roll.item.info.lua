--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local WowNativeGetLootRollItemInfo = using "[built-in]" [[  GetLootRollItemInfo  ]]

using "[declare] [bind]" "Pavilion.Warcraft.GroupLooting.BuiltIns.GetLootRollItemInfo" (WowNativeGetLootRollItemInfo)
