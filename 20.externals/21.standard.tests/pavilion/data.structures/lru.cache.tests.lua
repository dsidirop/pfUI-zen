local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local LRUCache = using "Pavilion.DataStructures.LRUCache" --@formatter:off

local TG, U = using "[testgroup.tagged]" "Pavilion.DataStructures.LRUCache" { "data-structures", "lru-cache" } --@formatter:on

TG:AddTheory("LRUCache.Constructor.GivenGreenInput.ShouldConstruct",
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
            U.Should.Not.Throw(function()
                LRUCache:New(options)
            end)
        end
)

TG:AddTheory("LRUCache.Constructor.GivenRedInput.ShouldThrowGuardException",
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
