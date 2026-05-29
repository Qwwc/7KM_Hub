-- استدعاء مكتبة واجهات DrRay (المتوافقة مع كل المحركات)
local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/Main.lua"))()

-- إنشاء النافذة الرئيسية بحقوقك
local Window = DrRayLibrary:NewWindow("7KM Hub | Premium", "Default")

-- الخدمات الأساسية داخل روبلوكس
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- متغيرات التحكم بالقدرات
local FlySpeed = 50
local Flying = false
local Noclip = false
local InfJump = false

-- إنشاء التبويبات (Tabs)
local Tab1 = DrRayLibrary:NewTab("اللاعب", "rbxassetid://4483345998")
local Tab2 = DrRayLibrary:NewTab("الحركة والقدرات", "rbxassetid://4483345998")

------------------------------------------------------------------------
-- [1] ميزات تبويب اللاعب (Tab 1)
------------------------------------------------------------------------

-- شريط تعديل السرعة (WalkSpeed)
Tab1:NewSlider("تعديل السرعة (WalkSpeed)", "حدد سرعة لاعبك بدقة", 300, 16, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
    end
end)

-- شريط تعديل القفز (JumpPower)
Tab1:NewSlider("تعديل القفز (JumpPower)", "حدد قوة قفزة لاعبك", 300, 50, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.UseJumpPower = true
        hum.JumpPower = v
    end
end)

------------------------------------------------------------------------
-- [2] ميزات تبويب الحركة والقدرات (Tab 2)
------------------------------------------------------------------------

-- زر تفعيل وتعطيل الطيران
Tab2:NewToggle("تفعيل الطيران (Fly)", "تفعيل أو تعطيل الطيران في الهواء", function(state)
    Flying = state
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = state
    end
end)

-- شريط التحكم بسرعة الطيران
Tab2:NewSlider("سرعة الطيران", "حدد سرعة الطيران في الهواء", 300, 20, function(v)
    FlySpeed = v
end)

-- زر اختراق الجدران (Noclip)
Tab2:NewToggle("اختراق الجدران (Noclip)", "تسمح لك بالمرور من خلال الجدران", function(state)
    Noclip = state
end)

-- زر قفز لانهائي (Infinite Jump)
Tab2:NewToggle("قفز لانهائي (Infinite Jump)", "تسمح لك بالقفز المتكرر في الهواء", function(state)
    InfJump = state
end)

------------------------------------------------------------------------
-- [3] المحركات الخلفية (التي تشغل القدرات باستمرار)
------------------------------------------------------------------------

-- محرك حركة الطيران بالكيبورد (W, A, S, D)
task.spawn(function()
    while task.wait() do
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
