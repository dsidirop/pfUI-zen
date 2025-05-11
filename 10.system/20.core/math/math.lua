local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[ MathFloor = math.floor ]]

local Math = using "[declare]" "System.Math [Partial]"

Math.Floor = B.MathFloor
