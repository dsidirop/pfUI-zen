local g = assert(_G or getfenv(0))
local Bind = g.pvl_namespacer_bind
local SetFunctionEnvironment = g.setfenv

Bind("System.EScopes", {
    EGlobal = 0,
    EFunction = 1,
})

Bind("System.Scopify", SetFunctionEnvironment)
