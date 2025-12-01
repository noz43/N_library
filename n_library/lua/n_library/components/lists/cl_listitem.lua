local PANEL = {}

function PANEL:Init()
    self:SetTall(50)
    self:SetCursor("hand")
    
    self.Title = "List Item"
    self.Description = ""
    self.Icon = nil
    self.IconMaterial = nil
    self.RightText = ""
    
    self.BGColor = Color(33, 25, 41)
    self.HoverColor = Color(51, 41, 62)
    self.SelectedColor = Color(51, 41, 62)
    
    self.Selected = false
    
    self.HoverProgress = 0
    self.SelectProgress = 0
end

function PANEL:SetTitle(text)
    self.Title = text
end

function PANEL:SetDescription(text)
    self.Description = text
    if text and text ~= "" then
        self:SetTall(60)
    end
end

function PANEL:SetIcon(iconName)
    self.Icon = iconName
    if N and N.Materials and N.Materials.Icons and N.Materials.Icons[iconName] then
        self.IconMaterial = N.Materials.Icons[iconName]
    end
end

function PANEL:SetRightText(text)
    self.RightText = text
end

function PANEL:SetSelected(bool)
    self.Selected = bool
end

function PANEL:GetSelected()
    return self.Selected
end

function PANEL:DoClick()
end

function PANEL:Think()
    local isHovered = self:IsHovered()
    local target = isHovered and 1 or 0
    self.HoverProgress = Lerp(0.15, self.HoverProgress, target)
    
    local selectTarget = self.Selected and 1 or 0
    self.SelectProgress = Lerp(0.15, self.SelectProgress, selectTarget)
end

function PANEL:Paint(w, h)
    local bg = Color(
        Lerp(math.max(self.HoverProgress, self.SelectProgress), self.BGColor.r, self.HoverColor.r),
        Lerp(math.max(self.HoverProgress, self.SelectProgress), self.BGColor.g, self.HoverColor.g),
        Lerp(math.max(self.HoverProgress, self.SelectProgress), self.BGColor.b, self.HoverColor.b)
    )
    
    if self.HoverProgress > 0 then
        local glowAlpha = math.floor(15 * self.HoverProgress)
        N.RNDX.DrawShadows(8, 0, 0, w, h, Color(bg.r, bg.g, bg.b, glowAlpha), 6, 10)
    end
    
    N.RNDX.Draw(8, 0, 0, w, h, bg)
    
    local x = 12
    
    if self.IconMaterial then
        local iconSize = 24
        local iconY = h/2 - iconSize/2
        
        local iconAlpha = Lerp(self.HoverProgress, 200, 255)
        surface.SetDrawColor(255, 255, 255, iconAlpha)
        surface.SetMaterial(self.IconMaterial)
        surface.DrawTexturedRect(x, iconY, iconSize, iconSize)
        
        x = x + iconSize + 12
    end
    
    local titleAlpha = Lerp(self.HoverProgress, 200, 255)
    local descAlpha = Lerp(self.HoverProgress, 150, 200)
    
    if self.Description ~= "" then
        draw.SimpleText(self.Title, "N.Font.14.Bold", x, h/2 - 10, Color(255, 255, 255, titleAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(self.Description, "N.Font.12", x, h/2 + 5, Color(255, 255, 255, descAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    else
        draw.SimpleText(self.Title, "N.Font.14.Bold", x, h/2, Color(255, 255, 255, titleAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    if self.RightText ~= "" then
        draw.SimpleText(self.RightText, "N.Font.12", w - 12, h/2, Color(255, 255, 255, descAlpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end
    
    return true
end

vgui.Register("N.ListItem", PANEL, "DButton")