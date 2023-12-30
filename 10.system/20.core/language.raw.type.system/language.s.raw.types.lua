local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Debug = using "System.Debug"
local GlobalEnvironment = using "System.Global"

local SRawTypes = using "[declare]" "System.Language.SRawTypes [Partial]"

local _type = Debug.Assert(GlobalEnvironment.type) --         considering how early on this enum is being registered
local _rawget = Debug.Assert(GlobalEnvironment.rawget) --     we need to use native facilities to get things working
local _setmetatable = Debug.Assert(GlobalEnvironment.setmetatable)

SRawTypes.Nil      = "nil" --                                 @formatter:off
SRawTypes.Table    = "table"
SRawTypes.Number   = "number"
SRawTypes.String   = "string"
SRawTypes.Boolean  = "boolean"
SRawTypes.Function = "function"

SRawTypes.Thread   = "thread" --   rarely encountered
SRawTypes.Userdata = "userdata" -- rarely encountered         @formatter:on

_setmetatable(SRawTypes, {
    __index = function(tableObject, key) -- we cant use getrawvalue here  we have to write the method ourselves
        local value = _rawget(tableObject, key)

        Debug.Assert(value ~= nil, "SRawTypes enum doesn't have a member named '" .. key .. "'", 2)

        return value
    end
})

function SRawTypes.IsValid(value)
    -- we have to use _type here because we obviously cant afford the luxury of employing reflection utilities in here
    if _type(value) ~= SRawTypes.String then
        return false
    end

    return value == SRawTypes.Nil
            or value == SRawTypes.Table
            or value == SRawTypes.Number
            or value == SRawTypes.String
            or value == SRawTypes.Boolean
            or value == SRawTypes.Function
            or value == SRawTypes.Thread
            or value == SRawTypes.Userdata
end
