-- [1] فحص منع التكرار وتخطي الحمايات المتقدمة (مأخوذ من كودك)
if _G.7KM_LOADED and not _G.7KM_DEBUG then
	return
end
pcall(function() _G.7KM_LOADED = true end)
if not game:IsLoaded() then game.Loaded:Wait() end

function missing(t, f, fallback)
	if type(f) == t then return f end
	return fallback
end

cloneref = missing("function", cloneref, function(...) return ... end)

-- [2] استدعاء الخدمات بأمان وحماية كاملة ضد الكشف (cloneref)
local Players = cloneref(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer
local RunService = cloneref(game:GetService("RunService"))
local UIS = cloneref(game:GetService("UserInputService"))
local Camera = workspace.CurrentCamera

-- استدعاء واجهة Kavo المستقرة
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("7KM Hub | Premium Edition v8.0", "BloodTheme")

-- [3] متغيرات التحكم بالميزات
local WalkSpeedValue = 16
local JumpPowerValue = 50
local SpeedActive = false

local FlySpeed = 50
local Flying = false
local Noclip = false
local InfJump = false
local bV, bG

local AimActive = false
local IsRightClicking = false
local SelectedPlayerName = "اختر لاعب من السيرفر..."

-- إعداد دائرة الـ FOV المرئية للأيم بوت
local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Color = Color3.fromRGB(180, 0, 0)
FOV_Circle.Thickness = 1.5
FOV_Circle.NumSides = 64
FOV_Circle.Radius = 120
FOV_Circle.Filled = false
FOV_Circle.Visible = false

------------------------------------------------------------------------
-- [4] بناء التبويبات الـ 5 المنفصلة (نفس ترتيبك المفضل)
------------------------------------------------------------------------
local Tab1 = Window:NewTab("اللاعب والحركة")
local Tab2 = Window:NewTab("الطيران والجدران")
local Tab3 = Window:NewTab("الـ Aimbot")
local Tab4 = Window:NewTab("قائمة اللاعبين")
local Tab5 = Window:NewTab("الحقوق")

local Section1 = Tab1:NewSection("تعديل السرعة والفيزياء")
local Section2 = Tab2:NewSection("ضبط الطيران والسير في الهواء")
local Section3 = Tab3:NewSection("ضبط التوجيه التلقائي (كلك يمين)")
local Section4 = Tab4:NewSection("اللاعبين المتواجدين بالسيرفر")
local Section5 = Tab5:NewSection("المطور")

------------------------------------------------------------------------
-- تفعيل أزرار التبويبات والميزات داخل اللوحة
------------------------------------------------------------------------

-- التبويب 1: السرعة الثابتة (Anti-Slip حاد وبدون تزحلق)
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

-- التبويب 2: الطيران والـ Noclip
Section2:NewToggle("تفعيل الطيران (Fly)", "طيران سلس يتبع اتجاه الكاميرا ونظرك", function(state)
    Flying = state
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
        local root = char.HumanoidRootPart
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        if state then
            hum.PlatformStand = true
            bV = Instance.new("BodyVelocity")
            bV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bV.Velocity = Vector3.new(0, 0, 0)
            bV.Parent = root
            
            bG = Instance.new("BodyGyro")
            bG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bG.CFrame = root.CFrame
            bG.P = 10000 
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

-- التبويب 3: الـ Aimbot المستقل
Section3:NewToggle("تفعيل الـ Aimbot", "يشبك تلقائياً عند التعليق على كلك يمين الماوس", function(state)
    AimActive = state
    FOV_Circle.Visible = state
end)

Section3:NewSlider("تعديل مجال الرؤية (FOV)", "التحكم في قطر دائرة تحديد الهدف", 400, 30, function(v)
    FOV_Circle.Radius = v
end)

-- التبويب 4: قائمة اللاعبين المفصولة تماماً
local function getPlayersNames()
    local names = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(names, p.Name)
        end
    end
    return names
end

local PlayerDropdown = Section4:NewDropdown("اختر لاعب للـ Aim", "تحديد لاعب معين للتركيز عليه وتثبيت الايم عليه", getPlayersNames(), function(currentOption)
    SelectedPlayerName = currentOption
end)

Section4:NewButton("تحديث قائمة اللاعبين 🔄", "إعادة جلب الأسماء المتواجدة في السيرفر", function()
    PlayerDropdown:Refresh(getPlayersNames())
end)

------------------------------------------------------------------------
-- [5] المحركات الخلفية الفيزيائية والـ Aimbot (RenderStepped)
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

-- دالة جلب أقرب هدف داخل الـ FOV
local function getClosestPlayer()
    local closestTarget = nil
    local shortestDistance = math.huge
    
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

-- محرك التحديث مع كل فريم (السرعة الحادة والـ Aim)
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
        local root = char.HumanoidRootPart
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        -- ميزة السرعة الثابتة الحادة (تمنع التزحلق تماماً)
        if SpeedActive then
            local moveDirection = hum.MoveDirection
            if moveDirection.Magnitude > 0 then
                root.Velocity = Vector3.new(moveDirection.X * WalkSpeedValue, root.Velocity.Y, moveDirection.Z * WalkSpeedValue)
            end
        end
        
        -- ميزة الطيران المستقر
        if Flying then
            local dir = Vector3.new(0, 0, 0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
            
            if bG then bG.CFrame = Camera.CFrame end
            if bV then
                if dir.Magnitude > 0 then
                    bV.Velocity = dir.Unit * FlySpeed
                else
                    bV.Velocity = Vector3.new(0, 0, 0)
                end
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
    
    if FOV_Circle.Visible then
        FOV_Circle.Position = UIS:GetMouseLocation()
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

-- [6] تبويب الحقوق والمطور (تم تعديلها بالكامل لـ 7KM)
Section5:NewLabel("تم التطوير والتعديل بواسطة: 7KM")
Section5:NewLabel("النسخة البرمجية الآمنة v8.0")
Section5:NewLabel("جميع الحقوق محفوظة © 2026")
