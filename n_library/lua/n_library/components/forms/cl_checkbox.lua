local PANEL = {}

function PANEL:Init()
    self:SetText("")
    self:SetCursor("hand")
    self:SetSize(93, 22)
    
    self.Checked = false
    self.Label = "Option"
    self.Description = nil
    self.Icon = nil
    self.IconMaterial = nil
    self.IconPosition = "right" 
    self.CheckboxPosition = "left"  
    self.Shape = "square"  
    self.Type = "checkbox"  
    self.RadioGroup = "default"
    
    self.BGColor = Color(33, 25, 41, 255)              -- #211929 
    self.BGColorChecked = Color(51, 41, 62, 255)       -- #33293E (
    self.CheckboxEmpty = Color(33, 25, 41, 255)        -- #211929
    self.CheckboxFilled = Color(94, 72, 120, 255)      -- #5E4878
    self.CheckboxBorder = Color(94, 72, 120, 255)      -- #5E4878
    
    self.HoverProgress = 0
end

function PANEL:SetChecked(bool)
    self.Checked = bool
    
    if bool and self.Type == "radio" and self:GetParent() then
        for _, child in pairs(self:GetParent():GetChildren()) do
            if child ~= self and child.RadioGroup == self.RadioGroup and child.SetChecked and child.Type == "radio" then
                child:SetChecked(false)
            end
        end
    end
    
    self:OnChange(bool)
end

function PANEL:GetChecked()
    return self.Checked
end

function PANEL:Toggle()
    if self.Type == "radio" then
        if not self.Checked then
            self:SetChecked(true)
        end
    else
        self:SetChecked(not self.Checked)
    end
end

function PANEL:SetLabel(text)
    self.Label = text
end

function PANEL:SetDescription(text)
    self.Description = text
    if text then
        self:SetTall(25) 
    end
end

function PANEL:SetIcon(iconName)
    self.Icon = iconName
    if N and N.Materials and N.Materials.Icons and N.Materials.Icons[iconName] then
        self.IconMaterial = N.Materials.Icons[iconName]
    end
end

function PANEL:SetIconPosition(pos)
    self.IconPosition = pos  
end

function PANEL:SetCheckboxPosition(pos)
    self.CheckboxPosition = pos  
end

function PANEL:SetShape(shape)
    self.Shape = shape 
end

function PANEL:SetType(type)
    self.Type = type 
end

function PANEL:SetRadioGroup(group)
    self.RadioGroup = group
    self.Type = "radio"
end

function PANEL:OnMousePressed(keyCode)
    if keyCode == MOUSE_LEFT then
        self:Toggle()
    end
end

function PANEL:OnChange(value)
  
end

function PANEL:Think()
    local isHovered = self:IsHovered()
    local target = isHovered and 1 or 0
    self.HoverProgress = Lerp(0.15, self.HoverProgress, target)
end

function PANEL:Paint(w, h)

    N.RNDX.Draw(6, 0, 0, w, h, self.BGColor)
    

    local checkSize = 10  
    
    if self.Type == "radio" or self.Shape == "circle" then
        checkSize = 18
    end
    
    local checkX, checkY
    local textX
    local iconX, iconY = 0, 0
    local iconSize = 10
    
    checkY = h / 2 - checkSize / 2
    if self.Description then
        checkY = 6  
    end
    
    if self.CheckboxPosition == "right" then
        checkX = w - checkSize - 8
        textX = 8  
        
        if self.IconMaterial then
            iconX = w - iconSize - checkSize - 17
            iconY = h / 2 - iconSize / 2
            if self.Description then
                iconY = 6
            end
        end
    else
        checkX = 8
        textX = checkX + checkSize + 9  
        
        if self.IconMaterial then
            iconX = w - iconSize - 8  
            iconY = h / 2 - iconSize / 2
            if self.Description then
                iconY = 6
            end
        end
    end
    
    local centerX = checkX + checkSize / 2
    local centerY = checkY + checkSize / 2
    
    if self.Type == "radio" then
        local radioBG = self.Checked and self.CheckboxFilled or self.CheckboxEmpty
        
        N.RNDX.DrawCircle(centerX, centerY, checkSize / 2, radioBG)
        N.RNDX.DrawCircleOutlined(centerX, centerY, checkSize / 2, self.CheckboxBorder, 1)
    elseif self.Shape == "circle" then
        local circleBG = self.Checked and self.CheckboxFilled or self.CheckboxEmpty
        
        N.RNDX.DrawCircle(centerX, centerY, checkSize / 2, circleBG)
        N.RNDX.DrawCircleOutlined(centerX, centerY, checkSize / 2, self.CheckboxBorder, 1)
    else
        N.RNDX.Draw(2, checkX, checkY, checkSize, checkSize, self.CheckboxEmpty)
        N.RNDX.DrawOutlined(2, checkX, checkY, checkSize, checkSize, self.CheckboxBorder, 1)
        
        if self.Checked then
            local innerSize = 6
            local innerX = checkX + (checkSize - innerSize) / 2
            local innerY = checkY + (checkSize - innerSize) / 2
            
            N.RNDX.Draw(1, innerX, innerY, innerSize, innerSize, self.CheckboxFilled)
        end
    end
    
    if self.IconMaterial then
        local iconAlpha = Lerp(self.HoverProgress, 180, 255)
        surface.SetDrawColor(255, 255, 255, iconAlpha)
        surface.SetMaterial(self.IconMaterial)
        surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
    end
    
    local textAlpha = Lerp(self.HoverProgress, 200, 255)
    
    if self.Description then
        draw.SimpleText(self.Label, "N.Font.12", textX, 5, Color(255, 255, 255, textAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        
        local descAlpha = Lerp(self.HoverProgress, 150, 200)
        draw.SimpleText(self.Description, "N.Font.10", textX, 13, Color(255, 255, 255, descAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    else
        draw.SimpleText(self.Label, "N.Font.12", textX, h / 2, Color(255, 255, 255, textAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    return true
end

vgui.Register("N.Checkbox", PANEL, "DButton")