-- استدعاء مكتبة Kavo المستقرة والمتوافقة مع محركك
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- إنشاء اللوحة بثيم فخم (BloodTheme) وبحقوقك 7KM
local Window = Library.CreateLib("7KM Hub | Premium Edition v5.2", "BloodTheme")

-- الخدمات الأساسية داخل روبلوكس
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

-- إنشاء التبويبات الفخمة (Tabs)
local Tab1 = Window:NewTab("اللاعب")
local Tab2 = Window:NewTab("الحركة والطيران")
local Tab3 = Window:NewTab("الحقوق")

local Section1 = Tab1:NewSection("تعديل خصائص الشخصية")
local Section2 = Tab2:NewSection("ضبط الطيران والسير في الهواء")
local Section3 = Tab3:NewSection("المطور")

------------------------------------------------------------------------
-- [1] تبويب اللاعب
------------------------------------------------------------------------

Section1:NewSlider("تعديل السرعة (WalkSpeed)", "تحكم سريع في سرعة المشي", 300, 16, function(v)
    WalkSpeedValue = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
    end
end)

Section1:NewSlider("تعديل القفز (JumpPower)", "تحكم سريع في قوة القفز", 300, 50, function(v)
    JumpPowerValue = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.UseJumpPower = true
        hum.JumpPower = v
    end
end)

------------------------------------------------------------------------
-- [2] تبويب الحركة والطيران (الالتفاف مع الكاميرا بسلاسة)
------------------------------------------------------------------------

Section2:NewToggle("تفعيل الطيران (Fly)", "طيران يلتف مع اتجاه الكاميرا والماوس", function(state)
    Flying = state
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.PlatformStand = state
        if not state then
            if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end
        end
    end
end)

Section2:NewSlider("سرعة الطيران", "تحكم في سرعة تحليقك", 300, 20, function(v)
    FlySpeed = v
end)

Section2:NewToggle("اختراق الجدران (Noclip)", "المرور من الجدران والأبواب بسلاسة", function(state)
    Noclip = state
end)

Section2:NewToggle("قفز لانهائي (Infinite Jump)", "القفز المتكرر في الهواء", function(state)
    InfJump = state
end)

------------------------------------------------------------------------
-- [3] المحركات الخلفية المستقرة (معالجة الحركة والدوران)
------------------------------------------------------------------------

-- محرك الطيران المطور والمصحح بالكامل
RunService.RenderStepped:Connect(function()
    if Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        local dir = Vector3.new(0, 0, 0)
        
        -- جلب اتجاهات الحركة بالاعتماد على مكان الكاميرا الحالي
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        
        -- إجبار الشخصية على الالتفاف الفوري والكامل مع الماوس ونظر الكاميرا
        root.CFrame = CFrame.new(root.Position, root.Position + Camera.CFrame.LookVector)
        
        if dir.Magnitude > 0 then
            root.Velocity = dir.Unit * FlySpeed
        else
            root.Velocity = Vector3.new(0, 0, 0)
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

------------------------------------------------------------------------
-- [4] تبويب الحقوق
------------------------------------------------------------------------
Section3:NewLabel("تم التطوير والتعديل بواسطة: 7KM")
Section3:NewLabel("نسخة مستقرة ومصححة بالكامل v5.2")
Section3:NewLabel("جميع الحقوق محفوظة © 2026")
