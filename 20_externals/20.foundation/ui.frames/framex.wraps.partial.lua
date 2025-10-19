--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Class = using "[declare]" "Pavilion.Warcraft.Foundation.UI.Frames.FrameX [Partial]"

-- from 'Frame' itself

using "[wrap]" { "_rawWoWFrame", "Hide" }
using "[wrap]" { "_rawWoWFrame", "Show" }
using "[wrap]" { "_rawWoWFrame", "GetID" }
using "[wrap]" { "_rawWoWFrame", "Lower" }
using "[wrap]" { "_rawWoWFrame", "Raise" }
using "[wrap]" { "_rawWoWFrame", "SetID" }
using "[wrap]" { "_rawWoWFrame", "IsShown" }
using "[wrap]" { "_rawWoWFrame", "GetAlpha" }
using "[wrap]" { "_rawWoWFrame", "GetScale" }
using "[wrap]" { "_rawWoWFrame", "SetAlpha" }
using "[wrap]" { "_rawWoWFrame", "SetScale" }
using "[wrap]" { "_rawWoWFrame", "SetShown" }
using "[wrap]" { "_rawWoWFrame", "AbortDrag" }
using "[wrap]" { "_rawWoWFrame", "IsMovable" }
using "[wrap]" { "_rawWoWFrame", "IsVisible" }
using "[wrap]" { "_rawWoWFrame", "CreateLine" }
using "[wrap]" { "_rawWoWFrame", "GetRegions" }
using "[wrap]" { "_rawWoWFrame", "IsToplevel" }
using "[wrap]" { "_rawWoWFrame", "SetMovable" }
using "[wrap]" { "_rawWoWFrame", "GetChildren" }
using "[wrap]" { "_rawWoWFrame", "IsResizable" }
using "[wrap]" { "_rawWoWFrame", "SetToplevel" }
using "[wrap]" { "_rawWoWFrame", "StartMoving" }
using "[wrap]" { "_rawWoWFrame", "StartSizing" }
using "[wrap]" { "_rawWoWFrame", "GetAttribute" }
using "[wrap]" { "_rawWoWFrame", "IsUserPlaced" }
using "[wrap]" { "_rawWoWFrame", "SetAttribute" }
using "[wrap]" { "_rawWoWFrame", "SetResizable" }
using "[wrap]" { "_rawWoWFrame", "CreateTexture" }
using "[wrap]" { "_rawWoWFrame", "GetBoundsRect" }
using "[wrap]" { "_rawWoWFrame", "GetFrameLevel" }
using "[wrap]" { "_rawWoWFrame", "GetNumRegions" }
using "[wrap]" { "_rawWoWFrame", "RegisterEvent" }
using "[wrap]" { "_rawWoWFrame", "SetFrameLevel" }
using "[wrap]" { "_rawWoWFrame", "SetUserPlaced" }
using "[wrap]" { "_rawWoWFrame", "EnableKeyboard" }
using "[wrap]" { "_rawWoWFrame", "GetFrameStrata" }
using "[wrap]" { "_rawWoWFrame", "GetNumChildren" }
using "[wrap]" { "_rawWoWFrame", "IsObjectLoaded" }
using "[wrap]" { "_rawWoWFrame", "RotateTextures" }
using "[wrap]" { "_rawWoWFrame", "SetFrameStrata" }
using "[wrap]" { "_rawWoWFrame", "EnableDrawLayer" }
using "[wrap]" { "_rawWoWFrame", "GetResizeBounds" }
using "[wrap]" { "_rawWoWFrame", "RegisterForDrag" }
using "[wrap]" { "_rawWoWFrame", "SetResizeBounds" }
using "[wrap]" { "_rawWoWFrame", "UnregisterEvent" }
using "[wrap]" { "_rawWoWFrame", "CreateFontString" }
using "[wrap]" { "_rawWoWFrame", "DisableDrawLayer" }
using "[wrap]" { "_rawWoWFrame", "DoesClipChildren" }
using "[wrap]" { "_rawWoWFrame", "ExecuteAttribute" }
using "[wrap]" { "_rawWoWFrame", "GetHitRectInsets" }
using "[wrap]" { "_rawWoWFrame", "SetClipsChildren" }
using "[wrap]" { "_rawWoWFrame", "SetHitRectInsets" }
using "[wrap]" { "_rawWoWFrame", "SetIsFrameBuffer" }
using "[wrap]" { "_rawWoWFrame", "CreateMaskTexture" }
using "[wrap]" { "_rawWoWFrame", "GetEffectiveAlpha" }
using "[wrap]" { "_rawWoWFrame", "GetEffectiveScale" }
using "[wrap]" { "_rawWoWFrame", "IsClampedToScreen" }
using "[wrap]" { "_rawWoWFrame", "IsEventRegistered" }
using "[wrap]" { "_rawWoWFrame", "IsKeyboardEnabled" }
using "[wrap]" { "_rawWoWFrame", "RegisterAllEvents" }
using "[wrap]" { "_rawWoWFrame", "RegisterUnitEvent" }
using "[wrap]" { "_rawWoWFrame", "CanChangeAttribute" }
using "[wrap]" { "_rawWoWFrame", "EnableGamePadStick" }
using "[wrap]" { "_rawWoWFrame", "GetClampRectInsets" }
using "[wrap]" { "_rawWoWFrame", "HasFixedFrameLevel" }
using "[wrap]" { "_rawWoWFrame", "InterceptStartDrag" }
using "[wrap]" { "_rawWoWFrame", "SetClampRectInsets" }
using "[wrap]" { "_rawWoWFrame", "SetClampedToScreen" }
using "[wrap]" { "_rawWoWFrame", "SetFixedFrameLevel" }
using "[wrap]" { "_rawWoWFrame", "StopMovingOrSizing" }
using "[wrap]" { "_rawWoWFrame", "DesaturateHierarchy" }
using "[wrap]" { "_rawWoWFrame", "EnableGamePadButton" }
using "[wrap]" { "_rawWoWFrame", "GetDontSavePosition" }
using "[wrap]" { "_rawWoWFrame", "HasFixedFrameStrata" }
using "[wrap]" { "_rawWoWFrame", "SetDontSavePosition" }
using "[wrap]" { "_rawWoWFrame", "SetDrawLayerEnabled" }
using "[wrap]" { "_rawWoWFrame", "SetFixedFrameStrata" }
using "[wrap]" { "_rawWoWFrame", "UnregisterAllEvents" }
using "[wrap]" { "_rawWoWFrame", "GetHyperlinksEnabled" }
using "[wrap]" { "_rawWoWFrame", "SetHyperlinksEnabled" }
using "[wrap]" { "_rawWoWFrame", "SetIgnoreParentAlpha" }
using "[wrap]" { "_rawWoWFrame", "SetIgnoreParentScale" }
using "[wrap]" { "_rawWoWFrame", "IsGamePadStickEnabled" }
using "[wrap]" { "_rawWoWFrame", "IsIgnoringParentAlpha" }
using "[wrap]" { "_rawWoWFrame", "IsIgnoringParentScale" }
using "[wrap]" { "_rawWoWFrame", "SetAttributeNoHandler" }
using "[wrap]" { "_rawWoWFrame", "IsGamePadButtonEnabled" }
using "[wrap]" { "_rawWoWFrame", "GetFlattensRenderLayers" }
using "[wrap]" { "_rawWoWFrame", "SetFlattensRenderLayers" }
using "[wrap]" { "_rawWoWFrame", "GetPropagateKeyboardInput" }
using "[wrap]" { "_rawWoWFrame", "SetPropagateKeyboardInput" }
using "[wrap]" { "_rawWoWFrame", "GetEffectivelyFlattensRenderLayers" }

-- from 'Region' parent class
using "[wrap]" { "_rawWoWFrame", "GetAlpha" }
using "[wrap]" { "_rawWoWFrame", "GetScale" }
using "[wrap]" { "_rawWoWFrame", "SetAlpha" }
using "[wrap]" { "_rawWoWFrame", "SetScale" }
using "[wrap]" { "_rawWoWFrame", "GetDrawLayer" }
using "[wrap]" { "_rawWoWFrame", "SetDrawLayer" }
using "[wrap]" { "_rawWoWFrame", "GetVertexColor" }
using "[wrap]" { "_rawWoWFrame", "IsObjectLoaded" }
using "[wrap]" { "_rawWoWFrame", "SetVertexColor" }
using "[wrap]" { "_rawWoWFrame", "GetEffectiveScale" }
using "[wrap]" { "_rawWoWFrame", "SetIgnoreParentAlpha" }
using "[wrap]" { "_rawWoWFrame", "SetIgnoreParentScale" }
using "[wrap]" { "_rawWoWFrame", "IsIgnoringParentAlpha" }
using "[wrap]" { "_rawWoWFrame", "IsIgnoringParentScale" }

-- from 'ScriptRegion' grandparent class
using "[wrap]" { "_rawWoWFrame", "Hide" }
using "[wrap]" { "_rawWoWFrame", "Show" }
using "[wrap]" { "_rawWoWFrame", "GetTop" }
using "[wrap]" { "_rawWoWFrame", "GetLeft" }
using "[wrap]" { "_rawWoWFrame", "GetRect" }
using "[wrap]" { "_rawWoWFrame", "GetSize" }
using "[wrap]" { "_rawWoWFrame", "IsShown" }
using "[wrap]" { "_rawWoWFrame", "GetRight" }
using "[wrap]" { "_rawWoWFrame", "GetWidth" }
using "[wrap]" { "_rawWoWFrame", "SetShown" }
using "[wrap]" { "_rawWoWFrame", "GetBottom" }
using "[wrap]" { "_rawWoWFrame", "GetCenter" }
using "[wrap]" { "_rawWoWFrame", "GetHeight" }
using "[wrap]" { "_rawWoWFrame", "GetScript" }
using "[wrap]" { "_rawWoWFrame", "HasScript" }
using "[wrap]" { "_rawWoWFrame", "IsVisible" }
using "[wrap]" { "_rawWoWFrame", "SetParent" }
using "[wrap]" { "_rawWoWFrame", "SetScript" }
using "[wrap]" { "_rawWoWFrame", "HookScript" }
using "[wrap]" { "_rawWoWFrame", "IsDragging" }
using "[wrap]" { "_rawWoWFrame", "EnableMouse" }
using "[wrap]" { "_rawWoWFrame", "IsMouseOver" }
using "[wrap]" { "_rawWoWFrame", "IsProtected" }
using "[wrap]" { "_rawWoWFrame", "IsRectValid" }
using "[wrap]" { "_rawWoWFrame", "GetScaledRect" }
using "[wrap]" { "_rawWoWFrame", "IsMouseEnabled" }
using "[wrap]" { "_rawWoWFrame", "EnableMouseWheel" }
using "[wrap]" { "_rawWoWFrame", "EnableMouseMotion" }
using "[wrap]" { "_rawWoWFrame", "GetSourceLocation" }
using "[wrap]" { "_rawWoWFrame", "IsMouseMotionFocus" }
using "[wrap]" { "_rawWoWFrame", "IsMouseClickEnabled" }
using "[wrap]" { "_rawWoWFrame", "IsMouseWheelEnabled" }
using "[wrap]" { "_rawWoWFrame", "IsMouseMotionEnabled" }
using "[wrap]" { "_rawWoWFrame", "SetMouseClickEnabled" }
using "[wrap]" { "_rawWoWFrame", "IsAnchoringRestricted" }
using "[wrap]" { "_rawWoWFrame", "SetMouseMotionEnabled" }
using "[wrap]" { "_rawWoWFrame", "SetPassThroughButtons" }
using "[wrap]" { "_rawWoWFrame", "CanChangeProtectedState" }

-- from 'ScriptRegionResizing' parent class
using "[wrap]" { "_rawWoWFrame", "SetSize" }
using "[wrap]" { "_rawWoWFrame", "GetPoint" }
using "[wrap]" { "_rawWoWFrame", "SetPoint" }
using "[wrap]" { "_rawWoWFrame", "SetWidth" }
using "[wrap]" { "_rawWoWFrame", "SetHeight" }
using "[wrap]" { "_rawWoWFrame", "ClearPoint" }
using "[wrap]" { "_rawWoWFrame", "GetNumPoints" }
using "[wrap]" { "_rawWoWFrame", "SetAllPoints" }
using "[wrap]" { "_rawWoWFrame", "ClearAllPoints" }
using "[wrap]" { "_rawWoWFrame", "GetPointByName" }
using "[wrap]" { "_rawWoWFrame", "ClearPointsOffset" }
using "[wrap]" { "_rawWoWFrame", "AdjustPointsOffset" }

-- from 'AnimatableObject' parent class
using "[wrap]" { "_rawWoWFrame", "StopAnimating" }
using "[wrap]" { "_rawWoWFrame", "GetAnimationGroups" }
using "[wrap]" { "_rawWoWFrame", "CreateAnimationGroup" }

-- from 'FrameScriptObject' parent class
using "[wrap]" { "_rawWoWFrame", "GetName" }
using "[wrap]" { "_rawWoWFrame", "IsForbidden" }
using "[wrap]" { "_rawWoWFrame", "IsObjectType" }
using "[wrap]" { "_rawWoWFrame", "SetForbidden" }
using "[wrap]" { "_rawWoWFrame", "GetObjectType" }

-- from 'Object' parent class
using "[wrap]" { "_rawWoWFrame", "GetParent" }
using "[wrap]" { "_rawWoWFrame", "GetDebugName" }
using "[wrap]" { "_rawWoWFrame", "GetParentKey" }
using "[wrap]" { "_rawWoWFrame", "SetParentKey" }
