local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local tool = nil
local skyPart = nil
local skyLoop = nil
local musicEnabled = false
local requestedBtools = false

local RunService = game:GetService("RunService")

local function checkForBtools()
    local names = {"Building Tools","Btools","Building","F3X","Build","btool"}
    for _, item in ipairs(player.Backpack:GetChildren()) do
        if item:IsA("Tool") or item:IsA("HopperBin") then
            for _, name in ipairs(names) do
                if item.Name:lower() == name:lower() then
                    return true
                end
            end
        end
    end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") or item:IsA("HopperBin") then
            for _, name in ipairs(names) do
                if item.Name:lower() == name:lower() then
                    return true
                end
            end
        end
    end
    return false
end

local function findTool()
    for _, v in ipairs(player:GetDescendants()) do
        if v.Name == "SyncAPI" and v.Parent then
            tool = v.Parent
            return true
        end
    end
    for _, v in ipairs(game.ReplicatedStorage:GetDescendants()) do
        if v.Name == "SyncAPI" and v.Parent then
            tool = v.Parent
            return true
        end
    end
    return false
end

local function waitForTool()
    local hdRemote = game:GetService("ReplicatedStorage"):WaitForChild("HDAdminHDClient"):WaitForChild("Signals"):WaitForChild("RequestCommandSilent")
    while not findTool() do
        if not checkForBtools() and not requestedBtools then
            requestedBtools = true
            pcall(function()
                hdRemote:InvokeServer(";btools me")
            end)
        end
        task.wait(1)
    end
end

task.spawn(waitForTool)

local function getRemote()
    if tool and tool:FindFirstChild("SyncAPI") then
        return tool.SyncAPI:FindFirstChild("ServerEndpoint")
    end
    return nil
end

local function _(args)
    local r = getRemote()
    if r then
        pcall(function()
            r:InvokeServer(unpack(args))
        end)
    end
end

function CreatePart(cf, parent)
    _({"CreatePart","Normal",cf,parent})
end

function SetAnchor(part, boolean)
    _({"SyncAnchor",{{Part = part, Anchored = boolean}}})
end

function AddMesh(part)
    _({"CreateMeshes",{{Part = part}}})
end

function SetMesh(part, meshid)
    _({"SyncMesh",{{Part = part, MeshId = "rbxassetid://" .. meshid}}})
end

function SetTexture(part, texid)
    _({"SyncMesh",{{Part = part, TextureId = texid}}})
end

function MeshResize(part, size)
    _({"SyncMesh",{{Part = part, Scale = size}}})
end

function SetTransparency(part, value)
    _({"SyncTransparency",{{Part = part, Transparency = value}}})
end

function DestroyPart(part)
    if part and part.Parent then
        _({"Remove",{part}})
    end
end

local images = {
    "http://www.roblox.com/asset/?id=169585459",
    "http://www.roblox.com/asset/?id=169585475",
    "http://www.roblox.com/asset/?id=169585485",
    "http://www.roblox.com/asset/?id=169585502",
    "http://www.roblox.com/asset/?id=169585515",
    "http://www.roblox.com/asset/?id=169585502",
    "http://www.roblox.com/asset/?id=169585485",
    "http://www.roblox.com/asset/?id=169585475"
}

local frameTime = 1/10
local lastUpdate = 0
local index = 1

local function ClearSky()
    if skyLoop then
        skyLoop:Disconnect()
        skyLoop = nil
    end
    if skyPart then
        DestroyPart(skyPart)
        skyPart = nil
    end
end

local function CreateSky()
    ClearSky()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local spawnPos = hrp.CFrame.Position + Vector3.new(0,6,0)
    CreatePart(CFrame.new(spawnPos), workspace)

    for i = 1,80 do
        task.wait(0.03)
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and (v.Position - spawnPos).Magnitude < 3 then
                skyPart = v
                break
            end
        end
        if skyPart then break end
    end

    if not skyPart then return end

    SetAnchor(skyPart,true)
    AddMesh(skyPart)
    SetMesh(skyPart,"111891702759441")
    MeshResize(skyPart,Vector3.new(8000,8000,8000))
    SetTransparency(skyPart,0)

    index = 1
    lastUpdate = 0

    skyLoop = RunService.Heartbeat:Connect(function(dt)
        lastUpdate += dt
        if lastUpdate >= frameTime then
            lastUpdate = 0
            if not skyPart or not skyPart.Parent then
                skyLoop:Disconnect()
                return
            end
            SetTexture(skyPart,images[index])
            index = (index % #images) + 1
        end
    end)
end

player.CharacterAdded:Connect(function(newChar)
    char = newChar
    task.wait(1)
end)

if char:FindFirstChild("Humanoid") then
    char.Humanoid.Died:Connect(ClearSky)
end

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local frame = Instance.new("Frame", gui)
frame.BorderSizePixel = 3
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.Size = UDim2.new(0,210,0,138)
frame.Position = UDim2.new(0,12,0,20)
frame.BorderColor3 = Color3.fromRGB(0,0,0)

Instance.new("UIDragDetector", frame)

local musicBtn = Instance.new("TextButton", frame)
musicBtn.TextWrapped = true
musicBtn.TextScaled = true
musicBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
musicBtn.Size = UDim2.new(0,178,0,40)
musicBtn.Position = UDim2.new(0,14,0,92)
musicBtn.Text = "MUSIC"

local skyBtn = Instance.new("TextButton", frame)
skyBtn.TextWrapped = true
skyBtn.TextScaled = true
skyBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
skyBtn.Size = UDim2.new(0,178,0,38)
skyBtn.Position = UDim2.new(0,14,0,48)
skyBtn.Text = "SKYBOX"

local title = Instance.new("TextLabel", frame)
title.TextWrapped = true
title.TextScaled = true
title.BackgroundTransparency = 1
title.Size = UDim2.new(0,210,0,42)
title.Text = "Skeletonz f3x admin"

local function createHint()
    local hint = Instance.new("Hint")
    hint.Text = "Reset To Stop Skeleton Skybox."
    hint.Parent = workspace
    task.delay(6,function()
        if hint then hint:Destroy() end
    end)
end

local function clickAnim(btn)
    local s = btn.Size
    btn.Size = s - UDim2.new(0,8,0,4)
    task.delay(0.1,function()
        if btn then btn.Size = s end
    end)
end

skyBtn.MouseButton1Click:Connect(function()
    clickAnim(skyBtn)
    CreateSky()
    createHint()
end)

local hdRemote = game:GetService("ReplicatedStorage"):WaitForChild("HDAdminHDClient"):WaitForChild("Signals"):WaitForChild("RequestCommandSilent")

musicBtn.MouseButton1Click:Connect(function()
    clickAnim(musicBtn)
    if musicEnabled then
        hdRemote:InvokeServer(";unmusic")
    else
        hdRemote:InvokeServer(";music 101389433601746 ;volume inf ;pitch 0.8")
    end
    musicEnabled = not musicEnabled
end)

if char:FindFirstChild("Humanoid") then
    char.Humanoid.Died:Connect(ClearSky)
end
