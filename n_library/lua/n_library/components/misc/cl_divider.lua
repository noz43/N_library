local PANEL = {}

function PANEL:Init()
    self:SetSize(200, 1)
    
    self.Text = ""
    self.Color = Color(51, 41, 62)
    self.Thickness = 1
    self.Orientation = "horizontal"
end

function PANEL:SetText(text)
    self.Text = text
    if text and text ~= "" then
        self:SetTall(20)
    end
end

function PANEL:SetDividerColor(color)
    self.Color = color
end

function PANEL:SetThickness(thickness)
    self.Thickness = thickness
    if self.Orientation == "horizontal" then
        self:SetTall(thickness)
    else
        self:SetWide(thickness)
    end
end

function PANEL:SetOrientation(orientation)
    self.Orientation = orientation
end

function PANEL:Paint(w, h)
    if self.Orientation == "horizontal" then
        if self.Text ~= "" then
            local lineY = h/2
            local lineThick = self.Thickness
            
            surface.SetFont("N.Font.12")
            local textW, textH = surface.GetTextSize(self.Text)
            
            local leftW = (w - textW - 20) / 2
            local rightX = leftW + textW + 20
            local rightW = w - rightX
            
            surface.SetDrawColor(self.Color)
            surface.DrawRect(0, lineY, leftW, lineThick)
            surface.DrawRect(rightX, lineY, rightW, lineThick)
            
            draw.SimpleText(self.Text, "N.Font.12", w/2, h/2, Color(255, 255, 255, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            surface.SetDrawColor(self.Color)
            surface.DrawRect(0, 0, w, self.Thickness)
        end
    else
        surface.SetDrawColor(self.Color)
        surface.DrawRect(0, 0, self.Thickness, h)
    end
    
    return true
end

vgui.Register("N.Divider", PANEL, "DPanel")