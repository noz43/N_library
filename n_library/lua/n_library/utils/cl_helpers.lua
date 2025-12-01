N = N or {}
N.Helpers = {}

function N.Helpers:PlaySound(sound)
    if not N.Config.EnableSounds then return end
    surface.PlaySound(sound)
end

function N.Helpers:IsInside(x, y, px, py, pw, ph)
    return x >= px and x <= px + pw and y >= py and y <= py + ph
end

function N.Helpers:FormatNumber(num)
    return string.Comma(num)
end

function N.Helpers:FormatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    
    if hours > 0 then
        return string.format("%dh %02dm", hours, minutes)
    elseif minutes > 0 then
        return string.format("%dm %02ds", minutes, secs)
    else
        return string.format("%ds", secs)
    end
end

function N.Helpers:CopyToClipboard(text)
    SetClipboardText(text)
    notification.AddLegacy("Copié !", NOTIFY_GENERIC, 2)
end