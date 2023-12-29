local U, _setfenv, _importer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local U = _assert(_g.VWoWUnit)
    local _importer = _assert(_g.pvl_namespacer_get)

    return U, _setfenv, _importer
end)()

_setfenv(1, {})

local StringsHelper = _importer("System.Helpers.Strings")

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup { Name = "System.Helpers.Strings" }

TestsGroup:AddTheory("StringsHelper.Split.GivenGreenInput.ShouldMatchExpectedResults",
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
