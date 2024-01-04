local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local U = using "[built-in]" "VWoWUnit"
local B = using "[built-ins]" "NativeSubstringViaRange = string.sub"

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local StringsHelper = using "System.Helpers.Strings"

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup { Name = "System.Helpers.Strings" }

Scopify(EScopes.Function, {})

TestsGroup:AddTheory("StringsHelper.SubstringViaRange.GivenGreenInput.ShouldMatchExpectedResults",
        {
            ["SH.SVR.GGI.SMER.0000"] = {
                Input = "",
                StartIndex = 1,
                EndingIndex = 2,
            },
            ["SH.SVR.GGI.SMER.0010"] = {
                Input = "123456",
                StartIndex = 1,
                EndingIndex = 2,
            },
            ["SH.SVR.GGI.SMER.0020"] = {
                Input = "123456",
                StartIndex = 2,
                EndingIndex = nil,
            },
            ["SH.SVR.GGI.SMER.0030"] = {
                Input = "123456",
                StartIndex = 10,
                EndingIndex = nil,
            },
            ["SH.SVR.GGI.SMER.0040"] = {
                Input = "123456",
                StartIndex = 5,
                EndingIndex = 2,
            },
        },
        function(options)
            -- ARRANGE
            local expectedResult = B.NativeSubstringViaRange(options.Input, options.StartIndex, options.EndingIndex)

            -- ACT
            local substring = U.Should.Not.Throw(function()
                return StringsHelper.SubstringViaRange(options.Input, options.StartIndex, options.EndingIndex)
            end)

            -- ASSERT
            U.Should.Be.Equivalent(substring, expectedResult)
        end
)

TestsGroup:AddTheory("StringsHelper.SubstringViaRange.GivenRedInput.ShouldErrorOut",
        {
            ["SH.SVR.GRI.SMER.0000"] = {
                Input = nil,
                StartIndex = nil,
            },
            ["SH.SVR.GRI.SMER.0010"] = {
                Input = "123456",
                StartIndex = nil,
            },
            ["SH.SVR.GRI.SMER.0020"] = {
                Input = "123456",
                StartIndex = -10,
            },
            ["SH.SVR.GRI.SMER.0030"] = {
                Input = "123456",
                StartIndex = 0, -- must be >= 1
            },
            ["SH.SVR.GRI.SMER.0040"] = {
                Input = "123456",
                StartIndex = -1, -- must be >= 1
            },
            ["SH.SVR.GRI.SMER.0050"] = {
                Input = "123456",
                StartIndex = 1,
                EndingIndex = 0, -- must be >= 1
            },
            ["SH.SVR.GRI.SMER.0060"] = {
                Input = "123456",
                StartIndex = 1,
                EndingIndex = -1, -- must be >= 1
            },
        },
        function(options)
            -- ACT + ASSERT
            U.Should.Throw(function()
                return StringsHelper.SubstringViaRange(options.Input, options.StartIndex, options.EndingIndex)
            end)
        end
)
