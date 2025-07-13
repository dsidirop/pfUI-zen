--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Reflection = using "System.Reflection"

local TG, U = using "[testgroup] [tagged]" "System.Core.Tests.Reflection.TryGetNamespaceIfClassProto.Testbed" { "system", "core", "reflection", "get-namespace" }

TG:AddDynamicTheory("T000.Reflection.TryGetNamespaceIfClassProto.GivenVariousGreenValues.ShouldReturnCorrectTypes", -- @formatter:off
        function()
            return {
                ["REF.GNICP.GVGV.SRCT.0000"] = {
                    Value    = (using "[declare]" "T000.Reflection.TryGetNamespaceIfClassProto.GivenVariousGreenValues.ShouldReturnCorrectTypes.Class"),
                    Expected =                    "T000.Reflection.TryGetNamespaceIfClassProto.GivenVariousGreenValues.ShouldReturnCorrectTypes.Class"
                },
                ["REF.GNICP.GVGV.SRCT.0010"] = {
                    Value    = (using "[declare] [static]" "T000.Reflection.TryGetNamespaceIfClassProto.GivenVariousGreenValues.ShouldReturnCorrectTypes.StaticClass"),
                    Expected =                             "T000.Reflection.TryGetNamespaceIfClassProto.GivenVariousGreenValues.ShouldReturnCorrectTypes.StaticClass"
                },
                ["REF.GNICP.GVGV.SRCT.0020"] = {
                    Value    = (using "[declare] [abstract]" "T000.Reflection.TryGetNamespaceIfClassProto.GivenVariousGreenValues.ShouldReturnCorrectTypes.AbstractClass"),
                    Expected =                               "T000.Reflection.TryGetNamespaceIfClassProto.GivenVariousGreenValues.ShouldReturnCorrectTypes.AbstractClass"
                },
                ["REF.GNICP.GVGV.SRCT.0030"] = {
                    Value    = (using "[declare] [blend]" "T000.Reflection.TryGetNamespaceIfClassProto.GivenVariousGreenValues.ShouldReturnCorrectTypes.SubClass" {
                                            "IPing", using "[declare] [interface]" "T000.Reflection.TryGetNamespaceIfClassProto.GivenVariousGreenValues.ShouldReturnCorrectTypes.IPing"
                    }),
                    Expected =                            "T000.Reflection.TryGetNamespaceIfClassProto.GivenVariousGreenValues.ShouldReturnCorrectTypes.SubClass"
                },
                ["REF.GNICP.GVGV.SRCT.0040"] = {
                    Value    = (using "[declare] [interface]" "T000.Reflection.TryGetNamespaceIfClassProto.GivenVariousGreenValues.ShouldReturnCorrectTypes.IInterface"),
                    Expected = nil
                },
                ["REF.GNICP.GVGV.SRCT.0050"] = {
                    Value    = (using "[declare] [enum]" "T000.Reflection.TryGetNamespaceIfClassProto.GivenVariousGreenValues.ShouldReturnCorrectTypes.Enum"),
                    Expected = nil
                },
            }
        end, -- @formatter:on
        function(options)
            -- ARRANGE
            local namespace

            -- ACT
            U.Should.Not.Throw(function()
                namespace = Reflection.TryGetNamespaceIfClassProto(options.Value)
            end)

            -- ASSERT
            U.Should.Be.PlainlyEqual(namespace, options.Expected)
        end
)
