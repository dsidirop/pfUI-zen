local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Table = using "[declare] [static]" "System.Table [Partial]"

local B = using "[built-ins]" [[
    TableSort   = table.sort,
    TableInsert = table.insert,
    TableRemove = table.remove,
]]

Table.Sort   = B.TableSort
Table.Insert = B.TableInsert
Table.Remove = B.TableRemove
