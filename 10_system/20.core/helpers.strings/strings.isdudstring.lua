--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Guard = using "System.Guard"

local StringsHelper = using "[declare] [static]" "System.Helpers.Strings [Partial]"

function StringsHelper.IsDudString(value)
    Scopify(EScopes.Function, StringsHelper)
    
    Guard.Assert.IsNilOrString(value, "value")
    
    if value == nil then
        return true
    end
    
    local startIndex = StringsHelper.Find(value, "^()%s*$")
    
    return startIndex ~= nil
end
