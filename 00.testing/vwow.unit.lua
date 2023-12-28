local _g, _assert, _type, _print, _strlen, _format, _setfenv, _tableGetn, _setmetatable = (function()
	local _g = assert(_G or getfenv(0))
	local _assert = assert
	local _setfenv = _assert(_g.setfenv)
	_setfenv(1, {})

	local _type = _assert(_g.type)
	local _print = _assert(_g.print)
	local _strlen = _assert(_g.string.len)
	local _format = _assert(_g.string.format)
	local _tableGetn = _assert(_g.table.getn)
	local _setmetatable = _assert(_g.setmetatable)

	return _g, _assert, _type, _print, _strlen, _format, _setfenv, _tableGetn, _setmetatable
end)()

_setfenv(1, {})

local VWoWUnit = _g.VWoWUnit or {}
_g.VWoWUnit = VWoWUnit
_g = nil

local _Engine = {} -- local to this file only and instantiated only once at the bottom of this file

function _Engine:New()
	local instance = {
		_testTags = {},
		_testGroups = {},
	}

	_setmetatable(instance, self)
	self.__index = self

	return instance
end

--[[ Run ]]--

function _Engine:RunAllTestGroups()
	_setfenv(1, self)

	for _, group in _Engine.GetGroupTablePairsOrderedByGroupNames_(_testGroups) do
		_print("** Running test-group " .. group:GetName())
		group:Run()
		_print("")
	end
	
	-- 00  we want to ensure that tests with short names like system.exceptions to be run before tests with long names like pavilion.xyz.foo.bar 
end

function _Engine:RunTestGroup(testGroupName)
	_setfenv(1, self)
	
	local group = _testGroups[testGroupName]
	if not group then
		VWoWUnit.Raise_(_format("test group %q does not exist", testGroupName))
	end

	group:Run()
end

function _Engine:RunTestGroupsByTag(tagName)
	_setfenv(1, self)

	for _, group in _Engine.GetGroupTablePairsOrderedByGroupNames_(_testTags[tagName]) do
		group:Run()
	end
end

--[[ Registry ]]--

function _Engine:CreateOrUpdateGroup(options)
	_setfenv(1, self)
	
	_assert(_type(options) == "table")
	_assert(_type(options.Tags) == "table" or options.Tags == nil)
	_assert(_type(options.Name) == "string" and options.Name ~= "")

	options.Tags = options.Tags or {}
	
	local group = self:GetGroup(options.Name)
	if group == nil then
		group = VWoWUnit.TestsGroup:New(options.Name)
		_testGroups[options.Name] = group
	end

	local tagsCount = _tableGetn(options.Tags) 
	for i = 1, tagsCount do
		self:AssociateWithTestTag(group, options.Tags[i])
	end

	return group
end

function _Engine:GetGroup(name)
	_setfenv(1, self)
	
	return _testGroups[name]
end

function _Engine:AssociateWithTestTag(group, tag)
	_setfenv(1, self)

	_testTags[tag] = _testTags[tag] or {}

	_testTags[tag][group:GetName()] = group
end

-- private space

function _Engine.GetGroupTablePairsOrderedByGroupNames_(testGroups)
	_setfenv(1, _Engine)

	if testGroups == nil then
		return {}
	end

	return VWoWUnit.Utilities.GetTablePairsOrderedByKeys(testGroups, function(a, b)
		local lengthA = _strlen(a) -- 00
		local lengthB = _strlen(b)

		return lengthA < lengthB or (lengthA == lengthB and a < b)
	end)
end

VWoWUnit.TestsEngine = _Engine:New()
