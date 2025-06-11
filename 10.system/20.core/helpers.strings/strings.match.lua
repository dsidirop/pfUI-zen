local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local A = using "System.Helpers.Arrays"

local StringsHelper = using "[declare] [static]" "System.Helpers.Strings [Partial]"

function StringsHelper.Match(input, patternString, ...)
    local variadicsArray = arg

    Scopify(EScopes.Function, StringsHelper)

    Guard.Assert.IsString(input, "input")
    Guard.Assert.IsString(patternString, "patternString")

    if patternString == "" then
        return nil
    end

    local results = { StringsHelper.Find(input, patternString, A.Unpack(variadicsArray)) }

    local startIndex = results[1]
    if startIndex == nil then
        -- no match
        return nil
    end

    local match01 = results[3]
    if match01 == nil then
        local endIndex = results[2]
        return StringsHelper.SubstringViaRange(input, startIndex, endIndex) -- matched but without using captures   ("Foo 11 bar   ping pong"):match("Foo %d+ bar")
    end

    return A.UnpackRange(results, 3) -- matched with captures  ("Foo 11 bar   ping pong"):match("Foo (%d+) bar")
end
