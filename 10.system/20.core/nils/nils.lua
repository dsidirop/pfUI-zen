local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Nils = using "[declare] [static]" "System.Nils [Partial]"

function Nils.Coalesce(
        value,
        fallbackValueIfNil1,
        fallbackValueIfNil2,
        fallbackValueIfNil3,
        fallbackValueIfNil4,
        fallbackValueIfNil5,
        fallbackValueIfNil6,
        fallbackValueIfNil7
)
    if value ~= nil then -- 00
        return value
    end
    
    if fallbackValueIfNil1 ~= nil then
        return fallbackValueIfNil1
    end
    
    if fallbackValueIfNil2 ~= nil then
        return fallbackValueIfNil2
    end
    
    if fallbackValueIfNil3 ~= nil then
        return fallbackValueIfNil3
    end
    
    if fallbackValueIfNil4 ~= nil then
        return fallbackValueIfNil4
    end
    
    if fallbackValueIfNil5 ~= nil then
        return fallbackValueIfNil5
    end
    
    if fallbackValueIfNil6 ~= nil then
        return fallbackValueIfNil6
    end

    return fallbackValueIfNil7

    -- 00  dont try to inline this like 'value ~= nil and value or fallbackValueIfNil' because it will fail when value=false !!
end
