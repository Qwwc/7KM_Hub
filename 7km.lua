-- [1] تنظيف اللوحات السابقة وضمان عدم التكرار
if _G["7KM_CUSTOM_LOADED"] then
    local old = game:GetService("CoreGui"):FindFirstChild("7KM_CustomHub")
    if old then old:Destroy() end
end
_G["7KM_CUSTOM_LOADED"] = true

if not game:IsLoaded() then game.Loaded:Wait() end

-- جلب الخدمات الأساسية
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- متغيرات الميزات الأساسية
local WalkSpeedValue = 16
local JumpPowerValue = 50
local SpeedActive = false
local FlySpeed = 50
local Flying = false
local Noclip = false
local InfJump = false
local AimActive = false
local ESP_PlayerChams = false
local ClickTPActive = false
local HoldingRightClick = false
local HitboxActive = false
local HitboxSizeValue = 20
local bV, bG

-- جدول حفظ خصائص الـ HumanoidRootPart الأصلية لإعادتها بدقة
local OriginalHitboxes = {}

-- دائرة الـ FOV للأيم بوت
local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Color = Color3.fromRGB(255, 255, 255)
FOV_Circle.Thickness = 2
FOV_Circle.NumSides = 64
FOV_Circle.Radius = 120
FOV_Circle.Filled = false
FOV_Circle.Visible = false

------------------------------------------------------------------------
-- [2] بناء الواجهة الفخمة (ثيم أسود الملكي والأبيض الناصع)
------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "7KM_CustomHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400) -- مساحة مريحة تمنع تشوه النصوص
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- شريط العنوان العلوي
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 400, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "7KM HUB | PREMIUM CUSTOM EDITION v16.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- أزرار التحكم العلوية
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 24)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(12, 12, 12)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseBtn

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 28, 0, 24)
MinimizeBtn.Position = UDim2.new(1, -72, 0.5, -12)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 14
MinimizeBtn.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 5)
MinCorner.Parent = MinimizeBtn

-- القائمة الجانبية للتبويبات
local SideBar = Instance.new("ScrollingFrame")
SideBar.Size = UDim2.new(0, 160, 1, -50)
SideBar.Position = UDim2.new(0, 5, 0, 48)
SideBar.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
SideBar.BorderSizePixel = 0
SideBar.CanvasSize = UDim2.new(0, 0, 0, 380)
SideBar.ScrollBarThickness = 0
SideBar.Parent = MainFrame

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 6)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Parent = SideBar

-- حاوية المحتوى الرئيسي
local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -180, 1, -60)
Container.Position = UDim2.new(0, 170, 0, 50)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

-- الخط الفاصل الرأسي
local Separator = Instance.new("Frame")
Separator.Size = UDim2.new(0, 1, 1, -42)
Separator.Position = UDim2.new(0, 165, 0, 42)
Separator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
Separator.BorderSizePixel = 0
Separator.Parent = MainFrame

------------------------------------------------------------------------
-- [3] دالة إرجاع الهيت بوكس الأصلي بدقة عند إغلاق اللوحة
------------------------------------------------------------------------
local function ResetAllHitboxes()
    for player, data in pairs(OriginalHitboxes) do
        pcall(function()
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local root = player.Character.HumanoidRootPart
                root.Size = data.Size
                root.Transparency = data.Transparency
                root.BrickColor = data.BrickColor
                root.Material = data.Material
                root.CanCollide = data.CanCollide
            end
        end)
    end
    OriginalHitboxes = {}
end

local isMinimized = false
local originalSize = MainFrame.Size

MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MinimizeBtn.Text = "+"
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 42)}):Play()
    else
        MinimizeBtn.Text = "—"
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = originalSize}):Play()
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    SpeedActive = false; Flying = false; Noclip = false; InfJump = false; AimActive = false; ESP_PlayerChams = false; ClickTPActive = false; HitboxActive = false; FOV_Circle.Visible = false
    if bV then bV:Destroy() end if bG then bG:Destroy() end
    ResetAllHitboxes()
    pcall(function()
        for _, p in pairs(Players:GetPlayers()) do if p.Character then local h = p.Character:FindFirstChild("7KM_Highlight") if h then h:Destroy() end end end
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end
    end)
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 600, 0, 0), BackgroundTransparency = 1})
    tween:Play()
    tween.Completed:Connect(function() ScreenGui:Destroy() _G["7KM_CUSTOM_LOADED"] = false end)
end)

local uiEnabled = true
UIS.InputBegan:Connect(function(input, processed)
    if not processed and (input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.RightControl) then
        uiEnabled = not uiEnabled
        if uiEnabled then
            ScreenGui.Enabled = true
            MainFrame.Size = UDim2.new(0, 600, 0, 0)
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = isMinimized and UDim2.new(0, 600, 0, 42) or originalSize}):Play()
        else
            local t = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 600, 0, 0)})
            t:Play()
            t.Completed:Connect(function() if not uiEnabled then ScreenGui.Enabled = false end end)
        end
    end
end)

------------------------------------------------------------------------
-- [4] تعديل الخطوط جذرياً لمنع البكسلة والدمج نهائياً للعربي
------------------------------------------------------------------------
local tabs = {}
local tabButtons = {}
local currentTab = nil

local function CreateTab(name, order)
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = name .. "_Page"
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false
    TabPage.CanvasSize = UDim2.new(0, 0, 0, 460)
    TabPage.ScrollBarThickness = 4
    TabPage.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    TabPage.Parent = Container

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = TabPage

    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = name .. "_Btn"
    TabBtn.Size = UDim2.new(1, -10, 0, 38)
    TabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    TabBtn.Font = Enum.Font.ArialBold -- تغيير إلى ArialBold لضمان حدة الحروف العربية 100%
    TabBtn.TextSize = 14
    TabBtn.TextScaled = false
    TabBtn.LayoutOrder = order
    TabBtn.Parent = SideBar

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = TabBtn

    TabBtn.MouseEnter:Connect(function() if currentTab ~= TabPage then TweenService:Create(TabBtn, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(50, 50, 50), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play() end end)
    TabBtn.MouseLeave:Connect(function() if currentTab ~= TabPage then TweenService:Create(TabBtn, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(28, 28, 28), TextColor3 = Color3.fromRGB(220, 220, 220)}):Play() end end)

    TabBtn.MouseButton1Click:Connect(function()
        for _, page in pairs(tabs) do page.Visible = false end
        for _, btn in pairs(tabButtons) do btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28) btn.TextColor3 = Color3.fromRGB(220, 220, 220) end
        currentTab = TabPage; TabPage.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 255, 255), TextColor3 = Color3.fromRGB(12, 12, 12)}):Play()
    end)

    tabs[name] = TabPage; tabButtons[name] = TabBtn
    return TabPage
end

local function AddButton(page, text, desc, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -5, 0, 56)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Frame.Parent = page
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 6) corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -175, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = desc
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.Arial
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextWrapped = true
    Label.Parent = Frame

    -- حاوية أوسع مخصصة لمنع ضغط وبكسلة خطوط الأزرار الفرعية
    local BtnContainer = Instance.new("Frame")
    BtnContainer.Size = UDim2.new(0, 155, 0, 36)
    BtnContainer.Position = UDim2.new(1, -165, 0.5, -18)
    BtnContainer.BackgroundTransparency = 1
    BtnContainer.Parent = Frame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.ArialBold -- الحل الجذري: خط أريال عريض يفصل الحروف العربية تماماً وبدقة بكسل حادة
    Btn.TextSize = 14
    Btn.TextScaled = false
    Btn.Parent = BtnContainer

    local btnCorner = Instance.new("UICorner") btnCorner.CornerRadius = UDim.new(0, 5) btnCorner.Parent = Btn
    local stroke = Instance.new("UIStroke") stroke.Color = Color3.fromRGB(255, 255, 255) stroke.Thickness = 1 stroke.Parent = Btn

    local txtPadding = Instance.new("UIPadding")
    txtPadding.PaddingLeft = UDim.new(0, 6)
    txtPadding.PaddingRight = UDim.new(0, 6)
    txtPadding.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(255, 255, 255), TextColor3 = Color3.fromRGB(12, 12, 12)}):Play()
        task.wait(0.08)
        TweenService:Create(Btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(40, 40, 40), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        pcall(callback)
    end)
end

local function AddToggle(page, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -5, 0, 48)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Frame.Parent = page
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 6) corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -75, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.ArialBold
    Label.TextSize = 14
    Label.TextScaled = false
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local ToggleFrame = Instance.new("TextButton")
    ToggleFrame.Size = UDim2.new(0, 48, 0, 24)
    ToggleFrame.Position = UDim2.new(1, -58, 0.5, -12)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ToggleFrame.Text = ""
    ToggleFrame.Parent = Frame

    local tCorner = Instance.new("UICorner") tCorner.CornerRadius = UDim.new(1, 0) tCorner.Parent = ToggleFrame
    local tStroke = Instance.new("UIStroke") tStroke.Color = Color3.fromRGB(120, 120, 120) tStroke.Thickness = 1 tStroke.Parent = ToggleFrame

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 18, 0, 18)
    Circle.Position = UDim2.new(0, 3, 0.5, -9)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Parent = ToggleFrame
    local cCorner = Instance.new("UICorner") cCorner.CornerRadius = UDim.new(1, 0) cCorner.Parent = Circle

    local state = false
    ToggleFrame.MouseButton1Click:Connect(function()
        state = not state
        if state then
            TweenService:Create(ToggleFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -21, 0.5, -9), BackgroundColor3 = Color3.fromRGB(12, 12, 12)}):Play()
        else
            TweenService:Create(ToggleFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end
        pcall(callback, state)
    end)
end

local function AddSlider(page, text, min, max, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -5, 0, 54)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Frame.Parent = page
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 6) corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 220, 0, 22)
    Label.Position = UDim2.new(0, 12, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.ArialBold
    Label.TextSize = 14
    Label.TextScaled = false
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local SliderBar = Instance.new("TextButton")
    SliderBar.Size = UDim2.new(1, -65, 0, 6)
    SliderBar.Position = UDim2.new(0, 12, 1, -15)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderBar.Text = ""
    SliderBar.Parent = Frame

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0.1, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBar

    local ValLabel = Instance.new("TextLabel")
    ValLabel.Size = UDim2.new(0, 45, 0, 22)
    ValLabel.Position = UDim2.new(1, -50, 0, 5)
    ValLabel.BackgroundTransparency = 1
    ValLabel.Text = tostring(min)
    ValLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ValLabel.Font = Enum.Font.Code
    ValLabel.TextSize = 12
    ValLabel.Parent = Frame

    local holding = false
    local function update()
        local mouseX = Mouse.X
        local barX = SliderBar.AbsolutePosition.X
        local barWidth = SliderBar.AbsoluteSize.X
        local percentage = math.clamp((mouseX - barX) / barWidth, 0, 1)
        Fill.Size = UDim2.new(percentage, 0, 1, 0)
        local value = math.floor(min + (max - min) * percentage)
        ValLabel.Text = tostring(value)
        pcall(callback, value)
    end

    SliderBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then holding = true update() end end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then holding = false end end)
    RunService.RenderStepped:Connect(function() if holding then update() end end)
end

------------------------------------------------------------------------
-- [5] إنشاء التبويبات والميزات الفاخرة بدقة رندر واضحة للخط
------------------------------------------------------------------------
local Page1 = CreateTab("الحركة والسرعة ⚡", 1)
local Page2 = CreateTab("الطيران والجدران 🛸", 2)
local Page3 = CreateTab("الاستهداف (Aim) 🎯", 3)
local Page4 = CreateTab("قائمة اللاعبين 👤", 4)
local Page5 = CreateTab("السكربتات الخارجية 📂", 5)

-- تبويب الحركة والسرعة
AddToggle(Page1, "تفعيل تعديل السرعة", function(s) SpeedActive = s if not s and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16 end end)
AddSlider(Page1, "قوة السرعة (الافتراضي 16)", 16, 300, function(v) WalkSpeedValue = v if SpeedActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v end end)
AddSlider(Page1, "تعديل قوة القفزة (Jump Power)", 50, 300, function(v) JumpPowerValue = v if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid") hum.UseJumpPower = true hum.JumpPower = v end end)
AddToggle(Page1, "الانتقال بالنقر (Ctrl + كليك يسار)", function(s) ClickTPActive = s end)

-- تبويب الطيران والاختراق
AddToggle(Page2, "تفعيل الطيران الكلي (Fly)", function(state)
    Flying = state; local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
        local root = char.HumanoidRootPart local hum = char:FindFirstChildOfClass("Humanoid")
        if state then
            hum.PlatformStand = true
            bV = Instance.new("BodyVelocity") bV.MaxForce = Vector3.new(math.huge, math.huge, math.huge) bV.Velocity = Vector3.new(0, 0, 0) bV.Parent = root
            bG = Instance.new("BodyGyro") bG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge) bG.CFrame = root.CFrame bG.P = 10000 bG.Parent = root
        else
            hum.PlatformStand = false if bV then bV:Destroy() end if bG then bG:Destroy() end root.Velocity = Vector3.new(0,0,0)
        end
    end
end)
AddSlider(Page2, "سرعة تحليق الطيران", 20, 300, function(v) FlySpeed = v end)
AddToggle(Page2, "اختراق الجدران (Noclip)", function(s) Noclip = s if not s and LocalPlayer.Character then for _, part in pairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end end end)
AddToggle(Page2, "تفعيل القفز اللانهائي بالفضاء", function(s) InfJump = s end)

-- تبويب الاستهداف المطور مع الهيت بوكس الأزرق النيون
AddToggle(Page3, "تفعيل الـ Aimbot (كليك يمين فقط)", function(s) AimActive = s FOV_Circle.Visible = s end)
AddSlider(Page3, "نطاق دائرة تحديد الأهداف (FOV)", 30, 400, function(v) FOV_Circle.Radius = v end)
AddToggle(Page3, "رؤية السكن أبيض ناصع خلف الجدران", function(s) ESP_PlayerChams = s if not s then for _, p in pairs(Players:GetPlayers()) do if p.Character then local h = p.Character:FindFirstChild("7KM_Highlight") if h then h:Destroy() end end end end end)
AddToggle(Page3, "تفعيل تكبير الهيت بوكس (جذع نيون أزرق)", function(s) HitboxActive = s if not s then ResetAllHitboxes() end end)
AddSlider(Page3, "حجم تكبير الهيت بوكس (Hitbox)", 2, 50, function(v) HitboxSizeValue = v end)

-- تبويب قائمة اللاعبين - تم تعديل خطوط الانتقال لمنع التشوه
local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 6)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = Page4

local ListPadding = Instance.new("UIPadding")
ListPadding.PaddingBottom = UDim.new(0, 60)
ListPadding.Parent = Page4

local function UpdatePlayerList()
    for _, child in pairs(Page4:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local count = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            count = count + 1
            local PFrame = Instance.new("Frame")
            PFrame.Size = UDim2.new(1, -12, 0, 44)
            PFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            PFrame.Parent = Page4
            local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = PFrame

            local PLabel = Instance.new("TextLabel")
            PLabel.Size = UDim2.new(1, -125, 1, 0)
            PLabel.Position = UDim2.new(0, 12, 0, 0)
            PLabel.BackgroundTransparency = 1
            PLabel.Text = p.DisplayName .. " (@" .. p.Name .. ")"
            PLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            PLabel.Font = Enum.Font.ArialBold
            PLabel.TextSize = 13
            PLabel.TextXAlignment = Enum.TextXAlignment.Left
            PLabel.Parent = PFrame

            local TPBtn = Instance.new("TextButton")
            TPBtn.Size = UDim2.new(0, 100, 0, 30)
            TPBtn.Position = UDim2.new(1, -112, 0.5, -15)
            TPBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            TPBtn.Text = "انتقال (TP)"
            TPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TPBtn.Font = Enum.Font.ArialBold -- خط حاد جداً لقائمة اللاعبين
            TPBtn.TextSize = 13
            TPBtn.TextScaled = false
            TPBtn.Parent = PFrame
            local bCorner = Instance.new("UICorner") bCorner.CornerRadius = UDim.new(0, 4) bCorner.Parent = TPBtn

            TPBtn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            end)
        end
    end
    Page4.CanvasSize = UDim2.new(0, 0, 0, (count * 50) + 80)
end

Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)
UpdatePlayerList()

-- تبويب السكربتات الخارجية - مع ضبط الـ Arial والخط الثابت لحل المشكلة نهائياً
AddButton(Page5, "سكربت Dex 📂", "مستكشف ومحلل الملفات والأكواد الشهير Dark Dex", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)
AddButton(Page5, "سكربت ادمن 🛠️", "تشغيل سكربت الأدمن العالمي الشهير Infinite Yield", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
AddButton(Page5, "سكربت التخريب 💥", "تشغيل ميرسي سكربت لتدمير وتخريب السيرفرات بأمان", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Hm5011/hussain/refs/heads/main/Mercy%20Script"))() end)

task.defer(function()
    if tabs["الحركة والسرعة ⚡"] and tabButtons["الحركة والسرعة ⚡"] then
        tabs["الحركة والسرعة ⚡"].Visible = true; currentTab = tabs["الحركة والسرعة ⚡"]
        tabButtons["الحركة والسرعة ⚡"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tabButtons["الحركة والسرعة ⚡"].TextColor3 = Color3.fromRGB(12, 12, 12)
    end
end)

------------------------------------------------------------------------
-- [6] محرك اللعبة الرئيسي لإدارة الفيزياء، الطيران، والهيت بوكس المتطور
------------------------------------------------------------------------
UIS.InputBegan:Connect(function(input, processed)
    if not processed then
        if input.UserInputType == Enum.UserInputType.MouseButton2 then 
            HoldingRightClick = true 
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 and ClickTPActive and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            local pos = Mouse.Hit.Position
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
            end
        end
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then HoldingRightClick = false end
end)

local function applyHighlight(character)
    local hl = character:FindFirstChild("7KM_Highlight")
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "7KM_Highlight"
        hl.FillColor = Color3.fromRGB(255, 255, 255)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.15
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = character
    end
end

local function removeHighlight(character)
    local hl = character:FindFirstChild("7KM_Highlight")
    if hl then hl:Destroy() end
end

RunService.RenderStepped:Connect(function()
    if FOV_Circle.Visible then
        FOV_Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            -- الـ ESP الأبيض الناصع
            if ESP_PlayerChams and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                applyHighlight(p.Character)
            else
                removeHighlight(p.Character)
            end

            -- محرك الهيت بوكس المستقر
            if HitboxActive and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                local root = p.Character.HumanoidRootPart
                if not OriginalHitboxes[p] then
                    OriginalHitboxes[p] = {
                        Size = root.Size,
                        Transparency = root.Transparency,
                        BrickColor = root.BrickColor,
                        Material = root.Material,
                        CanCollide = root.CanCollide
                    }
                end
                root.Size = Vector3.new(HitboxSizeValue, HitboxSizeValue, HitboxSizeValue)
                root.Transparency = 0.7
                root.BrickColor = BrickColor.new("Really blue")
                root.Material = Enum.Material.Neon
                root.CanCollide = false
            end
        end
    end

    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
        local root = char.HumanoidRootPart local hum = char:FindFirstChildOfClass("Humanoid")
        if SpeedActive then hum.WalkSpeed = WalkSpeedValue end
        
        if Flying then
            local dir = Vector3.new(0, 0, 0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
            if bG then bG.CFrame = Camera.CFrame end
            if bV then if dir.Magnitude > 0 then bV.Velocity = dir.Unit * FlySpeed else bV.Velocity = Vector3.new(0, 0, 0) end end
        end
        
        if AimActive and HoldingRightClick then
            local closestTarget = nil local shortestDistance = math.huge
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                    local head = p.Character.Head
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if distance <= FOV_Circle.Radius and distance < shortestDistance then shortestDistance = distance closestTarget = head end
                    end
                end
            end
            if closestTarget then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
    end
end)

UIS.JumpRequest:Connect(function()
    if InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
