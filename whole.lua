local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cleanup existing UI
if playerGui:FindFirstChild("ScriptHubUI") then
	playerGui.ScriptHubUI:Destroy()
end

-- Script Configuration
local scripts = {
	{ Name = "Aimbot", URL = "https://raw.githubusercontent.com/Jakee8718/dh/refs/heads/main/aim.lua", Active = false },
	{ Name = "ESP", URL = "https://raw.githubusercontent.com/Jakee8718/dh/refs/heads/main/esp.lua", Active = false },
	{ Name = "Teleport", URL = "https://raw.githubusercontent.com/Jakee8718/dh/refs/heads/main/tp.lua", Active = false },
	{ Name = "Fly", URL = "https://raw.githubusercontent.com/Jakee8718/dh/refs/heads/main/fly.lua", Active = false},
	{ Name = "Codes", URL = "https://raw.githubusercontent.com/Jakee8718/dh/refs/heads/main/codes.lua", Active = false},
}

-- Theme Configuration
local themes = {
	Dark = {
		Background = Color3.fromRGB(20, 20, 20),
		Surface = Color3.fromRGB(30, 30, 30),
		Text = Color3.fromRGB(235, 0, 4),
		Primary = Color3.fromRGB(235, 0, 4),
		Accent = Color3.fromRGB(237, 0, 4)
	},
	Light = {
		Background = Color3.fromRGB(240, 240, 240),
		Surface = Color3.fromRGB(220, 220, 220),
		Text = Color3.fromRGB(30, 30, 30),
		Primary = Color3.fromRGB(94, 13, 225),
		Accent = Color3.fromRGB(114, 38, 227)
	},
	Ocean = {
		Background = Color3.fromRGB(10, 20, 30),
		Surface = Color3.fromRGB(20, 40, 60),
		Text = Color3.fromRGB(220, 240, 255),
		Primary = Color3.fromRGB(0, 150, 200),
		Accent = Color3.fromRGB(0, 170, 220)
	}
}

local currentTheme = themes.Dark

-- Create Main UI
local gui = Instance.new("ScreenGui")
gui.Name = "ScriptHubUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

-- Main Container
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 300, 0, 300)
main.Position = UDim2.new(0.5, -150, 0.5, -150)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = currentTheme.Background
main.ClipsDescendants = true
main.Parent = gui

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 8)

-- Proper draggable logic
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Header
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = currentTheme.Surface
header.BorderSizePixel = 0

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -40, 1, 0)
title.Font = Enum.Font.Gotham
title.Text = "RS"
title.TextColor3 = currentTheme.Primary
title.TextSize = 16
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0, 12, 0, 0)

local close = Instance.new("TextButton", header)
close.Size = UDim2.new(0, 32, 0, 32)
close.Position = UDim2.new(1, -32, 0, 4)
close.Text = "×"
close.TextColor3 = currentTheme.Text
close.TextSize = 20
close.Font = Enum.Font.GothamBold
close.BackgroundTransparency = 1

-- Tabs Container
local tabs = Instance.new("Frame", main)
tabs.Size = UDim2.new(1, 0, 0, 30)
tabs.Position = UDim2.new(0, 7.75, 0, 45) -- After header
tabs.BackgroundTransparency = 1

local tabList = Instance.new("UIListLayout", tabs)
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.HorizontalAlignment = Enum.HorizontalAlignment.Left
tabList.Padding = UDim.new(0, 6)

local scriptTab = Instance.new("TextButton", tabs)
scriptTab.Size = UDim2.new(0, 140, 1, -4)
scriptTab.Text = "Main"
scriptTab.Font = Enum.Font.GothamBold
scriptTab.TextSize = 14
scriptTab.TextColor3 = currentTheme.Text
scriptTab.BackgroundColor3 = currentTheme.Surface
Instance.new("UICorner", scriptTab).CornerRadius = UDim.new(0, 6)

local emptyTab = Instance.new("TextButton", tabs)
emptyTab.Size = UDim2.new(0, 140, 1, -4)
emptyTab.Text = "Target"
emptyTab.Font = Enum.Font.GothamBold
emptyTab.TextSize = 14
emptyTab.TextColor3 = currentTheme.Text
emptyTab.BackgroundColor3 = currentTheme.Surface
Instance.new("UICorner", emptyTab).CornerRadius = UDim.new(0, 6)

-- TELEPORT GUI
local TELEPORT_URL = "https://raw.githubusercontent.com/Jakee8718/dh/main/teleports.lua"
local Teleports = loadstring(game:HttpGet(TELEPORT_URL))()

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -16, 1, -120)
scroll.Position = UDim2.new(0, 8, 0, 78)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.CanvasSize = UDim2.new(0, 0, 0, (#scripts + 1) * 42)
local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0, 6)

local scrollTarget = Instance.new("ScrollingFrame", main)
scrollTarget.Name = "ScrollTarget"
scrollTarget.Size = scroll.Size
scrollTarget.Position = scroll.Position
scrollTarget.BackgroundTransparency = 1
scrollTarget.ScrollBarThickness = 4
scrollTarget.Visible = false
local listTarget = Instance.new("UIListLayout", scrollTarget)
listTarget.Padding = UDim.new(0, 6)
listTarget.SortOrder = Enum.SortOrder.LayoutOrder

-- Header label
local headerLabel = Instance.new("TextLabel", scrollTarget)
headerLabel.LayoutOrder            = 1
headerLabel.Size                   = UDim2.new(1, 0, 0, 24)
headerLabel.Font                   = Enum.Font.GothamBold
headerLabel.TextSize               = 16
headerLabel.TextColor3             = currentTheme.Primary
headerLabel.BackgroundTransparency = 1
headerLabel.Text                   = "Teleport to Areas"
headerLabel.TextXAlignment         = Enum.TextXAlignment.Left

-- Buttons for each teleport spot
local order = 2
for name, _ in pairs(Teleports.locations) do
    local btn = Instance.new("TextButton", scrollTarget)
    btn.LayoutOrder      = order
    btn.Size             = UDim2.new(1, 0, 0, 36)
    btn.Font             = Enum.Font.Gotham
    btn.TextSize         = 14
    btn.TextColor3       = currentTheme.Text
    btn.BackgroundColor3 = currentTheme.Surface
    btn.AutoButtonColor  = false
    btn.Text             = name
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        Teleports.teleport(name)
    end)

    order = order + 1
end

-- Resize the scroll frame to fit all buttons
scrollTarget.CanvasSize = UDim2.new(0, 0, 0, (order - 1) * 42)


-- 7) Tab‐switcher hookup (if not already present)
local function switchTab(tabName)
    scroll.Visible = (tabName == "Main")
    scrollTarget.Visible = (tabName ~= "Main")
end
scriptTab.MouseButton1Click:Connect(function() switchTab("Main") end)
emptyTab.MouseButton1Click:Connect(function() switchTab("Target") end)
switchTab("Main")

-- Fly Button
local flyButton = Instance.new("TextButton", scroll)
flyButton.Size = UDim2.new(1, 0, 0, 36)
flyButton.Font = Enum.Font.Gotham
flyButton.TextSize = 14
flyButton.TextColor3 = currentTheme.Text
flyButton.BackgroundColor3 = currentTheme.Surface
flyButton.AutoButtonColor = false
flyButton.Text = "Fly: Off"
Instance.new("UICorner", flyButton).CornerRadius = UDim.new(0, 6)

local flyActive = false
flyButton.MouseButton1Click:Connect(function()
	flyActive = not flyActive
	flyButton.Text = "Fly" .. (flyActive and ": On" or ": Off")

	if flyActive then
		pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Jakee8718/dh/refs/heads/main/fly.lua"))()
		end)
		shared.flyEnabled = true
	else
		shared.flyEnabled = false
	end
end)


-- Aimbot Button
local aimbotButton = Instance.new("TextButton", scroll)
aimbotButton.Size = UDim2.new(1, 0, 0, 36)
aimbotButton.Font = Enum.Font.Gotham
aimbotButton.TextSize = 14
aimbotButton.TextColor3 = currentTheme.Text
aimbotButton.BackgroundColor3 = currentTheme.Surface
aimbotButton.AutoButtonColor = false
aimbotButton.Text = "Aimbot: Off"
Instance.new("UICorner", aimbotButton).CornerRadius = UDim.new(0, 6)

local aimbotActive = false
aimbotButton.MouseButton1Click:Connect(function()
    aimbotActive = not aimbotActive
    aimbotButton.Text = "Aimbot" .. (aimbotActive and ": On" or ": Off")
    
    if aimbotActive then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Jakee8718/dh/refs/heads/main/aim.lua"))()
    else
        pcall(function()
            -- off
            if _G.aimbot then
                _G.aimbot:Disconnect()
                _G.aimbot = nil
            end
        end)
    end
end)

-- ESP Button
local espButton = Instance.new("TextButton", scroll)
espButton.Size = UDim2.new(1, 0, 0, 36)
espButton.Font = Enum.Font.Gotham
espButton.TextSize = 14
espButton.TextColor3 = currentTheme.Text
espButton.BackgroundColor3 = currentTheme.Surface
espButton.AutoButtonColor = false
espButton.Text = "ESP: Off"
Instance.new("UICorner", espButton).CornerRadius = UDim.new(0, 6)
local espActive = false
local espScript
pcall(function()
    espScript = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jakee8718/dh/refs/heads/main/esp.lua"))()
end)

espButton.MouseButton1Click:Connect(function()
    espActive = not espActive
    espButton.Text = "ESP" .. (espActive and ": On" or ": Off")

    if espActive then
        -- on
        if espScript then
            espScript.EnableESP()
        end
    else
        -- off
        if espScript then
            espScript.DisableESP()
        end
    end
end)

-- Teleport Button
local teleportButton = Instance.new("TextButton", scroll)
teleportButton.Size = UDim2.new(1, 0, 0, 36)
teleportButton.Font = Enum.Font.Gotham
teleportButton.TextSize = 14
teleportButton.TextColor3 = currentTheme.Text
teleportButton.BackgroundColor3 = currentTheme.Surface
teleportButton.AutoButtonColor = false
teleportButton.Text = "Teleport: Off"
Instance.new("UICorner", teleportButton).CornerRadius = UDim.new(0, 6)

local teleportActive = false
teleportButton.MouseButton1Click:Connect(function()
	teleportActive = not teleportActive
	teleportButton.Text = "Teleport" .. (teleportActive and ": On" or ": Off")

	local player = game:GetService("Players").LocalPlayer

	if teleportActive then
		-- turn on function
		pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Jakee8718/dh/refs/heads/main/tp.lua"))()
		end)
	else
		-- turn off function
		local teleportGui = player.PlayerGui:FindFirstChild("TeleportGui")
		if teleportGui then
			teleportGui:Destroy()
		end
	end
end)


-- Codes Button
local codesButton = Instance.new("TextButton", scroll)
codesButton.Size = UDim2.new(1, 0, 0, 36)
codesButton.Font = Enum.Font.Gotham
codesButton.TextSize = 14
codesButton.TextColor3 = currentTheme.Text
codesButton.BackgroundColor3 = currentTheme.Surface
codesButton.AutoButtonColor = false
codesButton.Text = "Codes: Off"
Instance.new("UICorner", codesButton).CornerRadius = UDim.new(0, 6)

local codesActive = false
codesButton.MouseButton1Click:Connect(function()
	codesActive = not codesActive
	codesButton.Text = "Codes" .. (codesActive and ": On" or ": Off")
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Jakee8718/dh/refs/heads/main/codes.lua"))()
	end)
end)

-- AntiMod Button
local antimodButton = Instance.new("TextButton", scroll)
antimodButton.Size = UDim2.new(1, 0, 0, 36)
antimodButton.Font = Enum.Font.Gotham
antimodButton.TextSize = 14
antimodButton.TextColor3 = currentTheme.Text
antimodButton.BackgroundColor3 = currentTheme.Surface
antimodButton.AutoButtonColor = false
antimodButton.Text = "AntiMod: On"
Instance.new("UICorner", antimodButton).CornerRadius = UDim.new(0, 6)

local antimodActive = true  -- Start on
local modUsernames = {
    "Benoxa",
    "FruitySama",
    "MalibuMaverick93",
    "jellieefishh",
    "thecracktroll999",
    "Felku",
    "EstheKing",
    "unroot",
    "AngelicTheWise",
    "Luutyy",
    "dtbbullet",
    "Nex5us",
    "boomalope",
    "Papa_Mbaye",
    "AStrongMuscle",
    "512f6",
    "Ghostlic",
    "JokeTheFool",
    "iumu",
    "ReallyCyan",
    "drizzyaudemars",
    "RealYurl", 
}

local function kickSelf()
    local player = game.Players.LocalPlayer
    if player then
        player:Kick("A mod has entered the game, kicking you.")
    end
end

local function checkForMods(player)
    if antimodActive and player and table.find(modUsernames, player.Name) then
        
        kickSelf()
    end
end

if antimodActive then
    local Players = game:GetService("Players")
    Players.PlayerAdded:Connect(checkForMods)
end
-- Button click handler to toggle AntiMod
antimodButton.MouseButton1Click:Connect(function()
    antimodActive = not antimodActive
    antimodButton.Text = "AntiMod" .. (antimodActive and ": On" or ": Off")

    local Players = game:GetService("Players")

    if antimodActive then
        
        Players.PlayerAdded:Connect(checkForMods)
    else
        
        
    end
end)

-- Theme Button
local themeButton = Instance.new("TextButton", main)
themeButton.Size = UDim2.new(1, -16, 0, 32)
themeButton.Position = UDim2.new(0, 8, 1, -40)
themeButton.Font = Enum.Font.Gotham
themeButton.TextSize = 14
themeButton.Text = "Theme: Dark"
themeButton.TextColor3 = currentTheme.Text
themeButton.BackgroundColor3 = currentTheme.Surface
themeButton.AutoButtonColor = false

local themeCorner = Instance.new("UICorner", themeButton)
themeCorner.CornerRadius = UDim.new(0, 6)

local themeIndex = 1
local themeNames = {"Dark", "Light", "Ocean"}

themeButton.MouseButton1Click:Connect(function()
	themeIndex = (themeIndex % #themeNames) + 1
	currentTheme = themes[themeNames[themeIndex]]
	themeButton.Text = "Theme: " .. themeNames[themeIndex]

	main.BackgroundColor3 = currentTheme.Background
	header.BackgroundColor3 = currentTheme.Surface
	title.TextColor3 = currentTheme.Primary
	close.TextColor3 = currentTheme.Text
	themeButton.TextColor3 = currentTheme.Text
	themeButton.BackgroundColor3 = currentTheme.Surface

	for _, child in ipairs(scroll:GetChildren()) do
		if child:IsA("TextButton") then
			child.BackgroundColor3 = currentTheme.Surface
			child.TextColor3 = currentTheme.Text
		end
	end
end)

-- Close Button
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Toggle visibility with RightShift
local isVisible = true
UserInputService.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.RightShift then
		isVisible = not isVisible
		gui.Enabled = isVisible
	end
end)

-- Re-enable GUI on respawn
player.CharacterAdded:Connect(function()
	gui.Enabled = true
end)
