local _gsub, _format, _setfenv, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _gsub = _assert(_g.string.gsub)
    local _format = _assert(_g.string.format)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _gsub, _format, _setfenv, _importer, _namespacer
end)()

_setfenv(1, {})

local Table = _importer("System.Table")
local Guard = _importer("System.Guard")
local Scopify = _importer("System.Scopify")
local EScopes = _importer("System.EScopes")

local StringsHelper = _namespacer("System.Helpers.Strings [Partial]")

function StringsHelper.Split(input, optionalDelimiter, optionalMaxChunksCount)
    Scopify(EScopes.Function, StringsHelper)
    
    Guard.Assert.IsString(input, "input")
    Guard.Assert.IsOptionallyString(optionalDelimiter, "optionalDelimiter")
    Guard.Assert.IsOptionallyPositiveIntegerOrZero(optionalMaxChunksCount, "optionalMaxChunksCount")
    
    if not input then
        return {}
    end

    local pattern = _format("([^%s]+)", optionalDelimiter or ",")

    local fields = {}
    _gsub(
            input,
            pattern,
            function(c)
                Table.Insert(fields, c)
            end,
            optionalMaxChunksCount
    )

    return fields
end
