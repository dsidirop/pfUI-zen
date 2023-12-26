local _g, _pairs, _setfenv, _tableSort, _tableInsert = (function()
	local _g = assert(_G or getfenv(0))
	local _assert = assert
	local _setfenv = _assert(_g.setfenv)
	_setfenv(1, {})

	local _pairs = _assert(_g.pairs)
	local _tableSort = _assert(_g.table.sort)
	local _tableInsert = _assert(_g.table.insert)

	return _g, _pairs, _setfenv, _tableSort, _tableInsert
end)()

local VWoWUnit = _g.VWoWUnit or {}
_g.VWoWUnit = VWoWUnit
_g = nil

_setfenv(1, {})

VWoWUnit.Utilities = {}

-- https://stackoverflow.com/a/70096863/863651
function VWoWUnit.Utilities.GetTablePairsOrderedByKeys(tableObject, comparer)
	_setfenv(1, VWoWUnit.Utilities)
	
	local allTableKeys = {}
	for key in _pairs(tableObject) do
		_tableInsert(allTableKeys, key)
	end
	_tableSort(allTableKeys, comparer)

	local i = 0
	local iteratorFunction = function()
		i = i + 1
		if allTableKeys[i] == nil then
			return nil
		end
		
		return allTableKeys[i], tableObject[allTableKeys[i]]
	end

	return iteratorFunction
end
