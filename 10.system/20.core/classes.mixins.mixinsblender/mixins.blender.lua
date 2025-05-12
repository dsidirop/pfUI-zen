local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local BlendMixinsFunctionOfNamespacer = using "[built-in]" [[ pvl_namespacer_blendMixins ]]

local MixinsBlender = using "[declare] [static]" "System.Classes.Mixins.MixinsBlender [Partial]"

-- applies multiple mixins using setmetatable and closures    this is the canon flavor to allow
-- user-land code to dynamically forge mixins at runtime  p.e. as a means of achieving the strategy-pattern
MixinsBlender.Blend = BlendMixinsFunctionOfNamespacer