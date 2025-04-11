local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 2
local keysDown = {}

UIS.InputBegan:Connect(function(input, typing)
	if typing then return end

	local key = input.KeyCode
	keysDown[key] = true

	if key == Enum.KeyCode.F then
		flying = not flying
	end
end)

UIS.InputEnded:Connect(function(input)
	keysDown[input.KeyCode] = false
end)

RunService.RenderStepped:Connect(function()
	if flying and hrp then
		local cam = workspace.CurrentCamera
		local moveVec = Vector3.new(0, 0, 0)

		if keysDown[Enum.KeyCode.W] then
			moveVec += cam.CFrame.LookVector
		end
		if keysDown[Enum.KeyCode.S] then
			moveVec -= cam.CFrame.LookVector
		end
		if keysDown[Enum.KeyCode.A] then
			moveVec -= cam.CFrame.RightVector
		end
		if keysDown[Enum.KeyCode.D] then
			moveVec += cam.CFrame.RightVector
		end
		if keysDown[Enum.KeyCode.Space] then
			moveVec += Vector3.new(0, 1, 0)
		end
		if keysDown[Enum.KeyCode.LeftShift] then
			moveVec -= Vector3.new(0, 1, 0)
		end

		if moveVec.Magnitude > 0 then
			moveVec = moveVec.Unit * speed
			hrp.CFrame = hrp.CFrame + moveVec
		end
	end
end)
