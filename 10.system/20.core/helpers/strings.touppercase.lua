local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[    StringToUppercase = string.upper    ]]

local StringsHelper = using "[declare]" "System.Helpers.Strings [Partial]"

StringsHelper.ToUppercase = B.StringToUppercase
