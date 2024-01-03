local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Table = using "[declare]" "System.Table [Partial]"

Table.Sort = using "[global]" "table.sort"
Table.Insert = using "[global]" "table.insert"
Table.Remove = using "[global]" "table.remove"
