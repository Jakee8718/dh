local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 2

UserInputService.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.F then
		if _G.FlyToggleState then
			flying = not flying
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if flying and _G.FlyToggleState then
		local moveDir = Vector3.new()
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			moveDir = moveDir + (workspace.CurrentCamera.CFrame.LookVector)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			moveDir = moveDir - (workspace.CurrentCamera.CFrame.LookVector)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			moveDir = moveDir - (workspace.CurrentCamera.CFrame.RightVector)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			moveDir = moveDir + (workspace.CurrentCamera.CFrame.RightVector)
		end
		humanoidRootPart.Velocity = moveDir.Unit * speed
	end
end)
