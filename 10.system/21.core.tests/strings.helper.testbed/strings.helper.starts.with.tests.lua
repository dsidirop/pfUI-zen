--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local StringsHelper = using "System.Helpers.Strings"

local TG, U = using "[testgroup]" "System.Helpers.Strings"

TG:AddTheory("StringsHelper.StartsWith.GivenVariousInputs.ShouldMatchExpectedResults",
        {
            ["SH.SW.GVI.SMER.0000"] = {
                Input = "abc",
                Prefix = "abc",
                ExpectedResult = true,
            },
            ["SH.SW.GVI.SMER.0010"] = {
                Input = "abc",
                Prefix = "ab",
                ExpectedResult = true,
            },
            ["SH.SW.GVI.SMER.0020"] = {
                Input = "abc",
                Prefix = "a",
                ExpectedResult = true,
            },
            ["SH.SW.GVI.SMER.0030"] = {
                Input = "abc",
                Prefix = "abcd",
                ExpectedResult = false,
            },
            ["SH.SW.GVI.SMER.0040"] = {
                Input = "abc",
                Prefix = "",
                ExpectedResult = true,
            },
            ["SH.SW.GVI.SMER.0050"] = {
                Input = "",
                Prefix = "",
                ExpectedResult = true,
            },
            ["SH.SW.GVI.SMER.0060"] = {
                Input = "",
                Prefix = "a",
                ExpectedResult = false,
            },
            ["SH.SW.GVI.SMER.0070"] = {
                Input = "ab",
                Prefix = "b",
                ExpectedResult = false,
            },
        },
        function(options)
            -- ARRANGE

            -- ACT
            local result = StringsHelper.StartsWith(options.Input, options.Prefix)

            -- ASSERT
            U.Should.Be.PlainlyEqual(result, options.ExpectedResult)
        end
)
