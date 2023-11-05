-- from lua version 5.2 and above loadstring() got renamed to load() and loadstring() got removed
-- but in wow lua 5.1 loadstring() is present on the global scope but load() is not

if load then
    return -- already loaded
end

local _loadstring = loadstring -- vanilla wow lua does have loadstring on the global scope so we can use it here
if not _loadstring then
    error("loadstring() is not present at the global scope", 1)
end

function load(script, ...)
    return _loadstring(script, unpack(arg))
end
