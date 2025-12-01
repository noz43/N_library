local PANEL = {}

function PANEL:Init()
    self:SetSize(610, 175)
    
    self.ImageURL = ""
    self.Title = "Title"
    self.Subtitle = "Subtitle"
    self.BorderColor = Color(255, 255, 255, 28)
    
    self.HTMLImage = vgui.Create("DHTML", self)
    self.HTMLImage:SetPos(0, 0)
    self.HTMLImage:SetSize(610, 175)
    self.HTMLImage:SetMouseInputEnabled(false)
    self.HTMLImage:SetKeyboardInputEnabled(false)
    self.HTMLImage:SetPaintedManually(true)
end

function PANEL:SetImgurImage(imageId)
    local url = "https://i.imgur.com/" .. imageId
    self:SetImageURL(url)
end

function PANEL:SetImageURL(url)
    self.ImageURL = url
    
    if IsValid(self.HTMLImage) then
        local html = string.format([[
            <!DOCTYPE html>
            <html>
            <head>
                <style>
                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                    }
                    body, html {
                        width: 100%%;
                        height: 100%%;
                        overflow: hidden;
                        background: #151119;
                    }
                    img {
                        width: 100%%;
                        height: 100%%;
                        object-fit: cover;
                        display: block;
                    }
                </style>
            </head>
            <body>
                <img src="%s" alt="Image" />
            </body>
            </html>
        ]], url)
        
        self.HTMLImage:SetHTML(html)
    end
end

function PANEL:SetTitle(title)
    self.Title = title
end

function PANEL:SetSubtitle(subtitle)
    self.Subtitle = subtitle
end

function PANEL:PerformLayout(w, h)
    if IsValid(self.HTMLImage) then
        self.HTMLImage:SetPos(0, 0)
        self.HTMLImage:SetSize(w, h)
    end
end

function PANEL:Paint(w, h)
    if N.RNDX then
        N.RNDX.Draw(8, 0, 0, w, h, Color(21, 17, 25))
    else
        draw.RoundedBox(8, 0, 0, w, h, Color(21, 17, 25))
    end
    
    if IsValid(self.HTMLImage) then
        self.HTMLImage:PaintManual()
    end
    
    local gradientHeight = 100
    for i = 0, 50 do
        local frac = i / 50
        local y = h - (gradientHeight * frac)
        local alpha = math.floor(230 * (1 - frac))
        surface.SetDrawColor(21, 17, 25, alpha)
        surface.DrawRect(0, y, w, gradientHeight / 50)
    end
    
    surface.SetDrawColor(self.BorderColor)
    surface.DrawOutlinedRect(0, 0, w, h, 3)
    
    draw.SimpleText(self.Subtitle, "N.Font.14", 25, h - 50, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(self.Title, "N.Font.20.Bold", 25, h - 30, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    
    return true
end

function PANEL:OnRemove()
    if IsValid(self.HTMLImage) then
        self.HTMLImage:Remove()
    end
end

vgui.Register("N.LargeImageCard", PANEL, "DPanel")