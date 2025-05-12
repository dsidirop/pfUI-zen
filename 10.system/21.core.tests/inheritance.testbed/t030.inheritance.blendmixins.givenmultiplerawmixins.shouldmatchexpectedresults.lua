local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Scopify       = using "System.Scopify"
local EScopes       = using "System.EScopes"

local U = using "[built-in]" [[ VWoWUnit ]] -- @formatter:on         

Scopify(EScopes.Function, {})

local TG = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Core.Tests.InheritanceTestbed",
    Tags = { "system", "system-core", "inheritance" }
}

Scopify(EScopes.Function, {})

--TG:AddFact("T030.Inheritance.BlendMixins.GivenMultipleRawMixins.ShouldMatchExpectedResults",
--        function()
--            -- ARRANGE
--
--            -- Create an object
--            local playerInstance -- keep this first
--
--            -------
--
--            local FooMovable = using "[declare]" "Foo.Movable"
--            function FooMovable:New()
--                Scopify(EScopes.Function, self)
--
--                return self:Instantiate({
--                    x = 0,
--                    y = 0,
--                })
--            end
--            function FooMovable:Move(x, y)
--                U.Should.Be.PlainlyEqual(self, playerInstance)
--
--                self.x = self.x + x
--                self.y = self.y + y
--            end
--            function FooMovable:Jump()
--                U.Should.Be.PlainlyEqual(self, playerInstance)
--
--                return true
--            end
--            function FooMovable:ShadowStep()
--                U.Should.Not.ReachHere("FooMovable:ShadowStep() should not be reached - the fact that it was means something is amiss with the mixin")
--            end
--            function FooMovable._.AndAnotherStaticUtilityMethodCommonOnBothBaseClasses()
--                U.Should.Not.Be.PlainlyEqual(message, playerInstance)
--
--                return "FooMovable._.AndAnotherStaticUtilityMethodCommonOnBothBaseClasses() "
--            end
--
--            -------
--
--            local BarSpeakable = using "[declare]" "Bar.Speakable"
--            function BarSpeakable:New()
--                Scopify(EScopes.Function, self)
--
--                return self:Instantiate()
--            end
--            function BarSpeakable:Speak(message)
--                U.Should.Be.PlainlyEqual(self, playerInstance)
--
--                return "Speakable: " .. message
--            end
--            function BarSpeakable._.SomeStaticUtilityMethod(message)
--                U.Should.Not.Be.PlainlyEqual(message, playerInstance)
--
--                return message
--            end
--            function BarSpeakable._.AnotherStaticUtilityMethod(message)
--                U.Should.Not.Be.PlainlyEqual(message, playerInstance)
--
--                return message
--            end
--            function BarSpeakable._.AndAnotherStaticUtilityMethodCommonOnBothBaseClasses()
--                U.Should.Not.Be.PlainlyEqual(message, playerInstance)
--
--                return "BarSpeakable._.AndAnotherStaticUtilityMethodCommonOnBothBaseClasses() "
--            end
--
--            -------
--
--            local Player = using "[declare] [blend]" "Game.Player" { -- apply both mixins with explicit names
--                ["IMovable"]   = FooMovable,
--                ["ISpeakable"] = BarSpeakable
--            }
--
--            function Player:New()
--                Scopify(EScopes.Function, self)
--
--                return self:Instantiate({ })
--            end
--
--            -- override the move method and call base-methods using self.asBlendxin.*
--            function Player:Move(x, y)
--                U.Should.Be.PlainlyEqual(self, playerInstance)
--
--                self.asBlendxin.IMovable:Move(x, y)
--                return self.asBlendxin.ISpeakable:Speak("I moved to (" .. x .. ", " .. y .. ")")
--            end
--
--            -- completely overrides the base method
--            function Player:ShadowStep()
--                U.Should.Be.PlainlyEqual(self, playerInstance)
--
--                return true
--            end
--
--            -- function player:Jump() -- dont   we want to test whether the original FooMovable:Jump() will be called
--            -- end
--
--            function Player:Speak(message)
--                U.Should.Be.PlainlyEqual(self, playerInstance)
--
--                return self.blendxin:Speak(message)
--            end
--
--            function Player._.AnotherStaticUtilityMethod(message)
--                return "[Wrapped] " .. Player.blendxin._.AnotherStaticUtilityMethod(message)
--            end
--            
--            ------
--
--            playerInstance = Player:New()
--
--            local coords = { x = 5, y = 3 }
--            local actualSpeakMessage = ""
--            local actualJumpReturnValue = ""
--            local actualSomeStaticUtilityMethodReturnValue = ""
--            local actualAnotherStaticUtilityMethodReturnValue = ""
--
--            -- ACT
--            function action()
--                playerInstance:Move(coords.x, coords.y)
--                playerInstance:ShadowStep()
--
--                actualSpeakMessage = playerInstance:Speak("Hello, world!")
--                actualJumpReturnValue = playerInstance:Jump() -- this should call the original Jump method from FooMovable
--                actualSomeStaticUtilityMethodReturnValue = playerInstance.SomeStaticUtilityMethod("Hello, world!")
--                actualAnotherStaticUtilityMethodReturnValue = playerInstance.AnotherStaticUtilityMethod("Hello, world!")
--            end
--
--            -- ASSERT
--            U.Should.Not.Throw(action)
--
--            U.Should.Be.Equivalent({ x = playerInstance.x, y = playerInstance.y }, coords)
--            U.Should.Be.PlainlyEqual(actualSpeakMessage, "Speakable: Hello, world!")
--            U.Should.Be.PlainlyEqual(actualJumpReturnValue, true)
--            U.Should.Be.PlainlyEqual(actualSomeStaticUtilityMethodReturnValue, "Hello, world!")
--            U.Should.Be.PlainlyEqual(actualAnotherStaticUtilityMethodReturnValue, "[Wrapped] Hello, world!")
--        end
--)
