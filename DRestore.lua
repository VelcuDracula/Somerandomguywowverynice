local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function getf3x()
    for _, v in ipairs(player.Backpack:GetChildren()) do
        if v:FindFirstChild("SyncAPI") then
            return v
        end
    end
    for _, v in ipairs(player.Character:GetChildren()) do
        if v:FindFirstChild("SyncAPI") then
            return v
        end
    end
end

local function instantDecalRestore()
    local f3x = getf3x()
    if not f3x then 
        return 
    end

    local endpoint = f3x.SyncAPI.ServerEndpoint
    local targetId = "93353009758340"

    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Decal") and string.find(v.Texture or "", targetId) then
            task.spawn(function()
                pcall(function()
                    endpoint:InvokeServer("Remove", {v})
                end)
            end)
        end
    end
end

instantDecalRestore()
