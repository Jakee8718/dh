-- Cleanup if script was already loaded
if _G.FlyScript then
	_G.FlyScript:Disconnect()
	_G.FlyScript = nil
end

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Main control flags
_G.FlyScript = {} -- Table to hold connections
_G.FlyScript.Flying = false
_G.FlyScript.Enabled = true

local keysDown = {}
local speed = 2

-- F key toggle
_G.FlyScript.InputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.F and _G.FlyScript.Enabled then
		_G.FlyScript.Flying = not _G.FlyScript.Flying
		print("Flying: " .. tostring(_G.FlyScript.Flying))
	end
	keysDown[input.KeyCode] = true
end)

_G.FlyScript.InputEnded = UserInputService.InputEnded:Connect(function(input)
	keysDown[input.KeyCode] = false
end)

_G.FlyScript.Movement = RunService.RenderStepped:Connect(function()
	if _G.FlyScript.Flying and hrp then
		local cam = workspace.CurrentCamera
		local moveVec = Vector3.zero

		if keysDown[Enum.KeyCode.W] then moveVec += cam.CFrame.LookVector end
		if keysDown[Enum.KeyCode.S] then moveVec -= cam.CFrame.LookVector end
		if keysDown[Enum.KeyCode.A] then moveVec -= cam.CFrame.RightVector end
		if keysDown[Enum.KeyCode.D] then moveVec += cam.CFrame.RightVector end
		if keysDown[Enum.KeyCode.Space] then moveVec += Vector3.new(0, 1, 0) end
		if keysDown[Enum.KeyCode.LeftShift] then moveVec -= Vector3.new(0, 1, 0) end

		if moveVec.Magnitude > 0 then
			moveVec = moveVec.Unit * speed
			hrp.CFrame += moveVec
		end
	end
end)

-- Cleanup function to disable
function _G.FlyScript:Disconnect()
	if self.InputBegan then self.InputBegan:Disconnect() end
	if self.InputEnded then self.InputEnded:Disconnect() end
	if self.Movement then self.Movement:Disconnect() end
	self.Flying = false
	self.Enabled = false
end
