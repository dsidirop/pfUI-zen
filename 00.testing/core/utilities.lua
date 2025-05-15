local VWoWUnit, _pairs, _type, _setfenv, _tableSort, _tableInsert = (function()
	local _g = assert(_G or getfenv(0))
	local _assert = assert
	local _setfenv = _assert(_g.setfenv)
	_setfenv(1, {})

	_g.VWoWUnit = _g.VWoWUnit or {}
	
	local _type = _assert(_g.type)
	local _pairs = _assert(_g.pairs)
	local _tableSort = _assert(_g.table.sort)
	local _tableInsert = _assert(_g.table.insert)

	return _g.VWoWUnit, _pairs, _type, _setfenv, _tableSort, _tableInsert
end)()

_setfenv(1, {})

VWoWUnit.Utilities = {}

-- https://stackoverflow.com/a/70096863/863651
function VWoWUnit.Utilities.GetIteratorFunc_TablePairsOrderedByKeys(tableObject, comparer)
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

function VWoWUnit.Utilities.IsTable_(value)
	_setfenv(1, VWoWUnit.Utilities)
	
	return _type(value) == "table"
end

function VWoWUnit.Utilities.Difference_(a, b)
	if VWoWUnit.Utilities.IsTable_(a) and VWoWUnit.Utilities.IsTable_(b) then
		for key, value in _pairs(a) do
			local path, aa, bb = VWoWUnit.Utilities.Difference_(value, b[key])
			if path then
				return "." .. key .. path, aa, bb
			end
		end

		for key, value in _pairs(b) do
			if a[key] == nil then
				return "." .. key, nil, value
			end
		end

	elseif a ~= b then
		return "", a, b
	end

	return nil
end
