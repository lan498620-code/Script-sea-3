-- [[ AUTO FARM BONE SEA 3 - SAFE VERSION ]] --
-- AUTHOR: VƯƠNG THÁI BẢO

-- 1. Kiểm tra môi trường (Chỉ chạy ở Sea 3)
if game.PlaceId ~= 7449423635 then
    warn("Script nay chi hoat dong tai Sea 3 (Haunted Castle)!")
    return
end

-- 2. Tải thư viện UI (Kavo UI Library)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("VƯƠNG THÁI BẢO HUB - AUTO BONE SEA 3", "DarkTheme")

-- Các biến toàn cục
local Settings = {
    AutoBone = false,
    FastAttack = true,
    BringMob = true
}

-- Danh sách quái rớt xương tại Haunted Castle (Sea 3)
local BoneMobs = {
    "Reborn Skeleton",
    "Living Zombie",
    "Demonic Soul",
    "Posessed Mummy"
}

-- Hàm kiểm tra quái gần nhất
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

-- Hàm dịch chuyển an toàn (Tween)
local function SafeTween(targetCFrame)
    local Player = game.Players.LocalPlayer
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local Distance = (targetCFrame.Position - Player.Character.HumanoidRootPart.Position).Magnitude
    local Speed = 250 -- Tốc độ an toàn chống văng
    local TweenInfo = TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear)
    
    local Tween = game:GetService("TweenService"):Create(Player.Character.HumanoidRootPart, TweenInfo, {CFrame = targetCFrame})
    Tween:Play()
end

-- 3. Tạo Tab & Giao Diện
local MainTab = Window:NewTab("Main Auto")
local BoneSection = MainTab:NewSection("VƯƠNG THÁI BẢO - Auto Farm Bone (Sea 3)")

BoneSection:NewToggle("Auto Farm Bone (Safe)", "Tu dong farm quai rot xuong o Sea 3", function(state)
    Settings.AutoBone = state
end)

BoneSection:NewToggle("Fast Attack", "Tang toc do danh (An toan)", function(state)
    Settings.FastAttack = state
end)

-- 4. Vòng lặp Farm Xương (Main Loop)
task.spawn(function()
    while task.wait(0.1) do
        if Settings.AutoBone then
            pcall(function()
                local Target = GetNearestBoneMob()
                local Player = game.Players.LocalPlayer
                
                if Target and Target:FindFirstChild("HumanoidRootPart") then
                    -- Đứng cao hơn đầu quái 4 studs để né chiêu
                    local TargetCFrame = Target.HumanoidRootPart.CFrame * CFrame.new(0, 4, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    
                    SafeTween(TargetCFrame)
                    
                    -- Tự động đánh khi ở gần quái
                    if (Target.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude <= 15 then
                        local VirtualUser = game:GetService("VirtualUser")
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new(0,0))
                    end
                end
            end)
        end
    end
end)
