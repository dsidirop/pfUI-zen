local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard             = using "System.Guard" -- @formatter:off
local Scopify           = using "System.Scopify"
local EScopes           = using "System.EScopes"
local SAutohandlingMode = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SLootConfirmationPopupsAutohandlingMode" --@formatter:on

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Domain.Engine.PopupWarningItemBindAutohandling.AutohandlerAggregateSettings"

Scopify(EScopes.Function, {})

function Class:New()
    Scopify(EScopes.Function, self)

    return self:Instantiate({
        _mode = nil
    })
end

function Class:GetMode()
    Scopify(EScopes.Function, self)

    return self._mode
end

function Class:ChainSetMode(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsEnumValue(SAutohandlingMode, value, "value")

    _mode = value

    return self
end
