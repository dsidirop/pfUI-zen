--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Reflection = using "System.Reflection"

local Utilities = using "[declare] [static]" "System.Exceptions.Utilities" --@formatter:on

function Utilities.FormulateFullExceptionMessage(exception)
    Scopify(EScopes.Function, Utilities)

    return "[" .. (Reflection.TryGetNamespaceIfClassInstance(exception) or "(unknown exception - how!?)") .. "] " .. (exception:GetMessage() or "(no exception message available)")
            .. "\n\n--------------[ Stacktrace ]--------------\n"
            .. (exception:GetStacktrace() or "(stacktrace not available)")
            .. "------------[ End Stacktrace ]------------\n "
end
