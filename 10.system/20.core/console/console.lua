local _setfenv, _print, _tostring, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _print = _assert(_g.print)
    local _tostring = _assert(_g.tostring)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _setfenv, _print, _tostring, _importer, _namespacer
end)()

_setfenv(1, {})

local Guard               = _importer("System.Guard") --                              @formatter:off
local Scopify             = _importer("System.Scopify")
local EScopes             = _importer("System.EScopes")
local Classify            = _importer("System.Classify")
local TablesHelper        = _importer("System.Helpers.Tables")
local StringsHelper       = _importer("System.Helpers.Strings")
local WoWDefaultChatFrame = _importer("System.Externals.WoW.DefaultChatFrame") --     @formatter:on

local Console = _namespacer("System.Console [Partial]")

Console.Writer = {}

function Console.Writer:New(nativeWriteCallback)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsFunction(nativeWriteCallback)

    return Classify(self, {
        _nativeWriteCallback = nativeWriteCallback
    })
end

function Console.Writer:WriteFormatted(format, ...)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(format, "format")

    if TablesHelper.IsEmptyOrNil(arg) then --optimization
        _nativeWriteCallback(format)
        return
    end

    _nativeWriteCallback(StringsHelper.Format(format, TablesHelper.Unpack(arg)))
end

function Console.Writer:Write(message)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsString(message, "message")

    _nativeWriteCallback(message)
end

function Console.Writer:WriteLine(message)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(message, "message")

    _nativeWriteCallback(message .. "\n")
end

-- @formatter:off
Console.Out   = Console.Writer:New(function(message) WoWDefaultChatFrame:AddMessage(StringsHelper.Format("|cffffff55%s", message)) end)
Console.Error = Console.Writer:New(function(message) WoWDefaultChatFrame:AddMessage(StringsHelper.Format("|cffff5555%s", message)) end)
-- @formatter:on
