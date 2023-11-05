if string.format then
    return -- already loaded
end

local _format = format -- vanilla-wow-lua does have format on the global scope so we can use it here
if not _format then
    error("format() is not present at the global scope", 1)
end

function string:format(formatString, ...)
    return _format(self, formatString, unpack(arg))
end
