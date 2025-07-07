--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})
local B = using "[built-ins]"    [[
    StringSub    = string.sub,
    StringFind   = string.find,
    StringLength = string.len,
]]

local StringSub    = B.StringSub
local StringFind   = B.StringFind
local StringLength = B.StringLength

local Guard   = using "System.Guard"
local EScopes = using "System.EScopes" -- @formatter:on

local StringsHelper = using "[declare] [static]" "System.Helpers.Strings [Partial]"

function StringsHelper.StartsWith(input, desiredPrefix)
    Scopify(EScopes.Function, StringsHelper)

    Guard.Assert.IsString(input, "input")
    Guard.Assert.IsString(desiredPrefix, "desiredPrefix")

    if desiredPrefix == "" then
        return true
    end

    if input == "" then
        return false
    end

    local desiredPrefixLength = StringLength(desiredPrefix)
    if StringLength(input) < desiredPrefixLength then
        return false
    end

    if input == desiredPrefix then
        return true
    end

    if desiredPrefixLength == 1 then
        -- optimization for 1-char-prefixes because for the runtime those 1-char-prefixes are very efficiently cached via string-interning
        return StringSub(input, 1, 1) == desiredPrefix
    end

    return StringFind(input, desiredPrefix, --[[startindex:]] 1, --[[plainsearch:]] true) == 1
end
