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

TestsGroup:AddTheory("StringsHelper.StartsWith.GivenVariousInputs.ShouldMatchExpectedResults",
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
