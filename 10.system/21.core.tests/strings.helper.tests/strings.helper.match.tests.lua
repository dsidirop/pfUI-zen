local _setfenv, _importer, _VWoWUnit = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _VWoWUnit = _assert(_g.VWoWUnit)
    local _importer = _assert(_g.pvl_namespacer_get)

    return _setfenv, _importer, _VWoWUnit
end)()

_setfenv(1, {})

local StringsHelper = _importer("System.Helpers.Strings")

local TestsGroup = _VWoWUnit.I:CreateOrUpdateGroup { Name = "System.Helpers.Strings" }

TestsGroup:AddTheory("StringsHelper.Match.GivenGreenInput.ShouldMatchExpectedResults",
        {
            ["SH.M.GGI.SMER.0000"] = {
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
            _VWoWUnit.AreEqual(chunks, options.ExpectedChunks)
        end
)
