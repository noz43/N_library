local PANEL = {}

function PANEL:Init()
    self:SetSize(48, 48)
    
    self.Player = nil
    self.AvatarColor = Color(94, 72, 120)
    self.BorderColor = Color(51, 41, 62)
    self.BorderSize = 2
    self.ShowBorder = true
end

function PANEL:SetPlayer(ply)
    self.Player = ply
end

function PANEL:SetAvatarColor(color)
    self.AvatarColor = color
end

function PANEL:SetBorderColor(color)
    self.BorderColor = color
end

function PANEL:SetBorderSize(size)
    self.BorderSize = size
end

function PANEL:SetShowBorder(bool)
    self.ShowBorder = bool
end

function PANEL:Paint(w, h)
    local centerX = w / 2
    local centerY = h / 2
    local radius = math.min(w, h) / 2
    
    if self.ShowBorder then
        if N.RNDX then
            N.RNDX.DrawCircle(centerX, centerY, radius, self.BorderColor)
        else
            N.Draw:Circle(centerX, centerY, radius, self.BorderColor)
        end
        radius = radius - self.BorderSize
    end
    
    if N.RNDX then
        N.RNDX.DrawCircle(centerX, centerY, radius, self.AvatarColor)
    else
        N.Draw:Circle(centerX, centerY, radius, self.AvatarColor)
    end
    
    if self.Player and IsValid(self.Player) then
        local avatarMat = Material("../html/avatar.png")
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(avatarMat)
        
        local size = radius * 2
        local x = centerX - radius
        local y = centerY - radius
        
        render.ClearStencil()
        render.SetStencilEnable(true)
        render.SetStencilWriteMask(1)
        render.SetStencilTestMask(1)
        render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
        render.SetStencilPassOperation(STENCILOPERATION_ZERO)
        render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
        render.SetStencilReferenceValue(1)
        
        if N.RNDX then
            N.RNDX.DrawCircle(centerX, centerY, radius, Color(255, 255, 255))
        else
            N.Draw:Circle(centerX, centerY, radius, Color(255, 255, 255))
        end
        
        render.SetStencilFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
        render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
        render.SetStencilReferenceValue(1)
        
        surface.DrawTexturedRect(x, y, size, size)
        
        render.SetStencilEnable(false)
        render.ClearStencil()
    end
    
    return true
end

vgui.Register("N.Avatar", PANEL, "DPanel")