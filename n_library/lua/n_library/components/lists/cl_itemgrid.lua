local PANEL = {}

function PANEL:Init()
    self:SetSize(400, 150)  
    
    self.BGColor = Color(0, 0, 0, 0)
    self.SlotColor = Color(33, 25, 41)
    self.SlotHoverColor = Color(41, 33, 51)
    
    self.Title = "Items"
    self.Items = {}
    self.Rows = 2
    self.Columns = 6
    self.SlotSize = 32  
    self.SlotSpacing = 12
    self.TopMargin = 45
    self.LeftMargin = 20
    
    self.ItemAnimations = {}
end

function PANEL:SetTitle(title)
    self.Title = title
end

function PANEL:SetGridSize(rows, cols)
    self.Rows = rows
    self.Columns = cols
end

function PANEL:AddItem(name, icon, shape, onClick)
    local index = #self.Items + 1
    table.insert(self.Items, {
        name = name or "Name",
        icon = icon,
        shape = shape or "square",
        onClick = onClick or function() end
    })
    
    self.ItemAnimations[index] = {
        hoverProgress = 0
    }
end

function PANEL:ClearItems()
    self.Items = {}
    self.ItemAnimations = {}
end

function PANEL:Think()
    local mx, my = self:LocalCursorPos()
    
    for i, item in ipairs(self.Items) do
        local col = (i - 1) % self.Columns
        local row = math.floor((i - 1) / self.Columns)
        
        if row < self.Rows then
            local x = self.LeftMargin + col * (self.SlotSize + self.SlotSpacing)
            local y = self.TopMargin + row * (self.SlotSize + self.SlotSpacing + 20)
            
            local isHovered = mx >= x and mx <= x + self.SlotSize and my >= y and my <= y + self.SlotSize
            
            self.ItemAnimations[i] = self.ItemAnimations[i] or {hoverProgress = 0}
            
            local target = isHovered and 1 or 0
            self.ItemAnimations[i].hoverProgress = Lerp(0.15, self.ItemAnimations[i].hoverProgress, target)
        end
    end
end

function PANEL:Paint(w, h)
    local titleAlpha = 255
    draw.SimpleText(self.Title, "N.Font.24.Bold", 18, 22, Color(255, 255, 255, titleAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    
    for i, item in ipairs(self.Items) do
        local col = (i - 1) % self.Columns
        local row = math.floor((i - 1) / self.Columns)
        
        if row >= self.Rows then break end
        
        local x = self.LeftMargin + col * (self.SlotSize + self.SlotSpacing)
        local y = self.TopMargin + row * (self.SlotSize + self.SlotSpacing + 20)
        
        local anim = self.ItemAnimations[i] or {hoverProgress = 0}
        
        local bgColor = Color(
            Lerp(anim.hoverProgress, self.SlotColor.r, self.SlotHoverColor.r),
            Lerp(anim.hoverProgress, self.SlotColor.g, self.SlotHoverColor.g),
            Lerp(anim.hoverProgress, self.SlotColor.b, self.SlotHoverColor.b)
        )
        
        if anim.hoverProgress > 0 then
            local glowAlpha = math.floor(20 * anim.hoverProgress)
            N.RNDX.DrawShadows(8, x, y, self.SlotSize, self.SlotSize, Color(bgColor.r, bgColor.g, bgColor.b, glowAlpha), 6, 10)
        end
        
        if item.shape == "circle" then
            N.RNDX.DrawCircle(x + self.SlotSize/2, y + self.SlotSize/2, 32, bgColor)
        elseif item.shape == "rounded" then
            N.RNDX.Draw(12, x, y, self.SlotSize, self.SlotSize, bgColor)
        else
            N.RNDX.Draw(8, x, y, self.SlotSize, self.SlotSize, bgColor)
        end
        
        if item.icon and N.Materials and N.Materials.Icons and N.Materials.Icons[item.icon] then
            local iconAlpha = Lerp(anim.hoverProgress, 200, 255)
            surface.SetDrawColor(255, 255, 255, iconAlpha)
            surface.SetMaterial(N.Materials.Icons[item.icon])
            
            local iconSize = 20
            local iconX = x + (self.SlotSize - iconSize) / 2
            local iconY = y + (self.SlotSize - iconSize) / 2
            surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
        end
        
        local textAlpha = Lerp(anim.hoverProgress, 200, 255)
        draw.SimpleText(item.name, "N.Font.12", x + self.SlotSize / 2, y + self.SlotSize + 8, Color(255, 255, 255, textAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end
    
    return true
end

function PANEL:OnMousePressed(keyCode)
    if keyCode ~= MOUSE_LEFT then return end
    
    local mx, my = self:LocalCursorPos()
    
    for i, item in ipairs(self.Items) do
        local col = (i - 1) % self.Columns
        local row = math.floor((i - 1) / self.Columns)
        
        if row >= self.Rows then break end
        
        local x = self.LeftMargin + col * (self.SlotSize + self.SlotSpacing)
        local y = self.TopMargin + row * (self.SlotSize + self.SlotSpacing + 20)
        
        if mx >= x and mx <= x + self.SlotSize and my >= y and my <= y + self.SlotSize then
            item.onClick()
            return
        end
    end
end

vgui.Register("N.ItemGrid", PANEL, "DPanel")