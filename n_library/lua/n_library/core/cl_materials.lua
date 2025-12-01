N = N or {}
N.Materials = N.Materials or {}


-- Utilisé pour les effets de flou sur les modals, overlays, backgrounds
N.Materials.Blur = Material("pp/blurscreen")


N.Materials.Icons = {}

function N.Materials:LoadIcon(name, path)
    self.Icons[name] = Material(path, "smooth")
    return self.Icons[name]
end

function N.Materials:GetIcon(name)
    return self.Icons[name]
end

function N.Materials:LoadAllIcons()
    local iconPath = "materials/n_library/"
    local files = file.Find(iconPath .. "*.png", "GAME")
    
    for _, fileName in ipairs(files) do
        local iconName = string.StripExtension(fileName)
        self:LoadIcon(iconName, "n_library/" .. fileName)
    end
end

N.Materials:LoadAllIcons()

N.Materials:LoadIcon("search", "n_library/search.png")        -- Barre de recherche, search inputs
N.Materials:LoadIcon("settings", "n_library/settings.png")    -- Boutons paramètres, configuration
N.Materials:LoadIcon("user", "n_library/user.png")            -- Avatars par défaut, profils utilisateurs
N.Materials:LoadIcon("home", "n_library/home.png")            -- Bouton accueil, page principale
N.Materials:LoadIcon("close", "n_library/close.png")          -- Fermer fenêtres, modals, frames (TRÈS IMPORTANT)

N.Materials:LoadIcon("cart", "n_library/shop.png")           -- Menu boutique, shop
N.Materials:LoadIcon("shield", "n_library/shield.png")                -- Menu protection, sécurité, admin
N.Materials:LoadIcon("alert-triangle", "n_library/alert.png")-- Alertes, avertissements
N.Materials:LoadIcon("users", "n_library/users.png")                  -- Gestion des joueurs, liste membres
N.Materials:LoadIcon("bar-chart", "n_library/bar.png")          -- Statistiques, dashboard, analytics
N.Materials:LoadIcon("message-circle", "n_library/message.png")-- Chat, messages, notifications
N.Materials:LoadIcon("help-circle", "n_library/help.png")      -- Aide, support, info

N.Materials:LoadIcon("check", "n_library/check.png")          -- Validation, succès, checkbox cochée
N.Materials:LoadIcon("x", "n_library/x.png")                  -- Annulation, erreur, refus
N.Materials:LoadIcon("plus", "n_library/plus.png")            -- Ajouter, créer nouveau
N.Materials:LoadIcon("edit", "n_library/edit.png")            -- Éditer, modifier
N.Materials:LoadIcon("trash", "n_library/trash.png")          -- Supprimer, effacer (DANGER)
N.Materials:LoadIcon("download", "n_library/download.png")    -- Télécharger fichiers
N.Materials:LoadIcon("upload", "n_library/upload.png")        -- Uploader fichiers
N.Materials:LoadIcon("refresh", "n_library/refresh.png")      -- Actualiser, recharger

N.Materials:LoadIcon("chevron-left", "n_library/chevron-left.png")    -- Page précédente, retour
N.Materials:LoadIcon("chevron-right", "n_library/arrow1.png")  -- Page suivante

N.Materials:LoadIcon("eye", "n_library/eye.png")              -- Afficher, visible
N.Materials:LoadIcon("eye-off", "n_library/eye-off.png")      -- Cacher, masquer (mot de passe)

N.Materials:LoadIcon("lock", "n_library/lock.png")            -- Verrouillé, sécurisé
N.Materials:LoadIcon("unlock", "n_library/unlock.png")        -- Déverrouillé, accessible

N.Materials:LoadIcon("bell", "n_library/bell.png")            -- Notifications, alertes

N.Materials:LoadIcon("info", "n_library/info.png")                  -- Information générale
N.Materials:LoadIcon("alert-circle", "n_library/alert-circle.png")  -- Attention, warning
N.Materials:LoadIcon("check-circle", "n_library/check-circle.png")  -- Succès, validé
N.Materials:LoadIcon("x-circle", "n_library/x-circle.png")          -- Erreur, échec

-- ==========================================
-- IMAGES POUR CARDS (EXEMPLES - À SUPPRIMER SI IMGUR)
-- ==========================================
N.Materials.CardImages = {}

function N.Materials:LoadCardImage(name, path)
    self.CardImages[name] = Material(path, "smooth")
    return self.CardImages[name]
end

function N.Materials:GetCardImage(name)
    return self.CardImages[name]
end

-- EXEMPLE 1 - Image générique (peut garder pour placeholder)
N.Materials:LoadCardImage("example1", "n_library/example1.png")  

-- VALORANT - INUTILE si tu utilises Imgur, à SUPPRIMER
-- N.Materials:LoadCardImage("valorant", "n_library/cards/valorant.png")  
