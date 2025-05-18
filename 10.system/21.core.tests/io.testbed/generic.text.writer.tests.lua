local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local ArraysHelper = using "System.Helpers.Arrays"
local GenericTextWriter = using "System.IO.GenericTextWriter"

local U = using "[built-in]" [[ VWoWUnit ]]

Scopify(EScopes.Function, {})

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.IO.GenericTextWriterTestbed",
    Tags = { "system", "io", "text-writer" },
}

TestsGroup:AddFact("GenericTextWriter.Write.GivenValidMessage.ShouldPrintExpectedMessage", function()
    -- ARRANGE
    local allMessagesArray = {}
    local geneticTextWriter = GenericTextWriter:New(function(message)
        ArraysHelper.Append(allMessagesArray, message)
    end)
    
    -- ACT
    geneticTextWriter:Write("Hello")

    -- ASSERT
    U.Should.Be.Equivalent(allMessagesArray, { "Hello" })
end)

TestsGroup:AddFact("GenericTextWriter.WriteLine.GivenValidMessage.ShouldPrintExpectedMessage", function()
    -- ARRANGE
    local allMessagesArray = {}
    local geneticTextWriter = GenericTextWriter:New(function(message)
        ArraysHelper.Append(allMessagesArray, message)
    end)

    -- ACT
    geneticTextWriter:WriteLine("Hello")

    -- ASSERT
    U.Should.Be.Equivalent(allMessagesArray, { "Hello\n" })
end)

TestsGroup:AddFact("GenericTextWriter.WriteFormatted.GivenValidMessage.ShouldPrintExpectedMessage", function()
    -- ARRANGE
    local allMessagesArray = {}
    local geneticTextWriter = GenericTextWriter:New(function(message)
        ArraysHelper.Append(allMessagesArray, message)
    end)

    -- ACT
    geneticTextWriter:WriteFormatted("Hello")

    -- ASSERT
    U.Should.Be.Equivalent(allMessagesArray, { "Hello" })
end)
