local _g = assert(_G or getfenv(0))
local _setfenv = assert(_g.setfenv)
local _namespacer = assert(_g.pvl_namespacer_add)

local _table = assert(_g.table)
local _tableSort = assert(_table.sort)
local _tableInsert = assert(_table.insert)
local _tableRemove = assert(_table.remove)

_g = nil
_setfenv(1, {})

local Table = _namespacer("System.Table")

Table.Sort = _tableSort
Table.Insert = _tableInsert
Table.Remove = _tableRemove
