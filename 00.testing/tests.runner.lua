local U, _setfenv = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local U = _assert(_g.VWoWUnit)

    return U, _setfenv
end)()

_setfenv(1, {})

if U then
    -- _print("Running VWoWUnit tests...\n ")

    -- U.DefaultLogger:ChainSetOption_MinLogLevel(U.ELogLevels.Trace) -- for debugging
    -- U.DefaultLogger:ChainSetOption_MinLogLevel(U.ELogLevels.Error) -- for debugging
    U.DefaultLogger:ChainSetOption_MinLogLevel(U.ELogLevels.Warn) -- for debugging

    U.TestsEngine:RunAllTestGroups()

    -- U.TestsEngine:RunSpecificTest("T002.Inheritance.Subclassing.GivenPlainMixinToBlend.ShouldThrow")

    -- U.TestsEngine:RunSpecificTest("T020.Reflection.IsInstanceOf.GivenVariousDeepInheritancePairs.ShouldReturnExpectedVerdict")

    -- U.TestsEngine:RunTestGroup("System.Guard.Assert.IsBooleanizable")

    -- U.TestsEngine:RunTestGroupsByTag("grouplooting")

    -- U.TestsEngine:RunTestGroupsByTag("guard-check-tablerays")

    -- U.TestsEngine:RunTestGroupsByTag("inheritance")
    
    -- U.TestsEngine:RunTestGroupsByTag("text-writer")

    -- U.TestsEngine:RunTestGroupsByTag("is-instance-of")

    -- U.TestsEngine:RunTestGroupsByTag("is-instance-implementing")

    -- U.TestsEngine:RunTestGroupsByTag("get-info")

    -- U.TestsEngine:RunTestGroupsByTag("fields")
end
