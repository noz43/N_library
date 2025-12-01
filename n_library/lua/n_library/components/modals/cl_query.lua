local PANEL = {}

function PANEL:Init()
    self:SetSize(400, 220)
    self:Center()
    self:MakePopup()
    self:SetDraggable(false)
    self:SetTitle("")
    self:ShowCloseButton(false)
    
    self.ModalTitle = "Input Required"
    self.Message = "Please enter a value:"
    self.DefaultValue = ""
    self.OverlayColor = Color(0, 0, 0, 200)
    self.BGColor = Color(33, 25, 41)
    self.HeaderColor = Color(51, 41, 62)
    
    self.ConfirmText = "OK"
    self.CancelText = "Cancel"
    
    self.ConfirmCallback = function(value) end
    self.CancelCallback = function() end
    
    self.TextEntry = vgui.Create("N.TextEntry", self)
    self.TextEntry:SetValue(self.DefaultValue)
    
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

function PANEL:SetDefaultValue(value)
    self.DefaultValue = value
    if self.TextEntry then
        self.TextEntry:SetValue(value)
    end
end

function PANEL:OnConfirm()
    local value = self.TextEntry:GetValue()
    self.ConfirmCallback(value)
    self:Close()
end

function PANEL:OnCancel()
    self.CancelCallback()
    self:Close()
end

function PANEL:PerformLayout(w, h)
    DFrame.PerformLayout(self, w, h)
    
    if self.TextEntry then
        self.TextEntry:SetSize(w - 40, 40)
        self.TextEntry:SetPos(20, 100)
    end
    
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
    draw.SimpleText(self.Message, "N.Font.14", 20, 75, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    
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

vgui.Register("N.Query", PANEL, "DFrame")

function N.CreateQuery(title, message, defaultValue, onConfirm, onCancel)
    local query = vgui.Create("N.Query")
    query:SetModalTitle(title or "Input Required")
    query:SetMessage(message or "Please enter a value:")
    query:SetDefaultValue(defaultValue or "")
    query.ConfirmCallback = onConfirm or function(value) end
    query.CancelCallback = onCancel or function() end
    return query
end