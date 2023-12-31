local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Global = using "System.Global"

local TablesHelper = using "System.Helpers.Tables"
local StringsHelper = using "System.Helpers.Strings"

local Validation = using "[declare]" "System.Validation [Partial]"

Validation.Assert = Global.assert or assert --order

local debugstack = Validation.Assert(Global.debugstack or debugstack, "Global.debugstack is not available (how is this even possible?)") --order
function Validation.Stacktrace(optionalExtraStackframesToSkipping)
    optionalExtraStackframesToSkipping = optionalExtraStackframesToSkipping or 0

    return debugstack(2 + optionalExtraStackframesToSkipping)
end

function Validation.FailFormatted(...)
    local variadicsArray = arg
    
    Validation.Fail(StringsHelper.Format(TablesHelper.Unpack(variadicsArray)))
end

function Validation.Fail(messageOrExceptionInstance)
    Validation.Assert(false, StringsHelper.Stringify(messageOrExceptionInstance) .. "\n" .. debugstack(2))
end
