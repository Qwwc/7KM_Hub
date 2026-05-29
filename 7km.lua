-- استدعاء مكتبة Kavo المستقرة والمعروفة عندك
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- إنشاء اللوحة بالشكل القديم الفخم (BloodTheme) وبحقوقك 7KM
local Window = Library.CreateLib("7KM Hub | Premium Edition v7.0", "BloodTheme")

-- الخدمات الأساسية داخل روبلوكس
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- متغيرات التحكم بالميزات
local WalkSpeedValue = 16
local JumpPowerValue = 50
local SpeedActive = false

-- متغيرات الـ Aimbot والـ FOV
local AimActive = false
local IsRightClicking = false
local SelectedPlayerName = "اختر لاعب من السيرفر..."

-- إعداد دائرة الـ FOV المرئية
local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Color = Color3.fromRGB(180, 0, 0)
FOV_Circle.Thickness = 1.5
FOV_Circle.NumSides = 64
FOV_Circle.Radius = 120
FOV_Circle.Filled = false
FOV_Circle.Visible = false

-- إنشاء التبويبات القديمة (Tabs) على اليسار نفس الصورة الأولى
local Tab1 = Window:NewTab("اللاعب والحركة")
local Tab2 = Window:NewTab("الـ Aimbot")
local Tab3 = Window:NewTab("الحقوق")

local Section1 = Tab1:NewSection("تعديل السرعة والفيزياء")
local Section2 = Tab2:NewSection("ضبط التوجيه التلقائي")
local Section3 = Tab3:NewSection("المطور")

------------------------------------------------------------------------
-- [1] تبويب اللاعب والحركة (السرعة الثابتة بدون تزحلق)
------------------------------------------------------------------------

Section1:NewToggle("تفعيل السرعة الثابتة (Anti-Slip)", "تفعيل محرك السرعة الفيزيائي بدون انزلاق", function(state)
    SpeedActive = state
end)

Section1:NewSlider("تعديل قوة السرعة", "التحكم في السرعة القصوى للشخصية", 300, 16, function(v)
    WalkSpeedValue = v
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
-- [2] تبويب الـ Aimbot وقائمة اللاعبين المتقدمة
------------------------------------------------------------------------

Section2:NewToggle("تفعيل الـ Aimbot", "يشبك تلقائياً عند التعليق على كلك يمين", function(state)
    AimActive = state
    FOV_Circle.Visible = state
end)

Section2:NewSlider("تعديل مجال الرؤية (FOV)", "التحكم في قطر دائرة تحديد الهدف", 400, 30, function(v)
    FOV_Circle.Radius = v
end)

-- دالة لجلب أسماء اللاعبين وتحديث القائمة المنسدلة (Dropdown)
local function getPlayersNames()
    local names = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(names, p.Name)
        end
    end
    return names
end

local PlayerDropdown = Section2:NewDropdown("اختر لاعب معين", "تحديد لاعب من السيرفر للتركيز عليه", getPlayersNames(), function(currentOption)
    SelectedPlayerName = currentOption
end)

-- زر لتحديث قائمة الأسماء داخل الـ Dropdown عند دخول لاعبين جدد
Section2:NewButton("تحديث قائمة اللاعبين 🔄", "إعادة جلب الأسماء المتواجدة في السيرفر", function()
    PlayerDropdown:Refresh(getPlayersNames())
end)

------------------------------------------------------------------------
-- [3] المحركات الخلفية المستقرة (الـ Aimbot والسرعة الفيزيائية)
------------------------------------------------------------------------

-- رصد ضغط وترك كلك يمين الماوس
UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.UserInputType == Enum.UserInputType.MouseButton2 then
        IsRightClicking = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        IsRightClicking = false
    end
end)

-- دالة جلب أقرب هدف
local function getClosestPlayer()
    local closestTarget = nil
    local shortestDistance = math.huge
    
    -- التحقق أولاً إذا كان اللاعب المحدد في القائمة المنسدلة موجوداً وقريباً
    if SelectedPlayerName ~= "اختر لاعب من السيرفر..." then
        local targetPlayer = Players:FindFirstChild(SelectedPlayerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = targetPlayer.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen then
                local mousePos = UIS:GetMouseLocation()
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if distance <= FOV_Circle.Radius then
                    return targetPlayer.Character
                end
            end
        end
    end
    
    -- البحث التلقائي عن الأقرب في السيرفر إذا لم يتم تحديد اسم معين
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
            if p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                local root = p.Character.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local mousePos = UIS:GetMouseLocation()
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance <= FOV_Circle.Radius and distance < shortestDistance then
                        shortestDistance = distance
                        closestTarget = p.Character
                    end
                end
            end
        end
    end
    return closestTarget
end

-- المحرك الموحد المربوط مع الفريمات
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
        local root = char.HumanoidRootPart
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        -- محرك السرعة الفيزيائي لـ منع التزحلق (يقف فوراً عند ترك الأزرار)
        if SpeedActive then
            local moveDirection = hum.MoveDirection
            if moveDirection.Magnitude > 0 then
                root.Velocity = Vector3.new(moveDirection.X * WalkSpeedValue, root.Velocity.Y, moveDirection.Z * WalkSpeedValue)
            end
        end
        
        -- تشغيل الـ Aimbot عند ضغط كلك يمين
        if AimActive and IsRightClicking then
            local target = getClosestPlayer()
            if target and target:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Head.Position)
            end
        end
    end
    
    -- تحديث موقع دائرة الـ FOV مع الماوس
    if FOV_Circle.Visible then
        FOV_Circle.Position = UIS:GetMouseLocation()
    end
end)

------------------------------------------------------------------------
-- [4] تبويب الحقوق
------------------------------------------------------------------------
Section3:NewLabel("تم التطوير والتعديل بواسطة: 7KM")
Section3:NewLabel("النسخة المتكاملة المستقرة v7.0")
Section3:NewLabel("جميع الحقوق محفوظة © 2026")
