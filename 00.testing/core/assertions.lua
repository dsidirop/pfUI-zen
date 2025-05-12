local VWoWUnit, _pcall, _unpack, _assert, _format, _setfenv, _tostring, _strsub, _debugstack, _tableRemove = (function()
	local _g = assert(_G or getfenv(0))
	local _assert = assert
	local _setfenv = _assert(_g.setfenv)
	_setfenv(1, {})

	_g.VWoWUnit = _g.VWoWUnit or {}
	
	local _pcall = _assert(_g.pcall)
	local _unpack = _assert(_g.unpack)
	local _strsub = _assert(_g.string.sub)
	local _format = _assert(_g.string.format)
	local _tostring = _assert(_g.tostring)
	local _debugstack = _assert(_g.debugstack)
	local _tableRemove = _assert(_g.table.remove)

	return _g.VWoWUnit, _pcall, _unpack, _assert, _format, _setfenv, _tostring, _strsub, _debugstack, _tableRemove
end)()

_setfenv(1, {})

VWoWUnit.Should = {}
VWoWUnit.Should.Be = {}
VWoWUnit.Should.Not = {}
VWoWUnit.Should.Not.Be = {}

function VWoWUnit.Should.Throw(action)
	_setfenv(1, VWoWUnit.Should)

	local success = _pcall(action)

	if success then
		VWoWUnit.RaiseWithoutStacktrace_(_format("[Should.Throw()] Was expecting an exception but no exception was thrown"))
	end
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
	
	local returnValuesTable = {_pcall(action)}
	
	local success = returnValuesTable[1]
	_tableRemove(returnValuesTable, 1)
	
	if not success then
		local errorMessage = returnValuesTable[1]
		VWoWUnit.RaiseWithoutStacktrace_(_format("[Should.Not.Throw()] Was not expecting an exception to be thrown but got this one:\n\n%s", _tostring(errorMessage)))
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

function VWoWUnit.Should.Be.PlainlyEqual(a, b)
	_setfenv(1, VWoWUnit.Should)

	if a == b then
		return
	end

	VWoWUnit.Raise_(_format("[Should.Be.PlainlyEqual()] Expected the two values to be plainly-equal but they're not (got %q which is not equal to %q)", _tostring(a), _tostring(b)))
end

function VWoWUnit.Should.Be.Equivalent(a, b)
	_setfenv(1, VWoWUnit.Should)

	local path, aa, bb = VWoWUnit.Utilities.Difference_(a, b)
	if path == nil then
		return
	end

	local message = _format("[Should.Be.Equivalent()] Expected %q, got %q", _tostring(bb), _tostring(aa))
	if path ~= nil and path ~= "" then
		message = _format("%s - tables differ at %q", message, _strsub(path, 2))
	end

	VWoWUnit.Raise_(message)
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
