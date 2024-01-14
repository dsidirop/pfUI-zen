local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) --@formatter:off

local Time     = using "System.Time"

local T        = using "System.Helpers.Tables"
local LRUCache = using "Pavilion.DataStructures.LRUCache"

local TG, U = using "[testgroup]" "Pavilion.DataStructures.LRUCache.Tests" --@formatter:on

TG:AddTheory("LRUCache.Clear.GivenGreenInput.ShouldClearSuccessfully",
        {
            ["LRUC.CL.GGI.SCS.0000"] = (function()
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
                    Expected = {
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
                
                for key, value in T.GetPairs(options.PreArranged) do
                    cache:Upsert(key, value.Value, value.Timestamp)
                end

                cache:Clear()
                
                return cache
            end)

            -- ASSERT
            U.Should.Be.Equivalent(cache:GetAll(), options.Expected)
            U.Should.Be.PlainlyEqual(cache:Count(), T.Count(options.Expected))
        end
)
