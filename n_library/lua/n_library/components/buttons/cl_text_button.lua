local PANEL = {}

function PANEL:Init()
    self:SetText("")
    self:SetCursor("hand")
    self:SetTall(32)
    
    self.Label = ""
    self.TextColor = Color(179, 115, 226)
    self.HoverColor = Color(189, 135, 236)
    self.HoverProgress = 0
    self.UnderlineProgress = 0
end

function PANEL:SetLabel(text)
    self.Label = text
end

function PANEL:SetTextColor(color)
    self.TextColor = color
end

function PANEL:SetHoverColor(color)
    self.HoverColor = color
end

function PANEL:Think()
    local isHovered = self:IsHovered()
    local target = isHovered and 1 or 0
    self.HoverProgress = Lerp(0.15, self.HoverProgress, target)
    self.UnderlineProgress = Lerp(0.2, self.UnderlineProgress, target)
end

function PANEL:Paint(w, h)
    local textColor = Color(
        Lerp(self.HoverProgress, self.TextColor.r, self.HoverColor.r),
        Lerp(self.HoverProgress, self.TextColor.g, self.HoverColor.g),
        Lerp(self.HoverProgress, self.TextColor.b, self.HoverColor.b)
    )
    
    draw.SimpleText(self.Label, "N.Font.14.Bold", w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    
    if self.UnderlineProgress > 0.01 then
        local lineWidth = w * self.UnderlineProgress
        local lineX = w/2 - lineWidth/2
        surface.SetDrawColor(textColor.r, textColor.g, textColor.b, 255)
        surface.DrawRect(lineX, h - 2, lineWidth, 2)
    end
    
    return true
end

vgui.Register("N.TextButton", PANEL, "DButton")