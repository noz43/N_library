N = N or {}
N.Anim = {}

function N.Anim:Lerp(current, target, speed)
    return Lerp(speed or N.Config.AnimationSpeed, current, target)
end

function N.Anim:ColorLerp(current, target, speed)
    if not current or not target then return Color(255, 255, 255) end
    
    local s = speed or N.Config.AnimationSpeed
    return Color(
        Lerp(s, current.r, target.r),
        Lerp(s, current.g, target.g),
        Lerp(s, current.b, target.b),
        Lerp(s, current.a or 255, target.a or 255)
    )
end

function N.Anim:EaseInOut(t)
    return t < 0.5 and 2 * t * t or -1 + (4 - 2 * t) * t
end

function N.Anim:EaseOut(t)
    return 1 - (1 - t) * (1 - t)
end

function N.Anim:EaseIn(t)
    return t * t
end