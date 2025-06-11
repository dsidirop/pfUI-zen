local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local B = using "[built-ins]" [[
    Next     = next,
    Unpack   = unpack,
    RawGet   = rawget,

    TableCount  = table.getn,
    TableInsert = table.insert,

    TableGetPairs        = pairs,
    TableGetIndexedPairs = ipairs,
]]

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Reflection = using "System.Reflection"

local Metatable = using "System.Classes.Metatable"

local TablesHelper = using "[declare] [static]" "System.Helpers.Tables"

Scopify(EScopes.Function, { })

TablesHelper.GetPairs = B.TableGetPairs
TablesHelper.GetIndexedPairs = B.TableGetIndexedPairs

function TablesHelper.Clear(tableInstance)
    Guard.Assert.IsTable(tableInstance, "tableInstance")

    for k in TablesHelper.GetPairs(tableInstance) do
        tableInstance[k] = nil
    end
end

function TablesHelper.RawGetValue(table, key)
    Guard.Assert.IsTable(table, "table")
    Guard.Assert.IsNotNil(key, "key")

    return B.RawGet(table, key)
end

function TablesHelper.Clone(tableInstance, seen)
    if Reflection.IsTable(tableInstance) then
        return tableInstance
    end

    if seen and seen[tableInstance] then
        return seen[tableInstance]
    end

    local s = seen or {}
    local result = Metatable.Set({}, Metatable.Get(tableInstance))

    s[tableInstance] = result
    for k, v in TablesHelper.GetPairs(tableInstance) do
        result[TablesHelper.Clone(k, s)] = TablesHelper.Clone(v, s)
    end

    return result
end

function TablesHelper.Append(table, value)
    Guard.Assert.IsTable(table, "table")
    Guard.Assert.IsNotNil(value, "value")

    return B.TableInsert(table, value)
end

function TablesHelper.Insert(table, value, index)
    Guard.Assert.IsTable(table, "table")
    Guard.Assert.IsNotNil(value, "value")
    Guard.Assert.IsPositiveNumber(index, "index")

    return B.TableInsert(table, value, index)
end

function TablesHelper.Dequeue(table)
    Guard.Assert.IsTable(table, "table")

    local firstKey = B.Next(table)
    if firstKey == nil then
        return nil
    end

    local value = table[firstKey]
    table[firstKey] = nil

    return value
end

function TablesHelper.Pop(table)
    Guard.Assert.IsTable(table, "table")

    local lastIndex = B.TableCount(table)
    if lastIndex == 0 then
        return nil
    end

    local value = table[lastIndex]
    table[lastIndex] = nil

    return value
end

function TablesHelper.AnyOrNil(tableInstance)
    return not TablesHelper.IsNilOrEmpty(tableInstance)
end

function TablesHelper.IsNilOrEmpty(tableInstance)
    Guard.Assert.IsNilOrTable(tableInstance, "tableInstance")

    return tableInstance == nil or B.Next(tableInstance) == nil
end

function TablesHelper.Count(tableInstance)
    Guard.Assert.IsTable(tableInstance, "tableInstance")
    
    local i = 0;
    for _ in TablesHelper.GetPairs(tableInstance) do
        i = i + 1
    end
    
    return i
end
