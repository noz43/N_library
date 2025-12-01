N = N or {}
N.Draw = {}

local RNDX = nil
local success = pcall(function()
    RNDX = include("n_library/utils/rndx.lua")
end)

if success and RNDX then
    N.RNDX = RNDX
end

function N.Draw:Rect(x, y, w, h, color, radius)
    if N.RNDX then
        N.RNDX.Draw(radius or 8, x, y, w, h, color)
    else
        draw.RoundedBox(radius or 8, x, y, w, h, color)
    end
end

function N.Draw:RectWithShadow(x, y, w, h, color, radius, shadowSpread, shadowIntensity)
    if N.RNDX then
        radius = radius or 8
        shadowSpread = shadowSpread or 10
        shadowIntensity = shadowIntensity or 15
        
        N.RNDX.DrawShadows(radius, x, y, w, h, Color(0, 0, 0, 150), shadowSpread, shadowIntensity)
        N.RNDX.Draw(radius, x, y, w, h, color)
    else
        self:Shadow(x, y, w, h, radius or 8, 80)
        draw.RoundedBox(radius or 8, x, y, w, h, color)
    end
end

function N.Draw:RectWithGlow(x, y, w, h, color, radius, glowColor)
    if N.RNDX then
        radius = radius or 8
        glowColor = glowColor or color
        
        local glowAlpha = math.max(30, glowColor.a * 0.3)
        local glow = Color(glowColor.r, glowColor.g, glowColor.b, glowAlpha)
        
        N.RNDX.DrawShadows(radius, x, y, w, h, glow, 15, 20)
        N.RNDX.Draw(radius, x, y, w, h, color)
    else
        draw.RoundedBox(radius or 8, x, y, w, h, color)
    end
end

function N.Draw:RectStroke(x, y, w, h, color, thickness, radius)
    if N.RNDX then
        radius = radius or 8
        thickness = thickness or 2
        N.RNDX.DrawOutlined(radius, x, y, w, h, color, thickness)
    else
        self:RectOutline(x, y, w, h, color, thickness, radius)
    end
end

function N.Draw:RectStrokeGlow(x, y, w, h, color, thickness, radius, glowSpread, glowIntensity)
    if N.RNDX then
        radius = radius or 8
        thickness = thickness or 2
        glowSpread = glowSpread or 8
        glowIntensity = glowIntensity or 12
        
        local glowAlpha = math.max(20, color.a * 0.2)
        local glowColor = Color(color.r, color.g, color.b, glowAlpha)
        
        N.RNDX.DrawShadows(radius, x, y, w, h, glowColor, glowSpread, glowIntensity)
        N.RNDX.DrawOutlined(radius, x, y, w, h, color, thickness)
    else
        self:RectStroke(x, y, w, h, color, thickness, radius)
    end
end

function N.Draw:RectOutline(x, y, w, h, color, thickness, radius)
    surface.SetDrawColor(color)
    local r = radius or 8
    local t = thickness or 2
    
    draw.RoundedBoxEx(r, x, y, w, t, color, true, true, false, false)
    draw.RoundedBoxEx(r, x, y + h - t, w, t, color, false, false, true, true)
    draw.RoundedBox(0, x, y + r, t, h - r * 2, color)
    draw.RoundedBox(0, x + w - t, y + r, t, h - r * 2, color)
end

function N.Draw:Text(text, x, y, font, color, alignX, alignY)
    draw.SimpleText(text, font or "N.Font.14", x, y, color or N.Theme:Get("Text"), alignX or TEXT_ALIGN_LEFT, alignY or TEXT_ALIGN_TOP)
end

function N.Draw:TextShadow(text, x, y, font, color, alignX, alignY, shadowColor, shadowOffset)
    shadowColor = shadowColor or Color(0, 0, 0, 150)
    shadowOffset = shadowOffset or 2
    
    draw.SimpleText(text, font or "N.Font.14", x + shadowOffset, y + shadowOffset, shadowColor, alignX or TEXT_ALIGN_LEFT, alignY or TEXT_ALIGN_TOP)
    draw.SimpleText(text, font or "N.Font.14", x, y, color or N.Theme:Get("Text"), alignX or TEXT_ALIGN_LEFT, alignY or TEXT_ALIGN_TOP)
end

function N.Draw:Circle(x, y, radius, color)
    if N.RNDX then
        N.RNDX.DrawCircle(x, y, radius, color)
    else
        draw.NoTexture()
        surface.SetDrawColor(color)
        
        local circle = {}
        local segments = 36
        
        for i = 0, segments do
            local a = math.rad((i / segments) * 360)
            table.insert(circle, {
                x = x + math.cos(a) * radius,
                y = y + math.sin(a) * radius
            })
        end
        
        surface.DrawPoly(circle)
    end
end

function N.Draw:CircleStroke(x, y, radius, color, thickness)
    if N.RNDX then
        thickness = thickness or 2
        N.RNDX.DrawCircleOutlined(x, y, radius, color, thickness)
    else
        self:CircleOutline(x, y, radius, color, thickness)
    end
end

function N.Draw:CircleWithGlow(x, y, radius, color, glowSpread, glowIntensity)
    if N.RNDX then
        glowSpread = glowSpread or 12
        glowIntensity = glowIntensity or 18
        
        local glowAlpha = math.max(30, color.a * 0.3)
        local glowColor = Color(color.r, color.g, color.b, glowAlpha)
        
        N.RNDX.DrawShadows(radius, x - radius, y - radius, radius * 2, radius * 2, glowColor, glowSpread, glowIntensity)
        N.RNDX.DrawCircle(x, y, radius, color)
    else
        self:Circle(x, y, radius, color)
    end
end

function N.Draw:CircleOutline(x, y, radius, color, thickness, segments)
    segments = segments or 36
    thickness = thickness or 2
    surface.SetDrawColor(color)
    
    for i = 0, segments do
        local a1 = math.rad((i / segments) * 360)
        local a2 = math.rad(((i + 1) / segments) * 360)
        
        for t = 0, thickness - 1 do
            surface.DrawLine(
                x + math.cos(a1) * (radius - t),
                y + math.sin(a1) * (radius - t),
                x + math.cos(a2) * (radius - t),
                y + math.sin(a2) * (radius - t)
            )
        end
    end
end

function N.Draw:Shadow(x, y, w, h, radius, intensity)
    local shadow = N.Theme:Get("Shadow", intensity or 80)
    draw.RoundedBox(radius or 8, x + 2, y + 2, w, h, shadow)
end

function N.Draw:Blur(panel, amount)
    if not N.Config.BlurEnabled then return end
    
    local x, y = panel:LocalToScreen(0, 0)
    local w, h = panel:GetSize()
    
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(N.Materials.Blur)
    
    for i = 1, (amount or 3) do
        N.Materials.Blur:SetFloat("$blur", (i / 3) * 4)
        N.Materials.Blur:Recompute()
        
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
    end
end

function N.Draw:Icon(icon, x, y, size, color)
    if not N.Materials.Icons[icon] then return end
    
    surface.SetDrawColor(color or Color(255, 255, 255))
    surface.SetMaterial(N.Materials.Icons[icon])
    surface.DrawTexturedRect(x, y, size, size)
end