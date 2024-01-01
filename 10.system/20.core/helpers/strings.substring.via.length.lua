local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard = using "System.Guard"
local Global = using "System.Global"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Validation = using "System.Validation"

local StringsHelper = using "[declare]" "System.Helpers.Strings [Partial]"

local NativeSubstringViaRange = Validation.Assert(Global.string.sub)

function StringsHelper.SubstringViaLength(input, chunkStartIndex, chunkLength)
    Scopify(EScopes.Function, StringsHelper)

    Guard.Assert.IsString(input, "input")
    Guard.Assert.IsPositiveInteger(chunkStartIndex, "chunkStartIndex")
    Guard.Assert.IsPositiveIntegerOrZero(chunkLength, "chunkLength")

    if input == "" then
        return ""
    end

    return NativeSubstringViaRange(input, chunkStartIndex, chunkStartIndex + chunkLength - 1)
end
