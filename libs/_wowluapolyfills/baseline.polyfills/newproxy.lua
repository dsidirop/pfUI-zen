-- Notes
--
--    - the function newproxy() was added in lua5.1 as a hidden asset only to be removed from lua5.2 because
--      the features added the language made newproxy() obsolete
--
--    - empty userdata were useful for detecting when the lua gc reclaimed objects but that role can be played
--      by zero-sized-tables in lua 5.2+
--
--    - some libraries unfortunately use newproxy() so it has to be poly-filled to cater to their needs
--      this polyfill simulates the behaviour of the original newproxy() with an accuracy of 99.99%
--

if newproxy then
    return -- already loaded
end

function newproxy(newMeta)
    local proxy = {}

    if (newMeta == false) then
        return proxy -- nothing to do
    end

    if (newMeta == true) then
        local mt = {}
        setmetatable(proxy, mt)
        return proxy
    end

    local mt = getmetatable(newMeta) -- new_meta must have a metatable
    setmetatable(proxy, mt)

    return proxy
end
