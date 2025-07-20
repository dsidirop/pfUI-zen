--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local PfuiGui = using "[built-in]" "pfUI.gui"

using "[declare] [bind]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.RawBindings.PfuiGui" (PfuiGui)
