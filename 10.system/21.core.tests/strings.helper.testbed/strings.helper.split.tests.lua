local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local StringsHelper = using "System.Helpers.Strings"

local TG, U = using "[testgroup]" "System.Helpers.Strings"

TG:AddTheory("StringsHelper.Split.GivenGreenInput.ShouldMatchExpectedResults",
        {
            ["SH.S.GGI.SMER.0000"] = {
                Input = "Hello World Once Again",
                Delimiter = nil, -- default delimiter is ","
                MaxChunksCount = nil,
                ExpectedChunks = { "Hello World Once Again" }
            },
            ["SH.S.GGI.SMER.0005"] = {
                Input = "Hello World,Once,Again",
                Delimiter = nil, -- default delimiter is ","
                MaxChunksCount = nil,
                ExpectedChunks = { "Hello World", "Once", "Again" },
            },
            ["SH.S.GGI.SMER.0008"] = {
                Input = "Hello World,Once,Again",
                Delimiter = nil, -- default delimiter is ","
                MaxChunksCount = 2,
                ExpectedChunks = { "Hello World", "Once" }
            },
            ["SH.S.GGI.SMER.0010"] = {
                Input = "Hello World\nOnce\nAgain",
                Delimiter = "\n",
                MaxChunksCount = nil,
                ExpectedChunks = { "Hello World", "Once", "Again" },
            },
            ["SH.S.GGI.SMER.0020"] = {
                Input = "Hello World\nOnce\nAgain",
                Delimiter = "\n",
                MaxChunksCount = 2,
                ExpectedChunks = { "Hello World", "Once" }
            },
        },
        function(options)
            -- ARRANGE

            -- ACT
            local chunks = StringsHelper.Split(options.Input, options.Delimiter, options.MaxChunksCount)
            
            -- ASSERT
            U.Should.Be.Equivalent(chunks, options.ExpectedChunks)
        end
)
