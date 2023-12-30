local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Debug = using "System.Debug"
local GlobalEnvironment = using "System.Global"

local Type = using "[declare]" "System.Primitives.Types [Partial]"

Type.GetRawType = Debug.Assert(GlobalEnvironment.type)
