local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Global = using "System.Global"

local Debug = using "[declare]" "System.Debug [Partial]"

Debug.Assert = Global.assert or assert --order

local _debugstack = Debug.Assert(Global.debugstack or debugstack, "Global.debugstack is not available (how is this even possible?)") --order

function Debug.Stacktrace(optionalExtraStackframesToSkipping)
    optionalExtraStackframesToSkipping = optionalExtraStackframesToSkipping or 0

    return _debugstack(2 + optionalExtraStackframesToSkipping)
end
