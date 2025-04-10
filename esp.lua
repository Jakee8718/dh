local ESP_ENABLED = true -- Toggle ESP on/off
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

local function CreateESPBox(character, player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = COLOR
    Box.Thickness = LINE_THICKNESS
    Box.Filled = false

    local NameTag = Drawing.new("Text")
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
                        -- ESP Box
                        Box.Size = Vector2.new(50, 100)
                        Box.Position = Vector2.new(Vector.X - 25, Vector.Y - 50)
                        Box.Visible = true

                        -- NameTag
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

local function OnPlayerAdded(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            CreateESPBox(character, player)
        end)
        if player.Character then
            CreateESPBox(player.Character, player)
        end
    end
end

for _, player in pairs(Players:GetPlayers()) do
    OnPlayerAdded(player)
end

Players.PlayerAdded:Connect(OnPlayerAdded)

print("ESP with NameTags Script Loaded!")
