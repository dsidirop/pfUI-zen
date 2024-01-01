local _unpack, _strsub, _strfind, _setfenv, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _unpack = _assert(_g.unpack)
    local _strsub = _assert(_g.string.sub)
    local _strfind = _assert(_g.string.find)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _unpack, _strsub, _strfind, _setfenv, _importer, _namespacer
end)()

_setfenv(1, {})

local Guard = _importer("System.Guard")
local Scopify = _importer("System.Scopify")
local EScopes = _importer("System.EScopes")

local StringsHelper = _namespacer("System.Helpers.Strings [Partial]")

function StringsHelper.Match(input, patternString, ...)
    local variadicsArray = arg
    
    Scopify(EScopes.Function, StringsHelper)
    
    Guard.Assert.IsString(input, "input")
    Guard.Assert.IsString(patternString, "patternString")

    if patternString == "" then
        -- todo  test out these corner cases
        return nil
    end

    local startIndex, endIndex,
    match01,
    match02,
    match03,
    match04,
    match05,
    match06,
    match07,
    match08,
    match09,
    match10,
    match11,
    match12,
    match13,
    match14,
    match15,
    match16,
    match17,
    match18,
    match19,
    match20,
    match21,
    match22,
    match23,
    match24,
    match25 = _strfind(input, patternString, _unpack(variadicsArray))
        
    -- todo   refactor this mechanism to have it rely on    local results = {_strfind(input, patternString, _unpack(arg))}   instead of the above 

    if startIndex == nil then
        -- no match
        return nil
    end

    if match01 == nil then
        -- matched but without using captures   ("Foo 11 bar   ping pong"):match("Foo %d+ bar")
        return _strsub(input, startIndex, endIndex)
    end

    return -- matched with captures  ("Foo 11 bar   ping pong"):match("Foo (%d+) bar")
    match01,
    match02,
    match03,
    match04,
    match05,
    match06,
    match07,
    match08,
    match09,
    match10,
    match11,
    match12,
    match13,
    match14,
    match15,
    match16,
    match17,
    match18,
    match19,
    match20,
    match21,
    match22,
    match23,
    match24,
    match25
end
