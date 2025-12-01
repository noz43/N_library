local PANEL = {}

function PANEL:Init()
    self.Canvas = vgui.Create("Panel", self)
    self.Canvas:SetPos(0, 0)
    
    self.VBar = vgui.Create("DVScrollBar", self)
    self.VBar:SetWide(7)
    
    function self.VBar:Paint(w, h)
        if N.RNDX then
            N.RNDX.Draw(3, 0, 0, w, h, Color(23, 19, 28))
        else
            draw.RoundedBox(3, 0, 0, w, h, Color(23, 19, 28))
        end
    end
    
    function self.VBar.btnGrip:Paint(w, h)
        if N.RNDX then
            N.RNDX.Draw(3, 0, 0, w, h, Color(179, 115, 226))
        else
            draw.RoundedBox(3, 0, 0, w, h, Color(179, 115, 226))
        end
    end
    
    self.VBar.btnUp:SetVisible(false)
    self.VBar.btnDown:SetVisible(false)
    self.VBar.btnUp:SetSize(0, 0)
    self.VBar.btnDown:SetSize(0, 0)
    
    self.VBar.btnUp.Paint = function() end
    self.VBar.btnDown.Paint = function() end
end

function PANEL:GetCanvas()
    return self.Canvas
end

function PANEL:OnMouseWheeled(delta)
    return self.VBar:OnMouseWheeled(delta)
end

function PANEL:PerformLayout(w, h)
    self.VBar:SetPos(w - 7, 0)
    self.VBar:SetSize(7, h)
    
    self.Canvas:SetPos(0, 0)
    self.Canvas:SetWide(w - 10)
    
    local tall = self.Canvas:GetTall()
    for _, child in pairs(self.Canvas:GetChildren()) do
        if IsValid(child) then
            local cx, cy = child:GetPos()
            local cw, ch = child:GetSize()
            tall = math.max(tall, cy + ch + 10)
        end
    end
    
    self.Canvas:SetTall(tall)
    
    self.VBar:SetUp(h, tall)
    self.Canvas:SetPos(0, self.VBar:GetOffset())
end

function PANEL:Paint(w, h)
    if self.BGColor then
        if N.RNDX then
            N.RNDX.Draw(0, 0, 0, w, h, self.BGColor)
        else
            draw.RoundedBox(0, 0, 0, w, h, self.BGColor)
        end
    end
end

function PANEL:SetBackgroundColor(col)
    self.BGColor = col
end

vgui.Register("N.ScrollPanel", PANEL, "Panel")