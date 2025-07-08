--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local PfuiRoll = using "[built-in]" [[  pfUI.roll  ]]

using "[declare] [bind]" "Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Roll" (PfuiRoll)

