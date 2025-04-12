local player = game.Players.LocalPlayer
local teleportGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local titleLabel = Instance.new("TextLabel")
local closeButton = Instance.new("TextButton")
local playerListFrame = Instance.new("ScrollingFrame")

teleportGui.Name = "TeleportGui"
teleportGui.Parent = player.PlayerGui

mainFrame.Name = "MainFrame"
mainFrame.Parent = teleportGui
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Active = true
mainFrame.Draggable = true

titleLabel.Name = "TitleLabel"
titleLabel.Parent = mainFrame
titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)  -- was (0.4,0.4,0.4)
titleLabel.BorderSizePixel = 0
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "RS - TP GUI"
titleLabel.TextColor3 = Color3.fromRGB(235, 0, 4)
titleLabel.TextSize = 20

playerListFrame.Name = "PlayerListFrame"
playerListFrame.Parent = mainFrame
playerListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
playerListFrame.BorderSizePixel = 0
playerListFrame.Position = UDim2.new(0, 20, 0, 40)
playerListFrame.Size = UDim2.new(0, 260, 0, 140)
playerListFrame.ScrollBarThickness = 6
playerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Start at 0, update dynamically

local function updatePlayerList()
    for _, child in pairs(playerListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local yOffset = 0
    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player then
            local playerButton = Instance.new("TextButton")
            playerButton.Name = otherPlayer.Name
            playerButton.Parent = playerListFrame
            playerButton.BackgroundColor3 = Color3.fromRGB(153, 153, 153) -- was (0.6, 0.6, 0.6)
            playerButton.BorderSizePixel = 0
            playerButton.Size = UDim2.new(0, 240, 0, 30)
            playerButton.Position = UDim2.new(0, 10, 0, yOffset)
            playerButton.Font = Enum.Font.SourceSans
            playerButton.Text = string.format("%s (@%s)", otherPlayer.DisplayName, otherPlayer.Name)
            playerButton.TextColor3 = Color3.fromRGB(235, 0, 4)  -- RED!
            playerButton.TextSize = 16

            playerButton.MouseButton1Click:Connect(function()
                local targetPlayer = game.Players:FindFirstChild(otherPlayer.Name)
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                else
                    print("Player not found!")
                end
            end)

            yOffset = yOffset + 35
        end
    end

    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

updatePlayerList()

game.Players.PlayerAdded:Connect(updatePlayerList)
game.Players.PlayerRemoving:Connect(updatePlayerList)

closeButton.MouseButton1Click:Connect(function()
    teleportGui:Destroy()
end)
