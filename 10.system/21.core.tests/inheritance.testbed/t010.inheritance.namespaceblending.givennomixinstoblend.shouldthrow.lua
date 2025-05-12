local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local U = using "[built-in]" [[ VWoWUnit ]] -- @formatter:on         

Scopify(EScopes.Function, {})

local TG = U.TestsEngine:CreateOrUpdateGroup { Name = "System.Core.Tests.InheritanceTestbed" }

Scopify(EScopes.Function, {})

-- todo   add tests for Reflection.IsInstanceOf(<instance>, <proto>) + associated Guards
-- todo   add tests for Reflection.Is(<instance>, <proto>) + associated Guards
-- todo   add tests for Reflection.IsImplementingInterface(<instance>, <interface-proto>) + associated Guards
--
-- todo   figure out what do with static-base-utility-methods that are defined as Bar.SomeMethod(someString) instead of Bar:SomeMethod(someString) <- we have a problem here!
-- todo         solution#1 store them in .blendxinRaw and in .asBlendxinRaw
-- todo         solution#2 refactor the entire codebase so that it supports static utility-methods under Class._.* while also supporting static classes through [declare] [static] [class]
-- todo                    thus enabling us to treat static classes specially when blending them!
-- todo   co-store the actual symbol-protos inside the .asBlendxin table!
-- todo   add support and tests for .CastAs(), .IsCastableAs(), .TryCastAs()
-- todo   figure out what to do with the inheritance of the __tostring() method from the base class (is it a static method or what?) 
-- todo   support passing arrays too for the mixins (as nameless mixins)

TG:AddFact("T005.Inheritance.NamespaceBlending.GivenRawRogueObjectToBlend.ShouldThrowExceptionAboutNotBeingBlendable",
        function()
            -- ARRANGE

            -- ACT
            function action()
                _ = using "[declare] [blend]" "T005.Inheritance.NamespaceBlending.GivenRawRogueObjectToBlend.ShouldThrowExceptionAboutNotBeingBlendable" {
                    ["Bar"] = {
                        a = 1,
                        b = 2,
                    },
                }
            end

            -- ASSERT
            U.Should.Throw(action)
        end
)

TG:AddFact("T006.Inheritance.NamespaceBlending.GivenTagInterfaceToBlend.ShouldWork",
        function()
            -- ARRANGE
            local Foobar
            local FoobarInstance

            -- ACT
            function action()
                local IPingInterface = using "[declare] [interface]" "T006.Inheritance.NamespaceBlending.GivenTagInterfaceToBlend.ShouldWork.IPingInterface"
                
                Foobar = using "[declare] [blend]" "T006.Inheritance.NamespaceBlending.GivenTagInterfaceToBlend.ShouldWork.Foobar" {
                    ["IPingInterface"] = IPingInterface,
                }

                function Foobar:New()
                    Scopify(EScopes.Function, self)

                    return self:Instantiate({
                        b = 10,
                    })
                end

                FoobarInstance = Foobar:New()
            end

            -- ASSERT
            U.Should.Not.Throw(action)
            
            U.Should.Be.PlainlyEqual(FoobarInstance.b, 10) -- should be unaffected
            
            U.Should.Not.Be.Nil(FoobarInstance.blendxin) --   we do allow interfaces to provide default implementations like in
            U.Should.Not.Be.Nil(FoobarInstance.asBlendxin) -- the latest versions of C# and Java so these members should not be nil
        end
)

--TG:AddFact("T006.Inheritance.NamespaceBlending.GivenBlendingInTwoSeparateSteps.ShouldWork",
--        function()
--            -- ARRANGE
--            local Foobar
--
--            -- ACT
--            function action()
--                local FoobarBlender = using "[declare] [blend]" "T006.Inheritance.NamespaceBlending.GivenBlendingInTwoSeparateSteps.ShouldWork"
--
--                Foobar = FoobarBlender {
--                    ["IBar"] = {
--                        a = 1,
--                    },
--                }
--            end
--
--            -- ASSERT
--            U.Should.Not.Throw(action)
--
--            U.Should.Not.Be.Nil(Foobar.blendxin)
--            U.Should.Not.Be.Nil(Foobar.asBlendxin)
--
--            U.Should.Be.PlainlyEqual(Foobar.a, 1)
--            U.Should.Be.PlainlyEqual(Foobar.blendxin.a, 1)
--            U.Should.Be.PlainlyEqual(Foobar.asBlendxin.IBar.a, 1)
--        end
--)
--
--TG:AddFact("T006.Inheritance.NamespaceBlending.GivenNamelessBlending.ShouldWork",
--        function()
--            -- ARRANGE
--            local Foobar
--
--            -- ACT
--            function action()
--                Foobar = using "[declare] [blend]" "T006.Inheritance.NamespaceBlending.GivenNamelessBlending.ShouldWork" {
--                    [""] = {
--                        a = 1,
--                    },
--                }
--            end
--
--            -- ASSERT
--            U.Should.Not.Throw(action)
--
--            U.Should.Not.Be.Nil(Foobar.blendxin)
--            U.Should.Not.Be.Nil(Foobar.asBlendxin)
--
--            U.Should.Be.PlainlyEqual(Foobar.a, 1)
--            U.Should.Be.PlainlyEqual(Foobar.blendxin.a, 1)
--            U.Should.Be.Equivalent(Foobar.asBlendxin, {}) -- since we don't have a name the .asBlendxin should be empty
--        end
--)
--
--TG:AddFact("T006.Inheritance.NamespaceBlending.GivenDudMixinBlending.ShouldThrow",
--        function()
--            -- ARRANGE
--            local Foobar
--
--            -- ACT
--            function action()
--                Foobar = using "[declare] [blend]" "T006.Inheritance.NamespaceBlending.GivenDudMixinBlending.ShouldThrow" {
--                    ["IDud"] = { },
--                }
--            end
--
--            -- ASSERT
--            U.Should.Throw(action)
--        end
--)
--
--TG:AddFact("T007.Inheritance.NamespaceBlending.GivenComplexBlending.ShouldWork",
--        function()
--            -- ARRANGE
--            local Foobar
--
--            -- ACT
--            function action()
--                Foobar = using "[declare] [blend]" "T007.Inheritance.NamespaceBlending.GivenComplexBlending.ShouldWork" {
--                    [""] = { -- this should be ok    it means "blend it in but don't add it under to the .asBlendxin[] table"
--                        a = 1,
--                    },
--                    ["IBar"] = { -- this should be ok
--                        b = 1,
--                    },
--                    ["IBar"] = { -- this should be ok
--                        b = 2,
--                        c = 2,
--                    },
--                    ["IPing"] = { -- this should be ok
--                        c = 3,
--                    },
--                }
--            end
--
--            -- ASSERT
--            U.Should.Not.Throw(action)
--
--            U.Should.Not.Be.Nil(Foobar.blendxin)
--            U.Should.Not.Be.Nil(Foobar.asBlendxin)
--
--            U.Should.Be.PlainlyEqual(Foobar.a, 1)
--            U.Should.Be.PlainlyEqual(Foobar.b, 2)
--            U.Should.Be.PlainlyEqual(Foobar.c, 3)
--
--            U.Should.Be.Equivalent(Foobar.blendxin, {
--                a = 1,
--                b = 2,
--                c = 3,
--            })
--
--            U.Should.Be.Equivalent(Foobar.asBlendxin.IBar, {
--                b = 2,
--                c = 2,
--            })
--
--            U.Should.Be.Equivalent(Foobar.asBlendxin.IPing, {
--                c = 3,
--            })
--        end
--)
--
--TG:AddFact("T020.Inheritance.NamespaceBlending.GivenEmptyNamedMixinsTableToBlend.ShouldThrow",
--        function()
--            -- ARRANGE
--
--            -- ACT
--            function action()
--                using "[declare] [blend]" "T020.Inheritance.NamespaceBlending.GivenEmptyNamedMixinsTableToBlend.ShouldThrow" {}
--            end
--
--            -- ASSERT
--            U.Should.Throw(action)
--        end
--)
--
--TG:AddFact("T030.Inheritance.NamespaceBlending.GivenPlainMixinToBlend.ShouldThrow",
--        function()
--            -- ARRANGE
--
--            -- ACT
--            function action()
--                using "[declare] [blend]" "T030.Inheritance.NamespaceBlending.GivenPlainMixinToBlend.ShouldThrow" { a = 1 }
--            end
--
--            -- ASSERT
--            U.Should.Throw(action)
--        end
--)
--
--TG:AddFact("T040.Inheritance.NamespaceBlending.GivenPlainMixinToBlend.ShouldThrow",
--        function()
--            -- ARRANGE
--
--            -- ACT
--            function action()
--                using "[declare] [blend]" "T040.Inheritance.NamespaceBlending.GivenPlainMixinToBlend.ShouldThrow" { a = 1 }
--            end
--
--            -- ASSERT
--            U.Should.Throw(action)
--        end
--)
