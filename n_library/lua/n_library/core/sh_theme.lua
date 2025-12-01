N = N or {}
N.Theme = {}

N.Theme.Colors = {
    Base = Color(33, 25, 41),           -- #211929 - Couleur de base d'un élément
    Selected = Color(51, 41, 62),       -- #33293E - Couleur de sélection
    Important = Color(179, 115, 226),   -- #B373E2 - Bouton important/contraste
    Danger = Color(217, 112, 112),      -- #D97070 - Danger (supprimer, bannir)
    
    -- Variantes
    Primary = Color(179, 115, 226),     -- Important
    Secondary = Color(51, 41, 62),      -- Selected
    Success = Color(114, 196, 114),     -- Vert
    Warning = Color(230, 180, 80),      -- Orange
    Info = Color(91, 141, 233),         -- Bleu
    
    -- Backgrounds
    Background = Color(33, 25, 41),
    BackgroundLight = Color(51, 41, 62),
    BackgroundDark = Color(25, 18, 30),
    
    -- Texte
    Text = Color(255, 255, 255),
    TextSecondary = Color(180, 180, 180),
    TextMuted = Color(120, 120, 120),
    
    -- Borders
    Border = Color(60, 50, 70),
    BorderLight = Color(80, 70, 90),
    
    -- Overlay
    Shadow = Color(0, 0, 0, 80),
    Overlay = Color(0, 0, 0, 200),
    
    -- PATTERNS COLORS
    PatternPrimary = Color(179, 115, 226, 15),      -- Violet subtil
    PatternSecondary = Color(100, 150, 255, 20),    -- Bleu
    PatternSuccess = Color(100, 255, 150, 18),      -- Vert
    PatternWarning = Color(230, 180, 80, 20),       -- Orange
    PatternDanger = Color(255, 150, 100, 22),       -- Rouge/Orange
    PatternInfo = Color(91, 141, 233, 18),          -- Bleu info
    PatternLight = Color(255, 255, 255, 8),         -- Blanc très subtil
    PatternDark = Color(0, 0, 0, 15)                -- Noir subtil
}

N.Theme.Radius = 3
N.Theme.Spacing = 8

N.Theme.Sizes = {
    BorderRadius = 3,
    BorderWidth = 1,
    
    Spacing = {
        XS = 4,
        SM = 8,
        MD = 16,
        LG = 24,
        XL = 32
    },
    
    Button = {
        Height = {
            SM = 28,
            MD = 40,
            LG = 50
        },
        Padding = {
            SM = 8,
            MD = 12,
            LG = 16
        }
    },
    
    Input = {
        Height = {
            SM = 28,
            MD = 36,
            LG = 44
        }
    }
}

function N.Theme:Get(name, alpha)
    local color = self.Colors[name] or Color(255, 255, 255)
    if alpha then
        return Color(color.r, color.g, color.b, alpha)
    end
    return Color(color.r, color.g, color.b, color.a)
end

function N.Theme:Darken(color, amount)
    local amt = amount or 20
    return Color(
        math.max(0, color.r - amt),
        math.max(0, color.g - amt),
        math.max(0, color.b - amt),
        color.a or 255
    )
end

function N.Theme:Lighten(color, amount)
    local amt = amount or 20
    return Color(
        math.min(255, color.r + amt),
        math.min(255, color.g + amt),
        math.min(255, color.b + amt),
        color.a or 255
    )
end