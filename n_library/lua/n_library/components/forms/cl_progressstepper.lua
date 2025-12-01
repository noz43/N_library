local PANEL = {}

function PANEL:Init()
    self:SetSize(300, 60)
    
    self.Steps = {}
    self.CurrentStep = 1
    self.TotalSteps = 4
    
    self.LineColor = Color(37, 40, 47)
    self.LineFilledColor = Color(158, 106, 221)
    self.StepBGColor = Color(54, 40, 70)
    self.StepBGColorCompleted = Color(85, 63, 111)
    self.StepBorderColor = Color(94, 72, 120)
    self.StepFilledColor = Color(158, 106, 221)
    
    self.StepSize = 16  
    self.LineThickness = 2 
    self.LineY = 30
    
    self.ShowLabels = true
    self.ShowDescriptions = true
end

function PANEL:SetSteps(steps)
    self.Steps = steps
    self.TotalSteps = #steps
end

function PANEL:SetCurrentStep(step)
    self.CurrentStep = math.Clamp(step, 1, self.TotalSteps)
end

function PANEL:GetCurrentStep()
    return self.CurrentStep
end

function PANEL:SetShowLabels(show)
    self.ShowLabels = show
end

function PANEL:SetShowDescriptions(show)
    self.ShowDescriptions = show
end

function PANEL:Paint(w, h)
    if self.TotalSteps == 0 then return true end
    
    local stepSpacing = (w - 20) / (self.TotalSteps - 1)
    local startX = 10
    
    local lineY = self.LineY
    local lineW = w - 20
    
    surface.SetDrawColor(self.LineColor)
    surface.DrawRect(startX, lineY, lineW, self.LineThickness)
    
    if self.CurrentStep > 1 then
        local filledW = stepSpacing * (self.CurrentStep - 1)
        surface.SetDrawColor(self.LineFilledColor)
        surface.DrawRect(startX, lineY, filledW, self.LineThickness)
    end
    
    for i = 1, self.TotalSteps do
        local stepX = startX + (i - 1) * stepSpacing - self.StepSize / 2
        local stepY = lineY - self.StepSize / 2 + self.LineThickness / 2
        
        local isCompleted = i <= self.CurrentStep
        local bgColor = isCompleted and self.StepBGColorCompleted or self.StepBGColor
        local borderColor = isCompleted and self.StepFilledColor or self.StepBorderColor
        
        N.RNDX.Draw(2, stepX, stepY, self.StepSize, self.StepSize, bgColor)
        
        N.RNDX.DrawOutlined(2, stepX, stepY, self.StepSize, self.StepSize, borderColor, 1)
        
        if isCompleted then
            local innerSize = 10
            local innerX = stepX + (self.StepSize - innerSize) / 2
            local innerY = stepY + (self.StepSize - innerSize) / 2
            
            N.RNDX.Draw(1, innerX, innerY, innerSize, innerSize, self.StepFilledColor)
        end
        
        if self.ShowLabels and self.Steps[i] then
            local labelX = startX + (i - 1) * stepSpacing
            local labelY = lineY + 12
            
            draw.SimpleText(self.Steps[i].label or "Step " .. i, "N.Font.12.Bold", labelX, labelY, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            
            if self.ShowDescriptions and self.Steps[i].description then
                draw.SimpleText(self.Steps[i].description, "N.Font.10", labelX, labelY + 10, Color(255, 255, 255, 180), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            end
        end
    end
    
    return true
end

vgui.Register("N.ProgressStepper", PANEL, "DPanel")