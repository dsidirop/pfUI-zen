local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Nils = using "[declare]" "System.Nils [Partial]"

function Nils.Coalesce(value, defaultValueIfNil)
    if value == nil then -- 00
        return defaultValueIfNil
    end
    
    return value
    
    -- 00  dont try to inline this like 'value ~= nil and value or defaultValueIfNil' because it will fail when value=false !!
end
