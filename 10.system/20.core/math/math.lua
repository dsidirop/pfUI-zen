local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Debug = using "System.Debug"
local GlobalEnvironment = using "System.Global"

local Math = using "[declare]" "System.Math [Partial]"

Math.Floor = Debug.Assert((GlobalEnvironment.math or {}).floor)
