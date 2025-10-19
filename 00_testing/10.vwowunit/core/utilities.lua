local VWoWUnit, _gsub, _pairs, _assert, _strlen, _strfind, _type, _setfenv, _tableSort, _tableInsert, _next = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    _g.VWoWUnit = _g.VWoWUnit or {}

    local _type = _assert(_g.type)
    local _next = _assert(_g.next)
    local _gsub = _assert(_g.gsub)
    local _pairs = _assert(_g.pairs)
    local _strlen = _assert(_g.string.len)
    local _strfind = _assert(_g.string.find)
    local _tableSort = _assert(_g.table.sort)
    local _tableInsert = _assert(_g.table.insert)

    return _g.VWoWUnit, _gsub, _pairs, _assert, _strlen, _strfind, _type, _setfenv, _tableSort, _tableInsert, _next
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

function VWoWUnit.Utilities.Difference(a, b)
    if VWoWUnit.Utilities.IsTable(a) and VWoWUnit.Utilities.IsTable(b) then
        for key, value in _pairs(a) do
            local path, aa, bb = VWoWUnit.Utilities.Difference(value, b[key])
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

function VWoWUnit.Utilities.IsGlobMatch(input, globPattern) --@formatter:off
    _setfenv(1, VWoWUnit.Utilities)

    __ = _type(input) == "string"                             or _assert(false, "the input must be a string")
    __ = _type(globPattern) == "string" and globPattern ~= "" or _assert(false, "the glob-pattern must be a non-empty string")  --@formatter:on

    return _strfind(input, VWoWUnit.Utilities.GlobToPattern_(globPattern)) ~= nil
end

function VWoWUnit.Utilities.IsTable(value)
    _setfenv(1, VWoWUnit.Utilities)

    return _type(value) == "table"
end

function VWoWUnit.Utilities.IsEmptyTable(value)
    _setfenv(1, VWoWUnit.Utilities)

    return VWoWUnit.Utilities.IsTable(value) and _next(value) == nil
end

function VWoWUnit.Utilities.GetGroupTablePairsOrderedByGroupNames_(testGroups)
    _setfenv(1, VWoWUnit.Utilities)

    if testGroups == nil then
        return {}
    end

    return VWoWUnit.Utilities.GetIteratorFunc_TablePairsOrderedByKeys(testGroups, function(a, b)
        local lengthA = _strlen(a) -- 00
        local lengthB = _strlen(b)

        return lengthA < lengthB or (lengthA == lengthB and a < b)
    end)
end

function VWoWUnit.Utilities.GlobToPattern_(globPattern)
    _setfenv(1, VWoWUnit.Utilities)

    __ = _type(globPattern) == "string" and globPattern ~= "" or _assert(false, "the glob-pattern must be a non-empty string")

    globPattern = _gsub(globPattern, "([%^%$%(%)%%%.%[%]%+%-])", "%%%1") -- escape magic chars
    globPattern = _gsub(globPattern, "%*", ".*")
    globPattern = _gsub(globPattern, "%?", ".")

    return "^" .. globPattern .. "$"
end
