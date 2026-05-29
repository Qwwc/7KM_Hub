-- استدعاء مكتبة واجهات Orion UI الحديثة ذات الأنميشن السريع والسلس
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- إنشاء النافذة الرئيسية بتصميم متناسق وسريع الاستجابة
local Window = Library:MakeWindow({
    Name = "7KM Hub | Orion Premium v6.0", 
    HidePremium = true, 
    SaveConfig = false, 
    ConfigFolder = "7KM_Orion"
})

-- الخدمات الأساسية ل روبلوكس
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- متغيرات التحكم بالميزات
local WalkSpeedValue = 16
local JumpPowerValue = 50
local FlySpeed = 50
local Flying = false
local Noclip = false
local InfJump = false
local BypassSpeed = false -- تفعيل تخطي حماية الحركة

------------------------------------------------------------------------
-- [1] تبويب تحركات اللاعب واختراق الحمايات
------------------------------------------------------------------------
local Tab1 = Window:MakeTab({
    Name = "اللاعب والحماية",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Tab1:AddToggle({
    Name = "تفعيل تخطي حماية السرعة (CFrame Speed)",
    Default = false,
    Callback = function(Value)
        BypassSpeed = Value
    end
})

Tab1:AddSlider({
    Name = "تعديل السرعة (WalkSpeed)",
    Min = 16,
    Max = 300,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "سرعة",
    Callback = function(Value)
        WalkSpeedValue = Value
        if not BypassSpeed then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
            end
        end
    end    
})

Tab1:AddSlider({
    Name = "تعديل القفز (JumpPower)",
    Min = 50,
    Max = 300,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "قوة",
    Callback = function(Value)
        JumpPowerValue = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            hum.UseJumpPower = true
            hum.JumpPower = Value
        end
    end    
})

------------------------------------------------------------------------
-- [2] تبويب الطيران واختراق الجدران (الالتفاف الكامل مع الكاميرا)
------------------------------------------------------------------------
local Tab2 = Window:MakeTab({
    Name = "الطيران والجدران",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Tab2:AddToggle({
    Name = "تفعيل الطيران الذكي",
    Default = false,
    Callback = function(Value)
        Flying = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            hum.PlatformStand = Value
            if not Value then
                if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                end
            end
        end
    end
})

Tab2:AddSlider({
    Name = "سرعة الطيران",
    Min = 20,
    Max = 300,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "سرعة تحليق",
    Callback = function(Value)
        FlySpeed = Value
    end    
})

Tab2:AddToggle({
    Name = "اختراق الجدران (Noclip)",
    Default = false,
    Callback = function(Value)
        Noclip = Value
    end
})

Tab2:AddToggle({
    Name = "قفز لانهائي (Inf Jump)",
    Default = false,
    Callback = function(Value)
        InfJump = Value
    end
})

------------------------------------------------------------------------
-- [3] تبويب الحقوق والمطور
------------------------------------------------------------------------
local Tab3 = Window:MakeTab({
    Name = "الحقوق",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Tab3:AddLabel("تم التطوير والتعديل بواسطة: 7KM")
Tab3:AddLabel("واجهة Orion الحديثة والمنشطة v6.0")
Tab3:AddLabel("جميع الحقوق محفوظة © 2026")

------------------------------------------------------------------------
-- [4] المحركات الخلفية المستقرة والسريعة
------------------------------------------------------------------------

-- محرك الحركة: يجمع بين تخطي حماية السرعة ودوران الطيران مع الماوس والكاميرا
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local root = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        
        -- تخطي حماية الماب عبر نقل الـ CFrame الحركي مباشرة دون تغيير الـ WalkSpeed
        if BypassSpeed and WalkSpeedValue > 16 and not Flying then
            local moveDirection = hum.MoveDirection
            if moveDirection.Magnitude > 0 then
                root.CFrame = root.CFrame + (moveDirection * (WalkSpeedValue / 120))
            end
        end
        
        -- محرك الطيران الذي يتبع الكاميرا والماوس بدقة
        if Flying then
            local dir = Vector3.new(0, 0, 0)
            
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
            
            -- التفاف الشخصية الفوري مع اتجاه الكاميرا
            root.CFrame = CFrame.new(root.Position, root.Position + Camera.CFrame.LookVector)
            
            if dir.Magnitude > 0 then
                root.Velocity = dir.Unit * FlySpeed
            else
                root.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

-- محرك اختراق الجدران (Noclip)
RunService.Stepped:Connect(function()
    if Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- محرك القفز اللانهائي
UIS.JumpRequest:Connect(function()
    if InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- تهيئة المكتبة وتشغيل الواجهة بنجاح
Library:Init()
