local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local G = using "System.Global"
local Binder = using "System.Namespacing.Binder"

Binder("System.Scopify", G.setfenv)
Binder("System.EScopes", { EGlobal = 0, EFunction = 1 })
