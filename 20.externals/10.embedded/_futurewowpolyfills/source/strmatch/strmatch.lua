if strmatch then
    return -- already loaded and patched
end

local _stringMatch = assert(string.match)

function strmatch(input, patternString, ...)
    return _stringMatch(input, patternString, unpack(arg))
end
