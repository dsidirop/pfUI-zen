--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local B = using "[built-ins]" "StringFind = strfind"

local Guard = using "System.Guard"

local A = using "System.Helpers.Arrays"

local StringsHelper = using "[declare] [static]" "System.Helpers.Strings"

function StringsHelper.Find(input, patternString, ...)
    local variadicsArray = arg
    
    Scopify(EScopes.Function, StringsHelper)

    Guard.Assert.IsString(input, "input")
    Guard.Assert.IsString(patternString, "patternString")
    
    return B.StringFind(input, patternString, A.Unpack(variadicsArray))
end
