local PANEL = {}

function PANEL:Init()
    self:SetSize(400, 140)
    
    self.BGColor = Color(0, 0, 0, 0)
    self.ItemBG = Color(33, 25, 41)
    self.ItemHoverBG = Color(41, 33, 51)
    self.CounterBG = Color(33, 25, 41)
    self.CounterBorder = Color(51, 41, 62)
    
    self.Title = "Missions"
    self.Items = {}
    self.TitleHeight = 45
    self.ItemHeight = 42
    self.ItemSpacing = 8
    self.Padding = 12
    
    self.ItemAnimations = {}
end

function PANEL:SetTitle(title)
    self.Title = title
end

function PANEL:AddMission(name, description, icon, current, total, shape, onClick)
    local index = #self.Items + 1
    table.insert(self.Items, {
        name = name or "Name",
        description = description or "Description",
        icon = icon,
        current = current or 0,
        total = total or 10,
        shape = shape or "square",
        onClick = onClick or function() end
    })
    
    self.ItemAnimations[index] = {
        hoverProgress = 0
    }
end

function PANEL:ClearMissions()
    self.Items = {}
    self.ItemAnimations = {}
end

function PANEL:Think()
    local mx, my = self:LocalCursorPos()
    local itemY = self.TitleHeight
    
    for i, item in ipairs(self.Items) do
        local isHovered = mx >= self.Padding and mx <= self:GetWide() - self.Padding and my >= itemY and my <= itemY + self.ItemHeight
        
        self.ItemAnimations[i] = self.ItemAnimations[i] or {hoverProgress = 0}
        
        local target = isHovered and 1 or 0
        self.ItemAnimations[i].hoverProgress = Lerp(0.15, self.ItemAnimations[i].hoverProgress, target)
        
        itemY = itemY + self.ItemHeight + self.ItemSpacing
    end
end

function PANEL:Paint(w, h)
    draw.SimpleText(self.Title, "N.Font.24.Bold", 18, 22, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    
    local itemY = self.TitleHeight
    
    for i, item in ipairs(self.Items) do
        local itemW = w - (self.Padding * 2)
        
        local anim = self.ItemAnimations[i] or {hoverProgress = 0}
        
        local bgColor = Color(
            Lerp(anim.hoverProgress, self.ItemBG.r, self.ItemHoverBG.r),
            Lerp(anim.hoverProgress, self.ItemBG.g, self.ItemHoverBG.g),
            Lerp(anim.hoverProgress, self.ItemBG.b, self.ItemHoverBG.b)
        )
        
        local radius = 8
        if item.shape == "rounded" then
            radius = 24
        end
        
        if anim.hoverProgress > 0 then
            local glowAlpha = math.floor(20 * anim.hoverProgress)
            N.RNDX.DrawShadows(radius, self.Padding, itemY, itemW, self.ItemHeight, Color(bgColor.r, bgColor.g, bgColor.b, glowAlpha), 6, 10)
        end
        
        N.RNDX.Draw(radius, self.Padding, itemY, itemW, self.ItemHeight, bgColor)
        
        if item.icon and N.Materials and N.Materials.Icons and N.Materials.Icons[item.icon] then
            local iconAlpha = Lerp(anim.hoverProgress, 200, 255)
            surface.SetDrawColor(255, 255, 255, iconAlpha)
            surface.SetMaterial(N.Materials.Icons[item.icon])
            surface.DrawTexturedRect(self.Padding + 12, itemY + 11, 20, 20)
        end
        
        local nameAlpha = Lerp(anim.hoverProgress, 200, 255)
        local descAlpha = Lerp(anim.hoverProgress, 150, 200)
        
        draw.SimpleText(item.name, "N.Font.18.Bold", self.Padding + 40, itemY + 8, Color(255, 255, 255, nameAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(item.description, "N.Font.12", self.Padding + 40, itemY + 25, Color(255, 255, 255, descAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        
        local counterText = item.current .. "/" .. item.total
        local counterW = 45
        local counterH = 20
        local counterX = w - self.Padding - counterW - 5
        local counterY = itemY + 11
        
        N.RNDX.Draw(3, counterX, counterY, counterW, counterH, self.CounterBG)
        N.RNDX.DrawOutlined(3, counterX, counterY, counterW, counterH, self.CounterBorder, 1)
        
        local counterAlpha = Lerp(anim.hoverProgress, 200, 255)
        draw.SimpleText(counterText, "N.Font.12.Bold", counterX + counterW / 2, counterY + counterH / 2, Color(255, 255, 255, counterAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        
        itemY = itemY + self.ItemHeight + self.ItemSpacing
    end
    
    return true
end

function PANEL:OnMousePressed(keyCode)
    if keyCode ~= MOUSE_LEFT then return end
    
    local mx, my = self:LocalCursorPos()
    local itemY = self.TitleHeight
    
    for i, item in ipairs(self.Items) do
        if mx >= self.Padding and mx <= self:GetWide() - self.Padding and my >= itemY and my <= itemY + self.ItemHeight then
            item.onClick()
            return
        end
        
        itemY = itemY + self.ItemHeight + self.ItemSpacing
    end
end

vgui.Register("N.MissionList", PANEL, "DPanel")