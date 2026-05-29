-- فحص ما إذا كان السكربت يعمل مسبقاً لمنع التكرار والكراش
if _G.7KM_LOADED and not _G.7KM_DEBUG then
    return
end
pcall(function() _G.7KM_LOADED = true end)
if not game:IsLoaded() then game.Loaded:Wait() end

-- دالة التحقق من دوال المحرك وتجنب الأخطاء البرمجية
local function missing(t, f, fallback)
    if type(f) == t then return f end
    return fallback
end

cloneref = missing("function", cloneref, function(...) return ... end)
sethidden = missing("function", sethiddenproperty or set_hidden_property or set_hidden_prop)
gethidden = missing("function", gethiddenproperty or get_hidden_property or get_hidden_prop)
UIS = cloneref(game:GetService("UserInputService"))
RunService = cloneref(game:GetService("RunService"))
Players = cloneref(game:GetService("Players"))
LocalPlayer = Players.LocalPlayer
Camera = workspace.CurrentCamera

-- إنشاء حاوية الواجهة الرسمية مع حمايتها من كشف نظام اللعبة (Anti-Leak)
local PARENT = nil
local MAX_DISPLAY_ORDER = 2147483647
if gethui then
    PARENT = gethui()
elseif cloneref(game:GetService("CoreGui")):FindFirstChild("RobloxGui") then
    PARENT = cloneref(game:GetService("CoreGui")).RobloxGui
else
    local Main = Instance.new("ScreenGui")
    Main.Name = "7KM_Secure_Gui_" .. tostring(math.random(100,999))
    Main.ResetOnSpawn = false
    Main.DisplayOrder = MAX_DISPLAY_ORDER
    Main.Parent = cloneref(game:GetService("CoreGui"))
    PARENT = Main
end

-- تدمير النسخ القديمة لتحديث الشاشة فوراً
if PARENT:FindFirstChild("7KM_Main_Frame") then
    PARENT["7KM_Main_Frame"]:Destroy()
end

------------------------------------------------------------------------
-- متغيرات التحكم والميزات الفيزيائية للـ Hub
------------------------------------------------------------------------
local WalkSpeedValue = 16
local JumpPowerValue = 50
local SpeedActive = false
local FlySpeed = 50
local Flying = false
local Noclip = false
local InfJump = false
local AimActive = false
local IsRightClicking = false
local SelectedPlayerName = "اختر لاعب..."
local bV, bG

-- إعداد حلقة تحديد الهدف للـ Aimbot (FOV)
local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Color = Color3.fromRGB(180, 0, 0)
FOV_Circle.Thickness = 1.5
FOV_Circle.NumSides = 64
FOV_Circle.Radius = 120
FOV_Circle.Filled = false
FOV_Circle.Visible = false

------------------------------------------------------------------------
-- بناء عناصر واجهة 7KM الاحترافية (Custom Elements)
------------------------------------------------------------------------
local MainHolder = Instance.new("Frame")
MainHolder.Name = "7KM_Main_Frame"
MainHolder.Size = UDim2.new(0, 500, 0, 320)
MainHolder.Position = UDim2.new(0.5, -250, 0.4, -160)
MainHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainHolder.BorderSizePixel = 0
MainHolder.Active = true
MainHolder.Draggable = true
MainHolder.Parent = PARENT

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainHolder

-- شريط العنوان العلوي (Premium Title)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainHolder

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "7KM Hub | Premium Edition v7.5"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 1, 0)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 16
CloseBtn.Parent = TopBar

-- قائمة التبويبات الجانبية (Left Navigation Panel)
local TabPanel = Instance.new("Frame")
TabPanel.Size = UDim2.new(0, 140, 1, -35)
TabPanel.Position = UDim2.new(0, 0, 0, 35)
TabPanel.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TabPanel.BorderSizePixel = 0
TabPanel.Parent = MainHolder

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 2)
TabList.Parent = TabPanel

-- حاوية الصفحات الرئيسية (Pages Container)
local ContentPanel = Instance.new("Frame")
ContentPanel.Size = UDim2.new(1, -140, 1, -35)
ContentPanel.Position = UDim2.new(0, 140, 0, 35)
ContentPanel.BackgroundTransparency = 1
ContentPanel.Parent = MainHolder

local pages = {}
local currentTabBtn = nil

local function createTab(name, id)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 35)
    tabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tabBtn.BackgroundTransparency = 0.5
    tabBtn.Text = "  " .. name
    tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabBtn.Font = Enum.Font.SourceSans
    tabBtn.TextSize = 14
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.Parent = TabPanel

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.Visible = false
    page.Parent = ContentPanel

    local pageList = Instance.new("UIListLayout")
    pageList.Padding = UDim.new(0, 8)
    pageList.Parent = page

    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        for _, b in pairs(TabPanel:GetChildren()) do
            if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(25, 25, 25) b.TextColor3 = Color3.fromRGB(200, 200, 200) end
        end
        page.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    pages[id] = page
    return page, tabBtn
end

------------------------------------------------------------------------
-- أدوات التصميم الداخلي للأزرار والسلايدرات والـ Dropdowns
------------------------------------------------------------------------
local function addToggle(page, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = "  [❌]  " .. text
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = page

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.Text = "  [✅]  " .. text
            btn.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
        else
            btn.Text = "  [❌]  " .. text
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end
        callback(state)
    end)
end

local function addSlider(page, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    frame.Parent = page

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.Position = UDim2.new(0, 10, 0, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. default
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0.9, 0, 0, 4)
    bar.Position = UDim2.new(0.05, 0, 0.7, 0)
    bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    bar.Parent = frame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local dragging = false
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    RunService.Heartbeat:Connect(function()
        if dragging then
            local mp = UIS:GetMouseLocation().X
            local bl = bar.AbsolutePosition.X
            local bw = bar.AbsoluteSize.X
            local pct = math.clamp((mp - bl) / bw, 0, 1)
            fill.Size = UDim2.new(pct, 0, 1, 0)
            local val = math.floor(min + (max - min) * pct)
            lbl.Text = text .. ": " .. val
            callback(val)
        end
    end)
end

------------------------------------------------------------------------
-- إنشاء الأقسام الـ 5 المنفصلة وتوزيع المميزات بالكامل
------------------------------------------------------------------------
local p1, b1 = createTab("اللاعب والحركة", "p1")
local p2, b2 = createTab("الطيران والجدران", "p2")
local p3, b3 = createTab("الـ Aimbot", "p3")
local p4, b4 = createTab("قائمة اللاعبين", "p4")
local p5, b5 = createTab("الحقوق والمطور", "p5")

-- تفعيل الصفحة الأولى تلقائياً عند فتح السكربت
p1.Visible = true
b1.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
b1.TextColor3 = Color3.fromRGB(255, 255, 255)

-- [1] الصفحة الأولى: اللاعب والحركة
addToggle(p1, "تفعيل السرعة الثابتة (Anti-Slip)", function(s) SpeedActive = s end)
addSlider(p1, "تعديل السرعة القصوى", 16, 300, 100, function(v) WalkSpeedValue = v end)
addSlider(p1, "تعديل قوة القفز", 50, 300, 50, function(v)
    JumpPowerValue = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        h.UseJumpPower = true
        h.JumpPower = v
    end
end)

-- [2] الصفحة الثانية: الطيران والجدران
addToggle(p2, "تفعيل الطيران الذكي (Fly)", function(state)
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
addSlider(p2, "سرعة تحليق الطيران", 20, 300, 50, function(v) FlySpeed = v end)
addToggle(p2, "اختراق الأبواب والجدران (Noclip)", function(s) Noclip = s end)
addToggle(p2, "قفز لانهائي في الهواء", function(s) InfJump = s end)

-- [3] الصفحة الثالثة: الـ Aimbot
addToggle(p3, "تفعيل نظام الـ Aimbot", function(s) AimActive = s FOV_Circle.Visible = s end)
addSlider(p3, "تعديل دائرة الرؤية (FOV)", 30, 400, 120, function(v) FOV_Circle.Radius = v end)

-- [4] الصفحة الرابعة: قائمة اللاعبين المستقلة
local DropLabel = Instance.new("TextLabel")
DropLabel.Size = UDim2.new(1, 0, 0, 25)
DropLabel.BackgroundTransparency = 1
DropLabel.Text = "اللاعب المحدد حالياً للـ Aim: " .. SelectedPlayerName
DropLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
DropLabel.Font = Enum.Font.SourceSans
DropLabel.TextSize = 14
DropLabel.TextXAlignment = Enum.TextXAlignment.Left
DropLabel.Parent = p4

local PlayerListContainer = Instance.new("Frame")
PlayerListContainer.Size = UDim2.new(1, 0, 0, 150)
PlayerListContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PlayerListContainer.Parent = p4

local ListScroll = Instance.new("ScrollingFrame")
ListScroll.Size = UDim2.new(1, -10, 1, -10)
ListScroll.Position = UDim2.new(0, 5, 0, 5)
ListScroll.BackgroundTransparency = 1
ListScroll.BorderSizePixel = 0
ListScroll.ScrollBarThickness = 3
ListScroll.Parent = PlayerListContainer

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = ListScroll

local function refreshPlayers()
    for _, c in pairs(ListScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, 0, 0, 28)
            pBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            pBtn.Text = "  " .. p.DisplayName .. " (@" .. p.Name .. ")"
            pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            pBtn.Font = Enum.Font.SourceSans
            pBtn.TextSize = 13
            pBtn.TextXAlignment = Enum.TextXAlignment.Left
            pBtn.Parent = ListScroll

            pBtn.MouseButton1Click:Connect(function()
                SelectedPlayerName = p.Name
                DropLabel.Text = "اللاعب المحدد حالياً للـ Aim: " .. p.Name
            end)
        end
    end
end
refreshPlayers()

local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(1, 0, 0, 30)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
RefreshBtn.Text = "تحديث قائمة أسماء اللاعبين 🔄"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Font = Enum.Font.SourceSansBold
RefreshBtn.TextSize = 14
RefreshBtn.Parent = p4
RefreshBtn.MouseButton1Click:Connect(refreshPlayers)

-- [5] الصفحة الخامسة: صفحة الحقوق (تعديل كامل لـ 7KM)
local l1 = Instance.new("TextLabel")
l1.Size = UDim2.new(1, 0, 0, 30)
l1.BackgroundTransparency = 1
l1.Text = "تمت إعادة الهيكلة والتطوير بواسطة: 7KM"
l1.TextColor3 = Color3.fromRGB(255, 255, 255)
l1.Font = Enum.Font.SourceSansBold
l1.TextSize = 14
l1.TextXAlignment = Enum.TextXAlignment.Left
l1.Parent = p5

local l2 = Instance.new("TextLabel")
l2.Size = UDim2.new(1, 0, 0, 20)
l2.BackgroundTransparency = 1
l2.Text = "النسخة النظيفة والمستقرة والمستقلة بالكامل © 2026"
l2.TextColor3 = Color3.fromRGB(150, 150, 150)
l2.Font = Enum.Font.SourceSansItalic
l2.TextSize = 12
l2.TextXAlignment = Enum.TextXAlignment.Left
l2.Parent = p5

------------------------------------------------------------------------
-- المحركات البرمجية المتوافقة والموحدة خلف الكواليس
------------------------------------------------------------------------
UIS.InputBegan:Connect(function(input, proc)
    if not proc and input.UserInputType == Enum.UserInputType.MouseButton2 then IsRightClicking = true end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then IsRightClicking = false end
end)

local function getClosestPlayer()
    local target, shortest = nil, math.huge
    if SelectedPlayerName ~= "اختر لاعب..." then
        local tp = Players:FindFirstChild(SelectedPlayerName)
        if tp and tp.Character and tp.Character:FindFirstChild("HumanoidRootPart") then
            local screenPos, onScreen = Camera:WorldToViewportPoint(tp.Character.HumanoidRootPart.Position)
            if onScreen and (Vector2.new(screenPos.X, screenPos.Y) - UIS:GetMouseLocation()).Magnitude <= FOV_Circle.Radius then
                return tp.Character
            end
        end
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
            if p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - UIS:GetMouseLocation()).Magnitude
                    if dist <= FOV_Circle.Radius and dist < shortest then
                        shortest = dist
                        target = p.Character
                    end
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
        local root = char.HumanoidRootPart
        local hum = char:FindFirstChildOfClass("Humanoid")

        -- معالجة السرعة الحادة الثابتة لمنع التزحلق تماماً
        if SpeedActive and hum.MoveDirection.Magnitude > 0 then
            root.Velocity = Vector3.new(hum.MoveDirection.X * WalkSpeedValue, root.Velocity.Y, hum.MoveDirection.Z * WalkSpeedValue)
        end

        -- معالجة الطيران الموجه بالكامل مع الكاميرا
        if Flying then
            local dir = Vector3.new(0, 0, 0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
            if bG then bG.CFrame = Camera.CFrame end
            if bV then bV.Velocity = dir.Magnitude > 0 and dir.Unit * FlySpeed or Vector3.new(0,0,0) end
        end

        -- معالجة التوجيه التلقائي (Aimbot) بكلك يمين
        if AimActive and IsRightClicking then
            local t = getClosestPlayer()
            if t and t:FindFirstChild("Head") then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Head.Position) end
        end
    end
    if FOV_Circle.Visible then FOV_Circle.Position = UIS:GetMouseLocation() end
end)

RunService.Stepped:Connect(function()
    if Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    FOV_Circle.Visible = false
    FOV_Circle:Delete()
    MainHolder:Destroy()
end)
