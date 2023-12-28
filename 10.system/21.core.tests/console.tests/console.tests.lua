local _setfenv, _importer, U = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local U = _assert(_g.VWoWUnit)
    local _importer = _assert(_g.pvl_namespacer_get)
    
    return _setfenv, _importer, U
end)()

_setfenv(1, {}) --                                           @formatter:off

local Console      = _importer("System.Console")
local ArraysHelper = _importer("System.Helpers.Arrays")

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Console.Tests",
    Tags = { "system", "output" },
} --                                                         @formatter:on

TestsGroup:AddFact("ConsoleWriter.Write.GivenValidMessage.ShouldPrintExpectedMessage", function()
    -- ARRANGE
    local allMessagesArray = {}
    local consoleWriter = Console.Writer:New(function(message)
        ArraysHelper.Append(allMessagesArray, message)
    end)
    
    -- ACT
    consoleWriter:Write("Hello")

    -- ASSERT
    U.Should.Be.Equivalent(allMessagesArray, { "Hello" })
end)

TestsGroup:AddFact("ConsoleWriter.WriteLine.GivenValidMessage.ShouldPrintExpectedMessage", function()
    -- ARRANGE
    local allMessagesArray = {}
    local consoleWriter = Console.Writer:New(function(message)
        ArraysHelper.Append(allMessagesArray, message)
    end)

    -- ACT
    consoleWriter:WriteLine("Hello")

    -- ASSERT
    U.Should.Be.Equivalent(allMessagesArray, { "Hello\n" })
end)

TestsGroup:AddFact("ConsoleWriter.WriteFormatted.GivenValidMessage.ShouldPrintExpectedMessage", function()
    -- ARRANGE
    local allMessagesArray = {}
    local consoleWriter = Console.Writer:New(function(message)
        ArraysHelper.Append(allMessagesArray, message)
    end)

    -- ACT
    consoleWriter:WriteFormatted("Hello")

    -- ASSERT
    U.Should.Be.Equivalent(allMessagesArray, { "Hello" })
end)
