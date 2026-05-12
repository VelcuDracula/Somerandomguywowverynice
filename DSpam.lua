local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local tool

for i,v in player:GetDescendants() do
	if v.Name == "SyncAPI" then
		tool = v.Parent
	end
end

for i,v in game.ReplicatedStorage:GetDescendants() do
	if v.Name == "SyncAPI" then
		tool = v.Parent
	end
end

local remote = tool.SyncAPI.ServerEndpoint

local function _(args)
	remote:InvokeServer(unpack(args))
end

local function SetLocked(part, boolean)
	_( {"SetLocked", {part}, boolean} )
end

local function SpawnDecal(part, side)
	_( {"CreateTextures", {
		{
			Part = part,
			Face = side,
			TextureType = "Decal"
		}
	}} )
end

local function AddDecal(part, asset, side)
	_( {"SyncTexture", {
		{
			Part = part,
			Face = side,
			TextureType = "Decal",
			Texture = "rbxassetid://" .. asset
		}
	}} )
end

local function spam(id)
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") then
			if char and v:IsDescendantOf(char) then
				continue
			end
			if v.Name == "Sky" then
				continue
			end
			task.spawn(function()
				SetLocked(v,false)
				for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
					SpawnDecal(v, face)
					AddDecal(v, id, face)
				end
			end)
		end
	end 
end

spam("98543007033715")
