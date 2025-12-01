local PANEL = {}

function PANEL:Init()
    self:SetSize(460, 180)
    
    self.BGColor = Color(179, 115, 226)
    self.HeaderBG = Color(33, 25, 41)
    self.ItemBG = Color(33, 25, 41)
    self.ItemHoverBG = Color(51, 41, 62)
    self.AvatarColor = Color(80, 60, 82)
    
    self.Items = {}
    self.SelectedIndex = -1
    
    self.Title = ""
    self.Columns = {"Pseudo", "Level", "Role", "Option"}
    
    self.ItemRadius = {8, 25, 8}
    
    self.ItemAnimations = {}
end

function PANEL:SetTitle(title)
    self.Title = title
end

function PANEL:AddUser(pseudo, level, role, option, onSettingsClick)
    local index = #self.Items + 1
    local item = {
        pseudo = pseudo,
        level = level,
        role = role,
        option = option,
        onSettingsClick = onSettingsClick or function() end
    }
    
    table.insert(self.Items, item)
    
    self.ItemAnimations[index] = {
        hoverProgress = 0
    }
end

function PANEL:ClearUsers()
    self.Items = {}
    self.SelectedIndex = -1
    self.ItemAnimations = {}
end

function PANEL:SetSelected(index)
    self.SelectedIndex = index
end

function PANEL:Think()
    local mx, my = self:LocalCursorPos()
    
    if mx >= 0 and mx <= self:GetWide() and my >= 0 and my <= self:GetTall() then
        local itemY = 53
        local itemH = 32
        
        for i = 1, #self.Items do
            local isHovered = my >= itemY and my <= itemY + itemH
            
            self.ItemAnimations[i] = self.ItemAnimations[i] or {hoverProgress = 0}
            
            local target = isHovered and 1 or 0
            self.ItemAnimations[i].hoverProgress = Lerp(0.15, self.ItemAnimations[i].hoverProgress, target)
            
            itemY = itemY + itemH + 5
        end
    end
end

function PANEL:Paint(w, h)
    N.RNDX.Draw(8, 0, 0, w, h, self.BGColor)
    
    local headerH = 35
    
    N.RNDX.Draw(8, 10, 10, w - 20, headerH, self.HeaderBG)
    
    local colW = (w - 80) / 4
    
    for i, col in ipairs(self.Columns) do
        local x = 50 + (i - 1) * colW
        draw.SimpleText(col, "N.Font.14", x, 10 + headerH/2, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    local itemY = 10 + headerH + 8
    local itemH = 32
    
    for i, item in ipairs(self.Items) do
        local anim = self.ItemAnimations[i] or {hoverProgress = 0}
        
        local bgColor = Color(
            Lerp(anim.hoverProgress, self.ItemBG.r, self.ItemHoverBG.r),
            Lerp(anim.hoverProgress, self.ItemBG.g, self.ItemHoverBG.g),
            Lerp(anim.hoverProgress, self.ItemBG.b, self.ItemHoverBG.b)
        )
        
        local radius = self.ItemRadius[i] or 8
        
        if anim.hoverProgress > 0 then
            local glowAlpha = math.floor(15 * anim.hoverProgress)
            N.RNDX.DrawShadows(radius, 10, itemY, w - 20, itemH, Color(bgColor.r, bgColor.g, bgColor.b, glowAlpha), 6, 10)
        end
        
        N.RNDX.Draw(radius, 10, itemY, w - 20, itemH, bgColor)
        
        N.RNDX.DrawCircle(18 + 7, itemY + 9 + 7, 7, self.AvatarColor)
        
        local textAlpha = Lerp(anim.hoverProgress, 200, 255)
        
        draw.SimpleText(item.pseudo, "N.Font.14", 50, itemY + itemH/2, Color(255, 255, 255, textAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(item.level, "N.Font.14", 50 + colW, itemY + itemH/2, Color(255, 255, 255, textAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(item.role, "N.Font.14", 50 + colW * 2, itemY + itemH/2, Color(255, 255, 255, textAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(item.option, "N.Font.14", 50 + colW * 3, itemY + itemH/2, Color(255, 255, 255, textAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        
        if anim.hoverProgress > 0 then
            if N.Materials and N.Materials.Icons and N.Materials.Icons["settings"] then
                local iconAlpha = math.floor(255 * anim.hoverProgress)
                surface.SetDrawColor(179, 115, 226, iconAlpha)
                surface.SetMaterial(N.Materials.Icons["settings"])
                surface.DrawTexturedRect(w - 35, itemY + 9, 14, 14)
            end
        end
        
        itemY = itemY + itemH + 5
    end
    
    return true
end

function PANEL:OnMousePressed(x, y)
    local itemY = 53
    local itemH = 32
    
    for i, item in ipairs(self.Items) do
        if y >= itemY and y <= itemY + itemH then
            if x >= self:GetWide() - 35 and x <= self:GetWide() - 21 then
                item.onSettingsClick()
                return
            end
            
            self.SelectedIndex = i
            return
        end
        
        itemY = itemY + itemH + 5
    end
end

vgui.Register("N.UserList", PANEL, "DPanel")