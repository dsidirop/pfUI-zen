-- lru cache  with a fixed maximum size    when the cache is full it discards the least recently used items first
--
-- inspired by https://github.com/kenshinx/Lua-LRU-Cache

local _assert, _type, _error, _time, _gsub, _format, _strmatch, _setfenv, _tableSort, _namespacer, _tableInsert, _setmetatable = (function()
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
    local _setmetatable = _assert(_g.setmetatable)

    return _assert, _type, _error, _time, _gsub, _format, _strmatch, _setfenv, _tableSort, _namespacer, _tableInsert, _setmetatable
end)()

_setfenv(1, {})

local Class = _namespacer("Pavilion.DataStructures.LRUCache")

--@options.maxSize default 10 items - if set to nil there is no upper limit
--@options.trimRatio default 0.25 of maximum size - cannot be nil
--@options.maxLifespanPerEntryInSeconds default 5 minutes - if set to nil entries never expire
function Class:New(options)
    _setfenv(1, self)

    _assert(options == nil or _type(options) == "table", "options must be a table or nil")

    options = options or {
        maxSize = 100,
        trimRatio = 0.25,
        maxLifespanPerEntryInSeconds = 5 * 60,
    }

    _assert(_type(options.maxSize) == nil or _type(options.maxSize) == "number" and options.maxSize > 0, "maxSize must either be nil or a positive number")
    _assert(_type(options.trimRatio) == "number" and (options.trimRatio >= 0 and options.trimRatio <= 1), "trimRatio must between 0 and 1")
    _assert(_type(options.maxLifespanPerEntryInSeconds) == nil or _type(options.maxLifespanPerEntryInSeconds) == "number" and options.maxLifespanPerEntryInSeconds > 0, "maxLifespanPerEntryInSeconds must either be nil or a positive number")

    local instance = {
        _values = {},
        _deadlines = {}, -- todo  these three tables could be merged into one with a composite structure ala { value, deadline, mostRecentAccessTimestamp } 
        _mostRecentAccessTimestamps = {},

        _timestampOfLastDeadlinesCleanup = -1,

        _maxSize = options.maxSize,
        _trimRatio = options.trimRatio,
        _maxLifespanPerEntryInSeconds = options.maxLifespanPerEntryInSeconds,
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class:Clear()
    _setfenv(1, self)

    _cache = {}
    _deadlines = {}
    _mostRecentAccessTimestamps = {}
end

function Class:Get(key)
    _setfenv(1, self)

    _assert(key ~= nil, "key cannot be nil")

    self:Cleanup_()
    if _cache[key] == nil then
        return nil
    end

    _mostRecentAccessTimestamps[key] = _time()
    return _cache[key]
end

function Class:GetKeys()
    _setfenv(1, self)

    local now = time()

    self:Cleanup_()

    local keys = {}
    for key in _pairs(_cache) do
        _tableInsert(keys, key)

        _mostRecentAccessTimestamps[key] = now
    end

    return keys
end

function Class:GetValues()
    _setfenv(1, self)

    local now = time()

    self:Cleanup_()

    local values = {}
    for _, value in _pairs(_cache) do
        _tableInsert(values, value)

        _mostRecentAccessTimestamps[key] = now
    end

    return values
end

-- insert or update if the key already exists
function Class:Upsert(key, valueOptional)
    _setfenv(1, self)

    _assert(key ~= nil, "key cannot be nil")

    valueOptional = valueOptional or true --00 

    local t = _time()
    _cache[key] = valueOptional
    _deadlines[key] = t + _maxLifespanPerEntryInSeconds
    _mostRecentAccessTimestamps[key] = t

    self:Cleanup_()

    -- 00  we allow values to be optional but we transform nil values to 'true' because if we
    --     leave it to nil it will cause the tables involved to remove the key altogether
end

function Class:Remove(key)
    _setfenv(1, self)

    _assert(key ~= nil, "key cannot be nil")

    _cache[key] = nil
    _deadlines[key] = nil
    _mostRecentAccessTimestamps[key] = nil
end

function Class:ToString()
    _setfenv(1, self)

    return self:__tostring()
end

-- private space

function Class:Cleanup_()
    _setfenv(1, self)

    if _maxLifespanPerEntryInSeconds ~= nil then
        -- remove expired entries
        local now = _time()
        if now - _timestampOfLastDeadlinesCleanup >= 1 then
            _timestampOfLastDeadlinesCleanup = now
            for key, deadline in _pairs(_deadlines) do
                if now >= deadline then
                    self:Remove(key)
                end
            end
        end
    end

    if _maxSize ~= nil then
        -- remove least recently used entries
        local currentLength = self:__len()
        if currentLength <= _maxSize then
            return
        end

        local sortedArray = self:Sort_(_mostRecentAccessTimestamps)

        local desiredEventualSize = _maxSize * (1 - _trimRatio)
        local numberOfItemsToDelete = currentLength - desiredEventualSize
        for i = 1, numberOfItemsToDelete, 1
        do
            self:Remove(sortedArray[i].key)
        end
    end
end

-- private space
function Class:Sort_(t)
    _setfenv(1, self)

    local array = {}
    for key, value in _pairs(t) do
        _tableInsert(array, { key = key, access = value })
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
    for key in _pairs(_cache) do
        s = s .. sep .. key
        sep = ","
    end

    return s .. "}"
end

function Class:__len()
    _setfenv(1, self)

    local count = 0
    for _ in _pairs(_cache) do
        count = count + 1
    end

    return count
end

