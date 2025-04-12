-- Global table to track ESP objects
local drawings = {}

-- Cleanup function to remove all ESP elements
getgenv().espCleanup = function()
    for _, obj in pairs(drawings) do
        if obj.Remove then
            obj:Remove()
        end
    end
    drawings = {} -- Reset the drawing table
    print("ESP Cleaned up!")
end

local ESP_ENABLED = false -- Default is off
local NAMETAGS_ENABLED = false -- Toggle NameTags on/off with key
local COLOR = Color3.fromRGB(255, 0, 0) -- Box color
local LINE_THICKNESS = 2
local REFRESH_RATE = 0.01

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = game.Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Toggle NameTags on key press "N"
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.N then
        NAMETAGS_ENABLED = not NAMETAGS_ENABLED
    end
end)

-- Create ESP Box for a player
local function CreateESPBox(character, player)
    local Box = Drawing.new("Square")
    table.insert(drawings, Box)  -- Track the box for cleanup
    Box.Visible = false
    Box.Color = COLOR
    Box.Thickness = LINE_THICKNESS
    Box.Filled = false

    local NameTag = Drawing.new("Text")
    table.insert(drawings, NameTag)  -- Track the NameTag for cleanup
    NameTag.Visible = false
    NameTag.Color = COLOR
    NameTag.Size = 16
    NameTag.Center = true
    NameTag.Outline = true

    local function Update()
        while character and character.Parent do
            if ESP_ENABLED then
                local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if HumanoidRootPart then
                    local Vector, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPart.Position)
                    if OnScreen then
                        Box.Size = Vector2.new(50, 100)
                        Box.Position = Vector2.new(Vector.X - 25, Vector.Y - 50)
                        Box.Visible = true

                        if NAMETAGS_ENABLED then
                            local distance = math.floor((HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude)
                            NameTag.Text = string.format("%s (@%s)\n[%d studs]", player.DisplayName, player.Name, distance)
                            NameTag.Position = Vector2.new(Vector.X, Vector.Y - 65)
                            NameTag.Visible = true
                        else
                            NameTag.Visible = false
                        end
                    else
                        Box.Visible = false
                        NameTag.Visible = false
                    end
                else
                    Box.Visible = false
                    NameTag.Visible = false
                end
            else
                Box.Visible = false
                NameTag.Visible = false
            end
            task.wait(REFRESH_RATE)
        end
        Box:Remove()
        NameTag:Remove()
    end

    coroutine.wrap(Update)()
end

-- Player added event to add ESP to new players
local function OnPlayerAdded(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            if ESP_ENABLED then
                CreateESPBox(character, player)
            end
        end)
        if player.Character then
            if ESP_ENABLED then
                CreateESPBox(player.Character, player)
            end
        end
    end
end

for _, player in pairs(Players:GetPlayers()) do
    OnPlayerAdded(player)
end

Players.PlayerAdded:Connect(OnPlayerAdded)

print("ESP with NameTags Script Loaded!")
