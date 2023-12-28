local _g, _pcall, _assert, _format, _setfenv, _tostring, _strsub, _debugstack = (function()
	local _g = assert(_G or getfenv(0))
	local _assert = assert
	local _setfenv = _assert(_g.setfenv)
	_setfenv(1, {})

	local _pcall = _assert(_g.pcall)
	local _strsub = _assert(_g.string.sub)
	local _format = _assert(_g.string.format)
	local _tostring = _assert(_g.tostring)
	local _debugstack = _assert(_g.debugstack)

	return _g, _pcall, _assert, _format, _setfenv, _tostring, _strsub, _debugstack
end)()

local VWoWUnit = _g.VWoWUnit or {}
_g.VWoWUnit = VWoWUnit
_g = nil

_setfenv(1, {})

VWoWUnit.Should = {}
VWoWUnit.Should.Be = {}

function VWoWUnit.Should.NotThrow(action)
	_setfenv(1, VWoWUnit.Should)
	
	local success, result = _pcall(action)

	if not success then
		VWoWUnit.Raise_(_format("[] Was not expecting an exception but got this one:\n\n%s ", result))
	end
	
	return result
end

function VWoWUnit.Should.Be.Equivalent(a, b)
	_setfenv(1, VWoWUnit.Should)

	local path, aa, bb = VWoWUnit.Utilities.Difference_(a, b)
	if path == nil then
		return
	end

	local message = _format("expected %q, got %q", _tostring(bb), _tostring(aa))
	if path ~= nil and path ~= "" then
		message = _format("tables differ at %q - %s", _strsub(path, 2), message)
	end

	VWoWUnit.Raise_(message)
end

function VWoWUnit.Should.Be.True(value)
	_setfenv(1, VWoWUnit.Should)
	
	if value then
		return
	end

	VWoWUnit.Raise_(_format("expected some value, got %q", _tostring(value)))
end

function VWoWUnit.Should.Be.False(value)
	_setfenv(1, VWoWUnit.Should)
	
	if not value then
		return
	end

	VWoWUnit.Raise_(_format("expected no value, got %q", _tostring(value)))
end

local ERROR_COLOR_CODE = "|cffff5555"
function VWoWUnit.Raise_(message)
	_setfenv(1, VWoWUnit)
	
	-- its absolutely vital to use assert() instead of error() because error() is overriden in addons like pfui to only print without
	-- actually raising an error as an exception which is not what we want to happen here   by using assert() we ensure that we get an exception
	_assert(false, ERROR_COLOR_CODE .. message .. "\n" .. _debugstack(3))
end
