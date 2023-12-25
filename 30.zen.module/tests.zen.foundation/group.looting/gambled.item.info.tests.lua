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

local VWoWUnit = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.VWoWUnit")
local EWowItemQuality = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Enums.EWowItemQuality")
local GambledItemInfo = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.GroupLooting.GambledItemInfo")

local TestsGroup = VWoWUnit.I:GetOrCreateGroup {
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
            VWoWUnit.AreEqual(gambledItemInfo:GetName(), StringsHelper.Trim(options.Name))
            VWoWUnit.AreEqual(gambledItemInfo:GetGamblingId(), options.GamblingId)
            VWoWUnit.AreEqual(gambledItemInfo:GetItemQuality(), options.ItemQuality)
            VWoWUnit.AreEqual(gambledItemInfo:IsBindOnPickUp(), options.IsBindOnPickUp)

            VWoWUnit.AreEqual(gambledItemInfo:IsNeedable(), options.IsNeedable)
            VWoWUnit.AreEqual(gambledItemInfo:IsGreedable(), options.IsGreedable)
            VWoWUnit.AreEqual(gambledItemInfo:IsDisenchantable(), options.IsDisenchantable)
            VWoWUnit.AreEqual(gambledItemInfo:IsTransmogrifiable(), options.IsTransmogrifiable)

            VWoWUnit.AreEqual(gambledItemInfo:GetCount(), options.Count)
            VWoWUnit.AreEqual(gambledItemInfo:GetTextureFilepath(), options.TextureFilepath)
            VWoWUnit.AreEqual(gambledItemInfo:GetEnchantingLevelRequiredToDEItem(), options.EnchantingLevelRequiredToDEItem)

            VWoWUnit.AreEqual(gambledItemInfo:GetNeedInelligibilityReasonType(), options.NeedInelligibilityReasonType)
            VWoWUnit.AreEqual(gambledItemInfo:GetGreedInelligibilityReasonType(), options.GreedInelligibilityReasonType)
            VWoWUnit.AreEqual(gambledItemInfo:GetDisenchantInelligibilityReasonType(), options.DisenchantInelligibilityReasonType)
        end
)
