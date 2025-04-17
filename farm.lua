-- Assuming this is inside your GUI for the target tab
local targetInput = targetTab:WaitForChild("TargetInput")  -- Input box for username
local farmButton = targetTab:WaitForChild("FarmButton")   -- Farm button to toggle
local farming = false  -- Keep track of farming state
local targetPlayer = nil

-- Toggle farming on or off
farmButton.MouseButton1Click:Connect(function()
    -- Get the target player name from the input field
    local username = targetInput.Text
    if username == "" then
        warn("Please enter a valid username.")
        return
    end

    -- Find the player by name
    targetPlayer = game.Players:FindFirstChild(username)

    if not targetPlayer then
        warn("Player not found.")
        return
    end

    -- Toggle farming state
    farming = not farming
    farmButton.Text = farming and "Farm: On" or "Farm: Off"

    if farming then
        -- Run the farming logic (teleport and circle)
        local function farmScript()
            while farming do
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
                    local myChar = game.Players.LocalPlayer.Character
                    local targetHead = targetPlayer.Character.Head
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        myChar.HumanoidRootPart.CFrame = targetHead.CFrame * CFrame.new(3, 0, 0) * CFrame.Angles(0, tick() * 2, 0)
                    end
                end
                wait(0.05)  -- Adjust speed of the circling
            end
        end

        -- Start the farming script
        spawn(farmScript)
    end
end)
