local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local B = using "[built-ins]" [[ GetRawType = type ]]

local SRawTypes = using "System.Language.SRawTypes"

local RawTypeSystem = using "[declare] [static]" "System.Language.RawTypeSystem"

RawTypeSystem.GetRawType = B.GetRawType 

function RawTypeSystem.IsNil(value)
    return value == nil -- should be faster than type(value) == "nil"
end

function RawTypeSystem.IsTable(value)
    return RawTypeSystem.GetRawType(value) == SRawTypes.Table
end

function RawTypeSystem.IsNumber(value)
    return RawTypeSystem.GetRawType(value) == SRawTypes.Number
end

function RawTypeSystem.IsString(value)
    return RawTypeSystem.GetRawType(value) == SRawTypes.String
end

function RawTypeSystem.IsBoolean(value)
    return RawTypeSystem.GetRawType(value) == SRawTypes.Boolean
end

function RawTypeSystem.IsFunction(value)
    return RawTypeSystem.GetRawType(value) == SRawTypes.Function
end

-- IsNilOr...() functions
function RawTypeSystem.IsNilOrTable(value)
    return value == nil or RawTypeSystem.GetRawType(value) == SRawTypes.Table
end

function RawTypeSystem.IsNilOrNumber(value)
    return value == nil or RawTypeSystem.GetRawType(value) == SRawTypes.Number
end

function RawTypeSystem.IsNilOrString(value)
    return value == nil or RawTypeSystem.GetRawType(value) == SRawTypes.String
end

function RawTypeSystem.IsNilOrBoolean(value)
    return value == nil or RawTypeSystem.GetRawType(value) == SRawTypes.Boolean
end

function RawTypeSystem.IsNilOrFunction(value)
    return value == nil or RawTypeSystem.GetRawType(value) == SRawTypes.Function
end
