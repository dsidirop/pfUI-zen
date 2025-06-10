local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local A = using "System.Helpers.Arrays"
local T = using "System.Helpers.Tables"
local S = using "System.Helpers.Strings"

local Fields = using "System.Classes.Fields"

local Class = using "[declare]" "System.IO.GenericTextWriter"

Scopify(EScopes.Function, {})

Fields(function(upcomingInstance)
    upcomingInstance._nativeWriteCallback = nil

    return upcomingInstance
end)

function Class:New(nativeWriteCallback)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsFunction(nativeWriteCallback, "nativeWriteCallback")
    
    local instance = self:Instantiate()
    
    instance._nativeWriteCallback = nativeWriteCallback
    
    return instance
end

function Class:WriteFormatted(format, ...)
    local variadicsArray = arg
    
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(format, "format")

    if T.IsNilOrEmpty(variadicsArray) then --optimization
        _nativeWriteCallback(format)
        return
    end

    _nativeWriteCallback(S.Format(format, A.Unpack(variadicsArray)))
end

function Class:Write(message)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsString(message, "message")

    _nativeWriteCallback(message)
end

function Class:WriteLine(message)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(message, "message")

    _nativeWriteCallback(message .. "\n")
end
