N = N or {}
N.Imgur = {}

function N.Imgur:Load(imageId, callback)
    local directory = "n_library/imgur/"
    local filePath = directory .. imageId
    
    if file.Exists(filePath, "DATA") then
        local mat = Material("../data/" .. filePath, "smooth")
        if callback then callback(mat) end
        return mat
    end
    
    http.Fetch("https://i.imgur.com/" .. imageId, 
        function(body, length, headers, code)
            if code ~= 200 then return end
            
            if not file.IsDir(directory, "DATA") then 
                file.CreateDir(directory)
            end
            
            file.Write(filePath, body)
            
            timer.Simple(0.1, function()
                if file.Exists(filePath, "DATA") then
                    local mat = Material("../data/" .. filePath, "smooth")
                    if callback then callback(mat) end
                end
            end)
        end,
        function(error) end
    )
    
    return Material("vgui/white")
end

function N.Imgur:Clear()
    local directory = "n_library/imgur/"
    local files = file.Find(directory .. "*", "DATA")
    
    for _, fileName in ipairs(files) do
        file.Delete(directory .. fileName)
    end
end