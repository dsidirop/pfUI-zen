local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[
    NativeSubstringViaRange = string.sub
]]

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local StringsHelper = using "[declare]" "System.Helpers.Strings [Partial]"

function StringsHelper.SubstringViaRange(input, startIndex, optionalEndingIndexInclusive)
    Scopify(EScopes.Function, StringsHelper)

    Guard.Assert.IsString(input, "input")
    Guard.Assert.IsPositiveInteger(startIndex, "startIndex")
    Guard.Assert.IsNilOrPositiveInteger(optionalEndingIndexInclusive, "optionalEndingIndexInclusive")
    -- Guard.Assert.IsGreaterOrEqualToOptional(startIndex, optionalEndingIndex, "startIndex", "optionalEndingIndexInclusive") --dont   start > end is legit

    if input == "" then
        return ""
    end

    return B.NativeSubstringViaRange(input, startIndex, optionalEndingIndexInclusive)
end
