-- استدعاء مكتبة Kavo المستقرة والمعروفة عندك
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- إنشاء اللوحة بالشكل القديم الفخم (BloodTheme) وبحقوقك 7KM
local Window = Library.CreateLib("7KM Hub | Premium Edition v5.5", "BloodTheme")

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

-- متغيرات محرك الطيران الجديد
local bV, bG

-- إنشاء التبويبات القديمة (Tabs)
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
-- [2] تبويب الحركة والطيران (تم تحديث الطيران ليلف مع الكاميرا 100%)
------------------------------------------------------------------------

Section2:NewToggle("تفعيل الطيران (Fly)", "طيران يلتف مع اتجاه الكاميرا ونظرك بالكامل", function(state)
    Flying = state
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
        local root = char.HumanoidRootPart
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        if state then
            hum.PlatformStand = true
            
            -- إنشاء أدوات تثبيت الحركة والاتجاه داخل جسم اللاعب
            bV = Instance.new("BodyVelocity")
            bV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bV.Velocity = Vector3.new(0, 0, 0)
            bV.Parent = root
            
            bG = Instance.new("BodyGyro")
            bG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bG.CFrame = root.CFrame
            bG.P = 10000 -- قوة الالتفاف السريع
            bG.Parent = root
        else
            hum.PlatformStand = false
            if bV then bV:Destroy() end
            if bG then bG:Destroy() end
            root.Velocity = Vector3.new(0,0,0)
        end
    end
end)

Section2:NewSlider("سرعة الطيران", "تحكم في سرعة تحليقك في الهواء", 300, 20, function(v)
    FlySpeed = v
end)

Section2:NewToggle("اختراق الجدران (Noclip)", "المرور من الجدران والأبواب بسلاسة", function(state)
    Noclip = state
end)

Section2:NewToggle("قفز لانهائي (Infinite Jump)", "القفز المتكرر في الهواء بدون توقف", function(state)
    InfJump = state
end)

------------------------------------------------------------------------
-- [3] المحركات الخلفية المستقرة (توجيه الطيران مع الكاميرا)
------------------------------------------------------------------------

-- محرك الطيران المطور للتوجيه الفوري مع الماوس والكاميرا
RunService.RenderStepped:Connect(function()
    if Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        local dir = Vector3.new(0, 0, 0)
        
        -- حساب اتجاهات الكيبورد بالنسبة للكاميرا
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        
        -- إجبار زاوية الطيران والدوران على تتبع الكاميرا فوراً بالـ BodyGyro
        if bG then
            bG.CFrame = Camera.CFrame
        end
        
        -- تطبيق السرعة
        if bV then
            if dir.Magnitude > 0 then
                bV.Velocity = dir.Unit * FlySpeed
            else
                bV.Velocity = Vector3.new(0, 0, 0)
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

------------------------------------------------------------------------
-- [4] تبويب الحقوق
------------------------------------------------------------------------
Section3:NewLabel("تم التطوير والتعديل بواسطة: 7KM")
Section3:NewLabel("النسخة الأصلية المستقرة v5.5")
Section3:NewLabel("جميع الحقوق محفوظة © 2026")
