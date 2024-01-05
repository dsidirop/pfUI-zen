local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local StringsHelper = using "[declare]" "System.Helpers.Strings [Partial]"

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
