-- استدعاء مكتبة Kavo المستقرة والمتوافقة مع محركك
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- إنشاء اللوحة بشكل محسّن وثيم فخم (BloodTheme) بحقوقك
local Window = Library.CreateLib("7KM Hub | Premium Edition", "BloodTheme")

-- الخدمات الأساسية ل روبلوكس
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- متغيرات التحكم بالميزات
local FlySpeed = 50
local Flying = false
local Noclip = false
local InfJump = false

-- إنشاء التبويبات الفخمة (Tabs)
local Tab1 = Window:NewTab("اللاعب")
local Tab2 = Window:AddTab("الحركة والقدرات")
local Tab3 = Window:NewTab("الحقوق")

local Section1 = Tab1:NewSection("تعديل خصائص اللاعب")
local Section2 = Tab2:NewSection("الطيران واختراق الجدران")
local Section3 = Tab3:NewSection("المطور")

------------------------------------------------------------------------
-- [1] تبويب اللاعب
------------------------------------------------------------------------

-- شريط السرعة
Section1:NewSlider("تعديل السرعة (WalkSpeed)", "تحكم في سرعة مشي الشخصية", 300, 16, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
    end
end)

-- شريط القفز
Section1:NewSlider("تعديل القفز (JumpPower)", "تحكم في قوة قفز الشخصية", 300, 50, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.UseJumpPower = true
        hum.JumpPower = v
    end
end)

------------------------------------------------------------------------
-- [2] تبويب الحركة والقدرات (الطيران والنكليب)
------------------------------------------------------------------------

-- زر الطيران
Section2:NewToggle("تفعيل الطيران (Fly)", "تسمح لك بالطيران والسير في الهواء", function(state)
    Flying = state
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = state
    end
end)

-- شريط سرعة الطيران
Section2:NewSlider("سرعة الطيران", "تحكم في سرعة طيرانك في الهواء", 300, 20, function(v)
    FlySpeed = v
end)

-- زر اختراق الجدران
Section2:NewToggle("اختراق الجدران (Noclip)", "تسمح لك بالمرور من بين الجدران والأشياء", function(state)
    Noclip = state
end)

-- زر قفز لانهائي
Section2:NewToggle("قفز لانهائي (Infinite Jump)", "تسمح لك بالقفز المتكرر في الهواء", function(state)
    InfJump = state
end)

------------------------------------------------------------------------
-- [3] المحركات الخلفية (التي تشغل القدرات باستمرار وبدون كراش)
------------------------------------------------------------------------

-- محرك الطيران (W, A, S, D)
task.spawn(function()
    while true do
        task.wait()
        if Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            local cam = workspace.CurrentCamera
            local dir = Vector3.new(0, 0, 0)
            
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            
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

------------------------------------------------------------------------
-- [4] تبويب الحقوق
------------------------------------------------------------------------
Section3:NewLabel("تم التطوير بواسطة: 7KM")
Section3:NewLabel("سكربت فخم ومتكامل ومستقر")
Section3:NewLabel("جميع الحقوق محفوظة © 2026")
