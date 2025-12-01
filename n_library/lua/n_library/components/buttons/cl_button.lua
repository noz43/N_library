local PANEL = {}

function PANEL:Init()
    self:SetText("")
    self:SetCursor("hand")
    self:SetTall(40)
    
    self.Label = ""
    self.Icon = nil
    self.IconMaterial = nil
    self.Style = "Standard"
    self.Disabled = false
    
    self.Colors = {
        Standard = {
            normal = Color(60, 50, 70),
            hover = Color(75, 63, 88),
            text = Color(255, 255, 255)
        },
        Important = {
            normal = Color(179, 115, 226),
            hover = Color(189, 135, 236),
            text = Color(255, 255, 255)
        },
        Danger = {
            normal = Color(217, 112, 112),
            hover = Color(227, 132, 132),
            text = Color(255, 255, 255)
        },
        Disabled = {
            normal = Color(45, 38, 52),
            hover = Color(45, 38, 52),
            text = Color(150, 140, 160)
        }
    }
    
    self.HoverProgress = 0
end

function PANEL:SetLabel(text)
    self.Label = text
end

function PANEL:SetIcon(iconName)
    self.Icon = iconName
    if N and N.Materials and N.Materials.Icons and N.Materials.Icons[iconName] then
        self.IconMaterial = N.Materials.Icons[iconName]
    end
end

function PANEL:SetStyle(style)
    self.Style = style
end

function PANEL:SetDisabled(bool)
    self.Disabled = bool
    if bool then
        self.Style = "Disabled"
    end
end

function PANEL:DoClick()
    if self.Disabled then return end
end

function PANEL:Think()
    if self.Disabled then return end
    
    local isHovered = self:IsHovered()
    local target = isHovered and 1 or 0
    self.HoverProgress = Lerp(0.15, self.HoverProgress, target)
end

function PANEL:Paint(w, h)
    local colorSet = self.Colors[self.Style] or self.Colors.Standard
    
    local bgColor = Color(
        Lerp(self.HoverProgress, colorSet.normal.r, colorSet.hover.r),
        Lerp(self.HoverProgress, colorSet.normal.g, colorSet.hover.g),
        Lerp(self.HoverProgress, colorSet.normal.b, colorSet.hover.b)
    )
    
    if N.RNDX then
        N.RNDX.Draw(8, 0, 0, w, h, bgColor)
    else
        draw.RoundedBox(8, 0, 0, w, h, bgColor)
    end
    
    local iconSize = 18
    local fontSize = "N.Font.14.Bold"
    
    if h >= 60 then
        iconSize = 24
        fontSize = "N.Font.18.Bold"
    elseif h >= 50 then
        iconSize = 20
        fontSize = "N.Font.16.Bold"
    end
    
    if self.IconMaterial and self.Label ~= "" then
        surface.SetFont(fontSize)
        local textW, textH = surface.GetTextSize(self.Label)
        local totalW = iconSize + 8 + textW
        local startX = w/2 - totalW/2
        
        surface.SetDrawColor(colorSet.text)
        surface.SetMaterial(self.IconMaterial)
        surface.DrawTexturedRect(startX, h/2 - iconSize/2, iconSize, iconSize)
        
        draw.SimpleText(self.Label, fontSize, startX + iconSize + 8, h/2, colorSet.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    elseif self.Label ~= "" then
        draw.SimpleText(self.Label, fontSize, w/2, h/2, colorSet.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    return true
end

vgui.Register("N.Button", PANEL, "DButton")