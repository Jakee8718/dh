-- Fly script with F-key toggle (controlled by GUI button)

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Kill previous fly state
if _G.FlyScriptRunning then
    _G.FlyEnabled = false
    _G.FlyKeyConnection:Disconnect()
    _G.FlyLoop:Disconnect()
    _G.FlyScriptRunning = false
    return
end

-- Global flags
_G.FlyScriptRunning = true
_G.FlyEnabled = false

-- Movement
local keysDown = {}
local speed = 2

-- Toggle fly on F press
_G.FlyKeyConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.F then
		_G.FlyEnabled = not _G.FlyEnabled
	end
end)

-- Track movement keys
UserInputService.InputBegan:Connect(function(input, typing)
	if typing then return end
	keysDown[input.KeyCode] = true
end)

UserInputService.InputEnded:Connect(function(input)
	keysDown[input.KeyCode] = false
end)

-- Fly logic
_G.FlyLoop = RunService.RenderStepped:Connect(function()
	if _G.FlyEnabled and hrp then
		local cam = workspace.CurrentCamera
		local moveVec = Vector3.new()

		if keysDown[Enum.KeyCode.W] then moveVec += cam.CFrame.LookVector end
		if keysDown[Enum.KeyCode.S] then moveVec -= cam.CFrame.LookVector end
		if keysDown[Enum.KeyCode.A] then moveVec -= cam.CFrame.RightVector end
		if keysDown[Enum.KeyCode.D] then moveVec += cam.CFrame.RightVector end
		if keysDown[Enum.KeyCode.Space] then moveVec += Vector3.new(0, 1, 0) end
		if keysDown[Enum.KeyCode.LeftShift] then moveVec -= Vector3.new(0, 1, 0) end

		if moveVec.Magnitude > 0 then
			hrp.Velocity = Vector3.zero -- optional to cancel physics
			moveVec = moveVec.Unit * speed
			hrp.CFrame = hrp.CFrame + moveVec
		end
	end
end)
