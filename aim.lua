local p = game:GetService("Players")
local lp = p.LocalPlayer
local ws = game:GetService("Workspace")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local cam = ws.CurrentCamera
local aim = false

local function getClosest()
    local closest, dist = nil, math.huge
    for _, v in ipairs(p:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("Head") then
            local head = v.Character.Head
            local pos, vis = cam:WorldToViewportPoint(head.Position)
            local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(uis:GetMouseLocation().X, uis:GetMouseLocation().Y)).Magnitude
            
            if vis and mag < dist then
                dist = mag
                closest = head
            end
        end
    end
    return closest
end

uis.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.Q then -- Use Q instead of MouseButton2
        aim = true
    end
end)

uis.InputEnded:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.Q then -- Stop aiming when Q is released
        aim = false
    end
end)

rs.RenderStepped:Connect(function()
    if aim then
        local t = getClosest()
        if t then
            cam.CFrame = CFrame.new(cam.CFrame.Position, t.Position)
        end
    end
end)
