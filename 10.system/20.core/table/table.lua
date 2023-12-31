local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Validation = using "System.Validation"
local GlobalEnvironment = using "System.Global"

local Table = using "[declare]" "System.Table [Partial]"

Table.Sort = Validation.Assert((GlobalEnvironment.table or {}).sort, "table.sort is not available")
Table.Insert = Validation.Assert((GlobalEnvironment.table or {}).insert, "table.insert is not available")
Table.Remove = Validation.Assert((GlobalEnvironment.table or {}).remove, "table.remove is not available")
