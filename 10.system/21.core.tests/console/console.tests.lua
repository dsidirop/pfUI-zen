local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Global = using "System.Global"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Console = using "System.Console"
local Validation = using "System.Validation"
local ArraysHelper = using "System.Helpers.Arrays"

local U = Validation.Assert(Global.VWoWUnit)

Scopify(EScopes.Function, {})

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Console.Tests",
    Tags = { "system", "output" },
}

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
