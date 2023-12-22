local _setfenv, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    
    return _setfenv, _importer, _namespacer
end)()

_setfenv(1, {}) --@formatter:off

local Guard            = _importer("System.Guard")
local Scopify          = _importer("System.Scopify")
local Classify         = _importer("System.Classify")

local TablesHelper     = _importer("System.Helpers.Tables")
local StringsHelper    = _importer("System.Helpers.Strings")

local DefaultChatFrame = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.DefaultChatFrame") --@formatter:on

local Console = _namespacer("System.Console")

local Writer = {}

function Writer:New(nativeWriteCallback)
    Scopify(EScopes.Function, self)
    
    Guard.Check.IsFunction(nativeWriteCallback)
    
    return Classify(self, {
        _nativeWriteCallback = nativeWriteCallback
    })
end

function Writer:WriteFormatted(format, ...)
    Scopify(EScopes.Function, self)
    
    Guard.Check.IsString(format)
    
    if TablesHelper.IsEmptyOrNil(arg) then
        _nativeWriteCallback(format)
        return
    end
    
    _nativeWriteCallback(StringsHelper.Format(format, TablesHelper.Unpack(arg)))
end

function Writer:Write(message)
    Scopify(EScopes.Function, self)

    Guard.Check.IsString(message)

    _nativeWriteCallback(message)
end

function Writer:WriteLine(message)
    Scopify(EScopes.Function, self)
    
    Guard.Check.IsString(message)

    _nativeWriteCallback(message .. "\n")
end

-- @formatter:off
Console.Out   = Writer:New(function() DefaultChatFrame:AddMessage(StringsHelper.Format("|cffffff55%s", msg)) end)
Console.Error = Writer:New(function() DefaultChatFrame:AddMessage(StringsHelper.Format("|cffff5555%s", msg)) end)
-- @formatter:on
