local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard        = using "System.Guard" --@formatter:off
local Scopify      = using "System.Scopify"
local EScopes      = using "System.EScopes"

local SWoWAddonNotLoadableReason = using "Pavilion.Warcraft.Strenums.SWoWAddonNotLoadableReason" --  @formater:on

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Contracts.AddonInfoDto"

Scopify(EScopes.Function, {})

function Class._.EnrichInstanceWithFields(upcomingInstance)
    upcomingInstance._title = ""
    upcomingInstance._isLoaded = false
    upcomingInstance._isDynamicallyLoadable = false

    upcomingInstance._notes = ""
    upcomingInstance._folderName = ""
    upcomingInstance._notLoadedReason = ""

    return upcomingInstance
end

function Class:New(options)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsTable(options, "options") -- todo   turn the options into its own options-class and add a validate() method to it  

    Guard.Assert.IsBooleanizable(options.IsLoaded, "options.IsLoaded")
    Guard.Assert.IsBooleanizable(options.IsDynamicallyLoadable, "options.IsDynamicallyLoadable")
    
    Guard.Assert.IsNonDudStringOfMaxLength(options.Title, 512, "options.Title")
    Guard.Assert.IsNonDudStringOfMaxLength(options.Notes, 4096, "options.Notes")
    Guard.Assert.IsNonDudStringOfMaxLength(options.FolderName, 1024, "options.FolderName")

    Guard.Assert.IsNilOrEnumValue(SWoWAddonNotLoadableReason, options.NotLoadedReason, "options.NotLoadedReason")
    
    local instance = self:Instantiate() --@formatter:off

    instance._title                 = options.Title
    instance._notes                 = options.Notes
    instance._isLoaded              = options.IsLoaded
    instance._folderName            = options.FolderName
    instance._notLoadedReason       = options.NotLoadedReason
    instance._isDynamicallyLoadable = options.IsDynamicallyLoadable

    return instance --@formatter:on
end

function Class:GetTitle()
    return self._title
end

function Class:IsLoaded()
    return self._isLoaded
end

function Class:IsDynamicallyLoadable()
    return self._isDynamicallyLoadable
end

function Class:GetNotes()
    return self._notes
end

function Class:GetFolderName()
    return self._folderName
end

function Class:GetNotLoadedReason()
    return self._notLoadedReason
end


