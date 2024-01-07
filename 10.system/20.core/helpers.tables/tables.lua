local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[
    Next = next,
    Unpack = unpack,
    RawGet = rawget,

    GetTablePairs = pairs,
    GetArrayIndecesAndValues = ipairs,

    TableCount = table.getn,
    TableInsert = table.insert,
]]

local Nils = using "System.Nils"
local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Reflection = using "System.Reflection"

local Metatable = using "System.Classes.Metatable"

local TablesHelper = using "[declare]" "System.Helpers.Tables [Partial]"

Scopify(EScopes.Function, { })

TablesHelper.GetKeyValuePairs = B.GetTablePairs
TablesHelper.GetArrayIndecesAndValues = B.GetArrayIndecesAndValues

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
    for k, v in TablesHelper.GetKeyValuePairs(tableInstance) do
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
    Guard.Assert.IsNilOrTable(tableInstance)

    return tableInstance == nil or B.Next(tableInstance) == nil
end

function TablesHelper.Unpack(tableInstance, ...)
    local variadicArguments = arg

    Guard.Assert.IsTable(tableInstance)
    Guard.Assert.Explained.IsNilOrEmptyTable(variadicArguments, "it seems you are attempting to use unpack(table, startIndex, endIndex) - use UnpackRange() for this kind of thing instead!")

    return B.Unpack(tableInstance)
end

function TablesHelper.UnpackViaLength(tableInstance, chunkStartIndex, chunkLength)
    Guard.Assert.IsTable(tableInstance)
    Guard.Assert.IsPositiveInteger(chunkStartIndex)
    Guard.Assert.IsPositiveIntegerOrZero(chunkLength)

    return TablesHelper.UnpackRange(tableInstance, chunkStartIndex, chunkStartIndex + chunkLength - 1)
end

function TablesHelper.UnpackRange(tableInstance, startIndex, optionalEndIndex)
    Guard.Assert.IsTable(tableInstance)
    Guard.Assert.IsPositiveInteger(startIndex)
    Guard.Assert.IsNilOrPositiveInteger(optionalEndIndex)

    local tableLength = B.TableCount(tableInstance)
    if tableLength == 0 then
        return -- nothing to unpack
    end

    optionalEndIndex = Nils.Coalesce(optionalEndIndex, tableLength)
    if startIndex == 1 and optionalEndIndex == tableLength then
        return B.Unpack(tableInstance) -- optimization
    end

    local results = {}
    for i = startIndex, optionalEndIndex do
        B.TableInsert(results, tableInstance[i])
    end

    return B.Unpack(results)
end
