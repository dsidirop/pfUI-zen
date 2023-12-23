local _setfenv, _print, _importer, _VWoWUnit = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _print = _assert(_g.print)
    local _VWoWUnit = _assert(_g.VWoWUnit)
    local _importer = _assert(_g.pvl_namespacer_get)
    
    return _setfenv, _print, _importer, _VWoWUnit
end)()

_setfenv(1, {}) --                                           @formatter:off

local Console      = _importer("System.Console")
local ArraysHelper = _importer("System.Helpers.Arrays")

local ConsoleTestsGroup = _VWoWUnit.I:GetOrCreateGroup {
    Name = "System.Console.Tests",
    Tags = { "system", "output" },
} --                                                         @formatter:on

ConsoleTestsGroup:AddTest("ConsoleWriter.Write.GivenValidMessage.ShouldPrintExpectedMessage", function()
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

ConsoleTestsGroup:AddTest("ConsoleWriter.WriteFormatted.GivenValidMessage.ShouldPrintExpectedMessage", function()
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

ConsoleTestsGroup:AddTest("ConsoleWriter.WriteLine.GivenValidMessage.ShouldPrintExpectedMessage", function()
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
