local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Metatable = using "System.Classes.Metatable"

local U = using "[built-in]" [[ VWoWUnit ]] -- @formatter:on         

Scopify(EScopes.Function, {})

local TG = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Core.Tests.InheritanceTestbed",
    Tags = { "system", "system-core", "inheritance" }
}

Scopify(EScopes.Function, {})

-- todo   add tests for Reflection.IsInstanceOf(<instance>, <proto>) + associated Guards
-- todo   add tests for Reflection.Is(<instance>, <proto>) + associated Guards
-- todo   add tests for Reflection.IsImplementingInterface(<instance>, <interface-proto>) + associated Guards
-- todo   add support + tests for .CastAs(), .IsCastableAs(), .TryCastAs()
--
-- todo   figure out what to do with the inheritance of the __tostring() method from the base class (is it a static method or what?) 
-- todo   support passing arrays too for the mixins (as nameless mixins)

TG:AddFact("T005.Inheritance.NamespaceBlending.GivenRawRogueObjectToBlend.ShouldThrowExceptionAboutNotBeingBlendable",
        function()
            -- ARRANGE

            -- ACT
            function action()
                _ = using "[declare] [blend]" "T005.Inheritance.NamespaceBlending.GivenRawRogueObjectToBlend.ShouldThrowExceptionAboutNotBeingBlendable.Foo" {
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

TG:AddFact("T006.Inheritance.NamespaceBlending.GivenNoMixins.ShouldThrowException",
        function()
            -- ARRANGE

            -- ACT
            function action()
                _ = using "[declare] [blend]" "T006.Inheritance.NamespaceBlending.GivenNoMixins.ShouldThrowException.Foo" { }
            end

            -- ASSERT
            U.Should.Throw(action)
        end
)

TG:AddFact("T007.Inheritance.NamespaceBlending.GivenCircularDependencyBlendingAttempt.ShouldThrowException",
        function()
            -- ARRANGE
            do
                local Foo = using "[declare]" "T007.Inheritance.NamespaceBlending.GivenCircularDependencyBlendingAttempt.ShouldThrowException.Foo [Partial]"

                local _ = using "[declare] [blend]" "T007.Inheritance.NamespaceBlending.GivenCircularDependencyBlendingAttempt.ShouldThrowException.Bar" {
                    ["Foo"] = Foo,
                }
            end

            -- ACT
            function action()
                local Bar = using "T007.Inheritance.NamespaceBlending.GivenCircularDependencyBlendingAttempt.ShouldThrowException.Bar"

                local Foo = using "[declare] [blend]" "T007.Inheritance.NamespaceBlending.GivenCircularDependencyBlendingAttempt.ShouldThrowException.Foo" {
                    ["Bar"] = Bar,
                }
            end

            -- ASSERT
            U.Should.Throw(action)
        end
)

TG:AddFact("T006.Inheritance.NamespaceBlending.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork",
        function()
            -- ARRANGE
            local FoobarInstance

            -- ACT
            function action()
                -------

                do
                    local _ = using "[declare] [interface]" "T006.Inheritance.NamespaceBlending.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.IPingTagInterface"
                end
                
                -------

                do
                    local Class = using "[declare]" "T006.Inheritance.NamespaceBlending.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.Zong"

                    function Class:New()
                        Scopify(EScopes.Function, self)

                        return self:Instantiate(Class._.EnrichNakedInstanceWithFields())
                    end

                    local BaseEnrichNakedInstanceWithFields = Class._.EnrichNakedInstanceWithFields -- autoset by the using() statement
                    function Class._.EnrichNakedInstanceWithFields(allocatedInstance)
                        allocatedInstance = BaseEnrichNakedInstanceWithFields(allocatedInstance)

                        allocatedInstance._a = 1
                        allocatedInstance._b = 2
                        
                        return allocatedInstance
                    end

                    function Class:Zang()
                        return true
                    end
                end

                -------

                do
                    local Zong = using "T006.Inheritance.NamespaceBlending.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.Zong"
                    local IPing = using "T006.Inheritance.NamespaceBlending.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.IPingTagInterface"
                    
                    local Class = using "[declare] [blend]" "T006.Inheritance.NamespaceBlending.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.Foobar" {
                        ["Zong"]  = Zong,
                        ["IPing"] = IPing,
                    }

                    function Class:New()
                        Scopify(EScopes.Function, self)

                        U.Should.Be.True(self.__index == self)
                        U.Should.Not.Be.Nil(self.blendxin)
                        U.Should.Not.Be.Nil(self.asBlendxin)
                        U.Should.Not.Be.Nil(self.asBlendxin.Zong)
                        
                        local newInstance = self:Instantiate(self._.EnrichNakedInstanceWithFields()) -- order

                        U.Should.Be.True(Metatable.Get(newInstance).__index == Metatable.Get(newInstance))
                        U.Should.Not.Be.Nil(Metatable.Get(newInstance))
                        U.Should.Not.Be.Nil(Metatable.Get(newInstance).blendxin)
                        U.Should.Not.Be.Nil(Metatable.Get(newInstance).asBlendxin)
                        U.Should.Not.Be.Nil(Metatable.Get(newInstance).asBlendxin.Zong)
                        U.Should.Not.Be.Nil(newInstance.blendxin)
                        U.Should.Not.Be.Nil(newInstance.asBlendxin)

                        newInstance = newInstance.asBlendxin.Zong.New(self) --     order    todo   test this approach out
                        -- newInstance = newInstance.asBlendxin.Bram.New(self) --  order
                        -- newInstance = newInstance.asBlendxin.Trong.New(self) -- order

                        newInstance._b = 10 -- finally the constructor can work its own magic after all super-constructors have been invoked above
                        
                        return newInstance
                    end

                    local BaseEnrichNakedInstanceWithFields = Class._.EnrichNakedInstanceWithFields -- autoset by the using() statement
                    function Class._.EnrichNakedInstanceWithFields(allocatedInstance)
                        Scopify(EScopes.Function, Class)

                        allocatedInstance = BaseEnrichNakedInstanceWithFields(allocatedInstance) -- order
                        allocatedInstance._b = 0 -- order

                        return allocatedInstance
                    end
                end
                
                ------

                do
                    local Foobar = using "T006.Inheritance.NamespaceBlending.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.Foobar"
                    
                    FoobarInstance = Foobar:New()    
                end                
            end

            -- ASSERT
            U.Should.Not.Throw(action)

            U.Should.Be.PlainlyEqual(FoobarInstance._a, 1)
            U.Should.Be.PlainlyEqual(FoobarInstance._b, 10) -- should be unaffected

            U.Should.Not.Be.Nil(FoobarInstance.blendxin) --   we do allow interfaces to provide default implementations like in
            U.Should.Not.Be.Nil(FoobarInstance.asBlendxin) -- the latest versions of C# and Java so these members should not be nil

            U.Should.Be.Nil(FoobarInstance.asBlendxin.Zong._a) -- these members should never be
            U.Should.Be.Nil(FoobarInstance.asBlendxin.Zong._b) -- initialized at the proto level

            U.Should.Not.Be.Nil(FoobarInstance.asBlendxin.Zong)
            U.Should.Not.Be.Nil(FoobarInstance.asBlendxin.Zong.Zang)
            U.Should.Not.Be.Nil(FoobarInstance.asBlendxin.IPing)
        end
)

-- todo   disabled for now because we need to figure out how to blend-in the base constructor
--TG:AddFact("T006.Inheritance.NamespaceBlending.GivenTagInterfaceToBlendDynamicallyAtRuntime.ShouldWork",
--        function()
--            -- ARRANGE
--            local FoobarInstance
--
--            -- ACT
--            function action()
--                local MixinsBlender = using "System.Classes.Mixins.MixinsBlender"
--
--                local Zong = using "[declare]" "T006.Inheritance.NamespaceBlending.GivenTagInterfaceToBlendDynamicallyAtRuntime.ShouldWork.Zong"
--
--                function Zong:New()
--                    Scopify(EScopes.Function, self)
--
--                    return self:Instantiate({
--                        b = 2,
--                    })
--                end
--                
--                function Zong:Zang()
--                    return true
--                end
--                
--                local IPingTagInterface = using "[declare] [interface]" "T006.Inheritance.NamespaceBlending.GivenTagInterfaceToBlendDynamicallyAtRuntime.ShouldWork.IPingTagInterface"
--
--                local Foobar = using "[declare]" "T006.Inheritance.NamespaceBlending.GivenTagInterfaceToBlendDynamicallyAtRuntime.ShouldWork.Foobar"
--
--                function Foobar:New()
--                    Scopify(EScopes.Function, self)
--                    
--                    -- todo  figure out a way to call the base constructor(s) here
--                    -- todo  self.asBlendxin.Zong:New()
--
--                    return self:Instantiate({
--                        b = 10,
--                    })
--                end
--                
--                -- todo   this needs more thought because we now try to blend-in late and we overwrite the :New() constructor of the child-class causing bugs!! 
--                function Foobar._.BlendAtRuntime()
--                    return MixinsBlender.Blend(Foobar, {
--                        ["Zong"] = Zong,
--                        ["IPingTagInterface"] = IPingTagInterface,
--                    })
--                end
--
--                Foobar._.BlendAtRuntime() --order
--
--                FoobarInstance = Foobar:New() --order
--            end
--
--            -- ASSERT
--            U.Should.Not.Throw(action)
--
--            U.Should.Be.PlainlyEqual(FoobarInstance.b, 10) -- should be unaffected
--
--            U.Should.Not.Be.Nil(FoobarInstance.blendxin) --   we do allow interfaces to provide default implementations like in
--            U.Should.Not.Be.Nil(FoobarInstance.asBlendxin) -- the latest versions of C# and Java so these members should not be nil
--            
--            U.Should.Not.Be.Nil(FoobarInstance.asBlendxin.Zong)
--            U.Should.Not.Be.Nil(FoobarInstance.asBlendxin.Zong.Zang)
--            U.Should.Be.PlainlyEqual(FoobarInstance.asBlendxin.Zong.b, 2)
--            U.Should.Not.Be.Nil(FoobarInstance.asBlendxin.IPingTagInterface)
--        end
--)

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
