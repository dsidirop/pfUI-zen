local _g, _assert, _type, _print, _error, _pairs, _ipairs, _strsub, _format, _tostring, _setfenv, _tableGetn, _debugstack, _tableInsert, _setmetatable = (function()
	local _g = assert(_G or getfenv(0))
	local _assert = assert
	local _setfenv = _assert(_g.setfenv)
	_setfenv(1, {})

	local _type = _assert(_g.type)
	local _pairs = _assert(_g.pairs)
	local _print = _assert(_g.print)
	local _error = _assert(_g.error)
	local _ipairs = _assert(_g.ipairs)
	local _strsub = _assert(_g.string.sub)
	local _format = _assert(_g.string.format)
	local _tostring = _assert(_g.tostring)
	local _tableGetn = _assert(_g.table.getn)
	local _debugstack = _assert(_g.debugstack)
	local _tableInsert = _assert(_g.table.insert)
	local _setmetatable = _assert(_g.setmetatable)

	return _g, _assert, _type, _print, _error, _pairs, _ipairs, _strsub, _format, _tostring, _setfenv, _tableGetn, _debugstack, _tableInsert, _setmetatable
end)()

_setfenv(1, {})

local VWoWUnit = _g.VWoWUnit or {}
_g.VWoWUnit = VWoWUnit
_g = nil

function VWoWUnit:New()
	local instance = {
		_testTags = {},
		_testGroups = {},
	}

	_setmetatable(instance, self)
	VWoWUnit.__index = self

	return instance
end

--[[ Run ]]--

function VWoWUnit:RunAllTestGroups()
	_setfenv(1, self)

	for _, group in _pairs(_testGroups) do
		_print("** Running test-group " .. group:GetName())
		group:Run()
		_print("")
	end
end

function VWoWUnit:RunTestGroup(testGroupName)
	_setfenv(1, self)
	
	local group = _testGroups[testGroupName]
	if not group then
		VWoWUnit.Raise_(_format("test group '%q' does not exist", testGroupName))
	end

	group:Run()
end

function VWoWUnit:RunTestGroupsForTagGroup(tagName)
	_setfenv(1, self)
	
	for _, group in _ipairs(_testTags[tagName]) do
		group:Run()
	end
end

--[[ Registry ]]--

function VWoWUnit:GetOrCreateGroup(options)
	_setfenv(1, self)
	
	_assert(_type(options) == "table")
	_assert(_type(options.Tags) == "table" or options.Tags == nil)
	_assert(_type(options.Name) == "string" and options.Name ~= "")

	options.Tags = options.Tags or {}
	
	local preexistingGroup = self:GetGroup(options.Name)
	if preexistingGroup then
		return preexistingGroup
	end

	local group = VWoWUnit.TestsGroup:New(options.Name)
	_testGroups[options.Name] = group

	local tagsCount = _tableGetn(options.Tags) 
	for i = 1, tagsCount do
		self:AssociateWithTestTag(group, options.Tags[i])
	end

	return group
end

function VWoWUnit:GetGroup(name)
	_setfenv(1, self)
	
	return _testGroups[name]
end

function VWoWUnit:AssociateWithTestTag(group, tag)
	_setfenv(1, self)

	_testTags[tag] = _testTags[tag] or {}

	_tableInsert(_testTags[tag], group)
end


--[[ Assertions ]]--

function VWoWUnit.AreEqual(a, b)
	local path, a, b = VWoWUnit.Difference_(a, b)
	if path == nil then
		return
	end
	
	local message = _format("expected %q, got %q", _tostring(b), _tostring(a))
	if path ~= nil and path ~= "" then
		message = _format("tables differ at %q - %s", _strsub(path, 2), message)
	end

	VWoWUnit.Raise_(message)
end

function VWoWUnit.IsTrue(value)
	if value then
		return
	end

	VWoWUnit.Raise_(_format("expected some value, got %q", _tostring(value)))
end

function VWoWUnit.IsFalse(value)
	if not value then
		return
	end

	VWoWUnit.Raise_(_format("expected no value, got %q", _tostring(value)))
end


--[[ Helpers ]]--

function VWoWUnit.FindInTableIfX_(tableObject, predicate)
	for k, v in _pairs(tableObject) do
		if predicate(v) then
			return k, v
		end
	end

	return nil
end

local ERROR_COLOR_CODE = "|cffff5555"
function VWoWUnit.Raise_(message)
	_error(ERROR_COLOR_CODE .. message .. "\n" .. _debugstack(), 3)

	-- stupid hack for pfui to stop the test execution   pfui overrides the error function with a custom one that
	-- doesnt invoke the base error function causing pcall to be oblivious to the exceptions that we are trying to throw
	intentional_error_to_force_stop_environments_that_override_the_error_function_with_a_custom_one_that_doesnt_invoke_the_base_error_function()
end

function VWoWUnit.IsTable_(value)
	return _type(value) == "table"
end

function VWoWUnit.Difference_(a, b)
	if VWoWUnit.IsTable_(a) and VWoWUnit.IsTable_(b) then
		for key, value in _pairs(a) do
			local path, a, b = VWoWUnit.Difference_(value, b[key])
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
