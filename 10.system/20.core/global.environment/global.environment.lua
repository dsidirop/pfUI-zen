local globalEnvironment = assert(_G or getfenv(0))
local using = assert(globalEnvironment.pvl_namespacer_get)

local Binder = using "System.Namespacing.Binder"

Binder("System.Global", globalEnvironment)
