-- استدعاء مكتبة واجهات Fluent المستقرة
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- إنشاء النافذة الرئيسية بحقوقك 7KM
local Window = Fluent:CreateWindow({
    Title = "7KM Hub | Premium",
    SubTitle = "بواسطة 7KM",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, 
    Theme = "Dark"
})

-- الخدمات الأساسية داخل روبلوكس
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- إضافة التبويبات الفخمة
local Tab1 = Window:AddTab({ Title = "اللاعب", Icon = "user" })
local Tab2 = Window:AddTab({ Title = "الحركة والقدرات", Icon = "navigation" })
local Tab3 = Window:AddTab({ Title = "الحقوق", Icon = "settings" })

-- متغيرات التحكم بالميزات
local FlySpeed = 50
local Flying = false
local Noclip = false
local InfJump = false

------------------------------------------------------------------------
-- [1] ميزات تبويب اللاعب
------------------------------------------------------------------------

-- شريط تعديل السرعة
Tab1:AddSlider("SpeedSlider", {
    Title = "تعديل السرعة (WalkSpeed)",
    Min = 16,
    Max = 300,
    Default = 16,
    Callback = function(v)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
        end
    end
})

-- شريط تعديل القفز
Tab1:AddSlider("JumpSlider", {
    Title = "تعديل القفز (JumpPower)",
    Min = 50,
    Max = 300,
    Default = 50,
    Callback = function(v)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            hum.UseJumpPower = true
            hum.JumpPower = v
        end
    end
})

------------------------------------------------------------------------
-- [2] ميزات تبويب الحركة والقدرات
------------------------------------------------------------------------

-- زر تفعيل الطيران
Tab2:AddToggle("FlyToggle", {
    Title = "تفعيل الطيران (Fly)",
    Default = false,
    Callback = function(state)
        Flying = state
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = state
        end
    end
})

-- شريط سرعة الطيران
Tab2:AddSlider("FlySpeedSlider", {
    Title = "سرعة الطيران",
    Min = 20,
    Max = 300,
    Default = 50,
    Callback = function(v)
        FlySpeed = v
    end
})

-- زر اختراق الجدران
Tab2:AddToggle("NoclipToggle", {
    Title = "اختراق الجدران (Noclip)",
    Default = false,
    Callback = function(state)
        Noclip = state
    end
})

-- زر قفز لانهائي
Tab2:AddToggle("InfJumpToggle", {
    Title = "قفز لانهائي (Infinite Jump)",
    Default = false,
    Callback = function(state)
        InfJump = state
    end
})

------------------------------------------------------------------------
-- [3] المحركات الخلفية المستقلة
------------------------------------------------------------------------

-- محرك حركة الطيران بالكيبورد (W, A, S, D)
task.spawn(function()
    while true do
        task.wait()
        if Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            local cam = workspace.CurrentCamera
            local dir = Vector3.new(0,0,0)
            
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            
            if dir.Magnitude > 0 then
                root.Velocity = dir.Unit * FlySpeed
            else
                root.Velocity = Vector3.new(0,0,0)
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
-- [4] قائمة الحقوق
------------------------------------------------------------------------
Tab3:AddParagraph({
    Title = "حقوق السكربت",
    Content = "تم تطوير وتصميم هذا السكربت الفخم بواسطة: 7KM
جميع الحقوق محفوظة © 2026"
})

-- فتح أول قائمة تلقائياً عند التشغيل
Window:SelectTab(1)
