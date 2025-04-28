-- teleports.lua

local Teleports = {}

-- 1) Locations
Teleports.locations = {
    Revolver = CFrame.new(-648.365356, 22.4022942, -119.864662),
    Bank     = CFrame.new(100,       22,         -50),
    TacoShop = CFrame.new(300,       20,         -100),
    -- etc…
}

-- 2) Icons
Teleports.icons = {
    Revolver = "rbxassetid://96808607551383",
    Bank     = "rbxassetid://12345678901234",  -- replace with your Bank icon ID
    TacoShop = "rbxassetid://23456789012345",  -- replace with your Taco Shop icon ID
    -- etc…
}

-- 3) Safe teleport function
function Teleports.teleport(name)
    local cf = Teleports.locations[name]
    if not cf then return end

    local plr = game.Players.LocalPlayer
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    hrp.Anchored = true
    hrp.CFrame   = cf
    task.wait(0.1)
    hrp.Anchored = false
end

return Teleports
