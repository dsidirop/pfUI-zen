local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Scopify    = using "System.Scopify" --           @formatter:off
local EScopes    = using "System.EScopes"
local Reflection = using "System.Reflection" --        @formatter:on

local Utilities = using "[declare]" "System.Exceptions.Utilities [Partial]"

function Utilities.FormulateFullExceptionMessage(exception)
    Scopify(EScopes.Function, Utilities)

    return "[" .. (Reflection.TryGetNamespaceIfClassInstance(exception) or "(unknown exception - how!?)") .. "] " .. (exception:GetMessage() or "(exception message not available)")
            .. "\n\n--------------[ Stacktrace ]--------------\n"
            .. (exception:GetStacktrace() or "(stacktrace not available)")
            .. "------------[ End Stacktrace ]------------\n "
end
