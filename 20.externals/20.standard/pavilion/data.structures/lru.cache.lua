---- lru cache  with a fixed maximum size    when the cache is full it discards the least recently used items first
----
---- inspired by https://github.com/kenshinx/Lua-LRU-Cache

local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Time         = using "System.Time" --                @formatter:off
local Nils         = using "System.Nils"
local Guard        = using "System.Guard"
local Table        = using "System.Table"
local Scopify      = using "System.Scopify"
local EScopes      = using "System.EScopes"

local T    = using "System.Helpers.Tables"
local StringsHelper   = using "System.Helpers.Strings" --  @formater:on

local Class = using "[declare]" "Pavilion.DataStructures.LRUCache"

Scopify(EScopes.Function, {})

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

    options = Guard.Assert.IsNilOrTable(options, "options") or Class.DefaultOptions_ --@formatter:off

    Guard.Assert.IsNilOrRatioNumber(options.TrimRatio, "options.TrimRatio")
    Guard.Assert.IsNilOrPositiveInteger(options.MaxSize, "options.MaxSize")
    Guard.Assert.IsNilOrPositiveIntegerOrZero(options.MaxLifespanPerEntryInSeconds, "options.MaxLifespanPerEntryInSeconds")

    return self:Instantiate({
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
    
    Guard.Assert.IsNotNil(key, "key")

    self:Cleanup()
    
    local entry = _entries[key]
    if entry == nil then
        return nil
    end

    entry.Timestamp = Time.Now()
    return entry.Value
end

function Class:PopKeysArray()
    Scopify(EScopes.Function, self)

    local keysArray = self:GetKeysArray()
    self:Clear()

    return keysArray
end

function Class:GetAll()
    Scopify(EScopes.Function, self)

    local now = Time.Now()

    self:Cleanup()

    local entries = {}
    for key, value in T.GetPairs(_entries) do
        entries[key] = value.Value

        _entries[key].Timestamp = now
    end

    return entries
end

function Class:GetKeysArray()
    Scopify(EScopes.Function, self)

    local now = Time.Now()

    self:Cleanup()

    local keys = {}
    for key in T.GetPairs(_entries) do
        Table.Insert(keys, key)

        _entries[key].Timestamp = now
    end

    return keys
end

function Class:GetValuesArray()
    Scopify(EScopes.Function, self)

    local now = Time.Now()

    self:Cleanup()

    local values = {}
    for k, v in T.GetPairs(_entries) do
        Table.Insert(values, v.Value)

        _entries[k].Timestamp = now
    end

    return values
end

-- insert or update if the key already exists
function Class:Upsert(key, valueOptional, timestampOptional)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNotNil(key, "key")
    Guard.Assert.IsNilOrPositiveInteger(timestampOptional, "timestampOptional")

    local t = timestampOptional or Time.Now()

    valueOptional = Nils.Coalesce(valueOptional, true) --00

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

    Guard.Assert.IsNotNil(key, "key")

    _count = _count - (_entries[key] ~= nil and 1 or 0) -- order

    _entries[key] = nil -- order
end

function Class:Count()
    Scopify(EScopes.Function, self)

    return self:__len()
end

function Class:ToString()
    Scopify(EScopes.Function, self)

    local s = "{ "
    local sep = ""
    for key, value in T.GetPairs(_entries) do
        s = s .. sep .. StringsHelper.Format("%q=%q", key, value.Value)
        sep = ", "
    end

    return s .. " }"
end
Class.__tostring = Class.ToString

function Class:Cleanup()
    Scopify(EScopes.Function, self)

    self:TrimExpiredEntries_()
    self:TrimOldestEntries_()
    
    return self
end

-- private space

function Class:TrimExpiredEntries_()
    Scopify(EScopes.Function, self)

    if _maxLifespanPerEntryInSeconds <= 0 then
        return
    end

    local now = Time.Now()
    if now - _timestampOfLastDeadlinesCleanup < 1 then
        return
    end

    _timestampOfLastDeadlinesCleanup = now
    for key, value in T.GetPairs(_entries) do
        if now >= value.Deadline then
            self:Remove(key)
        end
    end
end

function Class:TrimOldestEntries_()
    Scopify(EScopes.Function, self)

    if _maxSize <= 0 then
        return
    end

    if _count <= _maxSize then
        return
    end

    local sortedArrayOldestToNewest = self:Sort_(_entries) -- remove the least recently used entries

    local desiredEventualSize = _maxSize * (1 - _trimRatio)
    local numberOfItemsToDelete = _count - desiredEventualSize

    for i = 1, numberOfItemsToDelete, 1
    do
        self:Remove(sortedArrayOldestToNewest[i].key)
    end
end

function Class:Sort_(t)
    Scopify(EScopes.Function, self)

    local array = {}
    for key, value in T.GetPairs(t) do
        Table.Insert(array, { key = key, access = value.Timestamp })
    end

    Table.Sort(array, function(a, b)
        return a.access < b.access
    end)

    return array
end

function Class:__len()
    Scopify(EScopes.Function, self)

    return _count
end
