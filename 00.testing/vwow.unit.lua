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

local TestsRunnerEngine = {} -- local to this file only and instantiated only once at the bottom of this file

function TestsRunnerEngine:New()
	local instance = {
		_testTags = {},
		_testGroups = {},

		_options = {
			verbosity = "normal", -- minimal, normal, verbose
		}
	}

	_setmetatable(instance, self)
	self.__index = self

	return instance
end

--[[ Options ]]--

function TestsRunnerEngine:ChainSetOptionVerbosity(newLevel)
	_setfenv(1, self)

	_assert(_type(newLevel) == "string", "verbosity must be a string")
	_assert(newLevel == "minimal" or newLevel == "normal" or newLevel == "verbose", "verbosity must be one of: minimal, normal, verbose")

	_options.verbosity = newLevel
	
	return self
end

--[[ Run ]]--

function TestsRunnerEngine:RunAllTestGroups()
	_setfenv(1, self)

	for _, group in TestsRunnerEngine.GetGroupTablePairsOrderedByGroupNames_(_testGroups) do
		self:PrintNormal_("** Running test-group " .. group:GetName())
		group:Run()
		self:PrintNormal_("")
	end
	
	-- 00  we want to ensure that tests with short names like system.exceptions to be run before tests with long names like pavilion.xyz.foo.bar 
end

function TestsRunnerEngine:RunTestGroup(testGroupName)
	_setfenv(1, self)
	
	local group = _testGroups[testGroupName]
	if not group then
		VWoWUnit.Raise_(_format("test group %q does not exist", testGroupName))
	end

	group:Run()
end

function TestsRunnerEngine:RunTestGroupsByTag(tagName)
	_setfenv(1, self)

	for _, group in TestsRunnerEngine.GetGroupTablePairsOrderedByGroupNames_(_testTags[tagName]) do
		group:Run()
	end
end

--[[ Registry ]]--

function TestsRunnerEngine:CreateOrUpdateGroup(options)
	_setfenv(1, self)
	
	_assert(_type(options) == "table")
	_assert(_type(options.Tags) == "table" or options.Tags == nil)
	_assert(_type(options.Name) == "string" and options.Name ~= "")

	local group = self:GetsertGroup_(options.Name)
	self:AssociateTestGroupWithTags(group, options.Tags or {})

	return group
end

function TestsRunnerEngine:GetGroup(name)
	_setfenv(1, self)
	
	return _testGroups[name]
end

function TestsRunnerEngine:AssociateTestGroupWithTags(group, tags)
	_setfenv(1, self)

	_assert(_type(tags) == "table")

	local tagsCount = _tableGetn(tags)
	for i = 1, tagsCount do
		local tag  = tags[i]

		_testTags[tag] = _testTags[tag] or {}
		_testTags[tag][group:GetName()] = group
	end
	
	return self
end

-- private space

function TestsRunnerEngine:GetsertGroup_(name)
	_setfenv(1, self)

	_assert(_type(name) == "string" and name ~= "")

	local group = self:GetGroup(name)
	if group == nil then
		group = VWoWUnit.TestsGroup:New(name)
		_testGroups[name] = group
	end

	return group
end

function TestsRunnerEngine:PrintNormal_(message) -- todo   turn this into a separate logger
	_setfenv(1, self)

	if _options.verbosity == "normal" or _options.verbosity == "verbose" then
		_print(message)
	end
end

function TestsRunnerEngine:PrintVerbose_(message)
	_setfenv(1, self)

	if _options.verbosity == "verbose" then
		_print(message)
	end
end

function TestsRunnerEngine:PrintMinimal_(message)
	_setfenv(1, self)

	if _options.verbosity == "minimal" then
		_print(message)
	end
end

function TestsRunnerEngine.GetGroupTablePairsOrderedByGroupNames_(testGroups)
	_setfenv(1, TestsRunnerEngine)

	if testGroups == nil then
		return {}
	end

	return VWoWUnit.Utilities.GetTablePairsOrderedByKeys(testGroups, function(a, b)
		local lengthA = _strlen(a) -- 00
		local lengthB = _strlen(b)

		return lengthA < lengthB or (lengthA == lengthB and a < b)
	end)
end

VWoWUnit.TestsEngine = TestsRunnerEngine:New() -- single instance
