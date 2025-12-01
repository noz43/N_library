local PANEL = {}

function PANEL:Init()
    self:SetSize(220, 40)  
    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(false)
    
    self.BGColor = Color(33, 25, 41)
    self.SelectedBG = Color(51, 41, 62)
    self.HoverBG = Color(25, 19, 30)
    self.BorderColor = Color(51, 41, 62, 100)
    self.ArrowColor = Color(84, 71, 98)  -- #544762
    self.TextColor = Color(255, 255, 255)
    
    self.Options = {}
    self.SelectedIndex = 1
    self.IsOpen = false
    
    self.MaxVisibleOptions = 4
    self.ScrollOffset = 0
    
    self.AnimProgress = 0
    self.TargetProgress = 0
    self.ArrowRotation = 0
    self.TargetRotation = 0
    
    self.HoverProgress = 0
end

function PANEL:AddOption(text, value)
    table.insert(self.Options, {text = text, value = value or text})
end

function PANEL:SetSelected(index)
    if #self.Options == 0 then return end
    self.SelectedIndex = math.Clamp(index, 1, #self.Options)
    if self.Options[self.SelectedIndex] then
        self:OnSelect(self.Options[self.SelectedIndex])
    end
end

function PANEL:GetSelected()
    return self.Options[self.SelectedIndex]
end

function PANEL:OnSelect(option) end

function PANEL:Think()
    self.HoverProgress = Lerp(0.15, self.HoverProgress, self:IsHovered() and 1 or 0)
    
    if self.AnimProgress ~= self.TargetProgress then
        self.AnimProgress = Lerp(0.1, self.AnimProgress, self.TargetProgress)
        if math.abs(self.AnimProgress - self.TargetProgress) < 0.01 then
            self.AnimProgress = self.TargetProgress
        end
        self:InvalidateLayout()
    end
    
    if self.ArrowRotation ~= self.TargetRotation then
        self.ArrowRotation = Lerp(0.15, self.ArrowRotation, self.TargetRotation)
    end
    
    if self.IsOpen and not self:IsHovered() then
        local mx, my = gui.MousePos()
        if not mx or not my then return end
        
        local x, y = self:LocalToScreen(0, 0)
        if not x or not y then return end
        
        local w, h = self:GetSize()
        
        if mx < x or mx > x + w or my < y or my > y + h then
            self.IsOpen = false
            self.TargetProgress = 0
            self.TargetRotation = 0
            self:SetZPos(0)
        end
    end
end

function PANEL:Paint(w, h)
    N.RNDX.Draw(8, 0, 0, w, 40, self.BGColor)
    N.RNDX.DrawOutlined(8, 0, 0, w, 40, ColorAlpha(self.BorderColor, Lerp(self.HoverProgress, 100, 180)), 1)
    
    if self.Options[self.SelectedIndex] then
        local alpha = Lerp(self.HoverProgress, 220, 255)
        draw.SimpleText(self.Options[self.SelectedIndex].text, "N.Font.16", 16, 20, ColorAlpha(self.TextColor, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    local arrowX = w - 20
    local arrowY = 20
    local arrowSize = 6
    
    local angle = math.rad(self.ArrowRotation)
    local cos = math.cos(angle)
    local sin = math.sin(angle)
    
    local function rot(px, py)
        return arrowX + (px * cos - py * sin), arrowY + (px * sin + py * cos)
    end
    
    local p1x, p1y = rot(-arrowSize, -3)
    local p2x, p2y = rot(arrowSize, -3)
    local p3x, p3y = rot(0, 3)
    
    local arrowAlpha = Lerp(self.HoverProgress, 200, 255)
    surface.SetDrawColor(self.ArrowColor.r, self.ArrowColor.g, self.ArrowColor.b, arrowAlpha)
    draw.NoTexture()
    surface.DrawPoly({
        {x = p1x, y = p1y},
        {x = p2x, y = p2y},
        {x = p3x, y = p3y}
    })
    
    if self.AnimProgress > 0.01 and #self.Options > 0 then
        local visibleCount = math.min(#self.Options, self.MaxVisibleOptions)
        local optionH = 48
        local fullDropH = visibleCount * optionH
        local dropH = fullDropH * self.AnimProgress
        local startY = 46
        
        if dropH > 5 then
            N.RNDX.Draw(8, 0, startY, w, dropH, self.BGColor, N.RNDX.BLUR)
            N.RNDX.Draw(8, 0, startY, w, dropH, self.BGColor)
            N.RNDX.DrawOutlined(8, 0, startY, w, dropH, ColorAlpha(self.BorderColor, 150), 1)
            
            local alpha = math.min(255, math.max(0, (self.AnimProgress - 0.15) * 1700))
            if alpha > 10 then
                local mx, my = self:LocalCursorPos()
                
                for i = 1, visibleCount do
                    local idx = i + self.ScrollOffset
                    if idx <= #self.Options then
                        local oy = startY + (i - 1) * optionH + 4
                        local hover = mx >= 0 and mx <= w and my >= oy and my <= oy + 40
                        
                        if idx == self.SelectedIndex then
                            N.RNDX.Draw(6, 4, oy, w - 8, 40, ColorAlpha(self.SelectedBG, alpha))
                        elseif hover then
                            N.RNDX.Draw(6, 4, oy, w - 8, 40, ColorAlpha(self.HoverBG, alpha * 0.8))
                        end
                        
                        draw.SimpleText(self.Options[idx].text, "N.Font.16", 16, oy + 20, ColorAlpha(self.TextColor, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    end
                end
                
                if #self.Options > self.MaxVisibleOptions then
                    local sbH = (visibleCount / #self.Options) * dropH
                    local sbY = startY + (self.ScrollOffset / #self.Options) * dropH
                    N.RNDX.Draw(12, w - 8, sbY + 4, 4, sbH - 8, ColorAlpha(Color(84, 71, 98), alpha))  -- #544762
                end
            end
        end
    end
    
    return true
end

function PANEL:OnMousePressed(keyCode)
    if keyCode ~= MOUSE_LEFT then return end
    
    local mx, my = self:LocalCursorPos()
    if not mx or not my then return end
    
    if my <= 40 then
        self.IsOpen = not self.IsOpen
        self.ScrollOffset = 0
        self.TargetProgress = self.IsOpen and 1 or 0
        self.TargetRotation = self.IsOpen and 180 or 0
        self:SetZPos(self.IsOpen and 32767 or 0)
        if self.IsOpen then
            self:MoveToFront()
        end
        return
    end
    
    if self.IsOpen and my > 46 then
        local idx = math.floor((my - 50) / 48) + 1 + self.ScrollOffset
        if idx >= 1 and idx <= #self.Options then
            self:SetSelected(idx)
            self.IsOpen = false
            self.TargetProgress = 0
            self.TargetRotation = 0
            self:SetZPos(0)
        end
    end
end

function PANEL:OnMouseWheeled(delta)
    if self.IsOpen and #self.Options > self.MaxVisibleOptions then
        self.ScrollOffset = math.Clamp(self.ScrollOffset - delta, 0, #self.Options - self.MaxVisibleOptions)
        return true
    end
end

function PANEL:PerformLayout(w, h)
    if self.IsOpen and self.AnimProgress > 0 then
        local visibleCount = math.min(#self.Options, self.MaxVisibleOptions)
        local dropH = visibleCount * 48
        local animatedH = dropH * self.AnimProgress
        self:SetTall(40 + animatedH + 6)
    else
        self:SetTall(40)
    end
end

vgui.Register("N.Dropdown", PANEL, "DPanel")