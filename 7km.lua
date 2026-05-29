-- استدعاء مكتبة كلاسيكية خفيفة ومستحيلة تختفي أو تسبب كراش
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- إنشاء اللوحة بحقوقك 7KM
local Window = Library.CreateLib("7KM Hub | Premium Lite", "DarkTheme")

-- الخدمات الأساسية
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- إنشاء قائمة اللاعب
local Tab = Window:NewTab("اللاعب والقدرات")
local Section = Tab:NewSection("التحكم بالشخصية")

-- متغير القفز اللانهائي
local InfJump = false

-- 1. شريط تعديل السرعة
Section:NewSlider("تعديل السرعة (WalkSpeed)", "تغيير سرعة مشي اللاعب", 300, 16, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
    end
end)

-- 2. شريط تعديل القفز
Section:NewSlider("تعديل القفز (JumpPower)", "تغيير قوة قفز اللاعب", 300, 50, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.UseJumpPower = true
        hum.JumpPower = v
    end
end)

-- 3. زر قفز لانهائي
Section:NewToggle("قفز لانهائي (Infinite Jump)", "يسمح لك بالقفز في الهواء بدون توقف", function(state)
    InfJump = state
end)

-- محرك القفز اللانهائي الخلفي
UIS.JumpRequest:Connect(function()
    if InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
