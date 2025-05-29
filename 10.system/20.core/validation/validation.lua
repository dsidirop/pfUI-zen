local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[
    Assert     = assert,
    DebugStack = debugstack,
]]

local A = using "System.Helpers.Arrays"
local S = using "System.Helpers.Strings"

local Validation = using "[declare] [static]" "System.Validation [Partial]"

Validation.Assert = B.Assert
Validation.DebugStack = B.DebugStack

function Validation.FailFormatted(...)
    Validation.Fail(S.Format(A.Unpack(arg)))
end

function Validation.Fail(messageOrExceptionInstance)
    Validation.Assert(false, S.Stringify((messageOrExceptionInstance or "<the provided error is dud!?>")) .. "\n" .. Validation.DebugStack(2))
end
