local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard = using "System.Guard"
local Global = using "System.Global"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Validation = using "System.Validation"

local StringsHelper = using "[declare]" "System.Helpers.Strings [Partial]"

local NativeSubstringViaRange = Validation.Assert(Global.string.sub)

function StringsHelper.SubstringViaRange(input, startIndex, optionalEndingIndexInclusive)
    Scopify(EScopes.Function, StringsHelper)

    Guard.Assert.IsString(input, "input")
    Guard.Assert.IsPositiveInteger(startIndex, "startIndex")
    Guard.Assert.IsNilOrPositiveInteger(optionalEndingIndexInclusive, "optionalEndingIndexInclusive")
    -- Guard.Assert.IsGreaterOrEqualToOptional(startIndex, optionalEndingIndex, "startIndex", "optionalEndingIndexInclusive") --dont   start > end is legit

    if input == "" then
        return ""
    end

    return NativeSubstringViaRange(input, startIndex, optionalEndingIndexInclusive)
end
