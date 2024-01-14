local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) --@formatter:off

local Time     = using "System.Time"

local T        = using "System.Helpers.Tables"
local LRUCache = using "Pavilion.DataStructures.LRUCache"

local TG, U = using "[testgroup]" "Pavilion.DataStructures.LRUCache.Tests" --@formatter:on

TG:AddTheory("LRUCache.Remove.GivenGreenInput.ShouldRemoveSuccessfully",
        {
            ["LRUC.UP.GGI.SUS.0000"] = (function()
                local now = Time.Now()
                return {
                    CacheSettings = {
                        MaxSize = 10,
                        TrimRatio = 0.1
                    },
                    PreArranged = {
                        ["foo01"] = { Value = 01, Timestamp = now + 1 },
                        ["foo02"] = { Value = 02, Timestamp = now + 2 },
                    },
                    ToRemove = "foo01",
                    Expected = {
                        ["foo02"] = 02,
                    },
                }
            end)(),
            ["LRUC.UP.GGI.SUS.0010"] = (function()
                local now = Time.Now()
                return {
                    CacheSettings = {
                        MaxSize = 10,
                        TrimRatio = 0.1
                    },
                    PreArranged = {
                        ["foo01"] = { Value = 01, Timestamp = now + 1 },
                        ["foo02"] = { Value = 02, Timestamp = now + 2 },
                    },
                    ToRemove = "foobar",
                    Expected = {
                        ["foo01"] = 01,
                        ["foo02"] = 02,
                    },
                }
            end)(),
        },
        function(options)
            -- ARRANGE
            -- ...

            -- ACT
            local cache = U.Should.Not.Throw(function()
                local cache = LRUCache:New(options.CacheSettings)
                
                for key, value in T.GetKeyValuePairs(options.PreArranged) do
                    cache:Upsert(key, value.Value, value.Timestamp)
                end

                cache:Remove(options.ToRemove)
                
                return cache
            end)

            -- ASSERT
            U.Should.Be.Equivalent(cache:GetAll(), options.Expected)
        end
)
