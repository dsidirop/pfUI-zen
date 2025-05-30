local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Reflection = using "System.Reflection"

local StringsHelper = using "System.Helpers.Strings"

local Utilities = using "[declare] [static]" "System.Guard.Utilities [Partial]"

Scopify(EScopes.Function, {})

function Utilities.IsBooleanizable(value)
    Scopify(EScopes.Function, Utilities)
    
    return Reflection.IsBoolean(value)
            or Reflection.IsInteger(value)
            or Utilities.IsBooleanizableString(value)
end

function Utilities.IsBooleanizableString(value)
    Scopify(EScopes.Function, Utilities)
    
    if not Reflection.IsString(value) then
        return false
    end

    value = StringsHelper.ToUppercase(value)

    return     value == "1" --          @formatter:off
            or value == "Y"
            or value == "T"
            or value == "YES"
            or value == "TRUE"

            or value == "0"
            or value == "F"
            or value == "N"
            or value == "NO"
            or value == "FALSE" --      @formatter:on
end

function Utilities.IsStringOfMaxLength(value, maxLength)
    Scopify(EScopes.Function, Utilities)
    
    return StringsHelper.Length(value) <= maxLength
end
