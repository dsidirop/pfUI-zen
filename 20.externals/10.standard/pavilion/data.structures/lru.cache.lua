-- lru cache  with a fixed maximum size    when the cache is full it discards the least recently used items first
--
-- inspired by https://github.com/kenshinx/Lua-LRU-Cache

local _assert, _type, _error, _time, _gsub, _format, _strmatch, _setfenv, _tableSort, _namespacer, _tableInsert = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _error = _assert(_g.error)

    local _time = _assert(_g.os.time)
    local _gsub = _assert(_g.string.gsub)
    local _format = _assert(_g.string.format)
    local _strmatch = _assert(_g.string.match)
    local _tableSort = _assert(_g.table.sort)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _tableInsert = _assert(_g.table.insert)

    return _assert, _type, _error, _time, _gsub, _format, _strmatch, _setfenv, _tableSort, _namespacer, _tableInsert
end)()

_setfenv(1, {})

local Class = _namespacer("Pavilion.DataStructures.LRUCache")

--@options.maxSize default 10 items - if set to nil there is no upper limit
--@options.trimRatio default 0.25 of maximum size - cannot be nil
--@options.maxLifespanPerEntryInSeconds default 5 minutes - if set to nil entries never expire
function Class:New(options)
    -- { maxLifespanPerEntryInSeconds, maxSize }
    _setfenv(1, self)

    _assert(options == nil or _type(options) == "table", "options must be a table or nil")

    options = options or {
        maxSize = 100,
        trimRatio = 0.25,
        maxLifespanPerEntryInSeconds = 5 * 60,
    }

    _assert(_type(options.maxSize) == nil or _type(options.maxSize) == "number" and options.maxSize > 0, "maxSize must either be nil or a positive number")
    _assert(_type(options.trimRatio) == "number" and (options.maxSize >= 0 and options.maxSize <= 1), "trimRatio must between 0 and 1")
    _assert(_type(options.maxLifespanPerEntryInSeconds) == nil or _type(options.maxLifespanPerEntryInSeconds) == "number" and options.maxLifespanPerEntryInSeconds > 0, "maxLifespanPerEntryInSeconds must either be nil or a positive number")

    local instance = {
        _values = {},
        _deadlines = {},
        _mostRecentAccessTimestamps = {},

        _maxSize = options.maxSize,
        _trimRatio = options.trimRatio,
        _maxLifespanPerEntryInSeconds = options.maxLifespanPerEntryInSeconds,
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class:Get(key)
    _setfenv(1, self)

    _assert(key ~= nil, "key cannot be nil")

    _Cleanup()
    if _values[key] == nil then
        return nil
    end

    _mostRecentAccessTimestamps[key] = _time()
    return _values[key]
end

-- insert or update if the key already exists
function Class:Upsert(key, valueOptional)
    _setfenv(1, self)

    _assert(key ~= nil, "key cannot be nil")

    valueOptional = valueOptional or true --00 

    local t = _time()
    _values[key] = valueOptional
    _deadlines[key] = t + _maxLifespanPerEntryInSeconds
    _mostRecentAccessTimestamps[key] = t

    _Cleanup()

    -- 00  we allow values to be optional but we transform nil values to 'true' because if we
    --     leave it to nil it will cause the tables involved to remove the key altogether
end

function Class:Remove(key)
    _setfenv(1, self)

    _assert(key ~= nil, "key cannot be nil")

    _values[key] = nil
    _deadlines[key] = nil
    _mostRecentAccessTimestamps[key] = nil
end

-- private space

function Class:_Cleanup()
    _setfenv(1, self)

    if _maxLifespanPerEntryInSeconds ~= nil then
        -- remove expired entries
        local t = _time()
        for k, v in _pairs(_deadlines) do
            if v < t then
                Remove(k)
            end
        end
    end

    if _maxSize ~= nil then
        -- remove least recently used entries
        local currentLength = __len()
        if currentLength <= _maxSize then
            return
        end

        local sortedArray = _Sort(_mostRecentAccessTimestamps)

        local desiredEventualSize = _maxSize * (1 - _trimRatio)
        local numberOfItemsToDelete = currentLength - desiredEventualSize
        for i = 1, numberOfItemsToDelete, 1
        do
            Remove(sortedArray[i].key)
        end
    end

end

function Class:_Sort(t)
    _setfenv(1, self)

    local array = {}
    for k, v in _pairs(t) do
        _tableInsert(array, { key = k, access = v })
    end

    _tableSort(array, function(a, b)
        return a.access < b.access
    end)

    return array
end

function Class:__tostring()
    _setfenv(1, self)

    local s = "{"
    local sep = ""
    for k, _ in _pairs(_values) do
        s = s .. sep .. k
        sep = ","
    end

    return s .. "}"
end

function Class:__len()
    _setfenv(1, self)

    local count = 0
    for _ in _pairs(_values) do
        count = count + 1
    end

    return count
end

