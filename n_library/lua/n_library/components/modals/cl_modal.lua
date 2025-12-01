local PANEL = {}

function PANEL:Init()
    self:SetSize(400, 300)
    self:Center()
    self:MakePopup()
    self:SetDraggable(false)
    self:SetTitle("")
    self:ShowCloseButton(false)
    
    self.ModalTitle = "Modal"
    self.OverlayColor = Color(0, 0, 0, 200)
    self.BGColor = Color(33, 25, 41)
    self.HeaderColor = Color(51, 41, 62)
    
    self.CloseButton = vgui.Create("N.IconButton", self)
    self.CloseButton:SetSize(32, 32)
    self.CloseButton:SetIcon("close")
    self.CloseButton:SetStyle("Danger")
    self.CloseButton.DoClick = function()
        self:Close()
    end
end

function PANEL:SetModalTitle(title)
    self.ModalTitle = title
end

function PANEL:PerformLayout(w, h)
    DFrame.PerformLayout(self, w, h)
    
    if self.CloseButton then
        self.CloseButton:SetPos(w - 32 - 12, 12)
    end
end

function PANEL:Paint(w, h)
    if N.RNDX then
        N.RNDX.Draw(12, 0, 0, w, h, self.BGColor)
        N.RNDX.Draw(12, 0, 0, w, 56, self.HeaderColor, N.RNDX.NO_BL + N.RNDX.NO_BR)
    else
        draw.RoundedBox(12, 0, 0, w, h, self.BGColor)
        draw.RoundedBox(12, 0, 0, w, 56, self.HeaderColor)
        draw.RoundedBox(0, 0, 32, w, 24, self.HeaderColor)
    end
    
    draw.SimpleText(self.ModalTitle, "N.Font.20.Bold", 20, 28, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    
    return true
end

function PANEL:PaintOver(w, h)
    local scrW, scrH = ScrW(), ScrH()
    local x, y = self:LocalToScreen(0, 0)
    
    surface.SetDrawColor(self.OverlayColor)
    surface.DrawRect(-x, -y, scrW, y)
    surface.DrawRect(-x, h, scrW, scrH - y - h)
    surface.DrawRect(-x, 0, x, h)
    surface.DrawRect(w, 0, scrW - x - w, h)
end

vgui.Register("N.Modal", PANEL, "DFrame")