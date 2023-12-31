local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Global = using "System.Global"

local Validation = using "[declare]" "System.Validation [Partial]"

Validation.Assert = Global.assert or assert --order

local _debugstack = Validation.Assert(Global.debugstack or debugstack, "Global.debugstack is not available (how is this even possible?)") --order

function Validation.Stacktrace(optionalExtraStackframesToSkipping)
    optionalExtraStackframesToSkipping = optionalExtraStackframesToSkipping or 0

    return _debugstack(2 + optionalExtraStackframesToSkipping)
end
