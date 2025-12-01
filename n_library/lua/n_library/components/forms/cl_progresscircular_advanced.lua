local PANEL = {}

function PANEL:Init()
    self:SetSize(140, 140)
    
    self.Value = 0
    self.MaxValue = 100
    self.MinValue = 0
    
    self.BGColor = Color(40, 35, 45)
    self.BarColor = Color(179, 115, 226)
    
    self.Thickness = 18
    self.ShowLabel = true
    self.LabelFormat = "%d%%"
    self.CustomLabel = nil
    self.Title = ""
    
    self.Animated = true
    self.CurrentValue = 0
    self.UseGradient = false
    self.ShowGlow = true
    
    self.GlowIntensity = 1.0
end

function PANEL:SetValue(value)
    self.Value = math.Clamp(value, self.MinValue, self.MaxValue)
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
end

function PANEL:SetBGColor(color)
    self.BGColor = color
end

function PANEL:SetThickness(thickness)
    self.Thickness = thickness
end

function PANEL:SetTitle(title)
    self.Title = title
end

function PANEL:SetLabelFormat(format)
    if type(format) == "string" then
        if string.find(format, "%%") then
            self.LabelFormat = format
            self.CustomLabel = nil
        else
            self.CustomLabel = format
            self.LabelFormat = nil
        end
    end
end

function PANEL:SetUseGradient(use)
    self.UseGradient = use
end

function PANEL:SetShowGlow(show)
    self.ShowGlow = show
end

function PANEL:SetGlowIntensity(intensity)
    self.GlowIntensity = math.Clamp(intensity, 0, 2)
end

function PANEL:Think()
    if self.Animated then
        self.CurrentValue = Lerp(0.1, self.CurrentValue, self.Value)
    else
        self.CurrentValue = self.Value
    end
end

function PANEL:Paint(w, h)
    local cx = w / 2
    local cy = h / 2
    local radius = math.min(w, h) / 2 - 4
    
    local percent = (self.CurrentValue - self.MinValue) / (self.MaxValue - self.MinValue)
    

    if N.Draw and N.Draw.CircularProgressAdvanced then
        local centerColor = Color(23, 19, 28)
        
        N.Draw.CircularProgressAdvanced(
            cx, cy,                   
            radius,                   
            percent,                
            self.BGColor,              
            self.BarColor,            
            self.Thickness,          
            self.ShowGlow,            
            centerColor,               
            true                    
        )
    else

        self:DrawFallback(cx, cy, radius, percent)
    end
    
    if self.Title and self.Title ~= "" then
        draw.SimpleText(self.Title, "N.Font.12.Bold", cx, cy - radius - 15, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    if self.ShowLabel then
        local label
        if self.CustomLabel then
            label = self.CustomLabel
        elseif self.LabelFormat then
            local success, result = pcall(string.format, self.LabelFormat, percent * 100)
            if success then
                label = result
            else
                label = tostring(math.Round(percent * 100)) .. "%"
            end
        else
            label = tostring(math.Round(percent * 100)) .. "%"
        end
        
        draw.SimpleText(label, "N.Font.24.Bold", cx, cy - 5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        
        if self.CustomLabel and self.LabelFormat then
            local success, percentText = pcall(string.format, self.LabelFormat, percent * 100)
            if success then
                draw.SimpleText(percentText, "N.Font.12", cx, cy + 15, Color(255, 255, 255, 180), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end
    
    return true
end

function PANEL:DrawFallback(cx, cy, radius, percent)
    self:DrawArc(cx, cy, radius, self.Thickness, 0, 360, self.BGColor, false)
    
    local angle = 360 * percent
    if angle > 0 then
        self:DrawArc(cx, cy, radius, self.Thickness, -90, -90 + angle, self.BarColor, self.UseGradient)
    end
end

function PANEL:DrawArc(cx, cy, radius, thickness, startAngle, endAngle, color, useGradient)
    local segments = 80
    draw.NoTexture()
    
    for i = 0, segments - 1 do
        local angle1 = math.rad(startAngle + (endAngle - startAngle) * (i / segments))
        local angle2 = math.rad(startAngle + (endAngle - startAngle) * ((i + 1) / segments))
        
        local x1_outer = cx + math.cos(angle1) * radius
        local y1_outer = cy + math.sin(angle1) * radius
        local x2_outer = cx + math.cos(angle2) * radius
        local y2_outer = cy + math.sin(angle2) * radius
        
        local x1_inner = cx + math.cos(angle1) * (radius - thickness)
        local y1_inner = cy + math.sin(angle1) * (radius - thickness)
        local x2_inner = cx + math.cos(angle2) * (radius - thickness)
        local y2_inner = cy + math.sin(angle2) * (radius - thickness)
        
        if useGradient then
            local progress = i / segments
            local intensity = 1.0 - (progress * 0.7)
            local r = math.floor(color.r * intensity)
            local g = math.floor(color.g * intensity)
            local b = math.floor(color.b * intensity)
            surface.SetDrawColor(r, g, b, 255)
        else
            surface.SetDrawColor(color)
        end
        
        surface.DrawPoly({
            {x = x1_outer, y = y1_outer},
            {x = x2_outer, y = y2_outer},
            {x = x2_inner, y = y2_inner},
            {x = x1_inner, y = y1_inner}
        })
    end
end

vgui.Register("N.ProgressCircularAdvanced", PANEL, "DPanel")