local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[ Time = time ]]

local Class = using "[declare]" "System.Time [Partial]"

function Class.Now()
    return B.Time()
end
