local ESP_ENABLED = false
local NAMETAGS_ENABLED = false
local COLOR = Color3.fromRGB(255, 0, 0)
local LINE_THICKNESS = 2
local REFRESH_RATE = 0.01

local Players = game:GetService("Players")
local Camera = game.Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local drawings = {}
local running = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.N then
        NAMETAGS_ENABLED = not NAMETAGS_ENABLED
    end
end)

function EnableESP()
    ESP_ENABLED = true
    running = true
end

function DisableESP()
    ESP_ENABLED = false
    running = false
    for _, drawing in pairs(drawings) do
        drawing.Visible = false
    end
end

local function CreateESPBox(character, player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = COLOR
    Box.Thickness = LINE_THICKNESS
    Box.Filled = false
    table.insert(drawings, Box)

    local NameTag = Drawing.new("Text")
    NameTag.Visible = false
    NameTag.Color = COLOR
    NameTag.Size = 16
    NameTag.Center = true
    NameTag.Outline = true
    table.insert(drawings, NameTag)

    local function Update()
        while running do
            if ESP_ENABLED and character and character.Parent then
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

return {
    EnableESP = EnableESP,
    DisableESP = DisableESP
}
