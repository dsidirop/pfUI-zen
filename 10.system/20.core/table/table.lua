local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local Table = using "[declare] [static]" "System.Table"

local B = using "[built-ins]" [[
    TableSort   = table.sort,
    TableInsert = table.insert,
    TableRemove = table.remove,
]]

Table.Sort   = B.TableSort
Table.Insert = B.TableInsert
Table.Remove = B.TableRemove
