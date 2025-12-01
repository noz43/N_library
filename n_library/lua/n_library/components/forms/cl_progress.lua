local PANEL = {}

function PANEL:Init()
    self:SetSize(200, 8)
    
    self.Value = 0
    self.MaxValue = 100
    self.MinValue = 0
    self.ShowLabel = false
    self.LabelFormat = "%d%%"
    self.Title = ""
    self.Description = ""
    self.MainLabel = "" 
    
    self.BGColor = Color(23, 19, 28)
    self.BarColor = Color(179, 115, 226)
    self.GradientStart = Color(179, 115, 226)
    self.GradientEnd = Color(115, 61, 155)
    
    self.Animated = true
    self.CurrentValue = 0
    
    self.BarGradient = true
    self.Style = "horizontal"
    self.ShowDots = false
    self.DotCount = 5
    self.DotSpacing = 0
    self.DotSize = 4
end

function PANEL:Think()
    if self.Animated then
        self.CurrentValue = Lerp(0.1, self.CurrentValue, self.Value)
    else
        self.CurrentValue = self.Value
    end
end

function PANEL:SetValue(value)
    self.Value = math.Clamp(value, self.MinValue, self.MaxValue)
    self:OnChange(self.Value)
end

function PANEL:GetValue()
    return self.Value
end

function PANEL:SetMaxValue(max)
    self.MaxValue = max
end

function PANEL:SetMinValue(min)
    self.MinValue = min
end

function PANEL:SetBarColor(color)
    self.BarColor = color
    self.GradientStart = color
end

function PANEL:SetGradientColors(startColor, endColor)
    self.GradientStart = startColor
    self.GradientEnd = endColor
    self.BarGradient = true
end

function PANEL:SetShowLabel(bool)
    self.ShowLabel = bool
end

function PANEL:SetLabelFormat(format)
    self.LabelFormat = format
end

function PANEL:SetTitle(title)
    self.Title = title
end

function PANEL:SetDescription(desc)
    self.Description = desc
end

function PANEL:SetMainLabel(label)
    self.MainLabel = label
end

function PANEL:SetBarGradient(enabled)
    self.BarGradient = enabled
end

function PANEL:SetStyle(style)
    self.Style = style
end

function PANEL:SetShowDots(show)
    self.ShowDots = show
end

function PANEL:SetDotCount(count)
    self.DotCount = count
end

function PANEL:SetDotSpacing(spacing)
    self.DotSpacing = spacing
end

function PANEL:SetDotSize(size)
    self.DotSize = size
end

function PANEL:OnChange(value)
end

function PANEL:Paint(w, h)
    local barH = 8
    local barY = 0
    local barX = 0
    local barW = w
    local radius = 11  
    
    if self.MainLabel ~= "" then
        draw.SimpleText(self.MainLabel, "N.Font.24.Bold", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        barY = 22
    end
    
    if self.Title ~= "" then
        local titleY = self.MainLabel ~= "" and 20 or 0
        draw.SimpleText(self.Title, "N.Font.12", 0, titleY, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    
    N.RNDX.Draw(radius, barX, barY, barW, barH, self.BGColor)
    
    local percent = (self.CurrentValue - self.MinValue) / (self.MaxValue - self.MinValue)
    local filledW = barW * percent
    
    if filledW < barH then
        filledW = math.max(0, filledW)
    end
    
    if filledW > 0 then
        if self.BarGradient then
            local steps = 50
            local stepWidth = filledW / steps
            
            for i = 0, steps - 1 do
                local x = barX + i * stepWidth
                local progress = i / (steps - 1)
                
                local r = Lerp(progress, self.GradientStart.r, self.GradientEnd.r)
                local g = Lerp(progress, self.GradientStart.g, self.GradientEnd.g)
                local b = Lerp(progress, self.GradientStart.b, self.GradientEnd.b)
                
                local flags = 0
                if i ~= 0 then
                    flags = N.RNDX.NO_TL + N.RNDX.NO_BL
                end
                if i ~= steps - 1 then
                    flags = flags + N.RNDX.NO_TR + N.RNDX.NO_BR
                end
                
                N.RNDX.Draw(radius, x, barY, stepWidth + 1, barH, Color(r, g, b, 255), flags)
            end
        else
            N.RNDX.Draw(radius, barX, barY, filledW, barH, self.BarColor)
        end
    end
    
    if self.ShowDots then
        local spacing = self.DotSpacing > 0 and self.DotSpacing or (barW / (self.DotCount + 1))
        
        for i = 1, self.DotCount do
            local dotX = barX + spacing * i
            local dotY = barY + barH / 2
            local filled = (dotX / barW) <= percent
            
            local dotColor = Color(255, 255, 255, filled and 255 or 100)
            
            N.RNDX.DrawCircle(dotX, dotY, self.DotSize / 2, dotColor)
        end
    end
    
    return true
end

vgui.Register("N.Progress", PANEL, "DPanel")