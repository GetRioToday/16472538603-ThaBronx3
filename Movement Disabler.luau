local RunService = game:GetService("RunService")

local Character = game.Players.LocalPlayer.Character;
local RootPart = Character.HumanoidRootPart;

RunService.PreSimulation:Connect(function()
	RootPart.Anchored = false;
end)

RunService.PostSimulation:Connect(function()
	RootPart.Anchored = true;
end)
