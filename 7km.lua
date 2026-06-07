if _G["7KM_CUSTOM_LOADED"] then
    local old = game:GetService("CoreGui"):FindFirstChild("7KM_CustomHub")
    if old then old:Destroy() end
end
_G["7KM_CUSTOM_LOADED"] = true

if not game:IsLoaded() then game.Loaded:Wait() end

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local WalkSpeedValue = 16
local JumpPowerValue = 50
local SpeedActive = false
local FlySpeed = 100
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
local FlyToggleKey = Enum.KeyCode.F
local HubVisible = true
local KeybindConnection = nil

local OriginalHitboxes = {}

local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Color = Color3.fromRGB(0, 200, 255)
FOV_Circle.Thickness = 2
FOV_Circle.NumSides = 64
FOV_Circle.Radius = 120
FOV_Circle.Filled = false
FOV_Circle.Visible = false

local Colors = {
    bg = Color3.fromRGB(8, 8, 18),
    card = Color3.fromRGB(14, 14, 28),
    accent = Color3.fromRGB(0, 180, 255),
    text = Color3.fromRGB(220, 220, 240),
    textDim = Color3.fromRGB(140, 140, 160),
    border = Color3.fromRGB(30, 30, 60),
    danger = Color3.fromRGB(255, 60, 60),
    gold = Color3.fromRGB(255, 200, 50),
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "7KM_CustomHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 700, 0, 440)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -220)
MainFrame.BackgroundColor3 = Colors.bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
MainFrame.BackgroundTransparency = 1
MainFrame.Size = UDim2.new(0, 0, 0, 0)

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local BorderGlow = Instance.new("UIStroke")
BorderGlow.Color = Colors.accent
BorderGlow.Thickness = 1.5
BorderGlow.Transparency = 0.4
BorderGlow.Parent = MainFrame

local GlassFrame = Instance.new("Frame")
GlassFrame.Size = UDim2.new(1, 0, 1, 0)
GlassFrame.BackgroundColor3 = Colors.card
GlassFrame.BackgroundTransparency = 0.15
GlassFrame.BorderSizePixel = 0
GlassFrame.Parent = MainFrame

local GlassCorner = Instance.new("UICorner")
GlassCorner.CornerRadius = UDim.new(0, 14)
GlassCorner.Parent = GlassFrame

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Header.BackgroundTransparency = 0.3
Header.BorderSizePixel = 0
Header.Parent = GlassFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

local HeaderClipper = Instance.new("Frame")
HeaderClipper.Size = UDim2.new(1, 0, 0, 14)
HeaderClipper.Position = UDim2.new(0, 0, 1, -14)
HeaderClipper.BackgroundColor3 = Colors.card
HeaderClipper.BackgroundTransparency = 0.15
HeaderClipper.BorderSizePixel = 0
HeaderClipper.Parent = Header

local HeaderLine = Instance.new("Frame")
HeaderLine.Size = UDim2.new(1, -40, 0, 2)
HeaderLine.Position = UDim2.new(0, 20, 1, 0)
HeaderLine.BackgroundColor3 = Colors.accent
HeaderLine.BackgroundTransparency = 0.6
HeaderLine.BorderSizePixel = 0
HeaderLine.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 180, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡  7KM HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local TitleSub = Instance.new("TextLabel")
TitleSub.Size = UDim2.new(0, 180, 0, 14)
TitleSub.Position = UDim2.new(0, 42, 0, 30)
TitleSub.BackgroundTransparency = 1
TitleSub.Text = "PREMIUM v16.0"
TitleSub.TextColor3 = Colors.accent
TitleSub.Font = Enum.Font.Gotham
TitleSub.TextSize = 9
TitleSub.TextXAlignment = Enum.TextXAlignment.Left
TitleSub.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.BackgroundTransparency = 0.8
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Font = Enum.Font.GothamBlack
CloseBtn.TextSize = 20
CloseBtn.TextScaled = false
CloseBtn.Parent = Header
local CloseCorner = Instance.new("UICorner") CloseCorner.CornerRadius = UDim.new(0, 8) CloseCorner.Parent = CloseBtn
CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.2, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play() end)
CloseBtn.MouseLeave:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, TextColor3 = Color3.fromRGB(220, 50, 50)}):Play() end)
CloseBtn.MouseButton1Click:Connect(function()
    if KeybindConnection then KeybindConnection:Disconnect() KeybindConnection = nil end
    if FlyToggleCtrl then FlyToggleCtrl.setState(false) end
    SpeedActive = false; Flying = false; Noclip = false; InfJump = false; AimActive = false
    ESP_PlayerChams = false; ClickTPActive = false; HitboxActive = false; FOV_Circle.Visible = false
    if bV then bV:Destroy() bV = nil end; if bG then bG:Destroy() bG = nil end
    for pl, data in pairs(OriginalHitboxes) do
        pcall(function()
            if pl and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                local r = pl.Character.HumanoidRootPart
                r.Size = data.Size; r.Transparency = data.Transparency
                r.BrickColor = data.BrickColor; r.Material = data.Material
            end
        end)
    end; OriginalHitboxes = {}
    for _, p in pairs(Players:GetPlayers()) do if p.Character then local h = p.Character:FindFirstChild("7KM_Highlight") if h then h:Destroy() end end end
    if LocalPlayer.Character then for _, part in pairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end end
    ScreenGui:Destroy()
    _G["7KM_CUSTOM_LOADED"] = false
end)

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -76, 0.5, -14)
MinimizeBtn.BackgroundColor3 = Colors.text
MinimizeBtn.BackgroundTransparency = 0.85
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Colors.text
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16
MinimizeBtn.Parent = Header
local MinCorner = Instance.new("UICorner") MinCorner.CornerRadius = UDim.new(0, 8) MinCorner.Parent = MinimizeBtn
MinimizeBtn.MouseEnter:Connect(function() TweenService:Create(MinimizeBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)
MinimizeBtn.MouseLeave:Connect(function() TweenService:Create(MinimizeBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.85}):Play() end)
MinimizeBtn.MouseButton1Click:Connect(function()
    if MainFrame.Size.Y.Offset > 100 then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 700, 0, 50)}):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 700, 0, 440)}):Play()
    end
end)

TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 700, 0, 440), BackgroundTransparency = 0}):Play()

local SideBar = Instance.new("ScrollingFrame")
SideBar.Size = UDim2.new(0, 175, 1, -65)
SideBar.Position = UDim2.new(0, 6, 0, 56)
SideBar.BackgroundTransparency = 1
SideBar.BorderSizePixel = 0
SideBar.CanvasSize = UDim2.new(0, 0, 0, 380)
SideBar.ScrollBarThickness = 0
SideBar.Parent = GlassFrame

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 5)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Parent = SideBar

local Sep = Instance.new("Frame")
Sep.Size = UDim2.new(0, 2, 1, -65)
Sep.Position = UDim2.new(0, 186, 0, 56)
Sep.BackgroundColor3 = Colors.border
Sep.BorderSizePixel = 0
Sep.Parent = GlassFrame

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -202, 1, -72)
Container.Position = UDim2.new(0, 194, 0, 60)
Container.BackgroundTransparency = 1
Container.ClipsDescendants = true
Container.Parent = GlassFrame

local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, -10, 0, 20)
StatusBar.Position = UDim2.new(0, 5, 1, -5)
StatusBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StatusBar.BackgroundTransparency = 0.5
StatusBar.BorderSizePixel = 0
StatusBar.Parent = GlassFrame
local SBCorner = Instance.new("UICorner") SBCorner.CornerRadius = UDim.new(0, 6) SBCorner.Parent = StatusBar
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -10, 1, 0)
StatusText.Position = UDim2.new(0, 8, 0, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "◆ FLY: F  |  R-SHIFT: إخفاء/إظهار"
StatusText.TextColor3 = Colors.textDim
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = 10
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = StatusBar

local tabs = {}
local tabButtons = {}
local currentTab = nil

local function CreateTab(name, icon, order)
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = name .. "_Page"
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false
    TabPage.CanvasSize = UDim2.new(0, 0, 0, 460)
    TabPage.ScrollBarThickness = 3
    TabPage.ScrollBarImageColor3 = Colors.accent
    TabPage.Parent = Container
    TabPage.ClipsDescendants = true

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 7)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = TabPage

    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -8, 0, 40)
    TabBtn.BackgroundColor3 = Colors.card
    TabBtn.BackgroundTransparency = 0.5
    TabBtn.Text = ""
    TabBtn.LayoutOrder = order
    TabBtn.ClipsDescendants = true
    TabBtn.Parent = SideBar

    local BtnCorner = Instance.new("UICorner") BtnCorner.CornerRadius = UDim.new(0, 10) BtnCorner.Parent = TabBtn

    local BtnIcon = Instance.new("TextLabel")
    BtnIcon.Size = UDim2.new(0, 28, 1, 0)
    BtnIcon.Position = UDim2.new(0, 6, 0, 0)
    BtnIcon.BackgroundTransparency = 1
    BtnIcon.Text = icon
    BtnIcon.TextColor3 = Colors.textDim
    BtnIcon.Font = Enum.Font.GothamBold
    BtnIcon.TextSize = 15
    BtnIcon.Parent = TabBtn

    local BtnText = Instance.new("TextLabel")
    BtnText.Size = UDim2.new(1, -38, 1, 0)
    BtnText.Position = UDim2.new(0, 36, 0, 0)
    BtnText.BackgroundTransparency = 1
    BtnText.Text = name
    BtnText.TextColor3 = Colors.textDim
    BtnText.Font = Enum.Font.GothamBold
    BtnText.TextSize = 12
    BtnText.TextXAlignment = Enum.TextXAlignment.Left
    BtnText.Parent = TabBtn

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 3, 0, 0)
    Indicator.Position = UDim2.new(0, 0, 0.5, 0)
    Indicator.BackgroundColor3 = Colors.accent
    Indicator.BorderSizePixel = 0
    Indicator.Parent = TabBtn
    local IndCorner = Instance.new("UICorner") IndCorner.CornerRadius = UDim.new(0, 2) IndCorner.Parent = Indicator

    TabBtn.MouseEnter:Connect(function()
        if currentTab ~= TabPage then
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            TweenService:Create(BtnText, TweenInfo.new(0.2), {TextColor3 = Colors.text}):Play()
        end
    end)
    TabBtn.MouseLeave:Connect(function()
        if currentTab ~= TabPage then
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
            TweenService:Create(BtnText, TweenInfo.new(0.2), {TextColor3 = Colors.textDim}):Play()
        end
    end)

    TabBtn.MouseButton1Click:Connect(function()
        for _, page in pairs(tabs) do page.Visible = false; page.Position = UDim2.new(0, 20, 0, 0) end
        for _, btn in pairs(tabButtons) do
            btn.BackgroundTransparency = 0.5
            local t = btn:FindFirstChildOfClass("TextLabel")
            if t then TweenService:Create(t, TweenInfo.new(0.15), {TextColor3 = Colors.textDim}):Play() end
            local ind = btn:FindFirstChild("Frame")
            if ind then TweenService:Create(ind, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 0)}):Play() end
        end
        currentTab = TabPage; TabPage.Visible = true
        TabPage.Position = UDim2.new(0, -20, 0, 0)
        TweenService:Create(TabPage, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        TweenService:Create(BtnText, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 3, 0, 28)}):Play()
    end)

    tabs[name] = TabPage; tabButtons[name] = TabBtn
    return TabPage
end

local function AddButton(page, text, desc, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -6, 0, 56)
    Card.BackgroundColor3 = Colors.card
    Card.BackgroundTransparency = 0.3
    Card.ClipsDescendants = true
    Card.Parent = page
    local CardCorner = Instance.new("UICorner") CardCorner.CornerRadius = UDim.new(0, 10) CardCorner.Parent = Card
    local CardStroke = Instance.new("UIStroke") CardStroke.Color = Colors.border CardStroke.Thickness = 1 CardStroke.Transparency = 0.5 CardStroke.Parent = Card

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -165, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = desc
    Label.TextColor3 = Colors.textDim
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextWrapped = true
    Label.Parent = Card

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 150, 0, 36)
    Btn.Position = UDim2.new(1, -156, 0.5, -18)
    Btn.BackgroundColor3 = Colors.accent
    Btn.BackgroundTransparency = 0.8
    Btn.Text = text
    Btn.TextColor3 = Colors.accent
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.Parent = Card
    local btnCorner = Instance.new("UICorner") btnCorner.CornerRadius = UDim.new(0, 8) btnCorner.Parent = Btn
    local btnStroke = Instance.new("UIStroke") btnStroke.Color = Colors.accent btnStroke.Thickness = 1 btnStroke.Transparency = 0.5 btnStroke.Parent = Btn

    Btn.MouseEnter:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.2, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play(); TweenService:Create(btnStroke, TweenInfo.new(0.15), {Transparency = 0}):Play() end)
    Btn.MouseLeave:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, TextColor3 = Colors.accent}):Play(); TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play() end)
    Btn.MouseButton1Click:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.06), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(0, 0, 0)}):Play()
        TweenService:Create(Btn, TweenInfo.new(0.12), {BackgroundTransparency = 0.8, TextColor3 = Colors.accent}):Play()
        pcall(callback)
    end)
    return Btn
end

local function AddToggle(page, text, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -6, 0, 48)
    Card.BackgroundColor3 = Colors.card
    Card.BackgroundTransparency = 0.3
    Card.ClipsDescendants = true
    Card.Parent = page
    local CardCorner = Instance.new("UICorner") CardCorner.CornerRadius = UDim.new(0, 10) CardCorner.Parent = Card
    local CardStroke = Instance.new("UIStroke") CardStroke.Color = Colors.border CardStroke.Thickness = 1 CardStroke.Transparency = 0.5 CardStroke.Parent = Card

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Colors.text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 13
    Label.TextScaled = false
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Card

    local ToggleFrame = Instance.new("TextButton")
    ToggleFrame.Size = UDim2.new(0, 50, 0, 26)
    ToggleFrame.Position = UDim2.new(1, -60, 0.5, -13)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    ToggleFrame.Text = ""
    ToggleFrame.Parent = Card
    local tCorner = Instance.new("UICorner") tCorner.CornerRadius = UDim.new(1, 0) tCorner.Parent = ToggleFrame

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 20, 0, 20)
    Circle.Position = UDim2.new(0, 3, 0.5, -10)
    Circle.BackgroundColor3 = Colors.textDim
    Circle.Parent = ToggleFrame
    local cCorner = Instance.new("UICorner") cCorner.CornerRadius = UDim.new(1, 0) cCorner.Parent = Circle

    local Glow = Instance.new("Frame")
    Glow.Size = UDim2.new(0, 26, 0, 26)
    Glow.Position = UDim2.new(0, 0, 0.5, -13)
    Glow.BackgroundColor3 = Colors.accent
    Glow.BackgroundTransparency = 1
    Glow.BorderSizePixel = 0
    Glow.Parent = ToggleFrame
    local GlowCorner = Instance.new("UICorner") GlowCorner.CornerRadius = UDim.new(1, 0) GlowCorner.Parent = Glow

    local state = false
    ToggleFrame.MouseButton1Click:Connect(function()
        state = not state
        if state then
            TweenService:Create(ToggleFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = Colors.accent}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -23, 0.5, -10), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(Glow, TweenInfo.new(0.3), {BackgroundTransparency = 0.6}):Play()
        else
            TweenService:Create(ToggleFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 3, 0.5, -10), BackgroundColor3 = Colors.textDim}):Play()
            TweenService:Create(Glow, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end
        pcall(callback, state)
    end)

    return {
        setState = function(s)
            state = s
            ToggleFrame.BackgroundColor3 = s and Colors.accent or Color3.fromRGB(40, 40, 55)
            Circle.Position = s and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
            Circle.BackgroundColor3 = s and Color3.fromRGB(255, 255, 255) or Colors.textDim
            Glow.BackgroundTransparency = s and 0.6 or 1
            pcall(callback, state)
        end,
        getState = function() return state end
    }
end

local function AddSlider(page, text, min, max, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -6, 0, 56)
    Card.BackgroundColor3 = Colors.card
    Card.BackgroundTransparency = 0.3
    Card.ClipsDescendants = true
    Card.Parent = page
    local CardCorner = Instance.new("UICorner") CardCorner.CornerRadius = UDim.new(0, 10) CardCorner.Parent = Card
    local CardStroke = Instance.new("UIStroke") CardStroke.Color = Colors.border CardStroke.Thickness = 1 CardStroke.Transparency = 0.5 CardStroke.Parent = Card

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 220, 0, 22)
    Label.Position = UDim2.new(0, 12, 0, 6)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Colors.text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Card

    local ValLabel = Instance.new("TextLabel")
    ValLabel.Size = UDim2.new(0, 50, 0, 22)
    ValLabel.Position = UDim2.new(1, -58, 0, 6)
    ValLabel.BackgroundTransparency = 1
    ValLabel.Text = tostring(min)
    ValLabel.TextColor3 = Colors.accent
    ValLabel.Font = Enum.Font.GothamBold
    ValLabel.TextSize = 14
    ValLabel.Parent = Card

    local SliderBar = Instance.new("TextButton")
    SliderBar.Size = UDim2.new(1, -62, 0, 6)
    SliderBar.Position = UDim2.new(0, 12, 1, -14)
    SliderBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    SliderBar.Text = ""
    SliderBar.Parent = Card
    local SBarCorner = Instance.new("UICorner") SBarCorner.CornerRadius = UDim.new(1, 0) SBarCorner.Parent = SliderBar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0.1, 0, 1, 0)
    Fill.BackgroundColor3 = Colors.accent
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBar
    local FillCorner = Instance.new("UICorner") FillCorner.CornerRadius = UDim.new(1, 0) FillCorner.Parent = Fill

    local Thumb = Instance.new("Frame")
    Thumb.Size = UDim2.new(0, 14, 0, 14)
    Thumb.Position = UDim2.new(0.1, -7, 0.5, -7)
    Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Thumb.BorderSizePixel = 0
    Thumb.Parent = SliderBar
    local ThumbCorner = Instance.new("UICorner") ThumbCorner.CornerRadius = UDim.new(1, 0) ThumbCorner.Parent = Thumb

    local holding = false
    local function update()
        local mouseX = Mouse.X
        local barX = SliderBar.AbsolutePosition.X
        local barW = SliderBar.AbsoluteSize.X
        local pct = math.clamp((mouseX - barX) / barW, 0, 1)
        Fill.Size = UDim2.new(pct, 0, 1, 0)
        Thumb.Position = UDim2.new(pct, -7, 0.5, -7)
        local val = math.floor(min + (max - min) * pct)
        ValLabel.Text = tostring(val)
        pcall(callback, val)
    end

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            holding = true
            TweenService:Create(Thumb, TweenInfo.new(0.15), {Size = UDim2.new(0, 18, 0, 18)}):Play()
            update()
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            holding = false
            TweenService:Create(Thumb, TweenInfo.new(0.2), {Size = UDim2.new(0, 14, 0, 14)}):Play()
        end
    end)
    RunService.RenderStepped:Connect(function() if holding then update() end end)
end

-- TABS
local Page1 = CreateTab("الحركة والسرعة", "⚡", 1)
local Page2 = CreateTab("الطيران", "🛸", 2)
local Page3 = CreateTab("الاستهداف", "🎯", 3)
local Page4 = CreateTab("قائمة اللاعبين", "👤", 4)
local Page5 = CreateTab("السكربتات", "📂", 5)

-- == PAGE 1 ==
AddToggle(Page1, "تفعيل السرعة", function(s) SpeedActive = s if not s and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16 end end)
AddSlider(Page1, "قوة السرعة", 16, 300, function(v) WalkSpeedValue = v if SpeedActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v end end)
AddSlider(Page1, "قوة القفزة", 50, 300, function(v) JumpPowerValue = v if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid") h.UseJumpPower = true h.JumpPower = v end end)
AddToggle(Page1, "Click TP (Ctrl+كليك)", function(s) ClickTPActive = s end)

-- == PAGE 2 ==
local FlyToggleCtrl = AddToggle(Page2, "تفعيل الطيران", function(state)
    Flying = state
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
        local root = char.HumanoidRootPart; local hum = char:FindFirstChildOfClass("Humanoid")
        if state then
            hum.PlatformStand = true
            if bV then bV:Destroy() bV = nil end
            if bG then bG:Destroy() bG = nil end
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
            if bV then bV:Destroy() bV = nil end
            if bG then bG:Destroy() bG = nil end
            root.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)

AddSlider(Page2, "سرعة الطيران", 20, 1000, function(v) FlySpeed = v end)

local keybindBtn = AddButton(Page2, "🎮 F", "اضغط لتغيير مفتاح الطيران", function() end)
keybindBtn.MouseButton1Click:Connect(function()
    if KeybindConnection then KeybindConnection:Disconnect() end
    keybindBtn.Text = "⌨️ انتظر مفتاح..."
    local con
    con = UIS.InputBegan:Connect(function(input, proc)
        if not proc and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode ~= Enum.KeyCode.RightShift and input.KeyCode ~= Enum.KeyCode.RightControl then
            FlyToggleKey = input.KeyCode
            local kn = tostring(FlyToggleKey):gsub("Enum.KeyCode.", "")
            keybindBtn.Text = "🎮 " .. kn
            StatusText.Text = "◆ FLY: " .. kn .. "  |  R-SHIFT: إخفاء/إظهار"
            con:Disconnect()
            KeybindConnection = nil
        end
    end)
    KeybindConnection = con
end)

AddToggle(Page2, "Noclip (اختراق الجدران)", function(s) Noclip = s if not s and LocalPlayer.Character then for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end end)
AddToggle(Page2, "Inf Jump (قفز لانهائي)", function(s) InfJump = s end)

-- == PAGE 3 ==
AddToggle(Page3, "Aimbot (كليك يمين)", function(s) AimActive = s FOV_Circle.Visible = s end)
AddSlider(Page3, "FOV", 30, 400, function(v) FOV_Circle.Radius = v end)
AddToggle(Page3, "ESP أبيض", function(s) ESP_PlayerChams = s if not s then for _, p in pairs(Players:GetPlayers()) do if p.Character then local h = p.Character:FindFirstChild("7KM_Highlight") if h then h:Destroy() end end end end end)
AddToggle(Page3, "Hitbox (نيون أزرق)", function(s)
    HitboxActive = s
    if not s then
        for pl, data in pairs(OriginalHitboxes) do
            pcall(function()
                if pl and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                    local r = pl.Character.HumanoidRootPart
                    r.Size = data.Size; r.Transparency = data.Transparency
                    r.BrickColor = data.BrickColor; r.Material = data.Material; r.CanCollide = data.CanCollide
                end
            end)
        end
        OriginalHitboxes = {}
    end
end)
AddSlider(Page3, "حجم Hitbox", 2, 50, function(v) HitboxSizeValue = v end)

-- == PAGE 4 ==
local PLL = Instance.new("UIListLayout") PLL.Padding = UDim.new(0, 6) PLL.SortOrder = Enum.SortOrder.LayoutOrder PLL.Parent = Page4
local PLP = Instance.new("UIPadding") PLP.PaddingBottom = UDim.new(0, 60) PLP.Parent = Page4

local function UpdatePlayerList()
    for _, c in pairs(Page4:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    local n = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            n = n + 1
            local Card = Instance.new("Frame")
            Card.Size = UDim2.new(1, -10, 0, 48)
            Card.BackgroundColor3 = Colors.card
            Card.BackgroundTransparency = 0.3
            Card.Parent = Page4
            local ca = Instance.new("UICorner") ca.CornerRadius = UDim.new(0, 10) ca.Parent = Card
            local cs = Instance.new("UIStroke") cs.Color = Colors.border cs.Thickness = 1 cs.Transparency = 0.5 cs.Parent = Card

            local Av = Instance.new("Frame")
            Av.Size = UDim2.new(0, 30, 0, 30)
            Av.Position = UDim2.new(0, 10, 0.5, -15)
            Av.BackgroundColor3 = Colors.accent
            Av.BackgroundTransparency = 0.7
            Av.Parent = Card
            local avc = Instance.new("UICorner") avc.CornerRadius = UDim.new(1, 0) avc.Parent = Av
            local avt = Instance.new("TextLabel")
            avt.Size = UDim2.new(1, 0, 1, 0)
            avt.BackgroundTransparency = 1
            avt.Text = string.sub(p.DisplayName, 1, 1):upper()
            avt.TextColor3 = Colors.accent
            avt.Font = Enum.Font.GothamBold
            avt.TextSize = 14
            avt.Parent = Av

            local PL = Instance.new("TextLabel")
            PL.Size = UDim2.new(1, -230, 1, 0)
            PL.Position = UDim2.new(0, 48, 0, 0)
            PL.BackgroundTransparency = 1
            PL.Text = p.DisplayName
            PL.TextColor3 = Colors.text
            PL.Font = Enum.Font.GothamBold
            PL.TextSize = 13
            PL.TextXAlignment = Enum.TextXAlignment.Left
            PL.Parent = Card

            local TPB = Instance.new("TextButton")
            TPB.Size = UDim2.new(0, 70, 0, 30)
            TPB.Position = UDim2.new(1, -170, 0.5, -15)
            TPB.BackgroundColor3 = Colors.accent
            TPB.BackgroundTransparency = 0.8
            TPB.Text = "📍TP"
            TPB.TextColor3 = Colors.accent
            TPB.Font = Enum.Font.GothamBold
            TPB.TextSize = 12
            TPB.Parent = Card
            local tpc = Instance.new("UICorner") tpc.CornerRadius = UDim.new(0, 6) tpc.Parent = TPB
            local tps = Instance.new("UIStroke") tps.Color = Colors.accent tps.Thickness = 1 tps.Transparency = 0.5 tps.Parent = TPB
            TPB.MouseEnter:Connect(function() TweenService:Create(TPB, TweenInfo.new(0.15), {BackgroundTransparency = 0.2, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play() end)
            TPB.MouseLeave:Connect(function() TweenService:Create(TPB, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, TextColor3 = Colors.accent}):Play() end)

            TPB.MouseButton1Click:Connect(function()
                TweenService:Create(TPB, TweenInfo.new(0.06), {BackgroundTransparency = 0}):Play()
                TweenService:Create(TPB, TweenInfo.new(0.12), {BackgroundTransparency = 0.8}):Play()
                task.spawn(function()
                    local targetChar = p.Character
                    if not targetChar then
                        local chrCon; chrCon = p.CharacterAdded:Connect(function(c) targetChar = c end)
                        for i = 1, 50 do
                            if targetChar then break end
                            if p.Character and p.Character ~= targetChar then targetChar = p.Character; break end
                            task.wait(0.1)
                        end
                        if chrCon then chrCon:Disconnect() end
                    end
                    if not targetChar then return end
                    local root = targetChar:FindFirstChild("HumanoidRootPart")
                    for i = 1, 20 do
                        if root then break end
                        task.wait(0.1)
                        root = targetChar:FindFirstChild("HumanoidRootPart")
                    end
                    if root and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(0, 0, 3)
                    end
                end)
            end)

            local SKB = Instance.new("TextButton")
            SKB.Size = UDim2.new(0, 70, 0, 30)
            SKB.Position = UDim2.new(1, -88, 0.5, -15)
            SKB.BackgroundColor3 = Colors.gold
            SKB.BackgroundTransparency = 0.7
            SKB.Text = "👕سكن"
            SKB.TextColor3 = Colors.gold
            SKB.Font = Enum.Font.GothamBold
            SKB.TextSize = 12
            SKB.Parent = Card
            local skc = Instance.new("UICorner") skc.CornerRadius = UDim.new(0, 6) skc.Parent = SKB
            local sks = Instance.new("UIStroke") sks.Color = Colors.gold sks.Thickness = 1 sks.Transparency = 0.5 sks.Parent = SKB
            SKB.MouseEnter:Connect(function() TweenService:Create(SKB, TweenInfo.new(0.15), {BackgroundTransparency = 0.1, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play() end)
            SKB.MouseLeave:Connect(function() TweenService:Create(SKB, TweenInfo.new(0.2), {BackgroundTransparency = 0.7, TextColor3 = Colors.gold}):Play() end)

            SKB.MouseButton1Click:Connect(function()
                TweenService:Create(SKB, TweenInfo.new(0.06), {BackgroundTransparency = 0}):Play()
                TweenService:Create(SKB, TweenInfo.new(0.12), {BackgroundTransparency = 0.7}):Play()
                task.spawn(function()
                    pcall(function()
                        local myChar = LocalPlayer.Character
                        if not myChar then return end
                        local myHum = myChar:FindFirstChildOfClass("Humanoid")
                        if not myHum then return end
                        -- Primary: get official avatar description from Roblox servers
                        local ok, desc = pcall(function() return Players:GetHumanoidDescriptionFromUserId(p.UserId) end)
                        if ok and desc then
                            pcall(function() myHum:ApplyHumanoidDescription(desc) end)
                        end
                        -- Secondary: manual copy from character model for accessories and mesh
                        local tChar = p.Character
                        if tChar then
                            for _, acc in pairs(tChar:GetChildren()) do
                                if acc:IsA("Accessory") then
                                    local clone = acc:Clone()
                                    local old = myChar:FindFirstChild(acc.Name)
                                    if old then old:Destroy() end
                                    clone.Parent = myChar
                                end
                            end
                            local partNames = {"Head", "Torso", "UpperTorso", "LowerTorso", "LeftArm", "RightArm", "LeftLeg", "RightLeg", "LeftHand", "RightHand", "LeftFoot", "RightFoot"}
                            for _, n in pairs(partNames) do
                                local tp = tChar:FindFirstChild(n)
                                local mp = myChar:FindFirstChild(n)
                                if tp and mp and tp:IsA("BasePart") and mp:IsA("BasePart") then
                                    mp.Size = tp.Size; mp.Color = tp.Color; mp.Material = tp.Material
                                    mp.Shape = tp.Shape
                                    if tp:IsA("MeshPart") and mp:IsA("MeshPart") then
                                        mp.MeshId = tp.MeshId; mp.TextureID = tp.TextureID
                                    end
                                    local tMesh = tp:FindFirstChildOfClass("SpecialMesh")
                                    local mMesh = mp:FindFirstChildOfClass("SpecialMesh")
                                    if tMesh and mMesh then
                                        mMesh.MeshId = tMesh.MeshId; mMesh.TextureId = tMesh.TextureId
                                        mMesh.Scale = tMesh.Scale; mMesh.MeshType = tMesh.MeshType
                                    end
                                end
                            end
                            local tShirt = tChar:FindFirstChildOfClass("Shirt")
                            local tPants = tChar:FindFirstChildOfClass("Pants")
                            local myShirt = myChar:FindFirstChildOfClass("Shirt")
                            local myPants = myChar:FindFirstChildOfClass("Pants")
                            if not myShirt and tShirt then
                                local n = Instance.new("Shirt"); n.ShirtTemplate = tShirt.ShirtTemplate; n.Parent = myChar
                            elseif myShirt and tShirt then
                                myShirt.ShirtTemplate = tShirt.ShirtTemplate
                            end
                            if not myPants and tPants then
                                local n = Instance.new("Pants"); n.PantsTemplate = tPants.PantsTemplate; n.Parent = myChar
                            elseif myPants and tPants then
                                myPants.PantsTemplate = tPants.PantsTemplate
                            end
                        end
                    end)
                end)
            end)
        end
    end
    Page4.CanvasSize = UDim2.new(0, 0, 0, (n * 54) + 80)
end

Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)
UpdatePlayerList()

-- == PAGE 5 ==
AddButton(Page5, "تشغيل", "Dark Dex - مستكشف", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)
AddButton(Page5, "تشغيل", "Infinite Yield - ادمن", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
AddButton(Page5, "تشغيل", "Mercy Script - تخريب", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Hm5011/hussain/refs/heads/main/Mercy%20Script"))() end)

task.defer(function()
    if tabs["الحركة والسرعة"] and tabButtons["الحركة والسرعة"] then
        tabs["الحركة والسرعة"].Visible = true; currentTab = tabs["الحركة والسرعة"]
        tabButtons["الحركة والسرعة"].BackgroundTransparency = 0
        local t = tabButtons["الحركة والسرعة"]:FindFirstChildOfClass("TextLabel")
        if t then t.TextColor3 = Color3.fromRGB(255, 255, 255) end
        local ind = tabButtons["الحركة والسرعة"]:FindFirstChild("Frame")
        if ind then ind.Size = UDim2.new(0, 3, 0, 28) end
    end
end)

-- ENGINE
UIS.InputBegan:Connect(function(input, processed)
    if not processed then
        if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.RightControl then
            HubVisible = not HubVisible
            if HubVisible then
                ScreenGui.Enabled = true
                TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 700, 0, 440), BackgroundTransparency = 0}):Play()
            else
                TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 700, 0, 0), BackgroundTransparency = 1}):Play()
                task.wait(0.2)
                if not HubVisible then ScreenGui.Enabled = false end
            end
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseButton2 then HoldingRightClick = true
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 and ClickTPActive and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            local pos = Mouse.Hit.Position
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
            end
        end

        if input.KeyCode == FlyToggleKey and FlyToggleCtrl then
            FlyToggleCtrl.setState(not FlyToggleCtrl.getState())
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then HoldingRightClick = false end
end)

local function ah(c)
    local h = c:FindFirstChild("7KM_Highlight")
    if not h then h = Instance.new("Highlight") h.Name = "7KM_Highlight" h.FillColor = Color3.fromRGB(255, 255, 255) h.OutlineColor = Color3.fromRGB(255, 255, 255) h.FillTransparency = 0.15 h.OutlineTransparency = 0 h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop h.Parent = c end
end
local function rh(c) local h = c:FindFirstChild("7KM_Highlight") if h then h:Destroy() end end

RunService.RenderStepped:Connect(function()
    if FOV_Circle.Visible then FOV_Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if ESP_PlayerChams and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then ah(p.Character) else rh(p.Character) end
            if HitboxActive and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                local root = p.Character.HumanoidRootPart
                if not OriginalHitboxes[p] then OriginalHitboxes[p] = {Size = root.Size, Transparency = root.Transparency, BrickColor = root.BrickColor, Material = root.Material, CanCollide = root.CanCollide} end
                root.Size = Vector3.new(HitboxSizeValue, HitboxSizeValue, HitboxSizeValue); root.Transparency = 0.7; root.BrickColor = BrickColor.new("Really blue"); root.Material = Enum.Material.Neon; root.CanCollide = false
            end
        end
    end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
        local root = char.HumanoidRootPart; local hum = char:FindFirstChildOfClass("Humanoid")
        if SpeedActive then hum.WalkSpeed = WalkSpeedValue end
        if Flying then
            local dir = Vector3.new(0, 0, 0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
            if bG then bG.CFrame = Camera.CFrame end
            if bV then bV.Velocity = dir.Magnitude > 0 and dir.Unit * FlySpeed or Vector3.new(0, 0, 0) end
        end
        if AimActive and HoldingRightClick then
            local ct, sd = nil, math.huge
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                    local hd = p.Character.Head; local sp, os = Camera:WorldToViewportPoint(hd.Position)
                    if os then
                        local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                        if d <= FOV_Circle.Radius and d < sd then sd = d; ct = hd end
                    end
                end
            end
            if ct then Camera.CFrame = CFrame.new(Camera.CFrame.Position, ct.Position) end
        end
    end
end)

RunService.Stepped:Connect(function()
    if Noclip and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
end)

UIS.JumpRequest:Connect(function()
    if InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
