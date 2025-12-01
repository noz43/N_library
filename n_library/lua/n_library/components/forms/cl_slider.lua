local PANEL = {}

function PANEL:Init()
    self:SetSize(295, 40)
    self:SetCursor("hand")
    
    self.Value = 0
    self.MaxValue = 100
    self.MinValue = 0
    self.Decimals = 0
    self.Dragging = false
    
    self.Title = ""
    self.ShowValue = true
    self.ValueFormat = "%d/%d"
    self.ShowPercentage = false
    self.ValuePosition = "right"
    
    self.BGColor = Color(23, 19, 28)
    self.BarColor = Color(179, 115, 226)
    self.BarGradient = true
    self.GradientStart = Color(179, 115, 226)  -- #B373E2
    self.GradientEnd = Color(115, 61, 155)     -- #733D9B
    
    self.TrackHeight = 6
    self.Disabled = false
    
    self.HoverProgress = 0
end

function PANEL:SetValue(value)
    self.Value = math.Clamp(value, self.MinValue, self.MaxValue)
    self:OnValueChanged(self.Value)
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

function PANEL:SetDecimals(decimals)
    self.Decimals = decimals
end

function PANEL:SetTitle(title)
    self.Title = title
end

function PANEL:SetShowValue(show)
    self.ShowValue = show
end

function PANEL:SetValueFormat(format)
    self.ValueFormat = format
end

function PANEL:SetShowPercentage(show)
    self.ShowPercentage = show
end

function PANEL:SetValuePosition(pos)
    self.ValuePosition = pos
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

function PANEL:SetBarGradient(enabled)
    self.BarGradient = enabled
end

function PANEL:SetTrackHeight(height)
    self.TrackHeight = height
end

function PANEL:SetDisabled(disabled)
    self.Disabled = disabled
end

function PANEL:OnValueChanged(value)
end

function PANEL:OnMousePressed(keyCode)
    if keyCode == MOUSE_LEFT and not self.Disabled then
        self.Dragging = true
        self:UpdateValueFromMouse()
    end
end

function PANEL:OnMouseReleased(keyCode)
    if keyCode == MOUSE_LEFT then
        self.Dragging = false
    end
end

function PANEL:Think()
    if self.Dragging and not self.Disabled then
        self:UpdateValueFromMouse()
    end
    
    local isHovered = self:IsHovered()
    local target = isHovered and 1 or 0
    self.HoverProgress = Lerp(0.15, self.HoverProgress, target)
end

function PANEL:UpdateValueFromMouse()
    local x, _ = self:CursorPos()
    local w, h = self:GetSize()
    
    local percent = math.Clamp(x / w, 0, 1)
    local value = self.MinValue + (self.MaxValue - self.MinValue) * percent
    
    if self.Decimals == 0 then
        value = math.Round(value)
    else
        local mult = 10 ^ self.Decimals
        value = math.Round(value * mult) / mult
    end
    
    self:SetValue(value)
end

function PANEL:Paint(w, h)
    local trackY = 0
    local radius = 11  
    
    if self.Title ~= "" then
        local titleAlpha = Lerp(self.HoverProgress, 200, 255)
        draw.SimpleText(self.Title, "N.Font.14.Bold", 0, 0, Color(255, 255, 255, titleAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        trackY = 15
    end
    
    N.RNDX.Draw(radius, 0, trackY, w, self.TrackHeight, self.BGColor)
    
    local percent = (self.Value - self.MinValue) / (self.MaxValue - self.MinValue)
    local barW = w * percent
    
    if barW > 0 then
        if self.BarGradient then
            local steps = 50
            local stepWidth = barW / steps
            
            for i = 0, steps - 1 do
                local x = i * stepWidth
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
                
                N.RNDX.Draw(radius, x, trackY, stepWidth + 1, self.TrackHeight, Color(r, g, b, 255), flags)
            end
        else
            N.RNDX.Draw(radius, 0, trackY, barW, self.TrackHeight, self.BarColor)
        end
    end
    
    if self.ShowValue then
        local valueText
        if self.ShowPercentage then
            valueText = string.format("%d%%", percent * 100)
        else
            valueText = string.format(self.ValueFormat, self.Value, self.MaxValue)
        end
        
        local valueY = trackY + self.TrackHeight + 3
        local valueAlpha = Lerp(self.HoverProgress, 180, 255)
        
        if self.ValuePosition == "right" then
            draw.SimpleText(valueText, "N.Font.12", w, valueY, Color(255, 255, 255, valueAlpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
        elseif self.ValuePosition == "left" then
            draw.SimpleText(valueText, "N.Font.12", 0, valueY, Color(255, 255, 255, valueAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        elseif self.ValuePosition == "center" then
            draw.SimpleText(valueText, "N.Font.12", barW/2, trackY + self.TrackHeight/2, Color(255, 255, 255, valueAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(valueText, "N.Font.12", w, valueY, Color(255, 255, 255, valueAlpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
        end
    end
    
    return true
end

vgui.Register("N.Slider", PANEL, "DPanel")