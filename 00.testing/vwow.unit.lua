local VWoWUnit, _g, _assert, _type, _pfui, _setfenv, _tableGetn, _setmetatable = (function()
	local _g = assert(_G or getfenv(0))
	local _assert = assert
	local _setfenv = _assert(_g.setfenv)
	_setfenv(1, {})

	_g.VWoWUnit = _g.VWoWUnit or {} -- dont introduce a local variable here    it will cause bugs

	local _type = _assert(_g.type)
    local _pfui = _assert(_g.pfUI)
	local _tableGetn = _assert(_g.table.getn)
	local _setmetatable = _assert(_g.setmetatable)

	return _g.VWoWUnit, _g, _assert, _type, _pfui, _setfenv, _tableGetn, _setmetatable
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
    
    self:OnTestRoundCommencing_()

	for _, testsGroup in VWoWUnit.Utilities.GetGroupTablePairsOrderedByGroupNames_(_testGroups) do
		_logger:LogInfo("** [" .. testsGroup:GetName() .. "] Running test-group ...")
        testsGroup:Run()
		_logger:LogInfo("")
	end

    self:OnTestRoundCompleted_()
	
	-- 00  we want to ensure that tests with short names like system.exceptions to be run before tests with long names like pavilion.xyz.foo.bar 
end

function TestsRunnerEngine:RunTestGroup(testGroupName)
	_setfenv(1, self)

    self:OnTestRoundCommencing_()
	
	local group = _testGroups[testGroupName]
	if not group then
		_logger:LogError("** [" .. testGroupName .. "] doesn't exist - ignoring it")
		return
	end

    group:Run()

    self:OnTestRoundCompleted_()
end

function TestsRunnerEngine:RunTestGroupsByTag(tagName)
	_setfenv(1, self)

    self:OnTestRoundCommencing_()

    _logger:LogInfo("** [tag:" .. tagName .. "] Running tests tagged with it ...")
    
	for _, group in VWoWUnit.Utilities.GetGroupTablePairsOrderedByGroupNames_(_testTags[tagName]) do
		group:Run()
	end

    self:OnTestRoundCompleted_()
end

function TestsRunnerEngine:RunSpecificTest(testName)
    _setfenv(1, self)

    self:OnTestRoundCommencing_()

    local test = self:GetSpecificTest_(testName)
    if not test then
        _logger:LogError("** [" .. testName .. "] doesn't exist - ignoring it")
        return
    end

    test:Run()

    self:OnTestRoundCompleted_()
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

--[[ ZENSHARP ]]--

function TestsRunnerEngine:BindZenSharpKeywords(optionalTestgroupKeyword)
    _setfenv(1, self)
    
    _testgroupKeyword = optionalTestgroupKeyword or "[testgroup]"

    local using = _assert(_g.pvl_namespacer_get)

    local Namespacer = using "System.Namespacer" -- if zensharp hasnt been loaded yet this will error out as intended

    local vwowunitSnapshot = VWoWUnit
    Namespacer:BindKeyword(_testgroupKeyword, function(name)
        local testGroup = vwowunitSnapshot.TestsEngine:CreateOrUpdateGroup { Name = name }

        return testGroup, vwowunitSnapshot
    end)

    Namespacer:BindKeyword(_testgroupKeyword .. " [tagged]", function(name)
        local testGroup = vwowunitSnapshot.TestsEngine:CreateOrUpdateGroup { Name = name }

        return function(tags)
            vwowunitSnapshot.TestsEngine:AssociateTestGroupWithTags(testGroup, tags)
            return testGroup, vwowunitSnapshot
        end
    end)
end

function TestsRunnerEngine:UnbindZenSharpKeywords()
    _setfenv(1, self)

    if not _testgroupKeyword then
        return
    end

    local using = _assert(_g.pvl_namespacer_get)

    local Namespacer = using "System.Namespacer" -- if zensharp hasnt been loaded yet this will error out as intended

    Namespacer:UnbindKeyword(_testgroupKeyword)
    Namespacer:UnbindKeyword(_testgroupKeyword .. " [tagged]")
end

-- private space

function TestsRunnerEngine:OnTestRoundCommencing_()
    _setfenv(1, self)

    self:EnsurePfuiChatInterceptorsArePluggedIn_()
end

local _pfuiChatInterceptorsGotPluggedIn = false
function TestsRunnerEngine:EnsurePfuiChatInterceptorsArePluggedIn_()
    _setfenv(1, self)

    if _pfuiChatInterceptorsGotPluggedIn then
        return
    end
    
    _pfuiChatInterceptorsGotPluggedIn  = true
    
    if _type(_pfui) ~= "table" then
        return
    end
    
    if _type(_pfui.chat) ~= "table" then
        return
    end
    
    if _type(_pfui.chat.URLPattern) ~= "table" then
        return
    end

    if _type(_pfui.chat.URLFuncs) ~= "table" then
        return
    end

    _pfui.chat.URLPattern.VWoWUnitTestCases = {
        ["rx"] = "%[([_A-Za-z0-9-]+)%.([^%s%]()]+)%]",
        ["fm"] = "%s.%s"
    }

    _pfui.chat.URLFuncs.VWoWUnitTestCases = function(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
        return _pfui.chat:FormatLink(_pfui.chat.URLPattern.VWoWUnitTestCases.fm, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
    end

    _pfui.chat.URLPattern.VWoWUnitStackTraceFilePaths = {
        ["rx"] = "([\\._A-Za-z0-9-]+:[0-9]+): ",
        ["fm"] = "%s"
    }

    _pfui.chat.URLFuncs.VWoWUnitStackTraceFilePaths = function(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
        return _pfui.chat:FormatLink(_pfui.chat.URLPattern.VWoWUnitStackTraceFilePaths.fm, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
    end
end

function TestsRunnerEngine:OnTestRoundCompleted_()
    _setfenv(1, self)

    self:EnsurePfuiChatInterceptorsAreUnplugged_()
end


function TestsRunnerEngine:EnsurePfuiChatInterceptorsAreUnplugged_()
    _setfenv(1, self)

    if not _pfuiChatInterceptorsGotPluggedIn then
        return
    end

    _pfuiChatInterceptorsGotPluggedIn = false

    if _type(_pfui) ~= "table" then
        return
    end

    if _type(_pfui.chat) ~= "table" then
        return
    end

    if _type(_pfui.chat.URLPattern) ~= "table" then
        return
    end

    if _type(_pfui.chat.URLFuncs) ~= "table" then
        return
    end

    _pfui.chat.URLPattern.VWoWUnitTestCases = nil
    _pfui.chat.URLFuncs.VWoWUnitTestCases = nil

    _pfui.chat.URLPattern.VWoWUnitStackTraceFilePaths = nil
    _pfui.chat.URLFuncs.VWoWUnitStackTraceFilePaths = nil
end

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
