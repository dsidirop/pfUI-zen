local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[
    Type       = type,
    Assert     = assert,
    DebugStack = debugstack,
]]

local S = using "System.Helpers.Strings"

local Throw = using "[declare] [static]" "System.Exceptions.Throw [Partial]"


function Throw:__Call__(exception)
    -- todo  make the guard-check explicitly check for exception or a subclass of it
    _ = (B.Type(exception) == "table" or B.Type(exception) == "string") or B.Assert(false, "[THR.CLL.010] Attempt to throw an exception that is neither a table nor a string (type=" .. B.Type(exception) .. ")\n\n" .. B.DebugStack())

    if exception ~= nil and exception.ChainSetStacktrace ~= nil then
        exception:ChainSetStacktrace(B.DebugStack(3))
    end

    B.Assert(false, S.Stringify(exception or "<the exception is dud!?>")) -- 00   dont use validation.fail() here!

    -- 00  notice that we intentionally use assert() instead of error() under the hood here primarily because pfui and other libraries override the
    --     vanilla error() function to make it not throw an exception-error opting to simply print a message to the chat frame  this ofcourse is bad
    --     practice but we have to live with this shortcoming   so we use assert() instead which is typically not overriden
end
