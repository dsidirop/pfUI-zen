local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[
    Getn        = table.getn,
    TableInsert = table.insert,
    TableRemove = table.remove,
]]

local Guard = using "System.Guard"

local Class = using "[declare]" "System.Helpers.Arrays [Partial]"

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
