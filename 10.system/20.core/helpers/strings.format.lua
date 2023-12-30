local _setfenv, _strformat, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _strformat = _assert(_g.string.format)

    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _setfenv, _strformat, _importer, _namespacer
end)()

_setfenv(1, {})

local Guard = _importer("System.Guard")
local Scopify = _importer("System.Scopify")
local EScopes = _importer("System.EScopes")
local TablesHelper = _importer("System.Helpers.Tables")
local ArraysHelper = _importer("System.Helpers.Arrays")

local StringsHelper = _namespacer("System.Helpers.Strings [Partial]")

function StringsHelper.Format(format, ...)
    Scopify(EScopes.Function, StringsHelper)

    Guard.Assert.IsNonEmptyTable(arg)
    Guard.Assert.IsNonDudString(format)

    local argCount = ArraysHelper.Count(arg)
    if argCount == 0 then
        return format
    end
    
    if argCount == 1 then
        return _strformat(format, StringsHelper.Stringify(arg[1]))
    end

    if argCount == 2 then
        return _strformat(format, StringsHelper.Stringify(arg[1]), StringsHelper.Stringify(arg[2]))
    end

    if argCount == 3 then
        return _strformat(format, StringsHelper.Stringify(arg[1]), StringsHelper.Stringify(arg[2]), StringsHelper.Stringify(arg[3]))
    end

    if argCount == 4 then
        return _strformat(format, StringsHelper.Stringify(arg[1]), StringsHelper.Stringify(arg[2]), StringsHelper.Stringify(arg[3]), StringsHelper.Stringify(arg[4]))
    end

    if argCount == 5 then
        return _strformat(format, StringsHelper.Stringify(arg[1]), StringsHelper.Stringify(arg[2]), StringsHelper.Stringify(arg[3]), StringsHelper.Stringify(arg[4]), StringsHelper.Stringify(arg[5]))
    end

    if argCount == 6 then
        return _strformat(format, StringsHelper.Stringify(arg[1]), StringsHelper.Stringify(arg[2]), StringsHelper.Stringify(arg[3]), StringsHelper.Stringify(arg[4]), StringsHelper.Stringify(arg[5]), StringsHelper.Stringify(arg[6]))
    end

    if argCount == 7 then
        return _strformat(format, StringsHelper.Stringify(arg[1]), StringsHelper.Stringify(arg[2]), StringsHelper.Stringify(arg[3]), StringsHelper.Stringify(arg[4]), StringsHelper.Stringify(arg[5]), StringsHelper.Stringify(arg[6]), StringsHelper.Stringify(arg[7]))
    end

    if argCount == 8 then
        return _strformat(format, StringsHelper.Stringify(arg[1]), StringsHelper.Stringify(arg[2]), StringsHelper.Stringify(arg[3]), StringsHelper.Stringify(arg[4]), StringsHelper.Stringify(arg[5]), StringsHelper.Stringify(arg[6]), StringsHelper.Stringify(arg[7]), StringsHelper.Stringify(arg[8]))
    end

    if argCount == 9 then
        return _strformat(format, StringsHelper.Stringify(arg[1]), StringsHelper.Stringify(arg[2]), StringsHelper.Stringify(arg[3]), StringsHelper.Stringify(arg[4]), StringsHelper.Stringify(arg[5]), StringsHelper.Stringify(arg[6]), StringsHelper.Stringify(arg[7]), StringsHelper.Stringify(arg[8]), StringsHelper.Stringify(arg[9]))
    end

    if argCount == 10 then
        return _strformat(format, StringsHelper.Stringify(arg[1]), StringsHelper.Stringify(arg[2]), StringsHelper.Stringify(arg[3]), StringsHelper.Stringify(arg[4]), StringsHelper.Stringify(arg[5]), StringsHelper.Stringify(arg[6]), StringsHelper.Stringify(arg[7]), StringsHelper.Stringify(arg[8]), StringsHelper.Stringify(arg[9]), StringsHelper.Stringify(arg[10]))
    end

    local stringifiedArgs = {}
    for i = 1, argCount do
        stringifiedArgs[i] = StringsHelper.Stringify(arg[i])
    end
    
    return _strformat(format, TablesHelper.Unpack(stringifiedArgs))
end
