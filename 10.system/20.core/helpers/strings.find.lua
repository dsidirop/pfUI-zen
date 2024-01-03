local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Strfind = using "[global]" "strfind"

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local TablesHelper = using "System.Helpers.Tables"

local StringsHelper = using "[declare]" "System.Helpers.Strings [Partial]"

function StringsHelper.Find(input, patternString, ...)
    local variadicsArray = arg
    
    Scopify(EScopes.Function, StringsHelper)

    Guard.Assert.IsString(input, "input")
    Guard.Assert.IsString(patternString, "patternString")
    
    return Strfind(input, patternString, TablesHelper.Unpack(variadicsArray))
end
