-- unpack exists in wow-lua but not in standard-lua so we polyfill it for
-- standard-lua so that we can test our wow-libs on standard lua easier 

if unpack then
    return -- already present in wow-lua
end

unpack = assert(table.unpack) -- vanilla wow lua does have unpack at the global scope   but standard lua does not and we have to polyfill it
