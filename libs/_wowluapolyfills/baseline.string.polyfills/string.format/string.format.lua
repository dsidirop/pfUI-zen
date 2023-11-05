-- todo   for some reason even though this polyfill loads it doesnt really work in wow-lua because when we use it we get an index error
-- todo   need to figure out exactly why this happens
-- todo
-- todo   https://stackoverflow.com/questions/77426782/adding-an-additional-method-to-luas-string-works-in-official-lua-but-it-doesnt

if string.format then
    -- todo   need to find a better way to test whether string:format() exists as a method (not as a function)
    return -- already loaded
end

local _stringFormat = assert(format or string.format) -- vanilla-wow-lua does have format on the global scope so we can use it here
local _getmetatable = assert(getmetatable)
local _setmetatable = assert(setmetatable)

local _stringMetatable = _getmetatable(string)
if not _stringMetatable then
    _stringMetatable = { __index = {} } -- standard-lua returns a metatable but wow-lua returns nil
    _setmetatable(string, _stringMetatable)
end

function _stringMetatable:format(formatString, ...)
    return _stringFormat(self, formatString, unpack(arg))
end

_stringMetatable.__index.format = _stringMetatable.format
