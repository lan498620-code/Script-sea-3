-- [[ VƯƠNG THÁI BẢO HUB - AUTO FARM BONE SEA 3 ]] --

if game.PlaceId ~= 7449423635 then
    return
end

-- Tải thư viện Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "VƯƠNG THÁI BẢO HUB",
   LoadingTitle = "Đang tải Script Auto Bone...",
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

-- Tọa độ Lâu Đài Ma (Haunted Castle)
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

-- Hàm di chuyển an toàn
local function SafeTween(targetCFrame)
    local Player = game.Players.LocalPlayer
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local Distance = (targetCFrame.Position - Player.Character.HumanoidRootPart.Position).Magnitude
    local Speed = 250
    local TweenInfo = TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear)
    
    local Tween = game:GetService("TweenService"):Create(Player.Character.HumanoidRootPart, TweenInfo, {CFrame = targetCFrame})
    Tween:Play()
end

-- Hàm tìm quái xương gần nhất
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

-- Tạo Tab & Toggle trên GUI
local MainTab = Window:CreateTab("Tự Động Farm", 4483345998)
local Section = MainTab:CreateSection("Cấu Hình Farm Xương (Sea 3)")

local Toggle = MainTab:CreateToggle({
   Name = "Bật/Tắt Auto Farm Bone",
   CurrentValue = false,
   Flag = "AutoBoneFlag",
   Callback = function(Value)
       Settings.AutoBone = Value
   end,
})

-- Vòng lặp chính xử lý logic Farm
task.spawn(function()
    while task.wait(0.1) do
        if Settings.AutoBone then
            pcall(function()
                EquipWeapon()
                local Target = GetNearestBoneMob()
                local Player = game.Players.LocalPlayer
                
                if Target and Target:FindFirstChild("HumanoidRootPart") then
                    -- Bay lên đỉnh đầu quái 4 studs để né đòn
                    local TargetCFrame = Target.HumanoidRootPart.CFrame * CFrame.new(0, 4, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    SafeTween(TargetCFrame)
                    
                    -- Đánh tự động khi áp sát quái
                    if (Target.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude <= 20 then
                        local VirtualUser = game:GetService("VirtualUser")
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new(0,0))
                    end
                else
                    -- Không thấy quái thì bay về đảo Haunted Castle
                    SafeTween(HauntedCastleCFrame)
                end
            end)
        end
    end
end)
