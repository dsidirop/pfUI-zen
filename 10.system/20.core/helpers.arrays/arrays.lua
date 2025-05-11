local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local B = using "[built-ins]" [[
    Unpack      = unpack,

    Getn        = table.getn,
    TableInsert = table.insert,
    TableRemove = table.remove,
]]

local Nils  = using "System.Nils"
local Guard = using "System.Guard"

local Class = using "[declare]" "System.Helpers.Arrays [Partial]" -- @formatter:on

function Class.Count(array)
    Guard.Assert.IsTable(array, "array")

    return B.Getn(array)
end

function Class.Append(array, value)
    Guard.Assert.IsTable(array, "array")
    Guard.Assert.IsNotNil(value, "value")

    return B.TableInsert(array, value)
end

function Class.PopFirst(array)
    Guard.Assert.IsTable(array, "array")

    return B.TableRemove(array, 1) -- todo  table remove is known to be terribly inefficient  so we need to find something better
end

function Class.Unpack(tableInstance, ...)
    local variadicArguments = arg

    Guard.Assert.IsTable(tableInstance, "tableInstance")
    Guard.Assert.Explained.IsNilOrEmptyTable(variadicArguments, "it seems you are attempting to use unpack(table, startIndex, endIndex) - use UnpackRange() for this kind of thing instead!")

    return B.Unpack(tableInstance)
end

function Class.UnpackViaLength(tableInstance, chunkStartIndex, chunkLength)
    Guard.Assert.IsTable(tableInstance)
    Guard.Assert.IsPositiveInteger(chunkStartIndex)
    Guard.Assert.IsPositiveIntegerOrZero(chunkLength)

    return TablesHelper.UnpackRange(tableInstance, chunkStartIndex, chunkStartIndex + chunkLength - 1)
end

function Class.UnpackRange(tableInstance, startIndex, optionalEndIndex)
    Guard.Assert.IsTable(tableInstance)
    Guard.Assert.IsPositiveInteger(startIndex)
    Guard.Assert.IsNilOrPositiveInteger(optionalEndIndex)

    local tableLength = Class.Count(tableInstance)
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
