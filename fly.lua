-- Define fly state and fly connection
local isFlying = false
local flyConnection
local speed = 2
local keysDown = {}

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
    
    -- Only allow pressing 'F' to toggle flying if the GUI Fly button isn't toggled off
    if input.KeyCode == Enum.KeyCode.F and isFlying then
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

-- Handle the GUI fly button toggling logic
local function toggleFlyButton()
    if isFlying then
        stopFlying()
    else
        startFlying()
    end
end

-- Now inside your GUI button code:
-- Assuming you have a "Fly" button in the GUI, you should call toggleFlyButton when it is pressed.

-- Example button setup in GUI script (you will already have this, just ensure to call toggleFlyButton inside the button click event):

for _, scriptData in ipairs(scripts) do
    if scriptData.Name == "Fly" then
        -- GUI button for Fly
        local button = Instance.new("TextButton", scroll)
        button.Size = UDim2.new(1, 0, 0, 36)
        button.Font = Enum.Font.Gotham
        button.TextSize = 14
        button.TextColor3 = currentTheme.Text
        button.BackgroundColor3 = currentTheme.Surface
        button.AutoButtonColor = false
        button.Text = scriptData.Name .. ": Off"

        local corner = Instance.new("UICorner", button)
        corner.CornerRadius = UDim.new(0, 6)

        button.MouseButton1Click:Connect(function()
            -- Toggle the fly state when button is clicked
            scriptData.Active = not scriptData.Active
            button.Text = scriptData.Name .. (scriptData.Active and ": On" or ": Off")
            
            -- Toggle fly on/off based on button state
            toggleFlyButton()
        end)
    end
end
