    local PANEL = {}

    function PANEL:Init()
        self:SetSize(800, 600)
        self:MakePopup()
        self:Center()
        
        self.BGColor = Color(33, 25, 41)
        self.TitleBarColor = Color(51, 41, 62, 200)
        self.TitleColor = Color(255, 255, 255)
        self.FrameTitle = "Frame"
        self.Radius = 12
        self.TitleBarHeight = 56
        
        self.EnableBorder = false
        self.BorderColor = Color(179, 115, 226, 100)
        self.BorderThickness = 2
        
        self.EnableShadow = true
        self.ShadowSpread = 20
        self.ShadowIntensity = 25
        
        self.btnClose = vgui.Create("DButton", self)
        self.btnClose:SetText("")
        self.btnClose:SetSize(40, 40)
        self.btnClose.DoClick = function() 
            self:Remove()
        end
        
        self.btnClose.Paint = function(pnl, w, h)
            local isHovered = pnl:IsHovered()
            local col = isHovered and Color(217, 112, 112) or Color(60, 50, 70)
            local iconCol = isHovered and Color(255, 255, 255) or Color(180, 180, 180)
            
            if N.RNDX then
                if isHovered then
                    N.RNDX.DrawShadows(8, 0, 0, w, h, Color(217, 112, 112, 50), 8, 12)
                end
                
                N.RNDX.Draw(8, 0, 0, w, h, col)
            else
                draw.RoundedBox(8, 0, 0, w, h, col)
            end
            
            if N.Materials and N.Materials.Icons and N.Materials.Icons["close"] then
                surface.SetDrawColor(iconCol)
                surface.SetMaterial(N.Materials.Icons["close"])
                surface.DrawTexturedRect(8, 8, 24, 24)
            else
                draw.SimpleText("×", "N.Font.24.Bold", w/2, h/2, iconCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end

    function PANEL:SetFrameTitle(title)
        self.FrameTitle = title or "Frame"
    end

    function PANEL:SetBackgroundColor(col)
        self.BGColor = col or Color(33, 25, 41)
    end

    function PANEL:SetTitleBarColor(col)
        self.TitleBarColor = col or Color(51, 41, 62, 200)
    end

    function PANEL:SetRadius(radius)
        self.Radius = radius or 12
    end

    function PANEL:SetBorder(enabled, color, thickness)
        self.EnableBorder = enabled
        self.BorderColor = color or Color(179, 115, 226, 100)
        self.BorderThickness = thickness or 2
    end

    function PANEL:SetShadow(enabled, spread, intensity)
        self.EnableShadow = enabled
        self.ShadowSpread = spread or 20
        self.ShadowIntensity = intensity or 25
    end

    function PANEL:Close()
        self:Remove()
    end

    function PANEL:PerformLayout(w, h)
        if self.btnClose and IsValid(self.btnClose) then
            self.btnClose:SetPos(w - 50, 8)
        end
    end

    function PANEL:Paint(w, h)
        local bgColor = self.BGColor or Color(33, 25, 41)
        local titleBarColor = self.TitleBarColor or Color(51, 41, 62, 200)
        local titleColor = self.TitleColor or Color(255, 255, 255)
        
        if N.RNDX then
            if self.EnableShadow then
                N.RNDX.DrawShadows(self.Radius, 0, 0, w, h, Color(0, 0, 0, 200), self.ShadowSpread, self.ShadowIntensity)
            end
            
            if self.EnableBorder then
                N.RNDX.DrawShadows(self.Radius, 0, 0, w, h, self.BorderColor, 12, 15)
                N.RNDX.Draw(self.Radius, 0, 0, w, h, bgColor)
            else
                N.RNDX.Draw(self.Radius, 0, 0, w, h, bgColor)
            end
            
            local flags = N.RNDX.NO_BL + N.RNDX.NO_BR
            N.RNDX.Draw(self.Radius, 0, 0, w, self.TitleBarHeight, titleBarColor, flags)
        else
            draw.RoundedBox(self.Radius, 0, 0, w, h, bgColor)
            draw.RoundedBox(self.Radius, 0, 0, w, self.TitleBarHeight, titleBarColor)
        end
        
        draw.SimpleText(self.FrameTitle or "Frame", "N.Font.20.Bold", 20, self.TitleBarHeight / 2, titleColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        
        return true
    end

    vgui.Register("N.Frame", PANEL, "EditablePanel")