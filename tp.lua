local player = game.Players.LocalPlayer
local teleportGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local titleLabel = Instance.new("TextLabel")
local closeButton = Instance.new("TextButton")
local searchBox = Instance.new("TextBox")
local loopButton = Instance.new("TextButton")
local playerListFrame = Instance.new("ScrollingFrame")

local loopActive = false
local targetPlayer = nil

teleportGui.Name = "TeleportGui"
teleportGui.Parent = player.PlayerGui

mainFrame.Name = "MainFrame"
mainFrame.Parent = teleportGui
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.Size = UDim2.new(0, 300, 0, 220)
mainFrame.Active = true
mainFrame.Draggable = true

titleLabel.Name = "TitleLabel"
titleLabel.Parent = mainFrame
titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleLabel.BorderSizePixel = 0
titleLabel.Size = UDim2.new(1, -30, 0, 30)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "RS - TP GUI"
titleLabel.TextColor3 = Color3.fromRGB(235, 0, 4)
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Position = UDim2.new(0, 5, 0, 0)

closeButton.Name = "CloseButton"
closeButton.Parent = mainFrame
closeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
closeButton.BorderSizePixel = 0
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 3)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(235, 0, 4)
closeButton.TextSize = 16

searchBox.Name = "SearchBox"
searchBox.Parent = mainFrame
searchBox.PlaceholderText = "Search user or display name"
searchBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
searchBox.BorderSizePixel = 0
searchBox.Position = UDim2.new(0, 10, 0, 35)
searchBox.Size = UDim2.new(0, 200, 0, 25)
searchBox.Font = Enum.Font.SourceSans
searchBox.Text = ""
searchBox.TextColor3 = Color3.fromRGB(235, 0, 4)
searchBox.TextSize = 14

loopButton.Name = "LoopButton"
loopButton.Parent = mainFrame
loopButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
loopButton.BorderSizePixel = 0
loopButton.Position = UDim2.new(0, 215, 0, 35)
loopButton.Size = UDim2.new(0, 75, 0, 25)
loopButton.Font = Enum.Font.SourceSans
loopButton.Text = "Loop: Off"
loopButton.TextColor3 = Color3.fromRGB(235, 0, 4)
loopButton.TextSize = 14

playerListFrame.Name = "PlayerListFrame"
playerListFrame.Parent = mainFrame
playerListFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
playerListFrame.BorderSizePixel = 0
playerListFrame.Position = UDim2.new(0, 10, 0, 65)
playerListFrame.Size = UDim2.new(0, 280, 0, 145)
playerListFrame.ScrollBarThickness = 6
playerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local function updatePlayerList(filter)
    for _, child in pairs(playerListFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    local yOffset = 0
    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player then
            local nameMatch = otherPlayer.Name:lower():find(filter:lower())
            local displayMatch = otherPlayer.DisplayName:lower():find(filter:lower())
            if filter == "" or nameMatch or displayMatch then
                local entryFrame = Instance.new("Frame", playerListFrame)
                entryFrame.Size = UDim2.new(0, 260, 0, 30)
                entryFrame.Position = UDim2.new(0, 10, 0, yOffset)
                entryFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                entryFrame.BorderSizePixel = 0

                local avatar = Instance.new("ImageLabel", entryFrame)
                avatar.Size = UDim2.new(0, 24, 0, 24)
                avatar.Position = UDim2.new(0, 3, 0.5, -12)
                avatar.BackgroundTransparency = 1
                avatar.Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%s&width=420&height=420&format=png", otherPlayer.UserId)

                local nameLabel = Instance.new("TextButton", entryFrame)
                nameLabel.Size = UDim2.new(1, -35, 1, 0)
                nameLabel.Position = UDim2.new(0, 30, 0, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = string.format("%s (@%s)", otherPlayer.DisplayName, otherPlayer.Name)
                nameLabel.Font = Enum.Font.SourceSans
                nameLabel.TextColor3 = Color3.fromRGB(235, 0, 4)
                nameLabel.TextSize = 16
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left

                nameLabel.MouseButton1Click:Connect(function()
                    targetPlayer = otherPlayer
                    player.Character.HumanoidRootPart.CFrame = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and targetPlayer.Character.HumanoidRootPart.CFrame or player.Character.HumanoidRootPart.CFrame
                end)

                yOffset = yOffset + 35
            end
        end
    end
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    updatePlayerList(searchBox.Text)
end)

loopButton.MouseButton1Click:Connect(function()
    if targetPlayer then
        loopActive = not loopActive
        loopButton.Text = loopActive and "Loop: On" or "Loop: Off"
    end
end)

game.Players.PlayerAdded:Connect(function() updatePlayerList(searchBox.Text) end)
game.Players.PlayerRemoving:Connect(function() updatePlayerList(searchBox.Text) end)

task.spawn(function()
    while true do
        task.wait(0.5)
        if loopActive and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)

closeButton.MouseButton1Click:Connect(function()
    teleportGui:Destroy()
end)

updatePlayerList("")
