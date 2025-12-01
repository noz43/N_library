local PANEL = {}

function PANEL:Init()
    self:SetSize(150, 100)
    
    self.Value = "1000"
    self.Label = "Titre"
    
    self.BGColor = Color(33, 25, 41)
    self.BorderColor = Color(67, 77, 93)
end

function PANEL:SetValue(value)
    self.Value = value
end

function PANEL:SetLabel(label)
    self.Label = label
end

function PANEL:Paint(w, h)
    if N.RNDX then
        N.RNDX.Draw(8, 0, 0, w, h, self.BGColor)
        N.RNDX.DrawOutlined(8, 0, 0, w, h, self.BorderColor, 1)
    else
        draw.RoundedBox(8, 0, 0, w, h, self.BGColor)
        surface.SetDrawColor(self.BorderColor)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end
    
    draw.SimpleText(self.Value, "N.Font.28.Bold", w/2, h/2 - 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(self.Label, "N.Font.14", w/2, h/2 + 15, Color(255, 255, 255, 180), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    
    return true
end

vgui.Register("N.InfoCard", PANEL, "DPanel")