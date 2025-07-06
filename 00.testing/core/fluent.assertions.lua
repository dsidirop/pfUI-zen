local VWoWUnit, _pcall, _unpack, _assert, _format, _rawequal, _setfenv, _tostring, _strsub, _debugstack, _tableRemove, _type = (function()
	local _g = assert(_G or getfenv(0))
	local _assert = assert
	local _setfenv = _assert(_g.setfenv)
	_setfenv(1, {})

	_g.VWoWUnit = _g.VWoWUnit or {}
	
	local _type = _assert(_g.type)
    local _pcall = _assert(_g.pcall)
	local _unpack = _assert(_g.unpack)
	local _strsub = _assert(_g.string.sub)
	local _format = _assert(_g.string.format)
    local _rawequal = _assert(_g.rawequal)
	local _tostring = _assert(_g.tostring)
	local _debugstack = _assert(_g.debugstack)
	local _tableRemove = _assert(_g.table.remove)

	return _g.VWoWUnit, _pcall, _unpack, _assert, _format, _rawequal, _setfenv, _tostring, _strsub, _debugstack, _tableRemove, _type
end)()

_setfenv(1, {})

-- todo   this should probably be moved into a separate package called "VWoWFluentAssertions" or something like that

VWoWUnit.Should = {} -- everything is static here    no point to use class-proto or instances for these
VWoWUnit.Should.Be = {}
VWoWUnit.Should.Not = {}
VWoWUnit.Should.Not.Be = {}

function VWoWUnit.Should.Throw(action, optionalErrorMessageGlobPattern)
	_setfenv(1, VWoWUnit.Should)

    if action == nil then
        -- todo   this sort of testbed-failure should mark the test as inconclusive instead of failed    its a small detail but it would be a nice to have
        VWoWUnit.Raise_(_format("[Should.Throw()] [!!!TESTBED BUG!!!] Expected a function but got %q (fix the testbed - make sure the call is *.Throw(action) and not *.Throw(action()) !)", _tostring(_type(action))))
        return
    end
    
    if optionalErrorMessageGlobPattern ~= nil and _type(optionalErrorMessageGlobPattern) ~= "string" then
        VWoWUnit.Raise_(_format("[Should.Throw()] [!!!TESTBED BUG!!!] Expected a string glob pattern but got %q", _tostring(_type(optionalErrorMessageGlobPattern))))
        return
    end

    local returnValuesTable = {_pcall(action)}

    local success = returnValuesTable[1]
    _tableRemove(returnValuesTable, 1)
    
	if success then
		VWoWUnit.Raise_(_format("[Should.Throw()] Was expecting an exception but no exception was thrown"))
	end

    if optionalErrorMessageGlobPattern ~= nil then
        local errorMessage = returnValuesTable[1]

        if not VWoWUnit.Utilities.IsGlobMatch(errorMessage, optionalErrorMessageGlobPattern) then
            VWoWUnit.Raise_(_format("[Should.Throw()] Expected exception-message to match glob pattern %q but got this exception-message instead:\n\n%s\n\n", optionalErrorMessageGlobPattern, _tostring(errorMessage)))
        end
    end

    return _unpack(returnValuesTable)
end

function VWoWUnit.Should.Not.Be.Nil(value)
    _setfenv(1, VWoWUnit.Should)

    if value ~= nil then
        return
    end

    VWoWUnit.Raise_(_format("[Should.Not.Be.Nil()] Expected a non-nil value but got %q", _tostring(value)))
end

function VWoWUnit.Should.Not.Be.PlainlyEqual(a, b)
    _setfenv(1, VWoWUnit.Should)

    if a ~= b then
        return
    end

    VWoWUnit.Raise_(_format("[Should.Not.Be.PlainlyEqual()] Expected the two values to not be plainly-equal but they are (got %q which is equal to %q)", _tostring(a), _tostring(b)))
end


function VWoWUnit.Should.Not.ReachHere(explanation)
    _setfenv(1, VWoWUnit.Should)

    local message = "[Should.Not.ReachHere()] This code should not be reached"
    if explanation ~= nil then
        message = _format("%s: %s", message, _tostring(explanation))
    end

    VWoWUnit.RaiseWithoutStacktrace_(message)
end

function VWoWUnit.Should.Not.Throw(action)
	_setfenv(1, VWoWUnit.Should)

    if action == nil then
        VWoWUnit.Raise_(_format("[Should.Not.Throw()] [TESTBED BUG] Expected a function but got %q (fix the testbed - make sure the call is *.Throw(action) and not *.Throw(action()) !)", _tostring(_type(action))))
        return
    end
    
	local returnValuesTable = {_pcall(action)}
	
	local success = returnValuesTable[1]
	_tableRemove(returnValuesTable, 1)
	
	if not success then
		local errorMessage = returnValuesTable[1]
		VWoWUnit.RaiseWithoutStacktrace_(_format("[Should.Not.Throw()] Was not expecting an exception to be thrown but got this one:\n\n%s\n\n", _tostring(errorMessage)))
	end
	
	return _unpack(returnValuesTable)
end

function VWoWUnit.Should.Be.Nil(value)
    _setfenv(1, VWoWUnit.Should)

    if value == nil then
        return
    end

    VWoWUnit.Raise_(_format("[Should.Be.Nil()] Expected a nil value but got %q", _tostring(value)))
end

function VWoWUnit.Should.Be.RawEqual(a, b)
    _setfenv(1, VWoWUnit.Should)

    if _rawequal(a, b) then
        return
    end

    VWoWUnit.Raise_(_format("[Should.Be.RawEqual()] Expected the two values to be raw-equal but they're not (pointers: a = %p and b = %p)", a, b))
end

function VWoWUnit.Should.Be.PlainlyEqual(a, b)
	_setfenv(1, VWoWUnit.Should)

	if a == b then
		return
	end

	VWoWUnit.Raise_(_format("[Should.Be.PlainlyEqual()] Expected the two values to be plainly-equal but they're not: %q (%s) vS %q (%s)", _tostring(a), _tostring(_type(a)), _tostring(b), _tostring(_type(b))))
end

function VWoWUnit.Should.Be.Equivalent(a, b)
	_setfenv(1, VWoWUnit.Should)

	local path, aa, bb = VWoWUnit.Utilities.Difference(a, b)
	if path == nil then
		return
	end

	local message = _format("[Should.Be.Equivalent()] Expected %q, got %q", _tostring(bb), _tostring(aa))
	if path ~= nil and path ~= "" then
		message = _format("%s - tables differ at %q", message, _strsub(path, 2))
	end

	VWoWUnit.Raise_(message)
end

function VWoWUnit.Should.Be.TypeOfTable(value)
    _setfenv(1, VWoWUnit.Should)

    if _type(value) == "table" then
        return
    end

    VWoWUnit.Raise_(_format("[Should.Be.TypeOfTable()] Expected %q to be a table but got type = %q (value = %q)", name, _type(value), _tostring(value)))
end

function VWoWUnit.Should.Be.TypeOfString(value, name)
    _setfenv(1, VWoWUnit.Should)

    if _type(value) == "string" then
        return
    end
    
    VWoWUnit.Raise_(_format("[Should.Be.TypeOfString()] Expected %q to be a string but got type = %q (value = %q)", name, _type(value), _tostring(value)))
end

function VWoWUnit.Should.Be.Boolean(value)
    _setfenv(1, VWoWUnit.Should)

    if _type(value) == "boolean" then
        return
    end

    VWoWUnit.Raise_(_format("[Should.Be.Boolean()] Expected boolean value, got %q ( value = %q )", _type(value), _tostring(value)))
end

function VWoWUnit.Should.Be.True(value)
    _setfenv(1, VWoWUnit.Should)

    if _type(value) == "boolean" and value == true then
        return
    end

    VWoWUnit.Raise_(_format("[Should.Be.True()] Expected 'true' boolean value, got %q ( value = %q )", _tostring(value), _type(value)))
end

function VWoWUnit.Should.Be.Truthy(value)
	_setfenv(1, VWoWUnit.Should)
	
	if value then
		return
	end

	VWoWUnit.Raise_(_format("[Should.Be.Truthy()] Expected truthy value, got %q", _tostring(value)))
end

function VWoWUnit.Should.Be.Falsy(value)
	_setfenv(1, VWoWUnit.Should)
	
	if not value then
		return
	end

	VWoWUnit.Raise_(_format("[Should.Be.Falsy()] Expected falsy value, got %q", _tostring(value)))
end

local ERROR_COLOR_CODE = "|cffff5555"
function VWoWUnit.Raise_(message)
	_setfenv(1, VWoWUnit)

	VWoWUnit.RaiseRaw_(ERROR_COLOR_CODE .. message .. "\n" .. _debugstack(3))
end

function VWoWUnit.RaiseWithoutStacktrace_(message)
	_setfenv(1, VWoWUnit)

	-- its absolutely vital to use assert() instead of error() because error() is overriden in addons like pfui to only print without
	-- actually raising an error as an exception which is not what we want to happen here   by using assert() we ensure that we get an exception
	VWoWUnit.RaiseRaw_(ERROR_COLOR_CODE .. message)
end

function VWoWUnit.RaiseRaw_(message)
	_setfenv(1, VWoWUnit)

	-- its absolutely vital to use assert() instead of error() because error() is overriden in addons like pfui to only print without
	-- actually raising an error as an exception which is not what we want to happen here   by using assert() we ensure that we get an exception
	_assert(false, message)
end
