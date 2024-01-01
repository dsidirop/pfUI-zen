local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Global = using "System.Global"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Validation = using "System.Validation"

local StringsHelper = using "System.Helpers.Strings"

local U = Validation.Assert(Global.VWoWUnit)
local NativeSubstringViaLength = Validation.Assert(Global.string.sub)

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup { Name = "System.Helpers.Strings" }

Scopify(EScopes.Function, {})

TestsGroup:AddTheory("StringsHelper.SubstringViaLength.GivenGreenInput.ShouldMatchExpectedResults",
        {
            ["SH.SVL.GGI.SMER.0000"] = {
                Input = "",
                StartIndex = 1,
                ChunkLength = 2,
            },
            ["SH.SVL.GGI.SMER.0010"] = {
                Input = "123456",
                StartIndex = 1,
                ChunkLength = 2,
            },
            ["SH.SVL.GGI.SMER.0020"] = {
                Input = "123456",
                StartIndex = 2,
                ChunkLength = 0,
            },
        },
        function(options)
            -- ARRANGE
            local expectedResult = NativeSubstringViaLength(options.Input, options.StartIndex, options.StartIndex + options.ChunkLength - 1)

            -- ACT
            local substring = U.Should.Not.Throw(function()
                return StringsHelper.SubstringViaLength(options.Input, options.StartIndex, options.ChunkLength)
            end)

            -- ASSERT
            U.Should.Be.Equivalent(substring, expectedResult)
        end
)

TestsGroup:AddTheory("StringsHelper.SubstringViaLength.GivenRedInput.ShouldErrorOut",
        {
            ["SH.SVL.GRI.SMER.0000"] = {
                Input = nil,
            },
            ["SH.SVL.GRI.SMER.0010"] = {
                Input = "123456",
                StartIndex = nil,
            },
            ["SH.SVL.GRI.SMER.0015"] = {
                Input = "123456",
                StartIndex = 1,
                ChunkLength = nil,
            },
            ["SH.SVL.GRI.SMER.0020"] = {
                Input = "123456",
                StartIndex = 0, -- must be >= 1
            },
            ["SH.SVL.GRI.SMER.0030"] = {
                Input = "123456",
                StartIndex = -1, -- must be >= 1
            },
            ["SH.SVL.GRI.SMER.0040"] = {
                Input = "123456",
                StartIndex = 1,
                ChunkLength = -1, -- must be >= 1
            },
        },
        function(options)
            -- ACT + ASSERT
            U.Should.Throw(function()
                return StringsHelper.SubstringViaLength(options.Input, options.StartIndex, options.ChunkLength)
            end)
        end
)
