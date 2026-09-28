
-- [[ VƯƠNG THÁI BẢO HUB - AUTO FARM BONE SEA 3 (ANTI-BAN PROTECTED) ]] --

if game.PlaceId ~= 7449423635 then
    return
end

-- =============================================
-- [ 1. HỆ THỐNG ANTI-BAN & ANTI-KICK ADVANCED ]
-- =============================================
pcall(function()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        -- Chặn các hàm Kick tài khoản từ Server
        if method == "Kick" or method == "kick" then
            return nil
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end)

-- Vô hiệu hóa các script Anti-Cheat địa phương của game
pcall(function()
    for _, v in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
        if v:IsA("LocalScript") and (v.Name:find("Anti") or v.Name:find("Cheat") or v.Name:find("Detect")) then
            v.Disabled = true
        end
    end
end)

-- =============================================
-- [ 2. GIAO DIỆN & LOGIC FARM ]
-- =============================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "VƯƠNG THÁI BẢO HUB [SAFE]",
   LoadingTitle = "Đang tải Script Anti-Ban...",
   LoadingSubtitle = "by Vương Thái Bảo",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local Settings = {
    AutoBone = false
}

local BoneMobs = {
    "Reborn Skeleton",
    "Living Zombie",
    "Demonic Soul",
    "Posessed Mummy"
}

local HauntedCastleCFrame = CFrame.new(-9515, 142, 5537)

-- Hàm tự cầm vũ khí
local function EquipWeapon()
    local Player = game.Players.LocalPlayer
    if Player.Character and not Player.Character:FindFirstChildOfClass("Tool") then
        local Backpack = Player:FindFirstChild("Backpack")
        if Backpack then
            local Tool = Backpack:FindFirstChildOfClass("Tool")
            if Tool then
                Player.Character.Humanoid:EquipTool(Tool)
            end
        end
    end
end

-- Hàm dịch chuyển tốc độ an toàn (Tối đa 220 để né Anti-Cheat)
local function SafeTween(targetCFrame)
    local Player = game.Players.LocalPlayer
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local Distance = (targetCFrame.Position - Player.Character.HumanoidRootPart.Position).Magnitude
    local Speed = 220 -- Tốc độ di chuyển an toàn chuẩn
    local TweenInfo = TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear)
    
    local Tween = game:GetService("TweenService"):Create(Player.Character.HumanoidRootPart, TweenInfo, {CFrame = targetCFrame})
    Tween:Play()
end

-- Tìm quái gần nhất
local function GetNearestBoneMob()
    local NearestMob = nil
    local MinDistance = math.huge
    local Player = game.Players.LocalPlayer
    
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return nil end
    
    for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
        if table.find(BoneMobs, mob.Name) and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
            local dist = (mob.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
            if dist < MinDistance then
                MinDistance = dist
                NearestMob = mob
            end
        end
    end
    return NearestMob
end

-- Giao diện UI
local MainTab = Window:CreateTab("Tự Động Farm", 4483345998)
local Section = MainTab:CreateSection("Cấu Hình An Toàn (Anti-Ban)")

MainTab:CreateToggle({
   Name = "Bật/Tắt Auto Farm Bone (Safe)",
   CurrentValue = false,
   Flag = "AutoBoneFlag",
   Callback = function(Value)
       Settings.AutoBone = Value
   end,
})

-- Vòng lặp Farm chính
task.spawn(function()
    while task.wait(0.1) do
        if Settings.AutoBone then
            pcall(function()
                EquipWeapon()
                local Target = GetNearestBoneMob()
                local Player = game.Players.LocalPlayer
                
                if Target and Target:FindFirstChild("HumanoidRootPart") then
                    local TargetCFrame = Target.HumanoidRootPart.CFrame * CFrame.new(0, 4, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    SafeTween(TargetCFrame)
                    
                    if (Target.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude <= 20 then
                        local VirtualUser = game:GetService("VirtualUser")
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new(0,0))
                    end
                else
                    SafeTween(HauntedCastleCFrame)
                end
            end)
        end
    end
end)
