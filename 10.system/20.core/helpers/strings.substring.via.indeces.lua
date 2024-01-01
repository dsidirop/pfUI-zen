local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard = using "System.Guard"
local Global = using "System.Global"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Validation = using "System.Validation"

local StringsHelper = using "[declare]" "System.Helpers.Strings [Partial]"

local NativeSubstring = Validation.Assert(Global.string.sub)

function StringsHelper.SubstringViaIndeces(input, startIndex, optionalEndingIndex)
    Scopify(EScopes.Function, StringsHelper)

    Guard.Assert.IsString(input, "input")
    Guard.Assert.IsPositiveInteger(startIndex, "startIndex")
    Guard.Assert.IsNilOrPositiveInteger(optionalEndingIndex, "optionalEndingIndex")
    -- Guard.Assert.IsGreaterOrEqualToOptional(startIndex, optionalEndingIndex, "startIndex", "optionalEndingIndex") --dont   start > end is legit

    if input == "" then
        return ""
    end

    return NativeSubstring(input, startIndex, optionalEndingIndex)
end
