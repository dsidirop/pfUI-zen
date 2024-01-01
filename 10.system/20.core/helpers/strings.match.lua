local _strsub, _setfenv, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _strsub = _assert(_g.string.sub)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _strsub, _setfenv, _importer, _namespacer
end)()

_setfenv(1, {})

local Guard = _importer("System.Guard")
local Scopify = _importer("System.Scopify")
local EScopes = _importer("System.EScopes")

local TablesHelper = _importer("System.Helpers.Tables")
local ArraysHelper = _importer("System.Helpers.Arrays")

local StringsHelper = _namespacer("System.Helpers.Strings [Partial]")

function StringsHelper.Match(input, patternString, ...)
    local variadicsArray = arg
    
    Scopify(EScopes.Function, StringsHelper)
    
    Guard.Assert.IsString(input, "input")
    Guard.Assert.IsString(patternString, "patternString")

    if patternString == "" then
        return nil
    end

    local results = {StringsHelper.Find(input, patternString, TablesHelper.Unpack(variadicsArray))}
    
    local startIndex = results[1]
    if startIndex == nil then
        -- no match
        return nil
    end

    local match01 = results[3]
    if match01 == nil then
        local endIndex = results[2]
        return _strsub(input, startIndex, endIndex) -- matched but without using captures   ("Foo 11 bar   ping pong"):match("Foo %d+ bar")
    end

    ArraysHelper.PopFirst(results)
    ArraysHelper.PopFirst(results)
    return TablesHelper.Unpack(results) -- matched with captures  ("Foo 11 bar   ping pong"):match("Foo (%d+) bar")
end
