--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local B = using "[built-ins]" [[   StringLength = string.len   ]]

local Guard = using "System.Guard"

local StringsHelper = using "[declare] [static]" "System.Helpers.Strings [Partial]"

function StringsHelper.Length(input)
    Scopify(EScopes.Function, StringsHelper)

    Guard.Assert.IsString(input, "input")
    
    return B.StringLength(input)
end
