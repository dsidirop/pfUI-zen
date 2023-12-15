local COLLAPSE_TEXTURE = 'Interface/Buttons/UI-%sButton-Up'
local NUM_VISIBLE_BUTTONS = 16

local COLORS = {
    GRAY_FONT_COLOR,
    GREEN_FONT_COLOR,
    YELLOW_FONT_COLOR,
    RED_FONT_COLOR
}

--[[ Events ]]--

function VWoWUnit:OnEvent(event)
    C_Timer.NewTicker(
            0.1,
            function()
                self:RunTests(event)
                if self:IsShown() then
                    self.Scroll:update()
                end

                local status, count = self.Group.Status(self)
                local color = COLORS[status]
                VWoWUnitToggle:SetText(count)
                VWoWUnitToggle:SetWidth(VWoWUnitToggle:GetTextWidth() + 14)
                VWoWUnitToggle:SetBackdropColor(color.r, color.g, color.b)
            end,
            5
    )
end

function VWoWUnit:OnShow()
    HybridScrollFrame_CreateButtons(self.Scroll, 'VWoWUnitButtonTemplate', 2, -4, 'TOPLEFT', 'TOPLEFT', 0, -3)

    self:SortRegistry()
    self.TitleText:SetText('Unit Tests')
    self.Scroll:update()
end

function VWoWUnit:OnLoad()
    self.Bar.Highlight1:SetPoint('TOPLEFT', self, 'TOPLEFT', -2, 4)
    self.Bar.Highlight1:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -10, -4)
    self.Background:SetPoint('TOPRIGHT', self.Bar.Left, 'TOPLEFT', 0, 0)
    self.Name:SetPoint('RIGHT', self.Bar, 'LEFT', -3, 0)
end

function VWoWUnit:OnClick(entry)
    if entry.TestGroups then
        VWoWUnit_SV[entry.Name] = not VWoWUnit_SV[entry.Name] or nil
        self.Scroll:update()

    elseif table.getn(entry.errors) > 0 then
        local log = entry.log or CreateFrame('Frame', 'VWoWUnit' .. entry.Name .. 'Log', UIParent, 'VWoWUnitLogTemplate')
        log.Content:SetText(entry.errors[1])
        log.TitleText:SetText(entry.name)
        log:Show()

        entry.log = log
    end
end

function VWoWUnit:OnEnter()
    self.Bar.Highlight1:Show()
    self.Bar.Highlight2:Show()    
end

function VWoWUnit:OnLeave()
    self.Bar.Highlight1:Hide()
    self.Bar.Highlight2:Hide()    
end



--[[ Registry ]]--

function VWoWUnit:SortRegistry()
    sort(self.TestGroups)

    for _, group in _ipairs(self.TestGroups) do
        sort(group.TestGroups)
    end
end

function VWoWUnit:ListRegistry()
    local entries = {}
    for _, group in pairs(VWoWUnit.TestGroups) do
        table.insert(entries, group)

        if not VWoWUnit_SV[group.name] then
            for _, test in pairs(group.TestGroups) do
                table.insert(entries, test)
            end
        end
    end

    return entries
end


--[[ Update ]]--

function VWoWUnit.Scroll:update()
    local self = self or VWoWUnit.Scroll
    local off = HybridScrollFrame_GetOffset(self)
    local entries = VWoWUnit:ListRegistry()
    local overflow = table.getn(entries) > NUM_VISIBLE_BUTTONS

    for i, button in _ipairs(self.buttons) do
        local entry = entries[i + off]
        if entry then
            local isHeader = entry.TestGroups
            local collapseTexture = COLLAPSE_TEXTURE:format(VWoWUnit_SV[entry.name] and 'Plus' or 'Minus')
            local color = COLORS[entry:Status()]
            local height = isHeader and 15 or 21

            button.Name:SetText(entry.name)
            button.Name:SetFontObject(isHeader and GameFontNormalLeft or GameFontHighlightSmall)
            button.Name:SetPoint('LEFT', isHeader and button.CollapseButton or button, isHeader and 'RIGHT' or 'LEFT', 10, 0)
            button.Bar:SetStatusBarColor(color.r, color.g, color.b)
            button.CollapseButton:SetNormalTexture(collapseTexture)
            button.CollapseButton:SetShown(isHeader)
            button.Background:SetShown(not isHeader)
            button.Bar.Right:SetHeight(height)
            button.Bar.Left:SetHeight(height)

            if LE_EXPANSION_LEVEL_CURRENT < 2 then
                button.Background:SetTexCoord(0, 0.48, 0, 0.328125)
                button.Bar.Right:SetTexCoord(0, 0.0625, 0.34375, 0.671875)
                button.Bar.Left:SetTexCoord(0.48, 1, 0, 0.328125)
                button.Bar.Right:SetWidth(10)
                button.Bar.Left:SetWidth(92)
            else
                button.Background:SetTexCoord(0, 0.7578125, 0, 0.328125)

                if isHeader then
                    button.Bar.Right:SetTexCoord(0.0, 0.15234375, 0.390625, 0.625)
                    button.Bar.Left:SetTexCoord(0.765625, 1.0, 0.046875, 0.28125)
                else
                    button.Bar.Right:SetTexCoord(0.0, 0.1640625, 0.34375, 0.671875)
                    button.Bar.Left:SetTexCoord(0.7578125, 1.0, 0.0, 0.328125)
                end
            end
        end

        button:SetWidth(overflow and 222 or 238)
        button:SetShown(entry)
        button.entry = entry
    end

    HybridScrollFrame_Update(self, table.getn(entries) * 23 + 3, NUM_VISIBLE_BUTTONS * 20)
    self:SetPoint('BOTTOMRIGHT', overflow and -25 or 0, 7)
end

if BackdropTemplateMixin then
    Mixin(VWoWUnitToggle, BackdropTemplateMixin)
end

VWoWUnit_SV = VWoWUnit_SV or {}
VWoWUnit:SetScript('OnEvent', VWoWUnit.OnEvent)
VWoWUnit:SetScript('OnShow', VWoWUnit.OnShow)
VWoWUnitToggle:SetBackdrop({
    bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
    edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
    tileSize = 16, edgeSize = 16, tile = true, tileEdge = true,
    backdropColor = TOOLTIP_DEFAULT_BACKGROUND_COLOR,
    backdropBorderColor = TOOLTIP_DEFAULT_COLOR,
})
