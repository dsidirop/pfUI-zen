local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" "StringFind = strfind"

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local A = using "System.Helpers.Arrays"

local StringsHelper = using "[declare] [static]" "System.Helpers.Strings"

function StringsHelper.Find(input, patternString, ...)
    local variadicsArray = arg
    
    Scopify(EScopes.Function, StringsHelper)

    Guard.Assert.IsString(input, "input")
    Guard.Assert.IsString(patternString, "patternString")
    
    return B.StringFind(input, patternString, A.Unpack(variadicsArray))
end
