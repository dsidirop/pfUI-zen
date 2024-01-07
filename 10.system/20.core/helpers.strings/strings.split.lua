local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[   StringSubstitute = string.gsub   ]]

local Table = using "System.Table"
local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local StringsHelper = using "[declare]" "System.Helpers.Strings [Partial]"

function StringsHelper.Split(input, optionalDelimiter, optionalMaxChunksCount)
    Scopify(EScopes.Function, StringsHelper)
    
    Guard.Assert.IsString(input, "input")
    Guard.Assert.IsNilOrString(optionalDelimiter, "optionalDelimiter")
    Guard.Assert.IsNilOrPositiveIntegerOrZero(optionalMaxChunksCount, "optionalMaxChunksCount")
    
    if input == "" then
        return {}
    end

    local pattern = "([^" .. (optionalDelimiter or ",") .. "]+)"

    local fields = {}
    B.StringSubstitute(
            input,
            pattern,
            function(c)
                Table.Insert(fields, c)
            end,
            optionalMaxChunksCount
    )

    return fields
end
