-- حذف أي واجهة قديمة لتفادي التكرار والتعليق
local ScreenGui = game:GetService("CoreGui"):FindFirstChild("7KM_Custom_Hub")
if ScreenGui then ScreenGui:Destroy() end

-- إنشاء الواجهة محلياً بالكامل
ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local Credit = Instance.new("TextLabel")

-- إنشاء حاوية داخلية لترتيب العناصر بشكل متناسق وقابل للتمرير
local ScrollingFrame = Instance.new("ScrollingFrame")

ScreenGui.Name = "7KM_Custom_Hub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- تصميم اللوحة الرئيسية (نفس ثيم وستايل اللوحة الشغالة عندك)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.35, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 340, 0, 420)
MainFrame.Active = true
MainFrame.Draggable = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- عنوان اللوحة
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "7KM Hub | Premium Edition v6.5"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- زر إغلاق اللوحة
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
CloseBtn.Position = UDim2.new(0.88, 0, 0, 0)
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18
CloseBtn.BackgroundTransparency = 1

-- صندوق التمرير الداخلي للأزرار المتعددة
ScrollingFrame.Parent = MainFrame
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollingFrame.Size = UDim2.new(1, -20, 1, -80)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 550)
ScrollingFrame.ScrollBarThickness = 4

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

------------------------------------------------------------------------
-- دالة مساعدة لإنشاء الأزرار والعناصر بنفس التصميم الرمادي الأنيق
------------------------------------------------------------------------
local function createButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Font = Enum.Font.SourceSans
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.LayoutOrder = order
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    btn.Parent = ScrollingFrame
    return btn
end

local function createSlider(text, min, max, default, order, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 55)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.LayoutOrder = order
    
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 6)
    fCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Parent = frame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(0.9, 0, 0, 6)
    sliderBar.Position = UDim2.new(0.05, 0, 0.65, 0)
    sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBar.Parent = frame
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 14, 0, 14)
    sliderBtn.Position = UDim2.new((default - min)/(max - min), -7, 0.5, -7)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderBar
    
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = sliderBtn
    
    local dragging = false
    sliderBtn.MouseButton1Down:Connect(function() dragging = true end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if dragging then
            local mousePos = game:GetService("Players").LocalPlayer:GetMouse().X
            local barLeft = sliderBar.AbsolutePosition.X
            local barWidth = sliderBar.AbsoluteSize.X
            local percentage = math.clamp((mousePos - barLeft) / barWidth, 0, 1)
            sliderBtn.Position = UDim2.new(percentage, -7, 0.5, -7)
            local value = math.floor(min + (max - min) * percentage)
            label.Text = text .. ": " .. value
            callback(value)
        end
    end)
    
    frame.Parent = ScrollingFrame
end

------------------------------------------------------------------------
-- بناء عناصر القائمة والتحكم
------------------------------------------------------------------------
local SpeedBtn = createButton("تفعيل السرعة العالية الثابتة", 1)
createSlider("تعديل قوة السرعة", 16, 300, 100, 2, function(v) WalkSpeedValue = v end)

local AimBtn = createButton("تفعيل الـ Aimbot (كلك يمين للتشبيك)", 3)
createSlider("تعديل مجال الرؤية (FOV)", 30, 400, 120, 4, function(v) FOV_Circle.Radius = v end)

-- قائمة اللاعبين المنسدلة (Dropdown) المحدثة تلقائياً
local DropdownFrame = Instance.new("Frame")
DropdownFrame.Size = UDim2.new(1, 0, 0, 45)
DropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DropdownFrame.LayoutOrder = 5
local dCorner = Instance.new("UICorner")
dCorner.CornerRadius = UDim.new(0, 6)
dCorner.Parent = DropdownFrame

local DropdownBtn = Instance.new("TextButton")
DropdownBtn.Size = UDim2.new(1, 0, 1, 0)
DropdownBtn.BackgroundTransparency = 1
DropdownBtn.Font = Enum.Font.SourceSans
DropdownBtn.Text = "اختر لاعب من السيرفر..."
DropdownBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
DropdownBtn.TextSize = 15
DropdownBtn.Parent = DropdownFrame
DropdownFrame.Parent = ScrollingFrame

local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Size = UDim2.new(1, 0, 0, 120)
PlayerListFrame.Position = UDim2.new(0, 0, 1, 5)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PlayerListFrame.Visible = false
PlayerListFrame.ZIndex = 10
local pCorner = Instance.new("UICorner")
pCorner.CornerRadius = UDim.new(0, 6)
pCorner.Parent = PlayerListFrame
PlayerListFrame.Parent = DropdownFrame

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1, -10, 1, -10)
PlayerScroll.Position = UDim2.new(0, 5, 0, 5)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScroll.ScrollBarThickness = 3
PlayerScroll.ZIndex = 11
PlayerScroll.Parent = PlayerListFrame

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.Parent = PlayerScroll
PlayerListLayout.Padding = UDim.new(0, 5)

-- تحديث قائمة اللاعبين برمجياً
local selectedPlayer = nil
local function updatePlayerList()
    for _, child in pairs(PlayerScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local count = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            count = count + 1
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, 0, 0, 30)
            pBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            pBtn.Text = p.DisplayName .. " (@" .. p.Name .. ")"
            pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            pBtn.TextSize = 13
            pBtn.ZIndex = 12
            
            local pbCorner = Instance.new("UICorner")
            pbCorner.CornerRadius = UDim.new(0, 4)
            pbCorner.Parent = pBtn
            
            pBtn.MouseButton1Click:Connect(function()
                selectedPlayer = p
                DropdownBtn.Text = "اللاعب المحدد: " .. p.Name
                PlayerListFrame.Visible = false
            end)
            pBtn.Parent = PlayerScroll
        end
    end
    PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, count * 35)
end

DropdownBtn.MouseButton1Click:Connect(function()
    PlayerListFrame.Visible = not PlayerListFrame.Visible
    if PlayerListFrame.Visible then updatePlayerList() end
end)

-- تذييل الحقوق والمطور
Credit.Name = "Credit"
Credit.Parent = MainFrame
Credit.BackgroundTransparency = 1
Credit.Position = UDim2.new(0, 0, 0.93, 0)
Credit.Size = UDim2.new(1, 0, 0, 20)
Credit.Font = Enum.Font.SourceSansItalic
Credit.Text = "Developed by 7KM © 2026"
Credit.TextColor3 = Color3.fromRGB(150, 150, 150)
Credit.TextSize = 12

------------------------------------------------------------------------
-- المحركات الخلفية والفيزيائية (السرعة الثابتة والـ Aimbot)
------------------------------------------------------------------------
local Camera = workspace.CurrentCamera
local SpeedActive = false
local AimActive = false
local IsRightClicking = false

WalkSpeedValue = 100

-- إعداد دائرة الـ FOV المرئية
local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Color = Color3.fromRGB(180, 0, 0)
FOV_Circle.Thickness = 1.5
FOV_Circle.NumSides = 64
FOV_Circle.Radius = 120
FOV_Circle.Filled = false
FOV_Circle.Visible = false

SpeedBtn.MouseButton1Click:Connect(function()
    SpeedActive = not SpeedActive
    if SpeedActive then
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
        SpeedBtn.Text = "السرعة الثابتة: مفعلة"
    else
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        SpeedBtn.Text = "تفعيل السرعة العالية الثابتة"
    end
end)

AimBtn.MouseButton1Click:Connect(function()
    AimActive = not AimActive
    FOV_Circle.Visible = AimActive
    if AimActive then
        AimBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
        AimBtn.Text = "الـ Aimbot: نشط (علق كلك يمين)"
    else
        AimBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        AimBtn.Text = "تفعيل الـ Aimbot (كلك يمين للتشبيك)"
    end
end)

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

-- دالة جلب أقرب لاعب داخل دائرة الـ FOV ونطاق الرؤية
local function getClosestPlayer()
    local closestTarget = nil
    local shortestDistance = math.huge
    
    -- إذا اختار اللاعب شخصاً محدداً من القائمة المنسدلة، نعطيه الأولوية
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = selectedPlayer.Character.HumanoidRootPart
        local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
        if onScreen then
            local mousePos = UIS:GetMouseLocation()
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
            if distance <= FOV_Circle.Radius then
                return selectedPlayer.Character
            end
        end
    end
    
    -- إذا لم يتم تحديد لاعب معين، يبحث عن الأقرب في السيرفر تلقائياً
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

-- المحرك الموحد المربوط مع الفريمات (الحركة الدقيقة والـ Aim)
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
        local root = char.HumanoidRootPart
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        -- تطبيق محرك السرعة الفيزيائي السلس (بدون أي تزحلق عند التوقف)
        if SpeedActive then
            local moveDirection = hum.MoveDirection
            if moveDirection.Magnitude > 0 then
                -- دفع فيزيائي متزامن مع الاتجاه لضمان استجابة وقوف حادة وفورية
                root.Velocity = Vector3.new(moveDirection.X * WalkSpeedValue, root.Velocity.Y, moveDirection.Z * WalkSpeedValue)
            end
        end
        
        -- تشغيل الـ Aimbot عند تفعيله وضغط كلك يمين معاً
        if AimActive and IsRightClicking then
            local target = getClosestPlayer()
            if target and target:FindFirstChild("Head") then
                -- توجيه الكاميرا بسلاسة تامة نحو رأس الضحية مباشرة
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Head.Position)
            end
        end
    end
    
    -- تحديث موقع دائرة الـ FOV مع الماوس باستمرار
    if FOV_Circle.Visible then
        FOV_Circle.Position = UIS:GetMouseLocation()
    end
end)

-- إغلاق وتنظيف اللوحة بالكامل عند الضغط على زر X
CloseBtn.MouseButton1Click:Connect(function()
    FOV_Circle.Visible = false
    FOV_Circle:Delete()
    ScreenGui:Destroy()
end)
