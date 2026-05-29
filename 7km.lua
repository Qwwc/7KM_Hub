-- ================================================
-- Island GUI Script - by Claude
-- ضعه في: StarterGui > LocalScript
-- ================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- ================================================
-- متغيرات
-- ================================================
local flying = false
local flyConnection
local flySpeed = 50
local currentSpeed = 16

-- ================================================
-- إنشاء الـ GUI
-- ================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "IslandGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- الإطار الرئيسي
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 420)
mainFrame.Position = UDim2.new(0, 20, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- زوايا مستديرة
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- خط علوي ملون
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 4)
topBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame
local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar

-- العنوان
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 45)
titleLabel.Position = UDim2.new(0, 0, 0, 8)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🏝️ Island Menu"
titleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- ================================================
-- دالة إنشاء زر
-- ================================================
local function createButton(text, yPos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 42)
    btn.Position = UDim2.new(0.075, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 50)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = mainFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    -- تأثير hover
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = color or Color3.fromRGB(30, 30, 50)
        }):Play()
    end)

    return btn
end

-- ================================================
-- Slider السرعة
-- ================================================
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.85, 0, 0, 20)
speedLabel.Position = UDim2.new(0.075, 0, 0, 58)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ السرعة: 16"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
speedLabel.TextSize = 13
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = mainFrame

local sliderBg = Instance.new("Frame")
sliderBg.Size = UDim2.new(0.85, 0, 0, 10)
sliderBg.Position = UDim2.new(0.075, 0, 0, 82)
sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
sliderBg.BorderSizePixel = 0
sliderBg.Parent = mainFrame
local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 5)
sliderCorner.Parent = sliderBg

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.16, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBg
local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 5)
fillCorner.Parent = sliderFill

-- تحريك الـ slider
local dragging = false
sliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local sliderPos = sliderBg.AbsolutePosition.X
        local sliderWidth = sliderBg.AbsoluteSize.X
        local mouseX = input.Position.X
        local ratio = math.clamp((mouseX - sliderPos) / sliderWidth, 0, 1)
        sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
        currentSpeed = math.floor(ratio * 200) + 16
        speedLabel.Text = "⚡ السرعة: " .. currentSpeed
        humanoid.WalkSpeed = currentSpeed
    end
end)

-- ================================================
-- زر الطيران
-- ================================================
local flyBtn = createButton("🕊️ الطيران: OFF", 105, Color3.fromRGB(30, 30, 50))

local function stopFlying()
    flying = false
    flyBtn.Text = "🕊️ الطيران: OFF"
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    for _, obj in pairs(rootPart:GetChildren()) do
        if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") then
            obj:Destroy()
        end
    end
    humanoid.PlatformStand = false
end

local function startFlying()
    flying = true
    flyBtn.Text = "🕊️ الطيران: ON"
    humanoid.PlatformStand = true

    local bodyVel = Instance.new("BodyVelocity")
    bodyVel.Velocity = Vector3.new(0, 0, 0)
    bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVel.Parent = rootPart

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P = 1e4
    bodyGyro.Parent = rootPart

    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying then return end

        local camDir = camera.CFrame.LookVector
        local moveDir = Vector3.new(0, 0, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + camDir
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - camDir
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end

        if moveDir.Magnitude > 0 then
            bodyVel.Velocity = moveDir.Unit * flySpeed
        else
            bodyVel.Velocity = Vector3.new(0, 0, 0)
        end

        bodyGyro.CFrame = camera.CFrame
    end)
end

flyBtn.MouseButton1Click:Connect(function()
    if flying then
        stopFlying()
    else
        startFlying()
    end
end)

-- ================================================
-- Slider سرعة الطيران
-- ================================================
local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Size = UDim2.new(0.85, 0, 0, 20)
flySpeedLabel.Position = UDim2.new(0.075, 0, 0, 155)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.Text = "✈️ سرعة الطيران: 50"
flySpeedLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
flySpeedLabel.TextSize = 13
flySpeedLabel.Font = Enum.Font.Gotham
flySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
flySpeedLabel.Parent = mainFrame

local flySliderBg = Instance.new("Frame")
flySliderBg.Size = UDim2.new(0.85, 0, 0, 10)
flySliderBg.Position = UDim2.new(0.075, 0, 0, 178)
flySliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
flySliderBg.BorderSizePixel = 0
flySliderBg.Parent = mainFrame
local flySliderCorner = Instance.new("UICorner")
flySliderCorner.CornerRadius = UDim.new(0, 5)
flySliderCorner.Parent = flySliderBg

local flySliderFill = Instance.new("Frame")
flySliderFill.Size = UDim2.new(0.25, 0, 1, 0)
flySliderFill.BackgroundColor3 = Color3.fromRGB(100, 255, 180)
flySliderFill.BorderSizePixel = 0
flySliderFill.Parent = flySliderBg
local flyFillCorner = Instance.new("UICorner")
flyFillCorner.CornerRadius = UDim.new(0, 5)
flyFillCorner.Parent = flySliderFill

local flyDragging = false
flySliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        flyDragging = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        flyDragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if flyDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local sliderPos = flySliderBg.AbsolutePosition.X
        local sliderWidth = flySliderBg.AbsoluteSize.X
        local mouseX = input.Position.X
        local ratio = math.clamp((mouseX - sliderPos) / sliderWidth, 0, 1)
        flySliderFill.Size = UDim2.new(ratio, 0, 1, 0)
        flySpeed = math.floor(ratio * 200) + 10
        flySpeedLabel.Text = "✈️ سرعة الطيران: " .. flySpeed
    end
end)

-- ================================================
-- أزرار الأنميشن
-- ================================================
local animLabel = Instance.new("TextLabel")
animLabel.Size = UDim2.new(0.85, 0, 0, 20)
animLabel.Position = UDim2.new(0.075, 0, 0, 200)
animLabel.BackgroundTransparency = 1
animLabel.Text = "🎭 الأنميشن"
animLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
animLabel.TextSize = 13
animLabel.Font = Enum.Font.GothamBold
animLabel.TextXAlignment = Enum.TextXAlignment.Left
animLabel.Parent = mainFrame

-- الأنميشنات (IDs رسمية من Roblox)
local animations = {
    {name = "💃 رقص", id = "rbxassetid://182435998"},
    {name = "🤸 شقلبة", id = "rbxassetid://282574440"},
    {name = "👋 تحية", id = "rbxassetid://507770239"},
}

local currentAnim = nil
for i, anim in ipairs(animations) do
    local animBtn = createButton(anim.name, 195 + (i * 48), Color3.fromRGB(40, 20, 60))
    animBtn.MouseButton1Click:Connect(function()
        if currentAnim then
            currentAnim:Stop()
        end
        local animation = Instance.new("Animation")
        animation.AnimationId = anim.id
        currentAnim = humanoid:LoadAnimation(animation)
        currentAnim:Play()
    end)
end

-- زر إيقاف الأنميشن
local stopAnimBtn = createButton("⏹️ إيقاف الأنميشن", 195 + (4 * 48), Color3.fromRGB(80, 20, 20))
stopAnimBtn.MouseButton1Click:Connect(function()
    if currentAnim then
        currentAnim:Stop()
        currentAnim = nil
    end
end)

-- ================================================
-- تعليمات الطيران
-- ================================================
local hintLabel = Instance.new("TextLabel")
hintLabel.Size = UDim2.new(0.85, 0, 0, 30)
hintLabel.Position = UDim2.new(0.075, 0, 1, -38)
hintLabel.BackgroundTransparency = 1
hintLabel.Text = "W/A/S/D + Space/Ctrl للطيران"
hintLabel.TextColor3 = Color3.fromRGB(100, 100, 130)
hintLabel.TextSize = 11
hintLabel.Font = Enum.Font.Gotham
hintLabel.TextWrapped = true
hintLabel.Parent = mainFrame

-- ================================================
-- إعادة تعيين عند respawn
-- ================================================
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
    flying = false
    flyBtn.Text = "🕊️ الطيران: OFF"
end)

print("✅ Island GUI loaded!")
