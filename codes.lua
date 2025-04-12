local function getNilInstance(name, className)
    for _, instance in pairs(getnilinstances()) do
        if instance.ClassName == className and instance.Name == name then
            return instance
        end
    end
    return nil
end
local function redeemPromoCode(code)
    local args = {
        [1] = "EnterPromoCode",
        [2] = code
    }
    
    game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
end
redeemPromoCode("50MDHC", "Duck", "Watch", "SHRIMP", "VIP", "2025", "THANKSGIVING24", "DACARNIVAL",
        "HALLOWEEN2024", "TRADEME!", "DAUP", "pumpkins2023")
