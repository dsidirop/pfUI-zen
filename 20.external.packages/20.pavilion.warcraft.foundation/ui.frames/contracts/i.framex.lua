--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IFrameX = using "[declare] [interface]" "Pavilion.Warcraft.Foundation.UI.Frames.Contracts.IFrameX" --@formater:on

-- pavilion extra methods
function IFrameX:GetRawWowFrame() end;
function IFrameX:ChainSet_Height(height) end;
function IFrameX:ChainSet_Visibility(showNotHide) end;

function IFrameX:ChainApply_NudgingX(xNudge) end;
function IFrameX:ChainApply_NudgingY(yNudge) end;
function IFrameX:ChainApply_NudgingXY(xNudge, yNudge) end;

-- from 'Frame' itself
function IFrameX:Hide() end;
function IFrameX:Show() end;
function IFrameX:GetID() end;
function IFrameX:Lower() end;
function IFrameX:Raise() end;
function IFrameX:SetID() end;
function IFrameX:IsShown() end;
function IFrameX:GetAlpha() end;
function IFrameX:GetScale() end;
function IFrameX:SetAlpha() end;
function IFrameX:SetScale() end;
function IFrameX:SetShown() end;
function IFrameX:AbortDrag() end;
function IFrameX:IsMovable() end;
function IFrameX:IsVisible() end;
function IFrameX:CreateLine() end;
function IFrameX:GetRegions() end;
function IFrameX:IsToplevel() end;
function IFrameX:SetMovable() end;
function IFrameX:GetChildren() end;
function IFrameX:IsResizable() end;
function IFrameX:SetToplevel() end;
function IFrameX:StartMoving() end;
function IFrameX:StartSizing() end;
function IFrameX:GetAttribute() end;
function IFrameX:IsUserPlaced() end;
function IFrameX:SetAttribute() end;
function IFrameX:SetResizable() end;
function IFrameX:CreateTexture() end;
function IFrameX:GetBoundsRect() end;
function IFrameX:GetFrameLevel() end;
function IFrameX:GetNumRegions() end;
function IFrameX:RegisterEvent() end;
function IFrameX:SetFrameLevel() end;
function IFrameX:SetUserPlaced() end;
function IFrameX:EnableKeyboard() end;
function IFrameX:GetFrameStrata() end;
function IFrameX:GetNumChildren() end;
function IFrameX:IsObjectLoaded() end;
function IFrameX:RotateTextures() end;
function IFrameX:SetFrameStrata() end;
function IFrameX:EnableDrawLayer() end;
function IFrameX:GetResizeBounds() end;
function IFrameX:RegisterForDrag() end;
function IFrameX:SetResizeBounds() end;
function IFrameX:UnregisterEvent() end;
function IFrameX:CreateFontString() end;
function IFrameX:DisableDrawLayer() end;
function IFrameX:DoesClipChildren() end;
function IFrameX:ExecuteAttribute() end;
function IFrameX:GetHitRectInsets() end;
function IFrameX:SetClipsChildren() end;
function IFrameX:SetHitRectInsets() end;
function IFrameX:SetIsFrameBuffer() end;
function IFrameX:CreateMaskTexture() end;
function IFrameX:GetEffectiveAlpha() end;
function IFrameX:GetEffectiveScale() end;
function IFrameX:IsClampedToScreen() end;
function IFrameX:IsEventRegistered() end;
function IFrameX:IsKeyboardEnabled() end;
function IFrameX:RegisterAllEvents() end;
function IFrameX:RegisterUnitEvent() end;
function IFrameX:CanChangeAttribute() end;
function IFrameX:EnableGamePadStick() end;
function IFrameX:GetClampRectInsets() end;
function IFrameX:HasFixedFrameLevel() end;
function IFrameX:InterceptStartDrag() end;
function IFrameX:SetClampRectInsets() end;
function IFrameX:SetClampedToScreen() end;
function IFrameX:SetFixedFrameLevel() end;
function IFrameX:StopMovingOrSizing() end;
function IFrameX:DesaturateHierarchy() end;
function IFrameX:EnableGamePadButton() end;
function IFrameX:GetDontSavePosition() end;
function IFrameX:HasFixedFrameStrata() end;
function IFrameX:SetDontSavePosition() end;
function IFrameX:SetDrawLayerEnabled() end;
function IFrameX:SetFixedFrameStrata() end;
function IFrameX:UnregisterAllEvents() end;
function IFrameX:GetHyperlinksEnabled() end;
function IFrameX:SetHyperlinksEnabled() end;
function IFrameX:SetIgnoreParentAlpha() end;
function IFrameX:SetIgnoreParentScale() end;
function IFrameX:IsGamePadStickEnabled() end;
function IFrameX:IsIgnoringParentAlpha() end;
function IFrameX:IsIgnoringParentScale() end;
function IFrameX:SetAttributeNoHandler() end;
function IFrameX:IsGamePadButtonEnabled() end;
function IFrameX:GetFlattensRenderLayers() end;
function IFrameX:SetFlattensRenderLayers() end;
function IFrameX:GetPropagateKeyboardInput() end;
function IFrameX:SetPropagateKeyboardInput() end;
function IFrameX:GetEffectivelyFlattensRenderLayers() end;

-- from 'Region' parent class
function IFrameX:GetAlpha() end;
function IFrameX:GetScale() end;
function IFrameX:SetAlpha() end;
function IFrameX:SetScale() end;
function IFrameX:GetDrawLayer() end;
function IFrameX:SetDrawLayer() end;
function IFrameX:GetVertexColor() end;
function IFrameX:IsObjectLoaded() end;
function IFrameX:SetVertexColor() end;
function IFrameX:GetEffectiveScale() end;
function IFrameX:SetIgnoreParentAlpha() end;
function IFrameX:SetIgnoreParentScale() end;
function IFrameX:IsIgnoringParentAlpha() end;
function IFrameX:IsIgnoringParentScale() end;

-- from 'ScriptRegion' grandparent class
function IFrameX:Hide() end;
function IFrameX:Show() end;
function IFrameX:GetTop() end;
function IFrameX:GetLeft() end;
function IFrameX:GetRect() end;
function IFrameX:GetSize() end;
function IFrameX:IsShown() end;
function IFrameX:GetRight() end;
function IFrameX:GetWidth() end;
function IFrameX:SetShown() end;
function IFrameX:GetBottom() end;
function IFrameX:GetCenter() end;
function IFrameX:GetHeight() end;
function IFrameX:GetScript() end;
function IFrameX:HasScript() end;
function IFrameX:IsVisible() end;
function IFrameX:SetParent() end;
function IFrameX:SetScript() end;
function IFrameX:HookScript() end;
function IFrameX:IsDragging() end;
function IFrameX:EnableMouse() end;
function IFrameX:IsMouseOver() end;
function IFrameX:IsProtected() end;
function IFrameX:IsRectValid() end;
function IFrameX:GetScaledRect() end;
function IFrameX:IsMouseEnabled() end;
function IFrameX:EnableMouseWheel() end;
function IFrameX:EnableMouseMotion() end;
function IFrameX:GetSourceLocation() end;
function IFrameX:IsMouseMotionFocus() end;
function IFrameX:IsMouseClickEnabled() end;
function IFrameX:IsMouseWheelEnabled() end;
function IFrameX:IsMouseMotionEnabled() end;
function IFrameX:SetMouseClickEnabled() end;
function IFrameX:IsAnchoringRestricted() end;
function IFrameX:SetMouseMotionEnabled() end;
function IFrameX:SetPassThroughButtons() end;
function IFrameX:CanChangeProtectedState() end;

-- from 'ScriptRegionResizing' parent class
function IFrameX:SetSize() end;
function IFrameX:GetPoint() end;
function IFrameX:SetPoint() end;
function IFrameX:SetWidth() end;
function IFrameX:SetHeight() end;
function IFrameX:ClearPoint() end;
function IFrameX:GetNumPoints() end;
function IFrameX:SetAllPoints() end;
function IFrameX:ClearAllPoints() end;
function IFrameX:GetPointByName() end;
function IFrameX:ClearPointsOffset() end;
function IFrameX:AdjustPointsOffset() end;

-- from 'AnimatableObject' parent class
function IFrameX:StopAnimating() end;
function IFrameX:GetAnimationGroups() end;
function IFrameX:CreateAnimationGroup() end;

-- from 'FrameScriptObject' parent class
function IFrameX:GetName() end;
function IFrameX:IsForbidden() end;
function IFrameX:IsObjectType() end;
function IFrameX:SetForbidden() end;
function IFrameX:GetObjectType() end;

-- from 'Object' parent class
function IFrameX:GetParent() end;
function IFrameX:GetDebugName() end;
function IFrameX:GetParentKey() end;
function IFrameX:SetParentKey() end;
