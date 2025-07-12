--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local PfuiGui = using "[built-in]" "pfUI.gui"

using "[declare] [bind]" "Pavilion.Warcraft.Addons.Bindings.Pfui.PfuiGui" (PfuiGui) -- todo   turn this kind of stuff into class-based services that conform to interfaces
