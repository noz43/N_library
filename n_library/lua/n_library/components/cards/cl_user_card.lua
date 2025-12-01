local PANEL = {}

function PANEL:Init()
    self:SetSize(250, 50)
    self:SetCursor("hand")
    
    self.PlayerName = "Pseudo"
    self.PlayerInfo = "Info relatif au joueur"
    self.Shape = "rounded"
    
    self.BGColor = Color(33, 25, 41)
    self.AvatarColor = Color(80, 60, 82)
    
    self.HoverProgress = 0
end

function PANEL:SetPlayerName(name)
    self.PlayerName = name
end

function PANEL:SetPlayerInfo(info)
    self.PlayerInfo = info
end

function PANEL:SetShape(shape)
    self.Shape = shape
end

function PANEL:Think()
    local isHovered = self:IsHovered()
    local target = isHovered and 1 or 0
    self.HoverProgress = Lerp(0.15, self.HoverProgress, target)
end

function PANEL:Paint(w, h)
    local radius = 16
    if self.Shape == "square" then
        radius = 8
    end
    
    if N.RNDX then
        if self.HoverProgress > 0 then
            local glowAlpha = math.floor(20 * self.HoverProgress)
            N.RNDX.DrawShadows(radius, 0, 0, w, h, Color(self.BGColor.r, self.BGColor.g, self.BGColor.b, glowAlpha), 8, 12)
        end
        
        N.RNDX.Draw(radius, 0, 0, w, h, self.BGColor)
    else
        draw.RoundedBox(radius, 0, 0, w, h, self.BGColor)
    end
    
    local avatarSize = h - 8
    local avatarX = 4
    local avatarY = 4
    
    if N.RNDX then
        N.RNDX.DrawCircle(avatarX + avatarSize/2, avatarY + avatarSize/2, avatarSize/2, self.AvatarColor)
    else
        N.Draw:Circle(avatarX + avatarSize/2, avatarY + avatarSize/2, avatarSize/2, self.AvatarColor)
    end
    
    local textX = avatarX + avatarSize + 10
    
    local nameFont = "N.Font.14.Bold"
    local infoFont = "N.Font.12"
    
    if h >= 80 then
        nameFont = "N.Font.18.Bold"
        infoFont = "N.Font.14"
    elseif h >= 60 then
        nameFont = "N.Font.16.Bold"
        infoFont = "N.Font.12"
    end
    
    surface.SetFont(nameFont)
    local nameW, nameH = surface.GetTextSize(self.PlayerName)
    
    surface.SetFont(infoFont)
    local infoW, infoH = surface.GetTextSize(self.PlayerInfo)
    
    local totalTextH = nameH + infoH + 4
    local startY = (h - totalTextH) / 2
    
    local nameAlpha = Lerp(self.HoverProgress, 200, 255)
    local infoAlpha = Lerp(self.HoverProgress, 150, 200)
    
    draw.SimpleText(self.PlayerName, nameFont, textX, startY, Color(255, 255, 255, nameAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(self.PlayerInfo, infoFont, textX, startY + nameH + 4, Color(255, 255, 255, infoAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    
    return true
end

vgui.Register("N.UserCard", PANEL, "DButton")