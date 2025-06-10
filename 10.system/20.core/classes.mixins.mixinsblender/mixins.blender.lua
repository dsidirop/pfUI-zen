local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Namespacer = using "System.Namespacer"

local MixinsBlender = using "[declare] [static]" "System.Classes.Mixins.MixinsBlender"

-- applies multiple mixins using setmetatable and closures    this is the canon flavor to allow
-- user-land code to dynamically forge mixins at runtime  p.e. as a means of achieving the strategy-pattern

function MixinsBlender.Blend(symbolProto, namedMixins) -- [experimental] blends mixins to weave new types dynamically at *runtime*
    return Namespacer:BlendMixins(symbolProto, namedMixins)
end
