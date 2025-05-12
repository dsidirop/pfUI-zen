local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[   StringFormat = string.format   ]]

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local A = using "System.Helpers.Arrays"

local StringsHelper = using "[declare] [static]" "System.Helpers.Strings [Partial]"

function StringsHelper.Format(format, ...)
    Scopify(EScopes.Function, StringsHelper)

    local variadiacsArray = arg
    Guard.Assert.IsString(format, "format")
    Guard.Assert.IsNonEmptyTable(variadiacsArray, "variadiacsArray")

    local argCount = A.Count(variadiacsArray)
    if argCount == 0 then
        return format
    end
    
    if argCount == 1 then
        return B.StringFormat(format, StringsHelper.Stringify(variadiacsArray[1]))
    end

    if argCount == 2 then
        return B.StringFormat(format, StringsHelper.Stringify(variadiacsArray[1]), StringsHelper.Stringify(variadiacsArray[2]))
    end

    if argCount == 3 then
        return B.StringFormat(format, StringsHelper.Stringify(variadiacsArray[1]), StringsHelper.Stringify(variadiacsArray[2]), StringsHelper.Stringify(variadiacsArray[3]))
    end

    if argCount == 4 then
        return B.StringFormat(format, StringsHelper.Stringify(variadiacsArray[1]), StringsHelper.Stringify(variadiacsArray[2]), StringsHelper.Stringify(variadiacsArray[3]), StringsHelper.Stringify(variadiacsArray[4]))
    end

    if argCount == 5 then
        return B.StringFormat(format, StringsHelper.Stringify(variadiacsArray[1]), StringsHelper.Stringify(variadiacsArray[2]), StringsHelper.Stringify(variadiacsArray[3]), StringsHelper.Stringify(variadiacsArray[4]), StringsHelper.Stringify(variadiacsArray[5]))
    end

    if argCount == 6 then
        return B.StringFormat(format, StringsHelper.Stringify(variadiacsArray[1]), StringsHelper.Stringify(variadiacsArray[2]), StringsHelper.Stringify(variadiacsArray[3]), StringsHelper.Stringify(variadiacsArray[4]), StringsHelper.Stringify(variadiacsArray[5]), StringsHelper.Stringify(variadiacsArray[6]))
    end

    if argCount == 7 then
        return B.StringFormat(format, StringsHelper.Stringify(variadiacsArray[1]), StringsHelper.Stringify(variadiacsArray[2]), StringsHelper.Stringify(variadiacsArray[3]), StringsHelper.Stringify(variadiacsArray[4]), StringsHelper.Stringify(variadiacsArray[5]), StringsHelper.Stringify(variadiacsArray[6]), StringsHelper.Stringify(variadiacsArray[7]))
    end

    if argCount == 8 then
        return B.StringFormat(format, StringsHelper.Stringify(variadiacsArray[1]), StringsHelper.Stringify(variadiacsArray[2]), StringsHelper.Stringify(variadiacsArray[3]), StringsHelper.Stringify(variadiacsArray[4]), StringsHelper.Stringify(variadiacsArray[5]), StringsHelper.Stringify(variadiacsArray[6]), StringsHelper.Stringify(variadiacsArray[7]), StringsHelper.Stringify(variadiacsArray[8]))
    end

    if argCount == 9 then
        return B.StringFormat(format, StringsHelper.Stringify(variadiacsArray[1]), StringsHelper.Stringify(variadiacsArray[2]), StringsHelper.Stringify(variadiacsArray[3]), StringsHelper.Stringify(variadiacsArray[4]), StringsHelper.Stringify(variadiacsArray[5]), StringsHelper.Stringify(variadiacsArray[6]), StringsHelper.Stringify(variadiacsArray[7]), StringsHelper.Stringify(variadiacsArray[8]), StringsHelper.Stringify(variadiacsArray[9]))
    end

    if argCount == 10 then
        return B.StringFormat(format, StringsHelper.Stringify(variadiacsArray[1]), StringsHelper.Stringify(variadiacsArray[2]), StringsHelper.Stringify(variadiacsArray[3]), StringsHelper.Stringify(variadiacsArray[4]), StringsHelper.Stringify(variadiacsArray[5]), StringsHelper.Stringify(variadiacsArray[6]), StringsHelper.Stringify(variadiacsArray[7]), StringsHelper.Stringify(variadiacsArray[8]), StringsHelper.Stringify(variadiacsArray[9]), StringsHelper.Stringify(variadiacsArray[10]))
    end

    local stringifiedArgs = {}
    for i = 1, argCount do
        stringifiedArgs[i] = StringsHelper.Stringify(variadiacsArray[i])
    end
    
    return B.StringFormat(format, A.Unpack(stringifiedArgs))
end
