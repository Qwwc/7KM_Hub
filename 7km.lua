-- استدعاء مكتبة Kavo المستقرة
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- إنشاء اللوحة بثيم BloodTheme الفخم بحقوقك
local Window = Library.CreateLib("7KM Hub | Premium Edition v3.0", "BloodTheme")

-- الخدمات الأساسية داخل روبلوكس
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- متغيرات التحكم بالميزات
local FlySpeed = 50
local Flying = false
local Noclip = false
local InfJump = false
local AimbotEnabled = false
local EspEnabled = false

-- جداول وحلقات ESP / Aimbot
local Camera = workspace.CurrentCamera
local EspTable = {}

-- إنشاء التبويبات (Tabs) بشكل منظم وجديد
local Tab1 = Window:NewTab("اللاعب")
local Tab2 = Window:NewTab("الحركة والطيران")
local Tab3 = Window:NewTab("القتال والمساعدات")
local Tab4 = Window:NewTab("الانتقال (Teleport)")
local Tab5 = Window:NewTab("الحقوق")

-- إنشاء الأقسام (Sections)
local Section1 = Tab1:NewSection("تعديل الشخصية الأساسية")
local Section2 = Tab2:NewSection("التحكم الكامل بالطيران والجدران")
local Section3 = Tab3:NewSection("أدوات القتال والـ ESP")
local Section4 = Tab4:NewSection("قائمة الانتقال السريع للاعبين")
local Section5 = Tab5:NewSection("المطور")

------------------------------------------------------------------------
-- [1] تبويب اللاعب
------------------------------------------------------------------------

Section1:NewSlider("تعديل السرعة (WalkSpeed)", "تغيير سرعة مشي اللاعب", 300, 16, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
    end
end)

Section1:NewSlider("تعديل القفز (JumpPower)", "تغيير قوة قفز اللاعب", 300, 50, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.UseJumpPower = true
        hum.JumpPower = v
    end
end)

Section1:NewButton("إعادة تعيين الشخصية (Reset)", "ينعش لاعبك فوراً", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
    end
end)

------------------------------------------------------------------------
-- [2] تبويب الحركة والطيران (تعديل نظام الطيران ليصبح سلس)
------------------------------------------------------------------------

Section2:NewToggle("تفعيل الطيران (Fly)", "طيران سلس بالكامل باستخدام الكيبورد", function(state)
    Flying = state
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.PlatformStand = state
        if not state then
            -- تنظيف قوى الحركة عند الإغلاق لمنع الطيران الغريب
            if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end
        end
    end
end)

Section2:NewSlider("سرعة الطيران", "التحكم في سرعة الطيران في الهواء", 300, 20, function(v)
    FlySpeed = v
end)

Section2:NewToggle("اختراق الجدران (Noclip)", "يسمح لك بالمرور من بين جميع الجدران والأشياء", function(state)
    Noclip = state
end)

Section2:NewToggle("قفز لانهائي (Infinite Jump)", "القفز المتكرر في الهواء بدون توقف", function(state)
    InfJump = state
end)

------------------------------------------------------------------------
-- [3] تبويب القتال والمساعدات (Aimbot & ESP)
------------------------------------------------------------------------

Section3:NewToggle("تفعيل مساعد التصويب (Aimbot)", "يلف الكاميرا تلقائياً على أقرب لاعب لك", function(state)
    AimbotEnabled = state
end)

-- وظيفة جلب أقرب لاعب للـ Aimbot
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                closestPlayer = v
                shortestDistance = distance
            end
        end
    end
    return closestPlayer
end

-- وظيفة الـ ESP المطور لإنشاء المربعات والأشياء
local function createEsp(player)
    if player == LocalPlayer then return end
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Thickness = 2
    box.Filled = false

    local function update()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if EspEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                local rPart = player.Character.HumanoidRootPart
                local pos, onScreen = Camera:WorldToViewportPoint(rPart.Position)
                if onScreen then
                    box.Size = Vector2.new(2000 / pos.Z, 3000 / pos.Z)
                    box.Position = Vector2.new(pos.X - box.Size.X / 2, pos.Y - box.Size.Y / 2)
                    box.Visible = true
                else
                    box.Visible = false
                end
            else
                box.Visible = false
                if not EspEnabled then
                    box:Remove()
                    connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(update)()
end

Section3:NewToggle("تفعيل رؤية الجدران (ESP Boxes)", "يضع مربعات حمراء حول الأعداء لمعرفة مكانهم", function(state)
    EspEnabled = state
    if state then
        for _, p in pairs(Players:GetPlayers()) do
            createEsp(p)
        end
    end
end)

Players.PlayerAdded:Connect(function(p)
    if EspEnabled then createEsp(p) end
end)

------------------------------------------------------------------------
-- [4] تبويب الانتقال (Teleport Menu)
------------------------------------------------------------------------

local currentSelectedPlayer = nil

local PlayerDropdown = Section4:NewDropdown("اختر اللاعب للذهاب إليه", "اختر أي لاعب موجود في السيرفر", {}, function(selected)
    currentSelectedPlayer = selected
end)

-- زر تحديث الأسماء في القائمة
Section4:NewButton("تحديث قائمة اللاعبين", "تحديث الأسماء داخل السيرفر", function()
    local playerNames = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(playerNames, p.Name)
        end
    end
    PlayerDropdown:Refresh(playerNames)
end)

Section4:NewButton("انتقال فوراً (Teleport)", "ينقلك فوراً للاعب الذي حددته فوق", function()
    if currentSelectedPlayer then
        local target = Players:FindFirstChild(currentSelectedPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
        end
    end
end)

------------------------------------------------------------------------
-- [5] المحركات الخلفية المستقرة (التحكم السلس بطيران وحركة اللاعب)
------------------------------------------------------------------------

-- محرك الطيران النظيف والناعم (W, A, S, D)
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

-- محرك الـ Aimbot الخلفي
RunService.RenderStepped:Connect(function()
    if AimbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
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

-- ميزة Anti-AFK (تمنع طردك من السيرفر)
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0,0))
end)

------------------------------------------------------------------------
-- [6] تبويب الحقوق
------------------------------------------------------------------------
Section5:NewLabel("تم التطوير والتعديل بواسطة: 7KM")
Section5:NewLabel("النسخة الفخمة والكاملة v3.0")
Section5:NewLabel("جميع الحقوق محفوظة © 2026")
