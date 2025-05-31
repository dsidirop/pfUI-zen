local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Metatable = using "System.Classes.Metatable"

local U = using "[built-in]" [[ VWoWUnit ]] -- @formatter:on         

local TG = U.TestsEngine:CreateOrUpdateGroup { Name = "System.Core.Tests.Classes.Inheritance.Testbed" }

Scopify(EScopes.Function, {})

TG:AddFact("T010.Inheritance.Subclassing.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork",
        function()
            -- ARRANGE
            local FoobarInstance

            -- ACT
            function action()
                -------

                do
                    local _ = using "[declare] [interface]" "T010.Inheritance.Subclassing.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.IPingTagInterface"
                end
                
                -------

                do
                    local Fields = using "System.Classes.Fields"

                    local Class = using "[declare]" "T010.Inheritance.Subclassing.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.Zong"

                    Class._.W = 1 -- statics
                    Class._.F = 2
                    
                    function Class:New()
                        Scopify(EScopes.Function, self)

                        return self:Instantiate()
                    end

                    Fields(function(upcomingInstance)
                        upcomingInstance._a = 1
                        upcomingInstance._b = 2
                        
                        return upcomingInstance
                    end)

                    function Class:Zang()
                        return true
                    end
                end

                -------

                do
                    local Fields = using "System.Classes.Fields"
                    
                    local Zong = using "T010.Inheritance.Subclassing.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.Zong"
                    local IPing = using "T010.Inheritance.Subclassing.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.IPingTagInterface"
                    
                    local Class = using "[declare] [blend]" "T010.Inheritance.Subclassing.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.Foobar" {
                        ["Zong"]  = Zong,
                        ["IPing"] = IPing,
                    }

                    function Class:New()
                        Scopify(EScopes.Function, self)

                        U.Should.Be.True(self.__index == self)
                        U.Should.Not.Be.Nil(self.blendxin)
                        U.Should.Not.Be.Nil(self.asBlendxin)
                        U.Should.Not.Be.Nil(self.asBlendxin.Zong)
                        
                        local newInstance = self:Instantiate() -- order  calls the field-pluggers automatically

                        U.Should.Be.PlainlyEqual(newInstance._a, 1)
                        U.Should.Be.PlainlyEqual(newInstance._b, 10)
                        
                        U.Should.Be.True(Metatable.Get(newInstance).__index == Metatable.Get(newInstance))
                        U.Should.Not.Be.Nil(Metatable.Get(newInstance))
                        U.Should.Not.Be.Nil(Metatable.Get(newInstance).blendxin)
                        U.Should.Not.Be.Nil(Metatable.Get(newInstance).asBlendxin)
                        U.Should.Not.Be.Nil(Metatable.Get(newInstance).asBlendxin.Zong)
                        U.Should.Not.Be.Nil(newInstance.blendxin)
                        U.Should.Not.Be.Nil(newInstance.asBlendxin)

                        newInstance = newInstance.asBlendxin.Zong.New(newInstance) --     order   notice that we are calling it as .New() instead of :New()
                        -- newInstance = newInstance.asBlendxin.Bram.New(newInstance) --  order   that is intentional because we want to call the base constructor

                        newInstance._sum = newInstance._a + newInstance._b -- finally the constructor can work its own magic after all super-constructors have been invoked above

                        return newInstance
                    end

                    Fields(function(upcomingInstance)
                        upcomingInstance._b = 10
                        upcomingInstance._sum = 0
                        return upcomingInstance
                    end)
                end
                
                ------

                do
                    local Foobar = using "T010.Inheritance.Subclassing.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.Foobar"
                    
                    FoobarInstance = Foobar:New()    
                end                
            end

            -- ASSERT
            U.Should.Not.Throw(action)

            U.Should.Be.PlainlyEqual(FoobarInstance._a, 1)
            U.Should.Be.PlainlyEqual(FoobarInstance._b, 10)
            U.Should.Be.PlainlyEqual(FoobarInstance._sum, 11)

            local ZongProto = using "T010.Inheritance.Subclassing.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.Zong"
            U.Should.Be.PlainlyEqual(FoobarInstance._.W, ZongProto._.W)
            U.Should.Be.PlainlyEqual(FoobarInstance._.F, ZongProto._.F)

            U.Should.Not.Be.Nil(FoobarInstance.blendxin) --   we do allow interfaces to provide default implementations like in
            U.Should.Not.Be.Nil(FoobarInstance.asBlendxin) -- the latest versions of C# and Java so these members should not be nil

            U.Should.Be.Nil(FoobarInstance.asBlendxin.Zong._a) -- these members should never be
            U.Should.Be.Nil(FoobarInstance.asBlendxin.Zong._b) -- initialized at the proto level

            U.Should.Not.Be.Nil(FoobarInstance.asBlendxin.Zong)
            U.Should.Not.Be.Nil(FoobarInstance.asBlendxin.Zong.Zang)
            U.Should.Not.Be.Nil(FoobarInstance.asBlendxin.IPing)
        end
)
