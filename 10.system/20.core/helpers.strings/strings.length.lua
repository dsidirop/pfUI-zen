local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local B = using "[built-ins]" [[   StringLength = string.len   ]]

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local StringsHelper = using "[declare] [static]" "System.Helpers.Strings [Partial]"

function StringsHelper.Length(input)
    Scopify(EScopes.Function, StringsHelper)

    Guard.Assert.IsString(input, "input")
    
    return B.StringLength(input)
end
