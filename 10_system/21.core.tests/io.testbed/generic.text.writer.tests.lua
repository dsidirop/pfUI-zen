--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local ArraysHelper = using "System.Helpers.Arrays"
local GenericTextWriter = using "System.IO.GenericTextWriter"

local TG, U = using "[testgroup] [tagged]" "System.IO.GenericTextWriterTestbed" { "system", "io", "text-writer" }

TG:AddFact("GenericTextWriter.Write.GivenValidMessage.ShouldPrintExpectedMessage", function()
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

TG:AddFact("GenericTextWriter.WriteLine.GivenValidMessage.ShouldPrintExpectedMessage", function()
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

TG:AddFact("GenericTextWriter.WriteFormatted.GivenValidMessage.ShouldPrintExpectedMessage", function()
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
