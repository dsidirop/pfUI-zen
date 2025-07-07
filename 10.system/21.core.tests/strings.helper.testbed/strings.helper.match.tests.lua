--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local StringsHelper = using "System.Helpers.Strings"

local TG, U = using "[testgroup]" "System.Helpers.Strings"

TG:AddTheory("StringsHelper.Match.GivenGreenInput.ShouldMatchExpectedResults",
        {
            -- ("ping   Foo 11 bar   pong"):match("Foo %d+ bar")
            ["SH.M.GGI.SMER.0000"] = {
                Input = "ping   Foo 123 bar    pong",
                Pattern = "Foo %d+ bar",
                ExpectedChunks = { "Foo 123 bar" },
            },
            ["SH.M.GGI.SMER.0002"] = {
                Input = "ping   Foo 123 bar    pong",
                Pattern = "Foo (%d+) bar",
                ExpectedChunks = { "123" },
            },
            ["SH.M.GGI.SMER.0005"] = {
                Input = "Hello World\nOnce\nAgain",
                Pattern = "([%w]+)%s([%w]+)%s([%w]+)%s([%w]+)",
                ExpectedChunks = { "Hello", "World", "Once", "Again" },
            },
            ["SH.M.GGI.SMER.0010"] = {
                Input = "Hello World\n-------Once-------\nabc\n-------Again-------\n",
                Pattern = "^[^\n]+\n([%s%S]+)",
                ExpectedChunks = { "-------Once-------\nabc\n-------Again-------\n" },
            },
            ["SH.M.GGI.SMER.0020"] = {
                Input = "-------Once-------\nabc\n-------Again-------",
                Pattern = "^[^\n]*----\n([%s%S]+\n)----[%s%S]*$",
                ExpectedChunks = { "abc\n" },
            },
        },
        function(options)
            -- ARRANGE

            -- ACT
            local chunks = { StringsHelper.Match(options.Input, options.Pattern) }

            -- ASSERT
            U.Should.Be.Equivalent(chunks, options.ExpectedChunks)
        end
)
