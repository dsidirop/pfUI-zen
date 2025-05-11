local _g, _assert, _unpack, _type, _pairs, _print, _setmetatable, _getmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _type = _assert(_g.type)
    --local _getn = _assert(_g.table.getn)
    --local _gsub = _assert(_g.string.gsub)
    local _pairs = _assert(_g.pairs)
    local _print = _assert(_g.print)
    local _unpack = _assert(_g.unpack)
    --local _format = _assert(_g.string.format)
    --local _strsub = _assert(_g.string.sub)
    --local _strfind = _assert(_g.string.find)
    --local _stringify = _assert(_g.tostring)
    --local _debugstack = _assert(_g.debugstack)
    --local _tableRemove = _assert(_g.table.remove)
    local _setmetatable = _assert(_g.setmetatable)
    local _getmetatable = _assert(_g.getmetatable)

    return _g, _assert, _unpack, _type, _pairs, _print, _setmetatable, _getmetatable
end)()

local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Scopify = using "System.Scopify" -- @formatter:off
local EScopes = using "System.EScopes"

local U = using "[built-in]" [[ VWoWUnit ]] -- @formatter:on         

Scopify(EScopes.Function, {})

local TG = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Core.Tests.InheritanceTestbed",
    Tags = { "system", "system-core", "inheritance" }
}

Scopify(EScopes.Function, {})

-- Function to apply multiple mixins using setmetatable and closures for asBlendxin
local function applyMixins(target, namedMixins)

    local target_blendxin = target.blendxin or {} -- create an blendxin and asBlendxin tables to hold per-mixin method closures
    local target_asBlendxin = target.asBlendxin or {}

    target.blendxin = target_blendxin
    target.asBlendxin = target_asBlendxin

    local target_mt = _getmetatable(target) or {}
    local target_blendxin_mt = _getmetatable(target_blendxin) or {} -- for the blendxin

    target_mt.__index = target_mt.__index or {}
    target_blendxin_mt.__index = target_blendxin_mt.__index or {}

    -- for each named mixin, create a table with closures that bind the target as self
    for name, mixin in _pairs(namedMixins) do
        local currentBlendxin = target_asBlendxin[name] or {} -- completely overwrite any previous asBlendxin[name]
        target_asBlendxin[name] = currentBlendxin

        for mixinMemberName, mixinMember in _pairs(mixin) do
            target_mt.__index[mixinMemberName] = mixinMember -- combine all mixin methods into __index     later mixins override earlier ones

            if _type(mixinMember) == "function" then
                local snapshotOfMixinFunction = mixinMember -- absolutely vital to snapshot locally   we create a closure that ignores the first argument and uses target as self
                function closure(_, ...)
                    return snapshotOfMixinFunction(target, _unpack(arg))
                end
                currentBlendxin[mixinMemberName] = closure
                target_blendxin_mt.__index[mixinMemberName] = closure
            else
                currentBlendxin[mixinMemberName] = mixinMember -- data field
                target_blendxin_mt.__index[mixinMemberName] = mixinMember -- data field
            end
        end
    end

    _setmetatable(target, target_mt)
    _setmetatable(target_blendxin, target_blendxin_mt)

    return target
end

TG:AddFact("Inheritance.BlendMultipleMixins.GivenGreenMixins.ShouldMatchExpectedResults",
        function()
            -- ARRANGE

            local FooMovable = { x = 0, y = 0 }
            FooMovable.__index = FooMovable

            function FooMovable:Move(x, y)
                self.x = self.x + x
                self.y = self.y + y
            end

            local BarSpeakable = { }
            BarSpeakable.__index = BarSpeakable

            function BarSpeakable:Speak(message)
                return "Speakable: " .. message
            end

            -- Create an object
            local player = { x = 0, y = 0 }

            -- Apply both mixins with explicit names
            applyMixins(player, {
                ["IMovable"] = FooMovable,
                ["ISpeakable"] = BarSpeakable
            })

            -- Override the move method and call base methods using self.asBlendxin
            function player:Move(x, y)
                self.asBlendxin.IMovable:Move(x, y)
                return self.asBlendxin.ISpeakable:Speak("I moved to (" .. x .. ", " .. y .. ")")
            end

            function player:Speak(message)
                return self.blendxin:Speak(message)
            end

            local coords = { x = 5, y = 3 }
            local actualSpeakMessage = ""

            -- ACT
            function action()
                player:Move(coords.x, coords.y)
                actualSpeakMessage = player:Speak("Hello, world!")
            end

            -- ASSERT
            U.Should.Not.Throw(action)

            U.Should.Be.Equivalent({ x = player.x, y = player.y }, coords)
            U.Should.Be.PlainlyEqual(actualSpeakMessage, "Speakable: Hello, world!")
        end
)
