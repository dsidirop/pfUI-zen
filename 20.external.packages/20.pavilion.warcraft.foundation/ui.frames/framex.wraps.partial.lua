--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Class = using "[declare]" "Pavilion.Warcraft.Foundation.UI.Frames.FrameX [Partial]"

-- from 'Frame' itself

using "[wrap]" { "_wowRawFrame", "Hide" }
using "[wrap]" { "_wowRawFrame", "Show" }
using "[wrap]" { "_wowRawFrame", "GetID" }
using "[wrap]" { "_wowRawFrame", "Lower" }
using "[wrap]" { "_wowRawFrame", "Raise" }
using "[wrap]" { "_wowRawFrame", "SetID" }
using "[wrap]" { "_wowRawFrame", "IsShown" }
using "[wrap]" { "_wowRawFrame", "GetAlpha" }
using "[wrap]" { "_wowRawFrame", "GetScale" }
using "[wrap]" { "_wowRawFrame", "SetAlpha" }
using "[wrap]" { "_wowRawFrame", "SetScale" }
using "[wrap]" { "_wowRawFrame", "SetShown" }
using "[wrap]" { "_wowRawFrame", "AbortDrag" }
using "[wrap]" { "_wowRawFrame", "IsMovable" }
using "[wrap]" { "_wowRawFrame", "IsVisible" }
using "[wrap]" { "_wowRawFrame", "CreateLine" }
using "[wrap]" { "_wowRawFrame", "GetRegions" }
using "[wrap]" { "_wowRawFrame", "IsToplevel" }
using "[wrap]" { "_wowRawFrame", "SetMovable" }
using "[wrap]" { "_wowRawFrame", "GetChildren" }
using "[wrap]" { "_wowRawFrame", "IsResizable" }
using "[wrap]" { "_wowRawFrame", "SetToplevel" }
using "[wrap]" { "_wowRawFrame", "StartMoving" }
using "[wrap]" { "_wowRawFrame", "StartSizing" }
using "[wrap]" { "_wowRawFrame", "GetAttribute" }
using "[wrap]" { "_wowRawFrame", "IsUserPlaced" }
using "[wrap]" { "_wowRawFrame", "SetAttribute" }
using "[wrap]" { "_wowRawFrame", "SetResizable" }
using "[wrap]" { "_wowRawFrame", "CreateTexture" }
using "[wrap]" { "_wowRawFrame", "GetBoundsRect" }
using "[wrap]" { "_wowRawFrame", "GetFrameLevel" }
using "[wrap]" { "_wowRawFrame", "GetNumRegions" }
using "[wrap]" { "_wowRawFrame", "RegisterEvent" }
using "[wrap]" { "_wowRawFrame", "SetFrameLevel" }
using "[wrap]" { "_wowRawFrame", "SetUserPlaced" }
using "[wrap]" { "_wowRawFrame", "EnableKeyboard" }
using "[wrap]" { "_wowRawFrame", "GetFrameStrata" }
using "[wrap]" { "_wowRawFrame", "GetNumChildren" }
using "[wrap]" { "_wowRawFrame", "IsObjectLoaded" }
using "[wrap]" { "_wowRawFrame", "RotateTextures" }
using "[wrap]" { "_wowRawFrame", "SetFrameStrata" }
using "[wrap]" { "_wowRawFrame", "EnableDrawLayer" }
using "[wrap]" { "_wowRawFrame", "GetResizeBounds" }
using "[wrap]" { "_wowRawFrame", "RegisterForDrag" }
using "[wrap]" { "_wowRawFrame", "SetResizeBounds" }
using "[wrap]" { "_wowRawFrame", "UnregisterEvent" }
using "[wrap]" { "_wowRawFrame", "CreateFontString" }
using "[wrap]" { "_wowRawFrame", "DisableDrawLayer" }
using "[wrap]" { "_wowRawFrame", "DoesClipChildren" }
using "[wrap]" { "_wowRawFrame", "ExecuteAttribute" }
using "[wrap]" { "_wowRawFrame", "GetHitRectInsets" }
using "[wrap]" { "_wowRawFrame", "SetClipsChildren" }
using "[wrap]" { "_wowRawFrame", "SetHitRectInsets" }
using "[wrap]" { "_wowRawFrame", "SetIsFrameBuffer" }
using "[wrap]" { "_wowRawFrame", "CreateMaskTexture" }
using "[wrap]" { "_wowRawFrame", "GetEffectiveAlpha" }
using "[wrap]" { "_wowRawFrame", "GetEffectiveScale" }
using "[wrap]" { "_wowRawFrame", "IsClampedToScreen" }
using "[wrap]" { "_wowRawFrame", "IsEventRegistered" }
using "[wrap]" { "_wowRawFrame", "IsKeyboardEnabled" }
using "[wrap]" { "_wowRawFrame", "RegisterAllEvents" }
using "[wrap]" { "_wowRawFrame", "RegisterUnitEvent" }
using "[wrap]" { "_wowRawFrame", "CanChangeAttribute" }
using "[wrap]" { "_wowRawFrame", "EnableGamePadStick" }
using "[wrap]" { "_wowRawFrame", "GetClampRectInsets" }
using "[wrap]" { "_wowRawFrame", "HasFixedFrameLevel" }
using "[wrap]" { "_wowRawFrame", "InterceptStartDrag" }
using "[wrap]" { "_wowRawFrame", "SetClampRectInsets" }
using "[wrap]" { "_wowRawFrame", "SetClampedToScreen" }
using "[wrap]" { "_wowRawFrame", "SetFixedFrameLevel" }
using "[wrap]" { "_wowRawFrame", "StopMovingOrSizing" }
using "[wrap]" { "_wowRawFrame", "DesaturateHierarchy" }
using "[wrap]" { "_wowRawFrame", "EnableGamePadButton" }
using "[wrap]" { "_wowRawFrame", "GetDontSavePosition" }
using "[wrap]" { "_wowRawFrame", "HasFixedFrameStrata" }
using "[wrap]" { "_wowRawFrame", "SetDontSavePosition" }
using "[wrap]" { "_wowRawFrame", "SetDrawLayerEnabled" }
using "[wrap]" { "_wowRawFrame", "SetFixedFrameStrata" }
using "[wrap]" { "_wowRawFrame", "UnregisterAllEvents" }
using "[wrap]" { "_wowRawFrame", "GetHyperlinksEnabled" }
using "[wrap]" { "_wowRawFrame", "SetHyperlinksEnabled" }
using "[wrap]" { "_wowRawFrame", "SetIgnoreParentAlpha" }
using "[wrap]" { "_wowRawFrame", "SetIgnoreParentScale" }
using "[wrap]" { "_wowRawFrame", "IsGamePadStickEnabled" }
using "[wrap]" { "_wowRawFrame", "IsIgnoringParentAlpha" }
using "[wrap]" { "_wowRawFrame", "IsIgnoringParentScale" }
using "[wrap]" { "_wowRawFrame", "SetAttributeNoHandler" }
using "[wrap]" { "_wowRawFrame", "IsGamePadButtonEnabled" }
using "[wrap]" { "_wowRawFrame", "GetFlattensRenderLayers" }
using "[wrap]" { "_wowRawFrame", "SetFlattensRenderLayers" }
using "[wrap]" { "_wowRawFrame", "GetPropagateKeyboardInput" }
using "[wrap]" { "_wowRawFrame", "SetPropagateKeyboardInput" }
using "[wrap]" { "_wowRawFrame", "GetEffectivelyFlattensRenderLayers" }

-- from 'Region' parent class
using "[wrap]" { "_wowRawFrame", "GetAlpha" }
using "[wrap]" { "_wowRawFrame", "GetScale" }
using "[wrap]" { "_wowRawFrame", "SetAlpha" }
using "[wrap]" { "_wowRawFrame", "SetScale" }
using "[wrap]" { "_wowRawFrame", "GetDrawLayer" }
using "[wrap]" { "_wowRawFrame", "SetDrawLayer" }
using "[wrap]" { "_wowRawFrame", "GetVertexColor" }
using "[wrap]" { "_wowRawFrame", "IsObjectLoaded" }
using "[wrap]" { "_wowRawFrame", "SetVertexColor" }
using "[wrap]" { "_wowRawFrame", "GetEffectiveScale" }
using "[wrap]" { "_wowRawFrame", "SetIgnoreParentAlpha" }
using "[wrap]" { "_wowRawFrame", "SetIgnoreParentScale" }
using "[wrap]" { "_wowRawFrame", "IsIgnoringParentAlpha" }
using "[wrap]" { "_wowRawFrame", "IsIgnoringParentScale" }

-- from 'ScriptRegion' grandparent class
using "[wrap]" { "_wowRawFrame", "Hide" }
using "[wrap]" { "_wowRawFrame", "Show" }
using "[wrap]" { "_wowRawFrame", "GetTop" }
using "[wrap]" { "_wowRawFrame", "GetLeft" }
using "[wrap]" { "_wowRawFrame", "GetRect" }
using "[wrap]" { "_wowRawFrame", "GetSize" }
using "[wrap]" { "_wowRawFrame", "IsShown" }
using "[wrap]" { "_wowRawFrame", "GetRight" }
using "[wrap]" { "_wowRawFrame", "GetWidth" }
using "[wrap]" { "_wowRawFrame", "SetShown" }
using "[wrap]" { "_wowRawFrame", "GetBottom" }
using "[wrap]" { "_wowRawFrame", "GetCenter" }
using "[wrap]" { "_wowRawFrame", "GetHeight" }
using "[wrap]" { "_wowRawFrame", "GetScript" }
using "[wrap]" { "_wowRawFrame", "HasScript" }
using "[wrap]" { "_wowRawFrame", "IsVisible" }
using "[wrap]" { "_wowRawFrame", "SetParent" }
using "[wrap]" { "_wowRawFrame", "SetScript" }
using "[wrap]" { "_wowRawFrame", "HookScript" }
using "[wrap]" { "_wowRawFrame", "IsDragging" }
using "[wrap]" { "_wowRawFrame", "EnableMouse" }
using "[wrap]" { "_wowRawFrame", "IsMouseOver" }
using "[wrap]" { "_wowRawFrame", "IsProtected" }
using "[wrap]" { "_wowRawFrame", "IsRectValid" }
using "[wrap]" { "_wowRawFrame", "GetScaledRect" }
using "[wrap]" { "_wowRawFrame", "IsMouseEnabled" }
using "[wrap]" { "_wowRawFrame", "EnableMouseWheel" }
using "[wrap]" { "_wowRawFrame", "EnableMouseMotion" }
using "[wrap]" { "_wowRawFrame", "GetSourceLocation" }
using "[wrap]" { "_wowRawFrame", "IsMouseMotionFocus" }
using "[wrap]" { "_wowRawFrame", "IsMouseClickEnabled" }
using "[wrap]" { "_wowRawFrame", "IsMouseWheelEnabled" }
using "[wrap]" { "_wowRawFrame", "IsMouseMotionEnabled" }
using "[wrap]" { "_wowRawFrame", "SetMouseClickEnabled" }
using "[wrap]" { "_wowRawFrame", "IsAnchoringRestricted" }
using "[wrap]" { "_wowRawFrame", "SetMouseMotionEnabled" }
using "[wrap]" { "_wowRawFrame", "SetPassThroughButtons" }
using "[wrap]" { "_wowRawFrame", "CanChangeProtectedState" }

-- from 'ScriptRegionResizing' parent class
using "[wrap]" { "_wowRawFrame", "SetSize" }
using "[wrap]" { "_wowRawFrame", "GetPoint" }
using "[wrap]" { "_wowRawFrame", "SetPoint" }
using "[wrap]" { "_wowRawFrame", "SetWidth" }
using "[wrap]" { "_wowRawFrame", "SetHeight" }
using "[wrap]" { "_wowRawFrame", "ClearPoint" }
using "[wrap]" { "_wowRawFrame", "GetNumPoints" }
using "[wrap]" { "_wowRawFrame", "SetAllPoints" }
using "[wrap]" { "_wowRawFrame", "ClearAllPoints" }
using "[wrap]" { "_wowRawFrame", "GetPointByName" }
using "[wrap]" { "_wowRawFrame", "ClearPointsOffset" }
using "[wrap]" { "_wowRawFrame", "AdjustPointsOffset" }

-- from 'AnimatableObject' parent class
using "[wrap]" { "_wowRawFrame", "StopAnimating" }
using "[wrap]" { "_wowRawFrame", "GetAnimationGroups" }
using "[wrap]" { "_wowRawFrame", "CreateAnimationGroup" }

-- from 'FrameScriptObject' parent class
using "[wrap]" { "_wowRawFrame", "GetName" }
using "[wrap]" { "_wowRawFrame", "IsForbidden" }
using "[wrap]" { "_wowRawFrame", "IsObjectType" }
using "[wrap]" { "_wowRawFrame", "SetForbidden" }
using "[wrap]" { "_wowRawFrame", "GetObjectType" }

-- from 'Object' parent class
using "[wrap]" { "_wowRawFrame", "GetParent" }
using "[wrap]" { "_wowRawFrame", "GetDebugName" }
using "[wrap]" { "_wowRawFrame", "GetParentKey" }
using "[wrap]" { "_wowRawFrame", "SetParentKey" }
