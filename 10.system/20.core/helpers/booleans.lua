local _setfenv, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _setfenv, _importer, _namespacer
end)()

_setfenv(1, {})

local Guard = _importer("System.Guard")
local Reflection = _importer("System.Reflection")
local StringsHelper = _importer("System.Helpers.Strings")

local Class = _namespacer("System.Helpers.Booleans")

function Class.Booleanize(value, defaultValueWhenValueIsNil)
    _ = defaultValueWhenValueIsNil == nil
            and Guard.Assert.IsBooleanizable(value)
            or Guard.Assert.IsOptionallyBooleanizable(value)
    
    if value == nil then
        return defaultValueWhenValueIsNil
    end

    if Reflection.IsString(value) then --00
        value = StringsHelper.ToUppercase(value)

        return     value == "1" --     @formatter:off
                or value == "Y"
                or value == "T"
                or value == "YES"
                or value == "TRUE" --  @formatter:on
    end

    if Reflection.IsNumber(value) then
        return value >= 1
    end
    
    return value --10
    
    -- 00  this must mirror the logic in Guard.Assert.IsBooleanizableString_
    -- 10  if we fallthrough then we must be dealing with a boolean
end
