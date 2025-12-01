N = N or {}

resource.AddFile("resource/fonts/montserrat-light.ttf")
resource.AddFile("resource/fonts/montserrat-medium.ttf")
resource.AddFile("resource/fonts/montserrat-bold.ttf")
resource.AddFile("resource/fonts/font_awesome_6_pro_regular.ttf")
resource.AddFile("resource/fonts/font_awesome_6_pro_solid.ttf")

local montserratSizes = {
    {name = "N.Font.10", size = 10, weight = 300},
    {name = "N.Font.12", size = 12, weight = 300},
    {name = "N.Font.14", size = 14, weight = 300},
    {name = "N.Font.16", size = 16, weight = 300},
    {name = "N.Font.18", size = 18, weight = 300},
    {name = "N.Font.20", size = 20, weight = 300},
    {name = "N.Font.24", size = 24, weight = 500},
    {name = "N.Font.28", size = 28, weight = 500},
    {name = "N.Font.32", size = 32, weight = 500},
    {name = "N.Font.36", size = 36, weight = 500},
    {name = "N.Font.40", size = 40, weight = 700},
    {name = "N.Font.48", size = 48, weight = 700},
    
    {name = "N.Font.12.Bold", size = 12, weight = 700},
    {name = "N.Font.14.Bold", size = 14, weight = 700},
    {name = "N.Font.16.Bold", size = 16, weight = 700},
    {name = "N.Font.18.Bold", size = 18, weight = 700},
    {name = "N.Font.20.Bold", size = 20, weight = 700},
    {name = "N.Font.24.Bold", size = 24, weight = 700},
    {name = "N.Font.28.Bold", size = 28, weight = 700},
    
    {name = "N.Font.14.Medium", size = 14, weight = 500},
    {name = "N.Font.16.Medium", size = 16, weight = 500},
    {name = "N.Font.18.Medium", size = 18, weight = 500},
    {name = "N.Font.20.Medium", size = 20, weight = 500}
}

for _, font in ipairs(montserratSizes) do
    surface.CreateFont(font.name, {
        font = "Montserrat",
        extended = true,
        size = font.size,
        weight = font.weight,
        antialias = true,
        shadow = false
    })
end

local iconSizes = {
    {name = "N.Icon.12", size = 12},
    {name = "N.Icon.14", size = 14},
    {name = "N.Icon.16", size = 16},
    {name = "N.Icon.18", size = 18},
    {name = "N.Icon.20", size = 20},
    {name = "N.Icon.24", size = 24},
    {name = "N.Icon.28", size = 28},
    {name = "N.Icon.32", size = 32},
    {name = "N.Icon.40", size = 40},
    {name = "N.Icon.48", size = 48}
}

for _, icon in ipairs(iconSizes) do
    surface.CreateFont(icon.name, {
        font = "Font Awesome 6 Pro Regular",
        extended = true,
        size = icon.size,
        weight = 400,
        antialias = true,
        shadow = false
    })
end

for _, icon in ipairs(iconSizes) do
    surface.CreateFont(icon.name .. ".Solid", {
        font = "Font Awesome 6 Pro Solid",
        extended = true,
        size = icon.size,
        weight = 900,
        antialias = true,
        shadow = false
    })
end
