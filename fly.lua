if _G.FlyConnection then
	-- Toggle off
	_G.FlyConnection:Disconnect()
	_G.FlyConnection = nil
	_G.Flying = false
	print("Fly: OFF")
	return
end

-- Toggle on
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

_G.Flying = true
local speed = 2
local keysDown = {}

UIS.InputBegan:Connect(function(input, typing)
	if typing then return end
	keysDown[input.KeyCode] = true
end)

UIS.InputEnded:Connect(function(input)
	keysDown[input.KeyCode] = false
end)

_G.FlyConnection = RunService.RenderStepped:Connect(function()
	if _G.Flying and hrp then
		local cam = workspace.CurrentCamera
		local moveVec = Vector3.new(0, 0, 0)

		if keysDown[Enum.KeyCode.W] then moveVec += cam.CFrame.LookVector end
		if keysDown[Enum.KeyCode.S] then moveVec -= cam.CFrame.LookVector end
		if keysDown[Enum.KeyCode.A] then moveVec -= cam.CFrame.RightVector end
		if keysDown[Enum.KeyCode.D] then moveVec += cam.CFrame.RightVector end
		if keysDown[Enum.KeyCode.Space] then moveVec += Vector3.new(0, 1, 0) end
		if keysDown[Enum.KeyCode.LeftShift] then moveVec -= Vector3.new(0, 1, 0) end

		if moveVec.Magnitude > 0 then
			moveVec = moveVec.Unit * speed
			hrp.CFrame = hrp.CFrame + moveVec
		end
	end
end)

print("Fly: ON")
