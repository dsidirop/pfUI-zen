local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local U = using "[built-in]" [[ VWoWUnit ]] -- @formatter:on         

local TG = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Core.Tests.Classes.Fields.Testbed",
    Tags = { "system", "system-core", "classes", "fields" }
}

Scopify(EScopes.Function, {})

TG:AddTheory("T020.Classes.Fields.GivenFieldSetterOnInvalidSymbol.ShouldThrow",
        {
            ["FDS.GFSOIS.ST.0000"] = { SymbolDeclaration = "[declare] [enum]" },
            ["FDS.GFSOIS.ST.0010"] = { SymbolDeclaration = "[declare] [static]" },
            ["FDS.GFSOIS.ST.0020"] = { SymbolDeclaration = "[declare] [interface]" },
        },
        function(specs, subtestCaseNickname)
            -- ARRANGE

            -- ACT
            function action()
                local Fields = using "System.Classes.Fields"

                local Class = using(specs.SymbolDeclaration)("T020.Classes.Fields.GivenFieldSetterOnInvalidSymbol.ShouldThrow." .. subtestCaseNickname)

                Fields(function(upcomingInstance) -- we allow multiple field-setters to co-exist
                    upcomingInstance._field1 = 42 -- overrides the previous value
                    upcomingInstance._field2 = "Hello, World!"
                    return upcomingInstance
                end)

                function Class:New()
                    return self:Instantiate()
                end

                return Class:New()
            end

            -- ASSERT
            U.Should.Throw(action, "*[NR.ENT.CSFPFFNSCP.020]*")
        end
)
