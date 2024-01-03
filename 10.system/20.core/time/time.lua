local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Time = using "[global]" "time"

local Class = using "[declare]" "System.Time [Partial]"

function Class.Now()
    return Time()
end
