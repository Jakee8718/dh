-- Place this near the top of fly.lua
if _G.FlyConnection then
	_G.FlyConnection:Disconnect()
	_G.FlyConnection = nil
end
if _G.Flying then
	_G.Flying = false
end
if _G.ToggleFlyKey then
	_G.ToggleFlyKey:Disconnect()
	_G.ToggleFlyKey = nil
end
if _G.DisableFly then
	_G.DisableFly()
end

-- Add this somewhere in the main fly script:
_G.Flying = false
_G.DisableFly = function()
	_G.Flying = false
	if _G.ToggleFlyKey then
		_G.ToggleFlyKey:Disconnect()
		_G.ToggleFlyKey = nil
	end
end

-- Then your normal toggle fly logic:
local UIS = game:GetService("UserInputService")

_G.ToggleFlyKey = UIS.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.F then
		_G.Flying = not _G.Flying
		-- Start/stop fly logic
	end
end)
