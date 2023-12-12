-- lru cache  with a fixed maximum size    when the cache is full it discards the least recently used items first
--
-- inspired by https://github.com/kenshinx/Lua-LRU-Cache

local _assert, _type, _pairs, _format, _tostring, _importer, _setfenv, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _pairs = _assert(_g.pairs)
    local _format = _assert(_g.string.format)
    local _tostring = _assert(_g.tostring)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _assert, _type, _pairs, _format, _tostring, _importer, _setfenv, _namespacer
end)()

_setfenv(1, {})

local Time = _importer("System.Time")
local Math = _importer("System.Math")
local Table = _importer("System.Table")
local Scopify = _importer("System.Scopify")
local EScopes = _importer("System.EScopes")
local Classify = _importer("System.Classify")

local TablesHelper = _importer("Pavilion.Helpers.Tables")

local Class = _namespacer("Pavilion.DataStructures.LRUCache")

Class.DefaultOptions_ = {
    MaxSize = 100,
    TrimRatio = 0.25,
    MaxLifespanPerEntryInSeconds = 5 * 60,
}

--@options.MaxSize                        must be either nil (default value of 100 items) or zero (limitless) or a positive integer number
--@options.TrimRatio                      must be either nil (default value of 0.25) or between 0 and 1 
--@options.MaxLifespanPerEntryInSeconds   must be either nil (default value of 300secs) or 0 (no expiration) or a positive integer number of seconds
function Class:New(options)
    Scopify(EScopes.Function, self)

    _assert(options == nil or _type(options) == "table", "options must be a table or nil")

    options = options or Class.DefaultOptions_ --@formatter:off

    _assert(options.MaxSize                      == nil or _type(options.MaxSize)                      == "number" and options.MaxSize >= 0                      and Math.floor(options.MaxSize) == options.MaxSize, "MaxSize must either be nil or a positive integer (given value=" .. _tostring(options.MaxSize) .. ")")
    _assert(options.TrimRatio                    == nil or _type(options.TrimRatio)                    == "number" and options.TrimRatio >= 0                    and options.TrimRatio <= 1, "TrimRatio must either be nil or between 0 and 1 (given value=" .. _tostring(options.TrimRatio) .. ")")
    _assert(options.MaxLifespanPerEntryInSeconds == nil or _type(options.MaxLifespanPerEntryInSeconds) == "number" and options.MaxLifespanPerEntryInSeconds >= 0 and Math.floor(options.MaxLifespanPerEntryInSeconds) == options.MaxLifespanPerEntryInSeconds, "MaxLifespanPerEntryInSeconds must either be nil or zero or a positive integer (given value=" .. _tostring(options.MaxLifespanPerEntryInSeconds) .. ")")

    return Classify(self, {
        _count = 0,
        _entries = {},
        _timestampOfLastDeadlinesCleanup = -1,

        _maxSize                      = options.MaxSize                      == nil  and Class.DefaultOptions_.MaxSize                       or options.MaxSize,
        _trimRatio                    = options.TrimRatio                    == nil  and Class.DefaultOptions_.TrimRatio                     or options.TrimRatio,
        _maxLifespanPerEntryInSeconds = options.MaxLifespanPerEntryInSeconds == nil  and Class.DefaultOptions_.MaxLifespanPerEntryInSeconds  or options.MaxLifespanPerEntryInSeconds,
    }) --@formatter:on
end

function Class:Clear()
    Scopify(EScopes.Function, self)

    _count = 0
    _entries = {}
    _timestampOfLastDeadlinesCleanup = -1
end

function Class:Get(key)
    Scopify(EScopes.Function, self)

    _assert(key ~= nil, "key cannot be nil")

    self:Cleanup()
    
    local entry = _entries[key]
    if entry == nil then
        return nil
    end

    entry.Timestamp = Time.Now()
    return entry.Value
end

function Class:GetKeys()
    Scopify(EScopes.Function, self)

    local now = Time.Now()

    self:Cleanup()

    local keys = {}
    for key in TablesHelper.GetKeyValuePairs(_entries) do
        Table.insert(keys, key)

        _entries[key].Timestamp = now
    end

    return keys
end

function Class:GetValues()
    Scopify(EScopes.Function, self)

    local now = Time.Now()

    self:Cleanup()

    local values = {}
    for k, v in TablesHelper.GetKeyValuePairs(_entries) do
        Table.insert(values, v.Value)

        _entries[k].Timestamp = now
    end

    return values
end

-- insert or update if the key already exists
function Class:Upsert(key, valueOptional)
    Scopify(EScopes.Function, self)

    _assert(key ~= nil, "key cannot be nil")

    valueOptional = valueOptional or true --00 

    local t = Time.Now()

    _count = _count + (_entries[key] == nil and 1 or 0) -- order
    
    _entries[key] = { -- order
        Value = valueOptional,
        Deadline = t + _maxLifespanPerEntryInSeconds,
        Timestamp = t,
    }

    self:Cleanup()
    
    return self

    -- 00  we allow values to be optional but we transform nil values to 'true' because if we
    --     leave it to nil it will cause the tables involved to remove the key altogether
end

function Class:Remove(key)
    Scopify(EScopes.Function, self)

    _assert(key ~= nil, "key cannot be nil")

    _count = _count - (_entries[key] ~= nil and 1 or 0) -- order

    _entries[key] = nil -- order
end

function Class:Count()
    Scopify(EScopes.Function, self)

    return self:__len()
end

function Class:ToString()
    Scopify(EScopes.Function, self)

    return self:__tostring()
end

function Class:Cleanup()
    Scopify(EScopes.Function, self)

    self:RemoveExpiredEntries_()
    self:RemoveSuperfluousEntries_()
    
    return self
end

-- private space

function Class:RemoveExpiredEntries_()
    Scopify(EScopes.Function, self)

    if _maxLifespanPerEntryInSeconds <= 0 then
        return
    end

    local now = Time.Now()
    if now - _timestampOfLastDeadlinesCleanup < 1 then
        return
    end

    _timestampOfLastDeadlinesCleanup = now
    for key, value in TablesHelper.GetKeyValuePairs(_entries) do
        if now >= value.Deadline then
            self:Remove(key)
        end
    end
end

function Class:RemoveSuperfluousEntries_()
    Scopify(EScopes.Function, self)

    if _maxSize <= 0 then
        return
    end

    if _count <= _maxSize then
        return
    end

    local sortedArrayOldestToNewest = self:Sort_(_entries) -- remove the least recently used entries

    local desiredEventualSize = _maxSize * (1 - _trimRatio)
    local numberOfItemsToDelete = currentLength - desiredEventualSize
    for i = 1, numberOfItemsToDelete, 1
    do
        self:Remove(sortedArrayOldestToNewest[i].key)
    end
end

function Class:Sort_(t)
    Scopify(EScopes.Function, self)

    local array = {}
    for key, value in TablesHelper.GetKeyValuePairs(t) do
        Table.insert(array, { key = key, access = value.Timestamp })
    end

    Table.sort(array, function(a, b)
        return a.access < b.access
    end)

    return array
end

function Class:__tostring()
    Scopify(EScopes.Function, self)

    local s = "{ "
    local sep = ""
    for key, value in TablesHelper.GetKeyValuePairs(_entries) do
        s = s .. sep .. _format("%q=%q", _tostring(key), _tostring(value.Value))
        sep = ", "
    end

    return s .. " }"
end

function Class:__len()
    Scopify(EScopes.Function, self)

    return _count
end

