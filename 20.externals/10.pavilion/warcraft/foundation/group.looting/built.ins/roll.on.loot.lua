--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local WowNativeRollOnLoot = using "[built-in]" [[  RollOnLoot  ]]

using "[declare] [bind]" "Pavilion.Warcraft.GroupLooting.BuiltIns.RollOnLoot" (WowNativeRollOnLoot)
