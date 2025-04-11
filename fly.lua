-- Fly Script
local player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50
local conn -- connection holder

local function onInput(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.F and not gameProcessed then
		flying = not flying
	end
end

local function flyLoop()
	if flying then
		local cam = workspace.CurrentCamera
		local move = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
		hrp.Velocity = move.Unit * speed
	else
		hrp.Velocity = Vector3.zero
	end
end

local inputConn = UIS.InputBegan:Connect(onInput)
local renderConn = RS.RenderStepped:Connect(flyLoop)

-- Save disconnect method globally so GUI can call it
_G.FlyDisconnect = function()
	inputConn:Disconnect()
	renderConn:Disconnect()
	flying = false
	hrp.Velocity = Vector3.zero
end
