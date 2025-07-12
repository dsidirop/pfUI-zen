--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local PfuiConfiguration = using "[built-in]" [[  pfUI.env.C  ]]

using "[declare] [bind]" "Pavilion.Warcraft.Addons.Pfui.Native.PfuiConfiguration" (PfuiConfiguration)
