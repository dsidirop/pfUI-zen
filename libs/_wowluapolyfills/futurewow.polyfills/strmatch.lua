if strmatch then
    return -- already loaded and patched
end

if not string.match then
    error("string.match() is not present at the global scope", 1)
end

function strmatch(input, patternString, ...)
    return input:match(patternString, unpack(arg))
end
