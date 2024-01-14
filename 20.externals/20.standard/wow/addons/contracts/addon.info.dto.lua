local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard        = using "System.Guard" --@formatter:off
local Scopify      = using "System.Scopify"
local EScopes      = using "System.EScopes"

local SWoWAddonNotLoadableReason = using "Pavilion.Warcraft.Strenums.SWoWAddonNotLoadableReason" --  @formater:on

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Contracts.AddonInfoDto"

Scopify(EScopes.Function, {})

function Class:New(options)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsTable(options, "options") -- todo   Guard.Assert.IsTableWithSpecificPropertyNames(options, OptionsPrototype)  

    Guard.Assert.IsBooleanizable(options.IsLoaded, "options.IsLoaded")
    Guard.Assert.IsBooleanizable(options.IsDynamicallyLoadable, "options.IsDynamicallyLoadable")
    
    Guard.Assert.IsNonDudStringOfMaxLength(options.Title, 512, "options.Title")
    Guard.Assert.IsNonDudStringOfMaxLength(options.Notes, 4096, "options.Notes")
    Guard.Assert.IsNonDudStringOfMaxLength(options.FolderName, 1024, "options.FolderName")

    Guard.Assert.IsNilOrEnumValue(SWoWAddonNotLoadableReason, options.NotLoadedReason, "options.NotLoadedReason")
    
    return self:Instantiate({ --@formatter:off
        _title = options.Title,
        _isLoaded = options.IsLoaded,
        _isDynamicallyLoadable = options.IsDynamicallyLoadable,
        
        _notes = options.Notes,
        _folderName = options.FolderName,
        _notLoadedReason = options.NotLoadedReason,
    }) --@formatter:on
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


