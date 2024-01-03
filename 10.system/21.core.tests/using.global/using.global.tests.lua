local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Global = using "System.Global"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Validation = using "System.Validation"

-- DO NOT EMPLOY   using "[global]"   HERE BECAUSE IT IS WHAT WE ARE ACTUALLY TESTING!!  
local _unpack = Validation.Assert(Global.unpack)
local _getfenv = Validation.Assert(Global.getfenv)
local _tableSort = Validation.Assert(Global.table.sort)
local _tableInsert = Validation.Assert(Global.table.insert)

local U = Validation.Assert(Global.VWoWUnit)

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup {
    Name = "using [global]",
    Tags = { "system", "using", "global" },
}

Scopify(EScopes.Function, {})

TestsGroup:AddFact("using.global.GivenNoArguments.ShouldThrow", function()
    -- ACT + ASSERT
    U.Should.Throw(function()
        using "[global]"()
    end)
end)

TestsGroup:AddFact("using.global.GivenTwoSymbolNames.ShouldReturnTwoSymbols",
        function()
            -- ACT
            local unpack, tableInsert = U.Should.Not.Throw(function()
                return using "[global]" ("unpack", "table.insert")
            end)

            -- ASSERT
            U.Should.Be.Equivalent({ unpack, tableInsert }, { _unpack, _tableInsert })
        end
)

TestsGroup:AddTheory("using.global.GivenGreenArguments.ShouldReturnExpectedGlobalSymbols",
        {
            ["UG.GGA.SREGS.0000"] = {
                SymbolNames = { "getfenv" },
                ExpectedResults = { _getfenv },
            },
            ["UG.GGA.SREGS.0010"] = {
                SymbolNames = { "getfenv", "unpack" },
                ExpectedResults = { _getfenv, _unpack },
            },
            ["UG.GGA.SREGS.0020"] = {
                SymbolNames = { "table.sort", "table.insert" },
                ExpectedResults = { _tableSort, _tableInsert },
            },
        },
        function(options)
            -- ARRANGE
            -- ...
            
            -- ACT
            local results = U.Should.Not.Throw(function()
                return {using "[global]" (_unpack(options.SymbolNames))} 
            end)
            
            -- ASSERT
            U.Should.Be.Equivalent(results, options.ExpectedResults)
        end
)

TestsGroup:AddTheory("using.global.GivenRedArguments.ShouldThrow",
        {
            ["UG.GRA.ST.0000"] = { SymbolNames = { "getfenv2" } },
            ["UG.GRA.ST.0010"] = { SymbolNames = { "getfenv", "unpack2" } },
            ["UG.GRA.ST.0020"] = { SymbolNames = { "table2.sort" } },
            ["UG.GRA.ST.0030"] = { SymbolNames = { "table.sort2" } },
        },
        function(options)
            -- ACT + ASSERT
            U.Should.Throw(function()
                return using "[global]" (_unpack(options.SymbolNames))
            end)
        end
)
