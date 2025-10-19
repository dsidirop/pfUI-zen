--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IPfuiAutolootDBContext = using "[declare] [interface] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Persistence.Contracts.EntityFramework.IPfuiAutolootDBContext" { --[[@formatter:on]]
    "IPfuiAutolootDBContextTrackable", using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Persistence.Contracts.EntityFramework.IPfuiAutolootDBContextTrackable",
    "IPfuiAutolootDBContextUntrackable", using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Persistence.Contracts.EntityFramework.IPfuiAutolootDBContextUntrackable",
}
