--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard  = using "System.Guard"
local Fields = using "System.Classes.Fields"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Contracts.Settings.UserPreferences.UserPreferencesDto" --@formatter:on


Fields(function(upcomingInstance)
    upcomingInstance._enabled = true
    upcomingInstance._isFirstLoading = true
    upcomingInstance._customAssociations = ""

    -- ... more user-preferences sections can be added here in the future ...

    return upcomingInstance
end)

-- GETTERS

function Class:Get_Enabled()
    Scopify(EScopes.Function, self)

    return _enabled
end

function Class:Get_IsFirstLoading()
    Scopify(EScopes.Function, self)

    return _isFirstLoading
end

function Class:Get_CustomAssociations()
    Scopify(EScopes.Function, self)

    return _customAssociations
end

-- SETTERS

function Class:ChainSet_Enabled(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBoolean(value, "value")

    _enabled = value

    return self
end

function Class:ChainSet_IsFirstLoading(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBoolean(value, "value")

    _isFirstLoading = value

    return self
end

function Class:ChainSet_CustomAssociations(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(value, "value")

    _customAssociations = value

    return self
end
