local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Debug = using "System.Debug"
local GlobalEnvironment = using "System.Global"

local Class = using "[declare]" "System.Time [Partial]"

local _time = Debug.Assert(GlobalEnvironment.time)

function Class.Now()
    return _time()
end
