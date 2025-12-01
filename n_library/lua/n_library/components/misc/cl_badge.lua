local PANEL = {}

function PANEL:Init()
    self:SetSize(60, 20)
    
    self.Text = "Badge"
    self.Style = "default"
    
    self.Colors = {
        default = {
            bg = Color(51, 41, 62),
            text = Color(255, 255, 255)
        },
        primary = {
            bg = Color(179, 115, 226),
            text = Color(255, 255, 255)
        },
        success = {
            bg = Color(114, 196, 114),
            text = Color(255, 255, 255)
        },
        warning = {
            bg = Color(230, 180, 80),
            text = Color(255, 255, 255)
        },
        danger = {
            bg = Color(217, 112, 112),
            text = Color(255, 255, 255)
        },
        info = {
            bg = Color(91, 141, 233),
            text = Color(255, 255, 255)
        }
    }
    
    self.Icon = nil
    self.IconMaterial = nil
    
    self.HoverProgress = 0
end

function PANEL:SetText(text)
    self.Text = text
    self:SizeToContents()
end

function PANEL:SetStyle(style)
    self.Style = style
end

function PANEL:SetIcon(iconName)
    self.Icon = iconName
    if N and N.Materials and N.Materials.Icons and N.Materials.Icons[iconName] then
        self.IconMaterial = N.Materials.Icons[iconName]
    end
    self:SizeToContents()
end

function PANEL:SizeToContents()
    surface.SetFont("N.Font.12")
    local textW, textH = surface.GetTextSize(self.Text)
    
    local w = textW + 16
    if self.IconMaterial then
        w = w + 12 + 4
    end
    
    self:SetSize(w, 20)
end

function PANEL:Think()
    local isHovered = self:IsHovered()
    local target = isHovered and 1 or 0
    self.HoverProgress = Lerp(0.15, self.HoverProgress, target)
end

function PANEL:Paint(w, h)
    local colorSet = self.Colors[self.Style] or self.Colors.default
    
    if N.RNDX then
        if self.HoverProgress > 0 then
            local glowAlpha = math.floor(30 * self.HoverProgress)
            N.RNDX.DrawShadows(h/2, 0, 0, w, h, Color(colorSet.bg.r, colorSet.bg.g, colorSet.bg.b, glowAlpha), 6, 10)
        end
        
        N.RNDX.Draw(h/2, 0, 0, w, h, colorSet.bg)
    else
        draw.RoundedBox(h/2, 0, 0, w, h, colorSet.bg)
    end
    
    local textX = w/2
    
    if self.IconMaterial then
        local iconSize = 12
        local iconX = 6
        local iconY = h/2 - iconSize/2
        
        local iconAlpha = Lerp(self.HoverProgress, 200, 255)
        surface.SetDrawColor(colorSet.text.r, colorSet.text.g, colorSet.text.b, iconAlpha)
        surface.SetMaterial(self.IconMaterial)
        surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
        
        textX = iconX + iconSize + 4 + (w - iconX - iconSize - 4 - 8) / 2
    end
    
    local textAlpha = Lerp(self.HoverProgress, 200, 255)
    draw.SimpleText(self.Text, "N.Font.12", textX, h/2, Color(colorSet.text.r, colorSet.text.g, colorSet.text.b, textAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    
    return true
end

vgui.Register("N.Badge", PANEL, "DPanel")