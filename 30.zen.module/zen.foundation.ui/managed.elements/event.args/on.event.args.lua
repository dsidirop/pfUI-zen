local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.EventArgs.OnEventArgs" -- @formatter:on

Scopify(EScopes.Function, {})

function Class:New(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
    Scopify(EScopes.Function, self)

    return self:Instantiate({
        _event = event,
        _arg1 = arg1,
        _arg2 = arg2,
        _arg3 = arg3,
        _arg4 = arg4,
        _arg5 = arg5,
        _arg6 = arg6,
        _arg7 = arg7,
        _arg8 = arg8,
        _arg9 = arg9,
        _arg10 = arg10
    })
end

function Class:GetEvent()
    Scopify(EScopes.Function, self)

    return _event
end

function Class:GetArg1()
    return self._arg1
end

function Class:GetArg2()
    return self._arg2
end

function Class:GetArg3()
    return self._arg3
end

function Class:GetArg4()
    return self._arg4
end

function Class:GetArg5()
    return self._arg5
end

function Class:GetArg6()
    return self._arg6
end

function Class:GetArg7()
    return self._arg7
end

function Class:GetArg8()
    return self._arg8
end

function Class:GetArg9()
    return self._arg9
end

function Class:GetArg10()
    return self._arg10
end
