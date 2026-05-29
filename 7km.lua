-- استدعاء مكتبة Kavo المستقرة
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- إنشاء اللوحة بثيم (BloodTheme) مع تفعيل سرعة الاستجابة والأنميشن الخفيف للمكتبة
local Window = Library.CreateLib("7KM Hub | Premium Edition v4.0", "BloodTheme")

-- الخدمات الأساسية ل روبلوكس
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- متغيرات التحكم بالميزات
local FlySpeed = 50
local Flying = false
local Noclip = false
local InfJump = false
local AimbotEnabled = false
local EspEnabled = false

-- إنشاء التبويبات (Tabs) بشكل مرتب وبأزرار محسنة
local Tab1 = Window:NewTab("اللاعب")
local Tab2 = Window:NewTab("الحركة والطيران")
local Tab3 = Window:NewTab("القتال والمساعدات")
local Tab4 = Window:NewTab("الانتقال (Teleport)")
local Tab5 = Window:NewTab("الحقوق")

-- إنشاء الأقسام (Sections) داخل التبويبات
local Section1 = Tab1:NewSection("تعديل خصائص الشخصية")
local Section2 = Tab2:NewSection("ضبط الطيران والسير في الهواء")
local Section3 = Tab3:NewSection("أدوات الهجوم والـ ESP")
local Section4 = Tab4:NewSection("الانتقال السريع للاعبين")
local Section5 = Tab5:NewSection("المطور")

------------------------------------------------------------------------
-- [1] تبويب اللاعب
------------------------------------------------------------------------

Section1:NewSlider("تعديل السرعة (WalkSpeed)", "تحكم سريع في سرعة المشي", 300, 16, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
    end
end)

Section1:NewSlider("تعديل القفز (JumpPower)", "تحكم سريع في قوة القفز", 300, 50, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.UseJumpPower = true
        hum.JumpPower = v
    end
end)

Section1:NewButton("إعادة تعيين الشخصية (Reset)", "ينعش لاعبك فوراً عند التعليق", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
    end
end)

------------------------------------------------------------------------
-- [2] تبويب الحركة والطيران (تم تعديله لتلتفت الشخصية مع الكاميرا فوراً)
------------------------------------------------------------------------

Section2:NewToggle("تفعيل الطيران (Fly)", "طيران احترافي يلف مع اتجاه الكاميرا والماوس", function(state)
    Flying = state
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.PlatformStand = state
        if not state then
            -- تنظيف الحركة فوراً عند الإغلاق لمنع الطيران العشوائي
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
-- [3] تبويب القتال والمساعدات (Aimbot & ESP)
------------------------------------------------------------------------

Section3:NewToggle("تفعيل مساعد التصويب (Aimbot)", "توجيه الكاميرا تلقائياً نحو أقرب هدف", function(state)
    AimbotEnabled = state
end)

-- وظيفة جلب أقرب لاعب
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

-- وظيفة الـ ESP لإنشاء مربعات حول اللاعبين
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

Section3:NewToggle("تفعيل رؤية الجدران (Player ESP)", "رؤية مربعات حمراء حول جميع اللاعبين", function(state)
    EspEnabled = state
    if state then
        for _, p in pairs(Players:GetPlayers()) do
            createEsp(p)
        end
    end
end)

------------------------------------------------------------------------
-- [4] تبويب الانتقال (Teleport)
------------------------------------------------------------------------

local currentSelectedPlayer = nil

local PlayerDropdown = Section4:NewDropdown("اختر اللاعب للذهاب إليه", "قائمة أسماء اللاعبين بالسيرفر", {}, function(selected)
    currentSelectedPlayer = selected
end)

Section4:NewButton("تحديث قائمة اللاعبين", "تحديث أسماء اللاعبين فوراً في القائمة", function()
    local playerNames = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(playerNames, p.Name)
        end
    end
    PlayerDropdown:Refresh(playerNames)
end)

Section4:NewButton("انتقال فوراً (Teleport)", "ينقلك فوراً للاعب المحدد أعلاه", function()
    if currentSelectedPlayer then
        local target = Players:FindFirstChild(currentSelectedPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
        end
    end
end)

------------------------------------------------------------------------
-- [5] المحركات الخلفية السريعة (ضبط لف الشخصية مع الكاميرا)
------------------------------------------------------------------------

-- محرك الطيران المطور (الشخصية تلف مع اتجاه الماوس والكاميرا)
task.spawn(function()
    while true do
        RunService.RenderStepped:Wait() -- سرعة استجابة قصوى متوافقة مع الفريمات
        if Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            local dir = Vector3.new(0, 0, 0)
            
            -- جلب اتجاهات حركة الكيبورد بالنسبة للكاميرا
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
            
            -- إجبار الشخصية (الـ CFrame) على الالتفات والدوران مع زاوية الكاميرا فوراً
            root.CFrame = CFrame.new(root.Position, root.Position + Camera.CFrame.LookVector)
            
            -- تطبيق السرعة بسلاسة وبدون تقطيع
            if dir.Magnitude > 0 then
                root.Velocity = dir.Unit * FlySpeed
            else
                root.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

-- محرك الـ Aimbot الخلفي السريع
RunService.RenderStepped:Connect(function()
    if AimbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- محرك اختراق الجدران المتجاوب (Noclip)
RunService.Stepped:Connect(function()
    if Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- محرك القفز اللانهائي الاستجابة السريعة
UIS.JumpRequest:Connect(function()
    if InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ميزة منع الطرد (Anti-AFK)
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0,0))
end)

------------------------------------------------------------------------
-- [6] تبويب الحقوق
------------------------------------------------------------------------
Section5:NewLabel("تم التطوير والتعديل بواسطة: 7KM")
Section5:NewLabel("النسخة الفخمة والكاملة v4.0")
Section5:NewLabel("جميع الحقوق محفوظة © 2026")
