local globalEnvironment = assert(_G or getfenv(0))

local using = globalEnvironment.assert(globalEnvironment["ZENSHARP:USING"])

local Namespacer = using "System.Namespacer"

Namespacer:Bind("System.Global", globalEnvironment)
