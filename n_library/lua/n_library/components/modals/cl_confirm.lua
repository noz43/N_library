local PANEL = {}

function PANEL:Init()
    self:SetSize(400, 200)
    self:Center()
    self:MakePopup()
    self:SetDraggable(false)
    self:SetTitle("")
    self:ShowCloseButton(false)
    
    self.ModalTitle = "Confirmation"
    self.Message = "Are you sure?"
    self.OverlayColor = Color(0, 0, 0, 200)
    self.BGColor = Color(33, 25, 41)
    self.HeaderColor = Color(51, 41, 62)
    
    self.ConfirmText = "Confirm"
    self.CancelText = "Cancel"
    
    self.ConfirmCallback = function() end
    self.CancelCallback = function() end
    
    self.ConfirmBtn = vgui.Create("N.Button", self)
    self.ConfirmBtn:SetLabel(self.ConfirmText)
    self.ConfirmBtn:SetStyle("Important")
    self.ConfirmBtn.DoClick = function()
        self:OnConfirm()
    end
    
    self.CancelBtn = vgui.Create("N.Button", self)
    self.CancelBtn:SetLabel(self.CancelText)
    self.CancelBtn:SetStyle("Standard")
    self.CancelBtn.DoClick = function()
        self:OnCancel()
    end
end

function PANEL:SetConfirmText(text)
    self.ConfirmText = text
    if self.ConfirmBtn then
        self.ConfirmBtn:SetLabel(text)
    end
end

function PANEL:SetCancelText(text)
    self.CancelText = text
    if self.CancelBtn then
        self.CancelBtn:SetLabel(text)
    end
end

function PANEL:SetMessage(msg)
    self.Message = msg
end

function PANEL:SetModalTitle(title)
    self.ModalTitle = title
end

function PANEL:OnConfirm()
    self.ConfirmCallback()
    self:Close()
end

function PANEL:OnCancel()
    self.CancelCallback()
    self:Close()
end

function PANEL:PerformLayout(w, h)
    DFrame.PerformLayout(self, w, h)
    
    local btnW = 120
    local btnH = 40
    local spacing = 10
    local btnY = h - btnH - 20
    
    if self.ConfirmBtn then
        self.ConfirmBtn:SetSize(btnW, btnH)
        self.ConfirmBtn:SetPos(w - btnW - 20, btnY)
    end
    
    if self.CancelBtn then
        self.CancelBtn:SetSize(btnW, btnH)
        self.CancelBtn:SetPos(w - btnW * 2 - 20 - spacing, btnY)
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
    
    local textY = 80
    draw.DrawText(self.Message, "N.Font.14", 20, textY, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT)
    
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

vgui.Register("N.Confirm", PANEL, "DFrame")

function N.CreateConfirm(title, message, onConfirm, onCancel)
    local confirm = vgui.Create("N.Confirm")
    confirm:SetModalTitle(title or "Confirmation")
    confirm:SetMessage(message or "Are you sure?")
    confirm.ConfirmCallback = onConfirm or function() end
    confirm.CancelCallback = onCancel or function() end
    return confirm
end