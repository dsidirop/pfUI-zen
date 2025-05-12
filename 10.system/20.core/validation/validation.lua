local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[
    Assert     = assert,
    Bebugstack = debugstack,
]]

local A = using "System.Helpers.Arrays"
local S = using "System.Helpers.Strings"

local Validation = using "[declare] [static]" "System.Validation [Partial]"

Validation.Assert = B.Assert
Validation.Debugstack = B.Bebugstack

function Validation.Stacktrace(optionalExtraStackframesToSkipping)
    optionalExtraStackframesToSkipping = optionalExtraStackframesToSkipping or 0

    return Validation.Debugstack(2 + optionalExtraStackframesToSkipping)
end

function Validation.FailFormatted(...)
    Validation.Fail(S.Format(A.Unpack(arg)))
end

function Validation.Fail(messageOrExceptionInstance)
    Validation.Assert(false, S.Stringify(messageOrExceptionInstance) .. "\n" .. Validation.Debugstack(2))
end
