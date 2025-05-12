local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[
    NativeSubstringViaRange = string.sub
]]

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local StringsHelper = using "[declare] [static]" "System.Helpers.Strings [Partial]"

function StringsHelper.SubstringViaLength(input, chunkStartIndex, chunkLength)
    Scopify(EScopes.Function, StringsHelper)

    Guard.Assert.IsString(input, "input")
    Guard.Assert.IsPositiveInteger(chunkStartIndex, "chunkStartIndex")
    Guard.Assert.IsPositiveIntegerOrZero(chunkLength, "chunkLength")

    if input == "" then
        return ""
    end

    return B.NativeSubstringViaRange(input, chunkStartIndex, chunkStartIndex + chunkLength - 1)
end
