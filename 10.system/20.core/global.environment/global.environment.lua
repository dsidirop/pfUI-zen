local globalEnvironment = assert(_G or getfenv(0))

local using = globalEnvironment.assert(globalEnvironment.pvl_namespacer_get)

local Namespacer = using "System.Namespacer"

Namespacer:Bind("System.Global", globalEnvironment)
