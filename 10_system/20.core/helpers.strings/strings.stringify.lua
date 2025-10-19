--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local B = using "[built-ins]" [[   ToString = tostring   ]]

local StringsHelper = using "[declare] [static]" "System.Helpers.Strings [Partial]"

StringsHelper.Stringify = B.ToString
