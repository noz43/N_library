local PANEL = {}

function PANEL:Init()
    self.BGColor = Color(51, 41, 62)
    self.BorderColor = nil
    self.BorderThickness = 0
    self.Radius = 8
    self.EnableShadow = false
    self.ShadowSpread = 10
    self.ShadowIntensity = 15
    self.EnableGlow = false
    self.GlowColor = nil
    
    self.UsePattern = false
    self.PatternType = "DiagonalLines"
    self.PatternColor = Color(255, 255, 255, 10)
    self.PatternSpacing = 20
    self.PatternThickness = 2
end

function PANEL:SetBackgroundColor(col)
    self.BGColor = col
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

function PANEL:SetGlow(enabled, color)
    self.EnableGlow = enabled
    self.GlowColor = color or self.BGColor
end

function PANEL:SetPattern(patternType, color, spacing, thickness)
    self.UsePattern = true
    self.PatternType = patternType or "DiagonalLines"
    self.PatternColor = color or Color(255, 255, 255, 10)
    self.PatternSpacing = spacing or 20
    self.PatternThickness = thickness or 2
end

function PANEL:DisablePattern()
    self.UsePattern = false
end

function PANEL:Paint(w, h)
    if N.RNDX then
        if self.EnableShadow or self.EnableGlow then
            local glowCol = self.EnableGlow and self.GlowColor or Color(0, 0, 0, 150)
            N.RNDX.DrawShadows(self.Radius, 0, 0, w, h, glowCol, self.ShadowSpread, self.ShadowIntensity)
        end
        
        N.RNDX.Draw(self.Radius, 0, 0, w, h, self.BGColor)
        
        if self.BorderColor and self.BorderThickness > 0 then
            N.RNDX.DrawOutlined(self.Radius, 0, 0, w, h, self.BorderColor, self.BorderThickness)
        end
    else
        draw.RoundedBox(self.Radius, 0, 0, w, h, self.BGColor)
        
        if self.BorderColor and self.BorderThickness > 0 then
            N.Draw:RectOutline(0, 0, w, h, self.BorderColor, self.BorderThickness, self.Radius)
        end
    end
    
    if self.UsePattern and N.Patterns and N.Patterns[self.PatternType] then
        N.Patterns[self.PatternType](0, 0, w, h, self.PatternColor, self.PatternSpacing, self.PatternThickness)
    end
end

vgui.Register("N.BasePanel", PANEL, "DPanel")