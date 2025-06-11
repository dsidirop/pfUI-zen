local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local B = using "[built-ins]" [[ Time = time ]]

local Class = using "[declare] [static]" "System.Time"

Class.Now = B.Time