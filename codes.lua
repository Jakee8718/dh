local function redeemPromoCode(code)
    local args = {
        [1] = "EnterPromoCode",
        [2] = code
    }

    print("Trying to redeem code:", code) -- Debug
	if redeemPromoCode == true
		then print("Successfully redeemed:", code)
	else print("Failed:", code)
    game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
end

local promoCodes = {
    "50MDHC",
    "Duck",
    "Watch",
    "SHRIMP",
    "VIP",
    "2025",
    "THANKSGIVING24",
    "DACARNIVAL",
    "HALLOWEEN2024",
    "TRADEME!",
    "DAUP",
    "pumpkins2023",
	"RUBY"
}

for _, code in ipairs(promoCodes) do
    redeemPromoCode(code)
    task.wait(5) 
end
