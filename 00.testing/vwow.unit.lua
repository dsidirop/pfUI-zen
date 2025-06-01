local VWoWUnit, _assert, _type, _setfenv, _tableGetn, _setmetatable = (function()
	local _g = assert(_G or getfenv(0))
	local _assert = assert
	local _setfenv = _assert(_g.setfenv)
	_setfenv(1, {})

	_g.VWoWUnit = _g.VWoWUnit or {} -- dont introduce a local variable here    it will cause bugs

	local _type = _assert(_g.type)
	local _tableGetn = _assert(_g.table.getn)
	local _setmetatable = _assert(_g.setmetatable)

	return _g.VWoWUnit, _assert, _type, _setfenv, _tableGetn, _setmetatable
end)()

_setfenv(1, {})

local TestsRunnerEngine = {} -- local to this file only and instantiated only once at the bottom of this file

function TestsRunnerEngine:New()
	local instance = {
		_testTags = {},
		_testGroups = {},

		_logger = VWoWUnit.DefaultLogger
	}

	_setmetatable(instance, self)
	self.__index = self

	return instance
end

--[[ Run ]]--

function TestsRunnerEngine:RunAllTestGroups()
	_setfenv(1, self)

	for _, testsGroup in VWoWUnit.Utilities.GetGroupTablePairsOrderedByGroupNames_(_testGroups) do
		_logger:LogInfo("** [" .. testsGroup:GetName() .. "] Running test-group ...")
        testsGroup:Run()
		_logger:LogInfo("")
	end
	
	-- 00  we want to ensure that tests with short names like system.exceptions to be run before tests with long names like pavilion.xyz.foo.bar 
end

function TestsRunnerEngine:RunTestGroup(testGroupName)
	_setfenv(1, self)
	
	local group = _testGroups[testGroupName]
	if not group then
		_logger:LogError("** [" .. testGroupName .. "] doesn't exist - ignoring it")
		return
	end

    group:Run()
end

function TestsRunnerEngine:RunTestGroupsByTag(tagName)
	_setfenv(1, self)

	for _, group in VWoWUnit.Utilities.GetGroupTablePairsOrderedByGroupNames_(_testTags[tagName]) do
		group:Run()
	end
end

function TestsRunnerEngine:RunSpecificTest(testName)
    _setfenv(1, self)

    local test = self:GetSpecificTest_(testName)
    if not test then
        _logger:LogError("** [" .. testName .. "] doesn't exist - ignoring it")
        return
    end

    test:Run()
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

function TestsRunnerEngine:GetSpecificTest_(testName)
    _setfenv(1, self)

    _assert(_type(testName) == "string" and testName ~= "")

    for _, group in VWoWUnit.Utilities.GetGroupTablePairsOrderedByGroupNames_(_testGroups) do
        local test = group:GetTest(testName)
        if test then
            return test
        end
    end

    return nil
end

VWoWUnit.TestsEngine = TestsRunnerEngine:New() -- single instance
