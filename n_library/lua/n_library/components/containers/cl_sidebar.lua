local PANEL = {}

function PANEL:Init()
    self.BGColor = Color(33, 25, 41)
    self.ItemColor = Color(33, 25, 41)
    self.ItemHoverColor = Color(41, 33, 51)
    self.ItemActiveColor = Color(51, 41, 62)
    self.PrimaryColor = Color(179, 115, 226)
    
    self.Items = {}
    self.FooterItems = {}
    self.ItemHeight = 60
    self.ActiveIndex = 1
    self.Mode = "iconstext"
    self.Radius = 12
    
    self.ItemAnimations = {}
    
    self:SetWide(250)
end

function PANEL:SetMode(mode)
    self.Mode = mode
    
    if mode == "icons" then
        self:SetWide(70)
        self.ItemHeight = 60
    elseif mode == "iconstext" then
        self:SetWide(250)
        self.ItemHeight = 55
    end
end

function PANEL:AddItem(text, icon, onClick)
    local index = #self.Items + 1
    table.insert(self.Items, {
        text = text,
        icon = icon,
        onClick = onClick or function() end
    })
    
    self.ItemAnimations[index] = {
        hoverProgress = 0,
        activeProgress = 0
    }
end

function PANEL:AddFooterItem(text, icon, onClick)
    local index = #self.Items + #self.FooterItems + 1
    table.insert(self.FooterItems, {
        text = text,
        icon = icon,
        onClick = onClick or function() end
    })
    
    self.ItemAnimations[index] = {
        hoverProgress = 0,
        activeProgress = 0
    }
end

function PANEL:ClearItems()
    self.Items = {}
    self.FooterItems = {}
    self.ItemAnimations = {}
end

function PANEL:SetActive(index)
    self.ActiveIndex = index
end

function PANEL:Think()
    local mx, my = self:LocalCursorPos()
    local w, h = self:GetSize()
    
    local y = 15
    local padding = self.Mode == "icons" and 5 or 10
    local spacing = self.Mode == "icons" and 8 or 6
    
    for i, item in ipairs(self.Items) do
        local isActive = i == self.ActiveIndex
        local isHovered = mx >= padding and mx <= w - padding and my >= y and my <= y + self.ItemHeight
        
        self.ItemAnimations[i] = self.ItemAnimations[i] or {hoverProgress = 0, activeProgress = 0}
        
        local targetHover = isHovered and 1 or 0
        self.ItemAnimations[i].hoverProgress = Lerp(0.15, self.ItemAnimations[i].hoverProgress, targetHover)
        
        local targetActive = isActive and 1 or 0
        self.ItemAnimations[i].activeProgress = Lerp(0.15, self.ItemAnimations[i].activeProgress, targetActive)
        
        y = y + self.ItemHeight + spacing
    end
    
    if #self.FooterItems > 0 then
        local footerY = h - ((#self.FooterItems * self.ItemHeight) + ((#self.FooterItems - 1) * spacing) + 15)
        
        for i, item in ipairs(self.FooterItems) do
            local itemIndex = #self.Items + i
            local isActive = itemIndex == self.ActiveIndex
            local isHovered = mx >= padding and mx <= w - padding and my >= footerY and my <= footerY + self.ItemHeight
            
            self.ItemAnimations[itemIndex] = self.ItemAnimations[itemIndex] or {hoverProgress = 0, activeProgress = 0}
            
            local targetHover = isHovered and 1 or 0
            self.ItemAnimations[itemIndex].hoverProgress = Lerp(0.15, self.ItemAnimations[itemIndex].hoverProgress, targetHover)
            
            local targetActive = isActive and 1 or 0
            self.ItemAnimations[itemIndex].activeProgress = Lerp(0.15, self.ItemAnimations[itemIndex].activeProgress, targetActive)
            
            footerY = footerY + self.ItemHeight + spacing
        end
    end
end

function PANEL:DrawItem(x, y, w, h, item, anim, isActive)
    local bgColor = Color(33, 25, 41)
    
    if isActive or anim.activeProgress > 0 then
        bgColor = Color(
            Lerp(anim.activeProgress, bgColor.r, self.ItemActiveColor.r),
            Lerp(anim.activeProgress, bgColor.g, self.ItemActiveColor.g),
            Lerp(anim.activeProgress, bgColor.b, self.ItemActiveColor.b)
        )
    end
    
    if anim.hoverProgress > 0 and not isActive then
        bgColor = Color(
            Lerp(anim.hoverProgress, bgColor.r, self.ItemHoverColor.r),
            Lerp(anim.hoverProgress, bgColor.g, self.ItemHoverColor.g),
            Lerp(anim.hoverProgress, bgColor.b, self.ItemHoverColor.b)
        )
    end
    
    if isActive and anim.hoverProgress > 0 then
        local glowAlpha = math.floor(30 * anim.hoverProgress)
        N.RNDX.DrawShadows(self.Radius, x, y, w, h, Color(179, 115, 226, glowAlpha), 10, 15)
    end
    
    N.RNDX.Draw(self.Radius, x, y, w, h, bgColor)
    
    if isActive then
        local strokeAlpha = math.floor(100 * anim.activeProgress)
        N.RNDX.DrawOutlined(self.Radius, x, y, w, h, Color(179, 115, 226, strokeAlpha), 2)
    end
end

function PANEL:Paint(w, h)
    N.RNDX.Draw(0, 0, 0, w, h, self.BGColor)
    
    local y = 15
    local padding = self.Mode == "icons" and 5 or 10
    local spacing = self.Mode == "icons" and 8 or 6
    
    for i, item in ipairs(self.Items) do
        local isActive = i == self.ActiveIndex
        local anim = self.ItemAnimations[i] or {hoverProgress = 0, activeProgress = 0}
        
        self:DrawItem(padding, y, w - (padding * 2), self.ItemHeight, item, anim, isActive)
        
        if item.icon and N.Materials and N.Materials.Icons and N.Materials.Icons[item.icon] then
            local iconSize = self.Mode == "icons" and 24 or 20
            local iconX, iconY
            
            if self.Mode == "icons" then
                iconX = (w - iconSize) / 2
                iconY = y + (self.ItemHeight - iconSize) / 2
            else
                iconX = padding + 15
                iconY = y + (self.ItemHeight - iconSize) / 2
            end
            
            local baseAlpha = 127
            local targetAlpha = 255
            
            if isActive then
                targetAlpha = 255
                baseAlpha = 255
            end
            
            local iconAlpha = Lerp(anim.hoverProgress, baseAlpha, targetAlpha)
            
            surface.SetDrawColor(255, 255, 255, iconAlpha)
            
            surface.SetMaterial(N.Materials.Icons[item.icon])
            surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
        end
        
        if self.Mode == "iconstext" then
            local baseAlpha = 127
            local targetAlpha = 255
            
            if isActive then
                targetAlpha = 255
                baseAlpha = 255
            end
            
            local textAlpha = Lerp(anim.hoverProgress, baseAlpha, targetAlpha)
            
            draw.SimpleText(item.text, "N.Font.14.Bold", padding + 50, y + self.ItemHeight / 2, Color(255, 255, 255, textAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        
        y = y + self.ItemHeight + spacing
    end
    
    if #self.FooterItems > 0 then
        local footerY = h - ((#self.FooterItems * self.ItemHeight) + ((#self.FooterItems - 1) * spacing) + 15)
        
        for i, item in ipairs(self.FooterItems) do
            local itemIndex = #self.Items + i
            local isActive = itemIndex == self.ActiveIndex
            local anim = self.ItemAnimations[itemIndex] or {hoverProgress = 0, activeProgress = 0}
            
            self:DrawItem(padding, footerY, w - (padding * 2), self.ItemHeight, item, anim, isActive)
            
            if item.icon and N.Materials and N.Materials.Icons and N.Materials.Icons[item.icon] then
                local iconSize = self.Mode == "icons" and 24 or 20
                local iconX, iconY
                
                if self.Mode == "icons" then
                    iconX = (w - iconSize) / 2
                    iconY = footerY + (self.ItemHeight - iconSize) / 2
                else
                    iconX = padding + 15
                    iconY = footerY + (self.ItemHeight - iconSize) / 2
                end
                
                local baseAlpha = 127
                local targetAlpha = 255
                
                if isActive then
                    targetAlpha = 255
                    baseAlpha = 255
                end
                
                local iconAlpha = Lerp(anim.hoverProgress, baseAlpha, targetAlpha)
                
                surface.SetDrawColor(255, 255, 255, iconAlpha)
                
                surface.SetMaterial(N.Materials.Icons[item.icon])
                surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
            end
            
            if self.Mode == "iconstext" then
                local baseAlpha = 127
                local targetAlpha = 255
                
                if isActive then
                    targetAlpha = 255
                    baseAlpha = 255
                end
                
                local textAlpha = Lerp(anim.hoverProgress, baseAlpha, targetAlpha)
                
                draw.SimpleText(item.text, "N.Font.14.Bold", padding + 50, footerY + self.ItemHeight / 2, Color(255, 255, 255, textAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
            
            footerY = footerY + self.ItemHeight + spacing
        end
    end
    
    return true
end

function PANEL:OnMousePressed(keyCode)
    if keyCode ~= MOUSE_LEFT then return end
    
    local mx, my = self:LocalCursorPos()
    local w, h = self:GetSize()
    
    local y = 15
    local padding = self.Mode == "icons" and 5 or 10
    local spacing = self.Mode == "icons" and 8 or 6
    
    for i, item in ipairs(self.Items) do
        if mx >= padding and mx <= w - padding and my >= y and my <= y + self.ItemHeight then
            self.ActiveIndex = i
            item.onClick()
            surface.PlaySound("ui/buttonclick.wav")
            return
        end
        y = y + self.ItemHeight + spacing
    end
    
    if #self.FooterItems > 0 then
        local footerY = h - ((#self.FooterItems * self.ItemHeight) + ((#self.FooterItems - 1) * spacing) + 15)
        
        for i, item in ipairs(self.FooterItems) do
            if mx >= padding and mx <= w - padding and my >= footerY and my <= footerY + self.ItemHeight then
                self.ActiveIndex = #self.Items + i
                item.onClick()
                surface.PlaySound("ui/buttonclick.wav")
                return
            end
            footerY = footerY + self.ItemHeight + spacing
        end
    end
end

vgui.Register("N.Sidebar", PANEL, "DPanel")