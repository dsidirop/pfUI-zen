local _setfenv, _importer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _importer = _assert(_g.pvl_namespacer_get)

    return _setfenv, _importer
end)()

_setfenv(1, {}) --                                                                                                           @formatter:off

local StringsHelper = _importer("System.Helpers.Strings")

local U = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.VWoWUnit")
local EWowItemQuality = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Enums.EWowItemQuality")
local GambledItemInfo = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.GroupLooting.GambledItemInfo")

local TestsGroup = U.I:GetOrCreateGroup {
    Name = "Pavilion.Warcraft.Addons.Zen.Foundation.GroupLooting.GambledItemInfo.Tests",
    Tags = { "pavilion", "grouplooting" },
} --                                                                                                                         @formatter:on

TestsGroup:AddDynamicDataTest("GambledItemInfo.Constructor.GivenBasicValidParameter.ShouldConstructSuccessfully",
        function()
            return {
                ["GII.CTOR.GBVP.SCS.010"] = {
                    Name = "Foobar",
                    GamblingId = 123,
                    ItemQuality = EWowItemQuality.Uncommon,
                    IsBindOnPickUp = false,

                    IsNeedable = true,
                    IsGreedable = true,
                    IsDisenchantable = true,
                    IsTransmogrifiable = true,

                    Count = 1,
                    TextureFilepath = "",
                    EnchantingLevelRequiredToDEItem = 0,

                    NeedInelligibilityReasonType = 0,
                    GreedInelligibilityReasonType = 0,
                    DisenchantInelligibilityReasonType = 0,
                },
                ["GII.CTOR.GBVP.SCS.020"] = {
                    Name = " Foobar ",
                    GamblingId = 123,
                    ItemQuality = EWowItemQuality.Uncommon,
                    IsBindOnPickUp = false,

                    IsNeedable = true,
                    IsGreedable = true,
                    IsDisenchantable = true,
                    IsTransmogrifiable = true,

                    Count = 1,
                    TextureFilepath = "",
                    EnchantingLevelRequiredToDEItem = 0,

                    NeedInelligibilityReasonType = 0,
                    GreedInelligibilityReasonType = 0,
                    DisenchantInelligibilityReasonType = 0,
                }
            }
        end,
        function(options)
            -- ARRANGE
            -- ...

            -- ACT
            local gambledItemInfo = GambledItemInfo:New {
                Name = options.Name,
                GamblingId = options.GamblingId,
                ItemQuality = options.ItemQuality,
                IsBindOnPickUp = options.IsBindOnPickUp,
            }

            -- ASSERT
            U.AreEqual(gambledItemInfo:GetName(), StringsHelper.Trim(options.Name))
            U.AreEqual(gambledItemInfo:GetGamblingId(), options.GamblingId)
            U.AreEqual(gambledItemInfo:GetItemQuality(), options.ItemQuality)
            U.AreEqual(gambledItemInfo:IsBindOnPickUp(), options.IsBindOnPickUp)

            U.AreEqual(gambledItemInfo:IsNeedable(), options.IsNeedable)
            U.AreEqual(gambledItemInfo:IsGreedable(), options.IsGreedable)
            U.AreEqual(gambledItemInfo:IsDisenchantable(), options.IsDisenchantable)
            U.AreEqual(gambledItemInfo:IsTransmogrifiable(), options.IsTransmogrifiable)

            U.AreEqual(gambledItemInfo:GetCount(), options.Count)
            U.AreEqual(gambledItemInfo:GetTextureFilepath(), options.TextureFilepath)
            U.AreEqual(gambledItemInfo:GetEnchantingLevelRequiredToDEItem(), options.EnchantingLevelRequiredToDEItem)

            U.AreEqual(gambledItemInfo:GetNeedInelligibilityReasonType(), options.NeedInelligibilityReasonType)
            U.AreEqual(gambledItemInfo:GetGreedInelligibilityReasonType(), options.GreedInelligibilityReasonType)
            U.AreEqual(gambledItemInfo:GetDisenchantInelligibilityReasonType(), options.DisenchantInelligibilityReasonType)
        end
)
