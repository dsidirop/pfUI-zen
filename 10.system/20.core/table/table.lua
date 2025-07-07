--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Table = using "[declare] [static]" "System.Table"

local B = using "[built-ins]" [[
    TableSort   = table.sort,
    TableInsert = table.insert,
    TableRemove = table.remove,
]]

Table.Sort   = B.TableSort
Table.Insert = B.TableInsert
Table.Remove = B.TableRemove
