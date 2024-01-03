local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local TablesHelper = using "System.Helpers.Tables"
local StringsHelper = using "System.Helpers.Strings"

local Validation = using "[declare]" "System.Validation [Partial]"

Validation.Assert = using "[global]" "assert"
Validation.Debugstack = using "[global]" "debugstack"

function Validation.Stacktrace(optionalExtraStackframesToSkipping)
    optionalExtraStackframesToSkipping = optionalExtraStackframesToSkipping or 0

    return Validation.Debugstack(2 + optionalExtraStackframesToSkipping)
end

function Validation.FailFormatted(...)
    Validation.Fail(StringsHelper.Format(TablesHelper.Unpack(arg)))
end

function Validation.Fail(messageOrExceptionInstance)
    Validation.Assert(false, StringsHelper.Stringify(messageOrExceptionInstance) .. "\n" .. Validation.Debugstack(2))
end
