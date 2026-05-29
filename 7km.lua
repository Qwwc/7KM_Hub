-- استدعاء مكتبة الواجهات الفخمة (Orion Library)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- إنشاء النافذة الرئيسية للسكربت بحقوقك
local Window = OrionLib:MakeWindow({
    Name = "7KM Hub | Premium Utility", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "7KM_Config"
})

-- خدمات روبلوكس الأساسية المستخدمة
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- متغيرات التحكم بالميزات
local FlySpeed = 50
local Flying = false
local Noclip = false
local InfiniteJump = false

------------------------------------------------------------------------
-- [1] قائمة اللاعب (Player Tab)
------------------------------------------------------------------------
local PlayerTab = Window:MakeTab({
    Name = "اللاعب",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- التحكم في السرعة عبر شريط منزلق (Slider) لتحديد القيمة بدقة
PlayerTab:AddSlider({
    Name = "تعديل السرعة (WalkSpeed)",
    Min = 16,
    Max = 500,
    Default = 16,
    Color = Color3.fromRGB(0, 120, 255),
    Increment = 1,
    ValueName = "سرعة",
    Callback = function(Value)
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end    
})

-- التحكم في قوة القفز عبر شريط منزلق (Slider)
PlayerTab:AddSlider({
    Name = "تعديل القفز (JumpPower)",
    Min = 50,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(255, 120, 0),
    Increment = 1,
    ValueName = "قوة",
    Callback = function(Value)
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = Value
        end
    end    
})

------------------------------------------------------------------------
-- [2] قائمة الميزات المتقدمة (Movement Tab)
------------------------------------------------------------------------
local MovementTab = Window:MakeTab({
    Name = "الحركة والطيران",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- زر تفعيل/تعطيل الطيران
MovementTab:AddToggle({
    Name = "تفعيل الطيران",
    Default = false,
    Callback = function(Value)
        Flying = Value
        if Flying then
            -- منطق الطيران البسيط والتوجيه بالكاميرا
            task.spawn(function()
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local root = character:FindFirstChild("HumanoidRootPart")
                if not root then return end
                
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.Parent = root
                
                while Flying and character and root and bv.Parent do
                    local cam = workspace.CurrentCamera
                    local moveDir = Vector3.new(0,0,0)
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
                    
                    bv.Velocity = moveDir.Unit * FlySpeed
                    if moveDir == Vector3.new(0,0,0) then bv.Velocity = Vector3.new(0,0,0) end
                    task.wait()
                end
                bv:Destroy()
            end)
        end
    end
})

-- تحديد سرعة الطيران بدقة
MovementTab:AddSlider({
    Name = "سرعة الطيران",
    Min = 10,
    Max = 300,
    Default = 50,
    Color = Color3.fromRGB(0, 255, 120),
    Increment = 1,
    ValueName = "سرعة",
    Callback = function(Value)
        FlySpeed = Value
    end    
})

-- زر تفعيل اختراق الجدران (Noclip)
MovementTab:AddToggle({
    Name = "اختراق الجدران (Noclip)",
    Default = false,
    Callback = function(Value)
        Noclip = Value
    end
})

-- تشغيل ميزة اختراق الجدران عبر إلغاء الاصطدام بصفة دورية
RunService.Stepped:Connect(function()
    if Noclip then
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- زر تفعيل القفز اللانهائي
MovementTab:AddToggle({
    Name = "قفز لانهائي (Infinite Jump)",
    Default = false,
    Callback = function(Value)
        InfiniteJump = Value
    end
})

-- التقاط الضغط على زر القفز في الهواء وتوليد قوة دفع إضافية
UserInputService.JumpRequest:Connect(function()
    if InfiniteJump then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

------------------------------------------------------------------------
-- [3] قائمة الحقوق والمعلومات (Credits Tab)
------------------------------------------------------------------------
local CreditsTab = Window:MakeTab({
    Name = "الحقوق",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

CreditsTab:AddLabel("تم تطوير هذا السكربت بواسطة: 7KM")
CreditsTab:AddLabel("جميع الحقوق محفوظة © 2026")

-- تشغيل الواجهة وتأكيد التحميل
OrionLib:Init()
