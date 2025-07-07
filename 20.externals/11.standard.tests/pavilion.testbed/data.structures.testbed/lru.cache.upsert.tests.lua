--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Time     = using "System.Time"

local T        = using "System.Helpers.Tables"
local LRUCache = using "Pavilion.DataStructures.LRUCache"

local TG, U = using "[testgroup]" "Pavilion.DataStructures.LRUCache.Tests" --@formatter:on

TG:AddTheory("LRUCache.Upsert.GivenGreenInput.ShouldUpsertSuccessfully",
        {
            ["LRUC.UP.GGI.SUS.0000"] = {
                PreArranged = {
                    ["foo"] = { Value = "bar" },
                },
                Expected = {
                    ["foo"] = "bar",
                },
            },
            ["LRUC.UP.GGI.SUS.0010"] = {
                PreArranged = {
                    ["foo"] = { Value = nil },
                },
                Expected = {
                    ["foo"] = true,
                },
            },
            ["LRUC.UP.GGI.SUS.0020"] = {
                PreArranged = {
                    ["foo"] = { Value = false },
                },
                Expected = {
                    ["foo"] = false,
                },
            },
            ["LRUC.UP.GGI.SUS.0030"] = {
                PreArranged = {
                    ["foo"] = { Value = 0 },
                },
                Expected = {
                    ["foo"] = 0,
                },
            },
            ["LRUC.UP.GGI.SUS.0040"] = {
                PreArranged = {
                    ["foo"] = { Value = {} },
                },
                Expected = {
                    ["foo"] = {},
                },
            },
            ["LRUC.UP.GGI.SUS.0050"] = {
                PreArranged = {
                    ["foo"] = { Value = -1 },
                },
                Expected = {
                    ["foo"] = -1,
                },
            },
            ["LRUC.UP.GGI.SUS.0060"] = (function()
                local fooFunction = function()  end

                return {
                    PreArranged = {
                        ["foo"] = { Value = fooFunction },
                    },
                    Expected = {
                        ["foo"] = fooFunction
                    },
                }
            end)(),
            ["LRUC.UP.GGI.SUS.0070"] = (function()
                local now = Time.Now()
                return {
                    CacheSettings = {
                        MaxSize = 1,
                        TrimRatio = 0.1
                    },
                    PreArranged = {
                        ["foo01"] = { Value = 01, Timestamp = now + 1 },
                        ["foo02"] = { Value = 02, Timestamp = now + 2 },
                    },
                    Expected = {
                        ["foo02"] = 02,
                    },
                }
            end)(),
            ["LRUC.UP.GGI.SUS.0080"] = (function()
                local now = Time.Now()
                return {
                    CacheSettings = {
                        MaxSize = 10,
                        TrimRatio = 0.5
                    },
                    PreArranged = {
                        ["foo01"] = { Value = 01, Timestamp = now + 1 },
                        ["foo02"] = { Value = 02, Timestamp = now + 2 },
                        ["foo03"] = { Value = 03, Timestamp = now + 3 },
                        ["foo04"] = { Value = 04, Timestamp = now + 4 },
                        ["foo05"] = { Value = 05, Timestamp = now + 5 },
                        ["foo06"] = { Value = 06, Timestamp = now + 6 },
                        ["foo07"] = { Value = 07, Timestamp = now + 7 },
                        ["foo08"] = { Value = 08, Timestamp = now + 8 },
                        ["foo09"] = { Value = 09, Timestamp = now + 9 },
                        ["foo10"] = { Value = 10, Timestamp = now + 10 },
                        ["foo11"] = { Value = 11, Timestamp = now + 11 },
                    },
                    Expected = {
                        ["foo11"] = 11,
                        ["foo10"] = 10,
                        ["foo09"] = 09,
                        ["foo08"] = 08,
                        ["foo07"] = 07,
                    },
                }
            end)(),
            ["LRUC.UP.GGI.SUS.0090"] = (function()
                local now = Time.Now()
                return {
                    CacheSettings = {
                        MaxSize = 10,
                        TrimRatio = 1
                    },
                    PreArranged = {
                        ["foo01"] = { Value = 01, Timestamp = now + 1 },
                        ["foo02"] = { Value = 02, Timestamp = now + 2 },
                        ["foo03"] = { Value = 03, Timestamp = now + 3 },
                        ["foo04"] = { Value = 04, Timestamp = now + 4 },
                        ["foo05"] = { Value = 05, Timestamp = now + 5 },
                        ["foo06"] = { Value = 06, Timestamp = now + 6 },
                        ["foo07"] = { Value = 07, Timestamp = now + 7 },
                        ["foo08"] = { Value = 08, Timestamp = now + 8 },
                        ["foo09"] = { Value = 09, Timestamp = now + 9 },
                        ["foo10"] = { Value = 10, Timestamp = now + 10 },
                        ["foo11"] = { Value = 11, Timestamp = now + 11 },
                    },
                    Expected = {
                        -- empty
                    },
                }
            end)(),
            ["LRUC.UP.GGI.SUS.0100"] = (function()
                local now = Time.Now()
                return {
                    CacheSettings = {
                        MaxSize = 3,
                        TrimRatio = 1
                    },
                    PreArranged = {
                        ["foo01"] = { Value = 01, Timestamp = now + 1 },
                        ["foo02"] = { Value = 02, Timestamp = now + 2 },
                        ["foo03"] = { Value = 03, Timestamp = now + 3 },
                    },
                    Expected = {
                        ["foo01"] = 01,
                        ["foo02"] = 02,
                        ["foo03"] = 03,
                    },
                }
            end)()
        },
        function(options)
            -- ARRANGE
            -- ...

            -- ACT
            local cache = U.Should.Not.Throw(function()
                local cache = LRUCache:New(options.CacheSettings)
                
                for key, value in T.GetPairs(options.PreArranged) do
                    cache:Upsert(key, value.Value, value.Timestamp)
                end
                
                -- unfortunately in wow lua its extremely hard to simulate time delays ala 'await Task.Delay(x)'
                -- we dont even have coroutines in wow 1.12   coroutines got introduced in wow 2.0.1
                
                return cache
            end)

            -- ASSERT
            U.Should.Be.Equivalent(cache:GetAll(), options.Expected)
            U.Should.Be.PlainlyEqual(cache:Count(), T.Count(options.Expected))
        end
)
