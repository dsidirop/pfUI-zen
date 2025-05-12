local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[
    Next     = next,
    Unpack   = unpack,
    RawGet   = rawget,

    TableCount  = table.getn,
    TableInsert = table.insert,

    GetPairs        = pairs,
    GetIndexedPairs = ipairs,
]]

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Reflection = using "System.Reflection"

local Metatable = using "System.Classes.Metatable"

local TablesHelper = using "[declare] [static]" "System.Helpers.Tables [Partial]"

Scopify(EScopes.Function, { })

TablesHelper.GetPairs = B.GetPairs
TablesHelper.GetIndexedPairs = B.GetIndexedPairs

function TablesHelper.Clear(tableInstance)
    Guard.Assert.IsTable(tableInstance, "tableInstance")

    for k in B.GetTablePairs(tableInstance) do
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
    Guard.Assert.IsTable(table)
    Guard.Assert.IsNotNil(value)

    return B.TableInsert(table, value)
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
