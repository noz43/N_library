local PANEL = {}

function PANEL:Init()
    self:SetTall(40)
    self:SetFont("N.Font.14")
    self:SetTextColor(Color(255, 255, 255, 200))
    self:SetCursorColor(Color(179, 115, 226))
    self:SetHighlightColor(Color(179, 115, 226, 50))
    
    self.Placeholder = "Search..."
    self.Style = "rounded"
    self.IconPosition = "left"
    self.Icon = "search"
    self.IconMaterial = nil
    
    self.BGColor = Color(33, 25, 41)
    
    self.FocusProgress = 0
    self.HoverProgress = 0
end

function PANEL:SetPlaceholder(text)
    self.Placeholder = text
end

function PANEL:SetInputStyle(style)
    self.Style = style
end

function PANEL:SetIconPosition(pos)
    self.IconPosition = pos
end

function PANEL:SetIcon(iconName)
    self.Icon = iconName
    if N and N.Materials and N.Materials.Icons and N.Materials.Icons[iconName] then
        self.IconMaterial = N.Materials.Icons[iconName]
    end
end

function PANEL:Think()
    local isFocused = self:HasFocus()
    local target = isFocused and 1 or 0
    self.FocusProgress = Lerp(0.15, self.FocusProgress, target)
    
    local isHovered = self:IsHovered()
    local hoverTarget = isHovered and 1 or 0
    self.HoverProgress = Lerp(0.15, self.HoverProgress, hoverTarget)
end

function PANEL:Paint(w, h)
    local radius = 8
    
    if self.Style == "square" then
        radius = 0
    elseif self.Style == "sharp" then
        radius = 4
    end
    
    if self.FocusProgress > 0 then
        local glowAlpha = math.floor(30 * self.FocusProgress)
        N.RNDX.DrawShadows(radius, 0, 0, w, h, Color(179, 115, 226, glowAlpha), 8, 12)
    end
    
    N.RNDX.Draw(radius, 0, 0, w, h, self.BGColor)
    
    if self.FocusProgress > 0 then
        local strokeAlpha = math.floor(150 * self.FocusProgress)
        N.RNDX.DrawOutlined(radius, 0, 0, w, h, Color(179, 115, 226, strokeAlpha), 1)
    end
    
    local iconSize = 16
    local iconX, iconY
    local textOffset = 0
    
    if self.IconPosition == "left" then
        iconX = 10
        iconY = h/2 - iconSize/2
        textOffset = 35
    elseif self.IconPosition == "right" then
        iconX = w - iconSize - 10
        iconY = h/2 - iconSize/2
        textOffset = 10
    end
    
    if self.IconMaterial then
        local iconAlpha = Lerp(self.FocusProgress, 150, 220)
        surface.SetDrawColor(255, 255, 255, iconAlpha)
        surface.SetMaterial(self.IconMaterial)
        surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
    end
    
    if self:GetValue() == "" and not self:IsEditing() then
        local placeholderAlpha = Lerp(self.HoverProgress, 127, 180)
        draw.SimpleText(self.Placeholder, self:GetFont(), textOffset, h/2, Color(255, 255, 255, placeholderAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    return true
end

function PANEL:OnGetFocus()
    self:SetTextInset(self.IconPosition == "left" and 35 or 10, 0)
end

vgui.Register("N.Search", PANEL, "DTextEntry")