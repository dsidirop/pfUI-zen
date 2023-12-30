local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Global = using "System.Global"
local Binder = using "System.Namespacing.Binder"

-- its preferable to use the binder to register the function itself
-- because if we register it as a class:__Call__() it wont be as performant

Binder("System.Scopify", Global.setfenv) -- no need to assert here   its done internally
Binder("System.EScopes", { EGlobal = 0, EFunction = 1 })
