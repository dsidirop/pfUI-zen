local U, _setfenv, _importer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local U = _assert(_g.VWoWUnit)
    local _importer = _assert(_g.pvl_namespacer_get)

    return U, _setfenv, _importer
end)()

_setfenv(1, {})

local LRUCache = _importer("Pavilion.DataStructures.LRUCache")

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup { Name = "Pavilion.DataStructures.LRUCache", Tags = { "data-structures", "lru-cache" } }

TestsGroup:AddTheory("LRUCache.Constructor.GivenGreenInput.ShouldConstruct",
        {
            ["LRUC.CTOR.GGI.SC.0000"] = nil, -- default options
            ["LRUC.CTOR.GGI.SC.0010"] = {
                MaxSize = 100,
                TrimRatio = 0.25,
                MaxLifespanPerEntryInSeconds = 5 * 60,
            },
            ["LRUC.CTOR.GGI.SC.0020"] = {
                MaxSize = 100,
                TrimRatio = 0,
                MaxLifespanPerEntryInSeconds = 5 * 60,
            },
            ["LRUC.CTOR.GGI.SC.0030"] = {
                MaxSize = nil,
                TrimRatio = 1,
                MaxLifespanPerEntryInSeconds = 0,
            },
            ["LRUC.CTOR.GGI.SC.0040"] = {
                -- all properties nil
            },
        },
        function(options)
            -- ARRANGE

            -- ACT + ASSERT
            U.Should.NotThrow(function()
                LRUCache:New(options)
            end)
        end
)

TestsGroup:AddTheory("LRUCache.Constructor.GivenRedInput.ShouldThrowGuardException",
        {
            ["LRUC.CTOR.GRI.STGE.0000"] = { MaxSize = -1, },
            ["LRUC.CTOR.GRI.STGE.0010"] = { TrimRatio = -1, },
            ["LRUC.CTOR.GRI.STGE.0020"] = { TrimRatio = 1.1, },
            ["LRUC.CTOR.GRI.STGE.0030"] = { MaxLifespanPerEntryInSeconds = -1, },
        },
        function(options)
            -- ARRANGE

            -- ACT + ASSERT
            U.Should.Throw(function()
                return LRUCache:New(options)
            end)
        end
)
