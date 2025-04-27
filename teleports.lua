-- teleports.lua

local Teleports = {}

-- 1) List all your spots here (just add more entries as you go)
Teleports.locations = {
    Revolver    = CFrame.new(-648.365356, 22.4022942, -119.864662),
    Bank        = CFrame.new(100,       22,         -50),
    TacoShop    = CFrame.new(300,       20,         -100),
    -- etc…
}

-- 2) Encapsulated “safe teleport” function
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
