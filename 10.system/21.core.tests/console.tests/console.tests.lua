local _setfenv, _importer, _VWoWUnit = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _VWoWUnit = _assert(_g.VWoWUnit)
    local _importer = _assert(_g.pvl_namespacer_get)
    
    return _setfenv, _importer, _VWoWUnit
end)()

_setfenv(1, {}) --                                           @formatter:off

local Console      = _importer("System.Console")
local ArraysHelper = _importer("System.Helpers.Arrays")

local TestsGroup = _VWoWUnit.I:GetOrCreateGroup {
    Name = "System.Console.Tests",
    Tags = { "system", "output" },
} --                                                         @formatter:on

TestsGroup:AddTest("ConsoleWriter.Write.GivenValidMessage.ShouldPrintExpectedMessage", function()
    -- ARRANGE
    local allMessagesArray = {}
    local consoleWriter = Console.Writer:New(function(message)
        ArraysHelper.Append(allMessagesArray, message)
    end)
    
    -- ACT
    consoleWriter:Write("Hello")

    -- ASSERT
    _VWoWUnit.AreEqual(allMessagesArray, { "Hello" })
end)

TestsGroup:AddTest("ConsoleWriter.WriteLine.GivenValidMessage.ShouldPrintExpectedMessage", function()
    -- ARRANGE
    local allMessagesArray = {}
    local consoleWriter = Console.Writer:New(function(message)
        ArraysHelper.Append(allMessagesArray, message)
    end)

    -- ACT
    consoleWriter:WriteLine("Hello")

    -- ASSERT
    _VWoWUnit.AreEqual(allMessagesArray, { "Hello\n" })
end)

TestsGroup:AddTest("ConsoleWriter.WriteFormatted.GivenValidMessage.ShouldPrintExpectedMessage", function()
    -- ARRANGE
    local allMessagesArray = {}
    local consoleWriter = Console.Writer:New(function(message)
        ArraysHelper.Append(allMessagesArray, message)
    end)

    -- ACT
    consoleWriter:WriteFormatted("Hello")

    -- ASSERT
    _VWoWUnit.AreEqual(allMessagesArray, { "Hello" })
end)
