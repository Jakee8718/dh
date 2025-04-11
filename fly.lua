-- Define fly state
local isFlying = false

-- Toggle fly on F key press
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Variables for flying speed and key inputs
local speed = 2
local keysDown = {}

-- Handle key inputs
UIS.InputBegan:Connect(function(input, typing)
	if typing then return end
	if input.KeyCode == Enum.KeyCode.F then
		isFlying = not isFlying
		if isFlying then
			print("Fly: ON")
		else
			print("Fly: OFF")
		end
	end

	keysDown[input.KeyCode] = true
end)

UIS.InputEnded:Connect(function(input)
	keysDown[input.KeyCode] = false
end)

-- Fly control loop
RunService.RenderStepped:Connect(function()
	if isFlying and hrp then
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
