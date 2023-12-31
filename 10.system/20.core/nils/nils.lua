local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Nils = using "[declare]" "System.Nils [Partial]"

function Nils.Coalesce(value, fallbackValueIfNil)
    if value == nil then -- 00
        return fallbackValueIfNil
    end
    
    return value
    
    -- 00  dont try to inline this like 'value ~= nil and value or fallbackValueIfNil' because it will fail when value=false !!
end
