-- teleports.lua

local Teleports = {}

-- 1) Locations
Teleports.locations = {
    Revolver = CFrame.new(-636.762, 21.748, -125,627),
    Bank     = CFrame.new(-405.471, 21.748, -284,517),
    Military = CFrame.new(38.660, 25.253, -869.897),
    LMG = CFrame.new(-625.019, 23.244, -298.706),
    Downhill Food = CFrame.new(-331,280, 23.681, -298.417),
    
    -- etc…
}

-- 2) Icons
Teleports.icons = {
    Revolver = "rbxassetid://96808607551383",
    Bank     = "rbxassetid://97059750033187",  -- replace with your Bank icon ID
    Military = "rbxassetid://16481049067",
    LMG = "rbxassetid://111111",
    Downhill Food = "rbxassetid://123444",
    
    
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
