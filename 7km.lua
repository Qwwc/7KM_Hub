-- حذف أي واجهة قديمة لتفادي التكرار
local ScreenGui = game:GetService("CoreGui"):FindFirstChild("7KM_Custom_Hub")
if ScreenGui then ScreenGui:Destroy() end

-- إنشاء الواجهة محلياً بدون روابط خارجية
ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SpeedBtn = Instance.new("TextButton")
local JumpBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")
local Credit = Instance.new("TextLabel")

ScreenGui.Name = "7KM_Custom_Hub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- تصميم اللوحة الرئيسية
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true -- تتيح لك سحب اللوحة بالماوس

-- زوايا دائرية فخمة
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- عنوان اللوحة
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "7KM Hub | Native Custom"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- زر تفعيل السرعة العالية
SpeedBtn.Name = "SpeedBtn"
SpeedBtn.Parent = MainFrame
SpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
SpeedBtn.Size = UDim2.new(0, 270, 0, 45)
SpeedBtn.Font = Enum.Font.SourceSans
SpeedBtn.Text = "تفعيل السرعة العالية (150)"
SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBtn.TextSize = 18

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 6)
SpeedCorner.Parent = SpeedBtn

-- زر قفزة عالية
JumpBtn.Name = "JumpBtn"
JumpBtn.Parent = MainFrame
JumpBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
JumpBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
JumpBtn.Size = UDim2.new(0, 270, 0, 45)
JumpBtn.Font = Enum.Font.SourceSans
JumpBtn.Text = "تفعيل القفز العالي (120)"
JumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpBtn.TextSize = 18

local JumpCorner = Instance.new("UICorner")
JumpCorner.CornerRadius = UDim.new(0, 6)
JumpCorner.Parent = JumpBtn

-- زر إغلاق السكربت
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
CloseBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
CloseBtn.Size = UDim2.new(0, 270, 0, 35)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Text = "إغلاق اللوحة"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- الحقوق والمطور
Credit.Name = "Credit"
Credit.Parent = MainFrame
Credit.BackgroundTransparency = 1
Credit.Position = UDim2.new(0, 0, 0.9, 0)
Credit.Size = UDim2.new(1, 0, 0, 20)
Credit.Font = Enum.Font.SourceSansItalic
Credit.Text = "Developed by 7KM © 2026"
Credit.TextColor3 = Color3.fromRGB(150, 150, 150)
Credit.TextSize = 12

------------------------------------------------------------------------
-- المحركات البرمجية والوظائف المباشرة
------------------------------------------------------------------------
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local SpeedActive = false
local JumpActive = false

-- تفعيل السرعة وتخطي الحماية محلياً
SpeedBtn.MouseButton1Click:Connect(function()
    SpeedActive = not SpeedActive
    if SpeedActive then
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
        SpeedBtn.Text = "السرعة العالية: مفعلة"
    else
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        SpeedBtn.Text = "تفعيل السرعة العالية (150)"
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
        end
    end
end)

-- تفعيل القفز العالي
JumpBtn.MouseButton1Click:Connect(function()
    JumpActive = not JumpActive
    if JumpActive then
        JumpBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
        JumpBtn.Text = "القفز العالي: مفعل"
    else
        JumpBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        JumpBtn.Text = "تفعيل القفز العالي (120)"
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
        end
    end
end)

-- تشغيل حركة السرعة والقفز بالتوافق مع فريمات اللعبة
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local root = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        
        -- تخطي نظام الحماية عن طريق تزويد مسافة الـ CFrame مباشرة
        if SpeedActive then
            local moveDirection = hum.MoveDirection
            if moveDirection.Magnitude > 0 then
                root.CFrame = root.CFrame + (moveDirection * (150 / 110))
            end
        end
        
        -- تطبيق قفزة مخصصة ثابتة
        if JumpActive then
            hum.UseJumpPower = true
            hum.JumpPower = 120
        end
    end
end)

-- وظيفة إغلاق اللوحة بالكامل
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
