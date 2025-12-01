N = N or {}
N.Patterns = {}
N.Patterns.Cache = {}

function N.Patterns.LoadMaterial(materialPath)
    if not N.Patterns.Cache[materialPath] then
        local cleanPath = materialPath:gsub("^materials/", "")
        N.Patterns.Cache[materialPath] = Material(cleanPath, "smooth")
    end
    return N.Patterns.Cache[materialPath]
end

function N.Patterns.DrawPattern(x, y, w, h, materialPath, color, scale)
    if not materialPath then return end
    
    color = color or Color(179, 115, 226, 35)
    
    if not color.a or color.a > 100 then
        color.a = 35
    end
    
    scale = scale or 0.5
    
    local mat = N.Patterns.LoadMaterial(materialPath)
    
    if not mat or mat:IsError() then
        return
    end
    
    surface.SetDrawColor(color)
    surface.SetMaterial(mat)
    
    local originalW = 2048
    local originalH = 2048
    
    local scaledW = originalW * scale
    local scaledH = originalH * scale
    
    local tilesX = math.ceil(w / scaledW)
    local tilesY = math.ceil(h / scaledH)
    
    for tileX = 0, tilesX - 1 do
        for tileY = 0, tilesY - 1 do
            local drawX = x + (tileX * scaledW)
            local drawY = y + (tileY * scaledH)
            
            local drawW = math.min(scaledW, w - (tileX * scaledW))
            local drawH = math.min(scaledH, h - (tileY * scaledH))
            
            if drawW > 0 and drawH > 0 then
                local u1 = 0
                local v1 = 0
                local u2 = drawW / scaledW
                local v2 = drawH / scaledH
                
                surface.DrawTexturedRectUV(drawX, drawY, drawW, drawH, u1, v1, u2, v2)
            end
        end
    end
end