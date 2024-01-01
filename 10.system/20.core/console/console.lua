local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local TablesHelper = using "System.Helpers.Tables"
local StringsHelper = using "System.Helpers.Strings"

local WoWUIGlobalFrames = using "System.Externals.WoW.UI.GlobalFrames"

local Console = using "[declare]" "System.Console [Partial]"

Console.Writer = using "[declare]" "System.Console.Writer [Partial]"

Scopify(EScopes.Function, {})

function Console.Writer:New(nativeWriteCallback)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsFunction(nativeWriteCallback)
    
    return self:Instantiate({
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
Console.Out   = Console.Writer:New(function(message) WoWUIGlobalFrames.DefaultChatFrame:AddMessage(StringsHelper.Format("|cffffff55%s", message)) end)
Console.Error = Console.Writer:New(function(message) WoWUIGlobalFrames.DefaultChatFrame:AddMessage(StringsHelper.Format("|cffff5555%s", message)) end)
-- @formatter:on
