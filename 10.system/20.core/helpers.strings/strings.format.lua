--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local B = using "[built-ins]" [[   StringFormat = string.format   ]]

local Guard = using "System.Guard"

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

    local stringifySnapshot = StringsHelper.Stringify
    
    if argCount == 1 then
        return B.StringFormat(format, stringifySnapshot(variadiacsArray[1]))
    end

    if argCount == 2 then
        return B.StringFormat(format, stringifySnapshot(variadiacsArray[1]), stringifySnapshot(variadiacsArray[2]))
    end

    if argCount == 3 then
        return B.StringFormat(format, stringifySnapshot(variadiacsArray[1]), stringifySnapshot(variadiacsArray[2]), stringifySnapshot(variadiacsArray[3]))
    end

    if argCount == 4 then
        return B.StringFormat(format, stringifySnapshot(variadiacsArray[1]), stringifySnapshot(variadiacsArray[2]), stringifySnapshot(variadiacsArray[3]), stringifySnapshot(variadiacsArray[4]))
    end

    if argCount == 5 then
        return B.StringFormat(format, stringifySnapshot(variadiacsArray[1]), stringifySnapshot(variadiacsArray[2]), stringifySnapshot(variadiacsArray[3]), stringifySnapshot(variadiacsArray[4]), stringifySnapshot(variadiacsArray[5]))
    end

    if argCount == 6 then
        return B.StringFormat(format, stringifySnapshot(variadiacsArray[1]), stringifySnapshot(variadiacsArray[2]), stringifySnapshot(variadiacsArray[3]), stringifySnapshot(variadiacsArray[4]), stringifySnapshot(variadiacsArray[5]), stringifySnapshot(variadiacsArray[6]))
    end

    if argCount == 7 then
        return B.StringFormat(format, stringifySnapshot(variadiacsArray[1]), stringifySnapshot(variadiacsArray[2]), stringifySnapshot(variadiacsArray[3]), stringifySnapshot(variadiacsArray[4]), stringifySnapshot(variadiacsArray[5]), stringifySnapshot(variadiacsArray[6]), stringifySnapshot(variadiacsArray[7]))
    end

    if argCount == 8 then
        return B.StringFormat(format, stringifySnapshot(variadiacsArray[1]), stringifySnapshot(variadiacsArray[2]), stringifySnapshot(variadiacsArray[3]), stringifySnapshot(variadiacsArray[4]), stringifySnapshot(variadiacsArray[5]), stringifySnapshot(variadiacsArray[6]), stringifySnapshot(variadiacsArray[7]), stringifySnapshot(variadiacsArray[8]))
    end

    if argCount == 9 then
        return B.StringFormat(format, stringifySnapshot(variadiacsArray[1]), stringifySnapshot(variadiacsArray[2]), stringifySnapshot(variadiacsArray[3]), stringifySnapshot(variadiacsArray[4]), stringifySnapshot(variadiacsArray[5]), stringifySnapshot(variadiacsArray[6]), stringifySnapshot(variadiacsArray[7]), stringifySnapshot(variadiacsArray[8]), stringifySnapshot(variadiacsArray[9]))
    end

    if argCount == 10 then
        return B.StringFormat(format, stringifySnapshot(variadiacsArray[1]), stringifySnapshot(variadiacsArray[2]), stringifySnapshot(variadiacsArray[3]), stringifySnapshot(variadiacsArray[4]), stringifySnapshot(variadiacsArray[5]), stringifySnapshot(variadiacsArray[6]), stringifySnapshot(variadiacsArray[7]), stringifySnapshot(variadiacsArray[8]), stringifySnapshot(variadiacsArray[9]), stringifySnapshot(variadiacsArray[10]))
    end

    local stringifiedArgs = {}
    for i = 1, argCount do
        stringifiedArgs[i] = stringifySnapshot(variadiacsArray[i])
    end
    
    return B.StringFormat(format, A.Unpack(stringifiedArgs))
end
