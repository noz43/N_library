local PANEL = {}

function PANEL:Init()
    self:SetText("")
    self:SetCursor("hand")
    self:SetSize(56, 56)
    
    self.Icon = nil
    self.IconMaterial = nil
    self.Style = "Standard"
    self.Shape = "square"
    self.Disabled = false
    
    self.Colors = {
        Standard = {
            normal = Color(120, 105, 140, 255),
            hover = Color(135, 120, 155, 255),
            icon = Color(255, 255, 255, 255)
        },
        Important = {
            normal = Color(179, 115, 226, 255),
            hover = Color(189, 135, 236, 255),
            icon = Color(255, 255, 255, 255)
        },
        Danger = {
            normal = Color(217, 112, 112, 255),
            hover = Color(227, 132, 132, 255),
            icon = Color(255, 255, 255, 255)
        },
        Disabled = {
            normal = Color(100, 90, 110, 255),
            hover = Color(100, 90, 110, 255),
            icon = Color(200, 190, 210, 255)
        }
    }
    
    self.HoverProgress = 0
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

function PANEL:SetShape(shape)
    self.Shape = shape
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
    
    local radius = 8
    if self.Shape == "rounded" then
        radius = 12
    elseif self.Shape == "circle" then
        radius = w/2
    end
    
    if N.RNDX then
        N.RNDX.Draw(radius, 0, 0, w, h, bgColor)
    else
        draw.RoundedBox(radius, 0, 0, w, h, bgColor)
    end
    
    if self.IconMaterial then
        local texW, texH = self.IconMaterial:Width(), self.IconMaterial:Height()
        local iconSize = math.min(texW, texH)
        
        iconSize = math.min(iconSize, math.min(w, h) - 8)
        
        iconSize = math.floor(iconSize)
        local x = math.floor((w - iconSize) / 2)
        local y = math.floor((h - iconSize) / 2)
        
        surface.SetMaterial(self.IconMaterial)
        surface.SetDrawColor(colorSet.icon)
        surface.DrawTexturedRect(x, y, iconSize, iconSize)
    elseif self.Icon then
        draw.SimpleText(self.Icon, "DermaDefault", w/2, h/2, colorSet.icon, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    return true
end

vgui.Register("N.IconButton", PANEL, "DButton")