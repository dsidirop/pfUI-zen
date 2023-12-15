local _g, _type, _print, _error, _pairs, _ipairs, _format, _tostring, _setfenv, _tableGetn, _tableInsert, _setmetatable, _FONT_COLOR_CODE_CLOSE, _HIGHLIGHT_FONT_COLOR_CODE = (function()
	local _g = assert(_G or getfenv(0))
	local _assert = assert
	local _setfenv = _assert(_g.setfenv)
	_setfenv(1, {})

	local _type = _assert(_g.type)
	local _pairs = _assert(_g.pairs)
	local _print = _assert(_g.print)
	local _error = _assert(_g.error)
	local _ipairs = _assert(_g.ipairs)
	local _format = _assert(_g.string.format)
	local _tostring = _assert(_g.tostring)
	local _tableGetn = _assert(_g.table.getn)
	local _tableInsert = _assert(_g.table.insert)
	local _setmetatable = _assert(_g.setmetatable)

	local _FONT_COLOR_CODE_CLOSE = _assert(_g.FONT_COLOR_CODE_CLOSE)
	local _HIGHLIGHT_FONT_COLOR_CODE = _assert(_g.HIGHLIGHT_FONT_COLOR_CODE)

	return _g, _type, _print, _error, _pairs, _ipairs, _format, _tostring, _setfenv, _tableGetn, _tableInsert, _setmetatable, _FONT_COLOR_CODE_CLOSE, _HIGHLIGHT_FONT_COLOR_CODE
end)()

_setfenv(1, {})

local VWoWUnit = _g.VWoWUnit or {}
_g.VWoWUnit = VWoWUnit
_g = nil

function VWoWUnit:New()
	local instance = {
		_enabled = true,

		_events = {},
		_testGroups = {},
	}

	_setmetatable(instance, self)
	self.__index = self

	return instance
end

--[[ Run ]]--

function VWoWUnit:RunAllTestGroups()
	_setfenv(1, self)
	
	for _, group in _pairs(_testGroups) do
		group:Run()
	end
end

function VWoWUnit:RunTestGroup(testGroupName)
	_setfenv(1, self)
	
	local group = _testGroups[testGroupName]
	if not group then
		self:Raise_(_format("test group %q does not exist", testGroupName))
	end

	group:Run()
end

function VWoWUnit:RunTestGroupsForEvent(event)
	_setfenv(1, self)
	
	for _, group in _ipairs(_events[event]) do
		group:Run()
	end
end

--[[ Registry ]]--

function VWoWUnit:GetOrCreateGroup(name, ...)
	_setfenv(1, self)
	
	local preexistingGroup = self:GetGroup(name)
	if preexistingGroup then
		return preexistingGroup
	end

	local group = VWoWUnit.TestsGroup:New(name)
	_tableInsert(_testGroups, group)

	local argumentCount = _tableGetn(arg) 
	if argumentCount == 0 then
		self:AddToEvent(group, "PLAYER_LOGIN")
		return group
	end

	for i = 1, argumentCount do
		self:AddToEvent(group, arg[i])
	end

	return group
end

function VWoWUnit:GetGroup(name)
	_setfenv(1, self)
	
	local _, group = self:FindInTableIfX_(_testGroups, function(g) return g._name == name end)
	
	return group
end

function VWoWUnit:AddToEvent(group, event)
	_setfenv(1, self)
	
	-- RegisterEvent(event)

	_events[event] = _events[event] or {}

	_tableInsert(_events[event], group)
end


--[[ Control ]]--

function VWoWUnit:Enable()
	_setfenv(1, self)
	
	_enabled = true
end

function VWoWUnit:Disable()
	_setfenv(1, self)
	
	_enabled = false
end

function VWoWUnit:IsEnabled()
	_setfenv(1, self)
	
	return _enabled
end


--[[ Assertions ]]--

function VWoWUnit:AreEqual(a, b)
	_setfenv(1, self)

	local path, a, b = self:Difference_(a, b)
	if path == nil then
		return
	end
	
	local message = _format("expected %q, got %q", _tostring(a), _tostring(b))
	if path ~= "" then
		message = _format("tables differ at %q - ", path:sub(2)) .. message
	end

	self:Raise_(message)
end

function VWoWUnit:IsTrue(value)
	_setfenv(1, self)
	
	if value then
		return
	end

	self:Raise_(_format("Expected some value, got %s", _tostring(value)))
end

function VWoWUnit:IsFalse(value)
	_setfenv(1, self)
	
	if not value then
		return
	end

	self:Raise_(_format("Expected no value, got %s", _tostring(value)))
end


--[[ Helpers ]]--

function VWoWUnit:FindInTableIfX_(tbl, pred)
	_setfenv(1, self)
	
	for k, v in _pairs(tbl) do
		if pred(v) then
			return k, v
		end
	end

	return nil;
end

function VWoWUnit:Raise_(message)
	_setfenv(1, self)
	
	_error(_HIGHLIGHT_FONT_COLOR_CODE .. message .. _FONT_COLOR_CODE_CLOSE, 3)
end

function VWoWUnit:IsTable_(value)
	_setfenv(1, self)
	
	return _type(value) == "table"
end

function VWoWUnit:Difference_(a, b)
	_setfenv(1, self)

	if self:IsTable_(a) and self:IsTable_(b) then
		for key, value in _pairs(a) do
			local path, a, b = self:Difference_(value, b[key])
			if path then
				return "." .. key .. path, a, b
			end
		end

		for key, value in _pairs(b) do
			if a[key] == nil then
				return "." .. key, nil, value
			end
		end

	elseif a ~= b then
		return "", a, b
	end

	return nil
end

VWoWUnit.I = VWoWUnit:New()
