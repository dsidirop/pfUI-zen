local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Math = using "[declare]" "System.Math [Partial]"

Math.Floor = using "[global]" "math.floor"
