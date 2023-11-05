-- from lua version 5.2 and above loadstring() got renamed to load() and loadstring() got removed
-- but in wow lua 5.1 loadstring() is present on the global scope but load() is not

if load then
    return -- already loaded
end

local _loadstring = assert(loadstring) -- vanilla wow lua does have loadstring on the global scope so we can use it here

function load(script, ...)
    return _loadstring(script, unpack(arg))
end
