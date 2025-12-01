N = N or {}
N.Draw = N.Draw or {}

local RNDX = nil
local success = pcall(function()
    RNDX = include("n_library/utils/rndx.lua")
end)

if success and RNDX then
    N.RNDX = RNDX
    
    function N.Draw.RoundedBoxWithShadow(radius, x, y, w, h, color, shadowSpread, shadowIntensity)
        shadowSpread = shadowSpread or 10
        shadowIntensity = shadowIntensity or 15
        
        RNDX.DrawShadows(radius, x, y, w, h, Color(0, 0, 0, 150), shadowSpread, shadowIntensity)
        RNDX.Draw(radius, x, y, w, h, color)
    end
    
    function N.Draw.RoundedBoxWithGlow(radius, x, y, w, h, color, glowColor, glowSpread, glowIntensity)
        glowColor = glowColor or color
        glowSpread = glowSpread or 15
        glowIntensity = glowIntensity or 20
        
        RNDX.DrawShadows(radius, x, y, w, h, glowColor, glowSpread, glowIntensity)
        RNDX.Draw(radius, x, y, w, h, color)
    end
    
    function N.Draw.RoundedBoxWithLayeredGlow(radius, x, y, w, h, color, glowColor)
        glowColor = glowColor or color
        
        local glowAlpha = math.max(30, glowColor.a * 0.3)
        local glowLight = Color(glowColor.r, glowColor.g, glowColor.b, glowAlpha)
        RNDX.DrawShadows(radius, x, y, w, h, glowLight, 18, 25)
        
        local glowMid = Color(glowColor.r, glowColor.g, glowColor.b, math.max(50, glowColor.a * 0.5))
        RNDX.DrawShadows(radius, x, y, w, h, glowMid, 10, 15)
        
        RNDX.Draw(radius, x, y, w, h, color)
    end
    
    function N.Draw.RoundedOutlineWithGlow(radius, x, y, w, h, outlineColor, thickness, glowSpread, glowIntensity)
        thickness = thickness or 2
        glowSpread = glowSpread or 8
        glowIntensity = glowIntensity or 12
        
        local glowAlpha = math.max(20, outlineColor.a * 0.2)
        local glowColor = Color(outlineColor.r, outlineColor.g, outlineColor.b, glowAlpha)
        RNDX.DrawShadows(radius, x, y, w, h, glowColor, glowSpread, glowIntensity)
        
        RNDX.DrawOutlined(radius, x, y, w, h, outlineColor, thickness)
    end
    
    function N.Draw.CircularProgress(cx, cy, radius, progress, bgColor, fgColor, thickness)
        thickness = thickness or 8
        progress = math.Clamp(progress, 0, 1)
        
        local innerRadius = radius - thickness
        
        local glowAlpha = math.max(25, fgColor.a * 0.25)
        local glowColor = Color(fgColor.r, fgColor.g, fgColor.b, glowAlpha)
        RNDX().Circle(cx, cy, radius * 2)
            :Color(glowColor)
            :Shadow(15, 20)
            :Draw()
        
        RNDX().Circle(cx, cy, radius * 2)
            :Color(Color(fgColor.r, fgColor.g, fgColor.b, math.max(40, fgColor.a * 0.4)))
            :Flags(RNDX.BLUR)
            :Draw()
        
        RNDX().Circle(cx, cy, radius * 2)
            :Color(bgColor)
            :Draw()
        
        if progress > 0 then
            local startAngle = -90
            local endAngle = startAngle + (progress * 360)
            
            RNDX().Circle(cx, cy, radius * 2)
                :Color(fgColor)
                :StartAngle(startAngle)
                :EndAngle(endAngle)
                :Draw()
        end
        
        RNDX().Circle(cx, cy, innerRadius * 2)
            :Color(bgColor)
            :Draw()
    end
    
    function N.Draw.CircularProgressAdvanced(cx, cy, radius, progress, bgColor, fgColor, thickness, showGlow, centerColor, drawCenter)
        thickness = thickness or 10
        progress = math.Clamp(progress, 0, 1)
        showGlow = showGlow ~= false
        centerColor = centerColor or Color(23, 19, 28)
        drawCenter = drawCenter ~= false
        
        local innerRadius = radius - thickness
        local startAngle = -90
        local endAngle = startAngle + (progress * 360)
        
        if showGlow then
            RNDX().Circle(cx, cy, (radius + 8) * 2)
                :Color(Color(fgColor.r, fgColor.g, fgColor.b, 30))
                :Shadow(20, 25)
                :Draw()
        end
        
        if showGlow then
            RNDX().Circle(cx, cy, (radius + 4) * 2)
                :Color(Color(fgColor.r, fgColor.g, fgColor.b, 50))
                :Shadow(12, 18)
                :Draw()
        end
        
        if showGlow then
            RNDX().Circle(cx, cy, (radius + 1) * 2)
                :Color(Color(fgColor.r, fgColor.g, fgColor.b, 80))
                :Shadow(6, 10)
                :Draw()
        end
        
        local segments = 80
        draw.NoTexture()
        for i = 0, segments - 1 do
            local angle1 = math.rad(i / segments * 360)
            local angle2 = math.rad((i + 1) / segments * 360)
            
            local x1_outer = cx + math.cos(angle1) * radius
            local y1_outer = cy + math.sin(angle1) * radius
            local x2_outer = cx + math.cos(angle2) * radius
            local y2_outer = cy + math.sin(angle2) * radius
            
            local x1_inner = cx + math.cos(angle1) * innerRadius
            local y1_inner = cy + math.sin(angle1) * innerRadius
            local x2_inner = cx + math.cos(angle2) * innerRadius
            local y2_inner = cy + math.sin(angle2) * innerRadius
            
            surface.SetDrawColor(bgColor)
            surface.DrawPoly({
                {x = x1_outer, y = y1_outer},
                {x = x2_outer, y = y2_outer},
                {x = x2_inner, y = y2_inner},
                {x = x1_inner, y = y1_inner}
            })
        end
        
        if progress > 0 then
            local arcSegments = math.ceil(segments * progress)
            for i = 0, arcSegments - 1 do
                local angle1 = math.rad(startAngle + (endAngle - startAngle) * (i / arcSegments))
                local angle2 = math.rad(startAngle + (endAngle - startAngle) * ((i + 1) / arcSegments))
                
                local x1_outer = cx + math.cos(angle1) * radius
                local y1_outer = cy + math.sin(angle1) * radius
                local x2_outer = cx + math.cos(angle2) * radius
                local y2_outer = cy + math.sin(angle2) * radius
                
                local x1_inner = cx + math.cos(angle1) * innerRadius
                local y1_inner = cy + math.sin(angle1) * innerRadius
                local x2_inner = cx + math.cos(angle2) * innerRadius
                local y2_inner = cy + math.sin(angle2) * innerRadius
                
                surface.SetDrawColor(fgColor.r, fgColor.g, fgColor.b, 255)
                surface.DrawPoly({
                    {x = x1_outer, y = y1_outer},
                    {x = x2_outer, y = y2_outer},
                    {x = x2_inner, y = y2_inner},
                    {x = x1_inner, y = y1_inner}
                })
            end
        end
        
        if drawCenter then
            RNDX().Circle(cx, cy, innerRadius * 2)
                :Color(centerColor)
                :Draw()
        end
    end
    
    function N.Draw.Rect(x, y, w, h)
        return RNDX().Rect(x, y, w, h)
    end
    
    function N.Draw.Circle(x, y, r)
        return RNDX().Circle(x, y, r)
    end
end