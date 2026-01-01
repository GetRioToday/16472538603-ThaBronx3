local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalClient = Players.LocalPlayer;
while not LocalClient do
    Players.PlayerAdded:Wait()
    LocalClient = Players.LocalPlayer;
end

local Character = LocalClient.Character;
local RootPart = Character.HumanoidRootPart;

RunService.PreSimulation:Connect(function()
	RootPart.Anchored = false;
end)

RunService.PostSimulation:Connect(function()
	RootPart.Anchored = true;
end)
