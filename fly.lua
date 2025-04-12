if _G.FlySetup then return end
_G.FlySetup = true

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

if _G.FlySetup then return end
_G.FlySetup = true

local flying = false
local speed = 2
local keysDown = {}
local hrp

local function updateHRP()
	local char = player.Character or player.CharacterAdded:Wait()
	hrp = char:WaitForChild("HumanoidRootPart")
end

local function startFlying()
	if _G.FlyConnection then return end

	_G.FlyKeyListener = UIS.InputBegan:Connect(function(input, typing)
		if typing then return end
		local key = input.KeyCode
		keysDown[key] = true

		if key == Enum.KeyCode.F then
			flying = not flying
		end
	end)

	_G.FlyKeyUpListener = UIS.InputEnded:Connect(function(input)
		keysDown[input.KeyCode] = false
	end)

	_G.FlyConnection = RunService.RenderStepped:Connect(function()
		if flying and hrp then
			local cam = workspace.CurrentCamera
			local moveVec = Vector3.new()

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
end

local function stopFlying()
	if _G.FlyConnection then
		_G.FlyConnection:Disconnect()
		_G.FlyConnection = nil
	end
	if _G.FlyKeyListener then
		_G.FlyKeyListener:Disconnect()
		_G.FlyKeyListener = nil
	end
	if _G.FlyKeyUpListener then
		_G.FlyKeyUpListener:Disconnect()
		_G.FlyKeyUpListener = nil
	end
	flying = false
end

-- Reconnect after death
player.CharacterAdded:Connect(function()
	task.wait(1) -- wait for character to fully load
	updateHRP()
	if _G.FlyActive then
		stopFlying()
		startFlying()
	end
end)

-- Initial setup
updateHRP()

-- Toggle via GUI
if _G.FlyActive then
	_G.FlyActive = false
	stopFlying()
else
	_G.FlyActive = true
	startFlying()
end
