local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Global = using "System.Global"
local Validation = using "System.Validation"

local Math = using "[declare]" "System.Math [Partial]"

Math.Floor = Validation.Assert((Global.math or {}).floor)
