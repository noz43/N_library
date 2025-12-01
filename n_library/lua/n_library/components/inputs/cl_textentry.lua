local PANEL = {}

function PANEL:Init()
    self:SetTall(40)
    self:SetFont("N.Font.14")
    self:SetTextColor(Color(255, 255, 255, 200))
    self:SetCursorColor(Color(179, 115, 226))
    self:SetHighlightColor(Color(179, 115, 226, 50))
    
    self.Placeholder = "Name..."
    self.Label = ""
    self.Style = "rounded"
    self.Disabled = false
    
    self.BGColor = Color(33, 25, 41)
    self.DisabledColor = Color(25, 20, 29)
    
    self.FocusProgress = 0
    self.HoverProgress = 0
end

function PANEL:SetPlaceholder(text)
    self.Placeholder = text
end

function PANEL:SetLabel(text)
    self.Label = text
end

function PANEL:SetInputStyle(style)
    self.Style = style
end

function PANEL:SetDisabled(bool)
    self.Disabled = bool
    self:SetEditable(not bool)
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
    local bgColor = self.Disabled and self.DisabledColor or self.BGColor
    local radius = 8
    
    if self.Style == "square" then
        radius = 0
    elseif self.Style == "sharp" then
        radius = 4
    elseif self.Style == "underline" then
        radius = 0
        
        N.RNDX.Draw(0, 0, 0, w, h, Color(33, 25, 41, 48))
        
        local lineAlpha = Lerp(self.FocusProgress, 100, 200)
        surface.SetDrawColor(179, 115, 226, lineAlpha)
        surface.DrawRect(0, h - 2, w, 2)
        
        if self:GetValue() == "" and not self:IsEditing() then
            local placeholderAlpha = Lerp(self.HoverProgress, 127, 180)
            draw.SimpleText(self.Placeholder, self:GetFont(), 10, h/2, Color(255, 255, 255, placeholderAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        
        return true
    end
    
    if self.FocusProgress > 0 and not self.Disabled then
        local glowAlpha = math.floor(30 * self.FocusProgress)
        N.RNDX.DrawShadows(radius, 0, 0, w, h, Color(179, 115, 226, glowAlpha), 8, 12)
    end
    
    N.RNDX.Draw(radius, 0, 0, w, h, bgColor)
    
    if self.FocusProgress > 0 and not self.Disabled then
        local strokeAlpha = math.floor(150 * self.FocusProgress)
        N.RNDX.DrawOutlined(radius, 0, 0, w, h, Color(179, 115, 226, strokeAlpha), 1)
    end
    
    if self:GetValue() == "" and not self:IsEditing() then
        local placeholderAlpha = self.Disabled and 80 or Lerp(self.HoverProgress, 127, 180)
        draw.SimpleText(self.Placeholder, self:GetFont(), 10, h/2, Color(255, 255, 255, placeholderAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    return true
end

function PANEL:PaintOver(w, h)
    if self.Label ~= "" then
        local labelAlpha = Lerp(self.FocusProgress, 200, 255)
        draw.SimpleText(self.Label, "N.Font.12.Bold", 0, -20, Color(255, 255, 255, labelAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
end

vgui.Register("N.TextEntry", PANEL, "DTextEntry")