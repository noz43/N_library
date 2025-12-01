local PANEL = {}

function PANEL:Init()
    self.BGColor = Color(51, 41, 62)
    self.Radius = 8
    self.BorderColor = nil
    self.BorderThickness = 0
    self.EnableShadow = false
    self.ShadowSpread = 10
    self.ShadowIntensity = 15
end

function PANEL:SetBackgroundColor(col)
    self.BGColor = col or Color(51, 41, 62)
end

function PANEL:SetRadius(radius)
    self.Radius = radius or 8
end

function PANEL:SetBorder(color, thickness)
    self.BorderColor = color
    self.BorderThickness = thickness or 2
end

function PANEL:SetShadow(enabled, spread, intensity)
    self.EnableShadow = enabled
    self.ShadowSpread = spread or 10
    self.ShadowIntensity = intensity or 15
end

function PANEL:Paint(w, h)
    local bgColor = self.BGColor or Color(51, 41, 62)
    
    if N.RNDX then
        if self.EnableShadow then
            N.RNDX.DrawShadows(self.Radius, 0, 0, w, h, Color(0, 0, 0, 150), self.ShadowSpread, self.ShadowIntensity)
        end
        
        N.RNDX.Draw(self.Radius, 0, 0, w, h, bgColor)
        
        if self.BorderColor and self.BorderThickness > 0 then
            N.RNDX.DrawOutlined(self.Radius, 0, 0, w, h, self.BorderColor, self.BorderThickness)
        end
    else
        draw.RoundedBox(self.Radius, 0, 0, w, h, bgColor)
        
        if self.BorderColor and self.BorderThickness > 0 then
            N.Draw:RectOutline(0, 0, w, h, self.BorderColor, self.BorderThickness, self.Radius)
        end
    end
    
    return true
end

vgui.Register("N.Panel", PANEL, "DPanel")