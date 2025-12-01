local PANEL = {}

function PANEL:Init()
    self:SetSize(300, 200)
    
    self.BGColor = Color(0, 0, 0, 0)
    self.Items = {}
    
    self.Scroll = vgui.Create("N.ScrollPanel", self)
    self.Scroll:Dock(FILL)
end

function PANEL:SetBackgroundColor(color)
    self.BGColor = color
end

function PANEL:AddItem(item)
    table.insert(self.Items, item)
    item:SetParent(self.Scroll:GetCanvas())
    item:Dock(TOP)
    item:DockMargin(0, 0, 0, 2)
end

function PANEL:Clear()
    for _, item in ipairs(self.Items) do
        if IsValid(item) then
            item:Remove()
        end
    end
    self.Items = {}
end

function PANEL:GetItems()
    return self.Items
end

function PANEL:Paint(w, h)
    if self.BGColor.a > 0 then
        N.RNDX.Draw(0, 0, 0, w, h, self.BGColor)
    end
    return true
end

vgui.Register("N.List", PANEL, "DPanel")