--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Guard = using "System.Guard"

local StringsHelper = using "[declare] [static]" "System.Helpers.Strings [Partial]"

function StringsHelper.Trim(input)
    Scopify(EScopes.Function, StringsHelper)

    Guard.Assert.IsString(input, "input")
    
    if input == "" then
        return input
    end
    
    return StringsHelper.Match(input, "^()%s*$")
            and ""
            or StringsHelper.Match(input, "^%s*(.*%S)")
end
