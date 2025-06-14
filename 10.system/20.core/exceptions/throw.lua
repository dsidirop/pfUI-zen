local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local B = using "[built-ins]" [[
    Assert     = assert,
    DebugStack = debugstack,
]]

local S = using "System.Helpers.Strings"

local Guard = using "System.Guard"
local Exception = using "System.Exceptions.Exception"

local Throw = using "[declare] [static]" "System.Exceptions.Throw"

function Throw:__Call__(exception)
    Guard.Assert.Explained.IsInstanceOf(exception, Exception, "[THR.CLL.010]", "exception")

    if exception ~= nil and exception.ChainSetStacktrace ~= nil then
        exception:ChainSetStacktrace(B.DebugStack(3))
    end

    B.Assert(false, S.Stringify(exception or "<the exception is dud!?>")) -- 00   dont use validation.fail() here!

    -- 00  notice that we intentionally use assert() instead of error() under the hood here primarily because pfui and other libraries override the
    --     vanilla error() function to make it not throw an exception-error opting to simply print a message to the chat frame  this ofcourse is bad
    --     practice but we have to live with this shortcoming   so we use assert() instead which is typically not overriden
end
