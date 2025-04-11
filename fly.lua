-- Define fly state
local isFlying = false

-- Variables for flying speed and key inputs
local speed = 2
local keysDown = {}
local flyConnection

-- Handle key inputs
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Function to start flying
local function startFlying()
	isFlying = true
	print("Fly: ON")
	
	-- Fly control loop
	flyConnection = RunService.RenderStepped:Connect(function()
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
end

-- Function to stop flying
local function stopFlying()
	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
		isFlying = false
		print("Fly: OFF")
	end
end

-- Handle key inputs for toggling fly
UIS.InputBegan:Connect(function(input, typing)
	if typing then return end
	
	if input.KeyCode == Enum.KeyCode.F then
		if isFlying then
			stopFlying()
		else
			startFlying()
		end
	end
	
	keysDown[input.KeyCode] = true
end)

UIS.InputEnded:Connect(function(input)
	keysDown[input.KeyCode] = false
end)
