local PANEL = {}

function PANEL:Init()
    self:SetSize(86, 59)
    
    self.BGColor = Color(33, 25, 41)
    self.BorderColor = Color(67, 77, 93)
    
    self.Title = "Titre"
    self.Value = "1000€"
    self.Description = ""
    self.HasDescription = false
end

function PANEL:SetTitle(title)
    self.Title = title
end

function PANEL:SetValue(value)
    self.Value = value
end

function PANEL:SetDescription(desc)
    self.Description = desc
    self.HasDescription = desc ~= ""
    
    if self.HasDescription then
        self:SetTall(68)
    else
        self:SetTall(59)
    end
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
    
    draw.SimpleText(self.Title, "N.Font.12", 16, 12, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    
    if self.HasDescription then
        draw.SimpleText(self.Description, "N.Font.12", 16, 24, Color(255, 255, 255, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(self.Value, "N.Font.20.Bold", 16, h - 24, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    else
        draw.SimpleText(self.Value, "N.Font.20.Bold", 16, 26, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    
    return true
end

vgui.Register("N.StatCard", PANEL, "DPanel")