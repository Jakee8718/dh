-- Variables for ESP
local ESP_ENABLED = false -- Default ESP off
local NAMETAGS_ENABLED = false -- Toggle NameTags on/off with key
local COLOR = Color3.fromRGB(255, 0, 0) -- Box color
local LINE_THICKNESS = 2
local REFRESH_RATE = 0.01
local UserInputService = game:GetService("UserInputService")

local Players = game:GetService("Players")
local Camera = game.Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local drawings = {}  -- Store drawings for cleanup
local running = false -- Track whether ESP is running

-- Toggle NameTags on key press "N"
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.N then
        NAMETAGS_ENABLED = not NAMETAGS_ENABLED
    end
end)

-- Function to enable ESP
function EnableESP()
    ESP_ENABLED = true
    running = true

    -- Set up ESP for all players already in the game
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            CreateESPBox(player.Character, player)
        end
        player.CharacterAdded:Connect(function(character)
            CreateESPBox(character, player)
        end)
    end
end


-- Function to disable ESP
function DisableESP()
    ESP_ENABLED = false
    running = false
    -- Hide all ESP elements
    for _, drawing in pairs(drawings) do
        drawing.Visible = false
    end
end

-- Create ESP Box and NameTag
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
        -- Cleanup after loop stops
        Box:Remove()
        NameTag:Remove()
    end

    coroutine.wrap(Update)()
end

-- Manage players entering the game
local function OnPlayerAdded(player)
    if player == LocalPlayer then return end

    local function SetupCharacter(character)
        -- Small delay to wait for HumanoidRootPart
        repeat
            task.wait(0.1)
        until character:FindFirstChild("HumanoidRootPart") or not character.Parent

        if character.Parent then
            CreateESPBox(character, player)
        end
    end

    -- Connect the CharacterAdded event for respawning
    player.CharacterAdded:Connect(SetupCharacter)

    -- If the player already has a character when they join, set up the ESP
    if player.Character then
        SetupCharacter(player.Character)
    end
end

-- Initialize for all players currently in the game
for _, player in pairs(Players:GetPlayers()) do
    OnPlayerAdded(player)
end

Players.PlayerAdded:Connect(OnPlayerAdded)

print("ESP with NameTags Script Loaded!")

-- Return the control functions
return {
    EnableESP = EnableESP,
    DisableESP = DisableESP
}
