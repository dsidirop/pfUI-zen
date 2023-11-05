if string.format then
    return -- already loaded
end

local _format = assert(format) -- vanilla-wow-lua does have format on the global scope so we can use it here

function string:format(formatString, ...)
    return _format(self, formatString, unpack(arg))
end
