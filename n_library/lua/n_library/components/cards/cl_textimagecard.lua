local PANEL = {}

function PANEL:Init()
    self:SetSize(520, 170)
    
    self.BGColor = Color(33, 25, 41)
    self.BorderColor = Color(67, 77, 93)
    self.ImageBG = Color(21, 17, 25)
    
    self.Title = "Titre"
    self.Description = "Description"
    self.ImageURL = ""
    
    self.HTMLImage = vgui.Create("DHTML", self)
    self.HTMLImage:SetMouseInputEnabled(false)
    self.HTMLImage:SetKeyboardInputEnabled(false)
end

function PANEL:SetTitle(title)
    self.Title = title
end

function PANEL:SetDescription(desc)
    self.Description = desc
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
                        border-radius: 8px;
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

function PANEL:PerformLayout(w, h)
    if IsValid(self.HTMLImage) then
        local imgSize = h - 26
        local imgX = w - imgSize - 13
        local imgY = 13
        
        self.HTMLImage:SetPos(imgX, imgY)
        self.HTMLImage:SetSize(imgSize, imgSize)
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
    
    draw.SimpleText(self.Title, "N.Font.18.Bold", 23, 30, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(self.Description, "N.Font.14", 23, 55, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    
    local imgSize = h - 26
    local imgX = w - imgSize - 13
    local imgY = 13
    
    if N.RNDX then
        N.RNDX.Draw(8, imgX, imgY, imgSize, imgSize, self.ImageBG)
    else
        draw.RoundedBox(8, imgX, imgY, imgSize, imgSize, self.ImageBG)
    end
    
    return true
end

function PANEL:OnRemove()
    if IsValid(self.HTMLImage) then
        self.HTMLImage:Remove()
    end
end

vgui.Register("N.TextImageCard", PANEL, "DPanel")