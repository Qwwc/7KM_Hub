-- [1] فحص منع التكرار وتخطي الحمايات (نفس كودك بالملي)
if IY_LOADED and not _G.IY_DEBUG then
	return
end

pcall(function() getgenv().IY_LOADED = true end)
if not game:IsLoaded() then game.Loaded:Wait() end

function missing(t, f, fallback)
	if type(f) == t then return f end
	return fallback
end

cloneref = missing("function", cloneref, function(...) return ... end)
sethidden =  missing("function", sethiddenproperty or set_hidden_property or set_hidden_prop)
gethidden =  missing("function", gethiddenproperty or get_hidden_property or get_hidden_prop)
queueteleport =  missing("function", queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport))
httprequest =  missing("function", request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request))
everyClipboard = missing("function", setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set))
firetouchinterest = missing("function", firetouchinterest)

Services = setmetatable({}, {
	__index = function(self, name)
		local success, cache = pcall(function()
			return cloneref(game:GetService(name))
		end)
		if success then
			rawset(self, name, cache)
			return cache
		else
			error("Invalid Service: " .. tostring(name))
		end
	end
})

Players = Services.Players
UserInputService = Services.UserInputService
RunService = Services.RunService
Camera = workspace.CurrentCamera
LocalPlayer = Players.LocalPlayer

function randomString()
	local length = math.random(10,20)
	local array = {}
	for i = 1, length do
		array[i] = string.char(math.random(32, 126))
	end
	return table.concat(array)
end

PARENT = nil
MAX_DISPLAY_ORDER = 2147483647
if gethui then
    PARENT = gethui()
elseif cloneref(game:GetService("CoreGui")):FindFirstChild("RobloxGui") then
    PARENT = cloneref(game:GetService("CoreGui")).RobloxGui
else
    local Main = Instance.new("ScreenGui")
    Main.Name = randomString()
    Main.ResetOnSpawn = false
    Main.DisplayOrder = MAX_DISPLAY_ORDER
    Main.Parent = cloneref(game:GetService("CoreGui"))
    PARENT = Main
end

------------------------------------------------------------------------
-- [2] بناء عناصر القائمة القديمة حقتك بالملي وتعديل الحقوق لـ 7KM
------------------------------------------------------------------------
currentVersion = "7.5 (Premium)"

ScaledHolder = Instance.new("Frame")
ScaledHolder.Name = randomString()
ScaledHolder.Size = UDim2.fromScale(1, 1)
ScaledHolder.BackgroundTransparency = 1
ScaledHolder.Parent = PARENT

Holder = Instance.new("Frame")
Holder.Name = randomString()
Holder.Parent = ScaledHolder
Holder.Active = true
Holder.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Holder.BorderSizePixel = 0
Holder.Position = UDim2.new(1, -250, 1, -220)
Holder.Size = UDim2.new(0, 250, 0, 220)
Holder.ZIndex = 10

Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Holder
Title.Active = true
Title.BackgroundColor3 = Color3.fromRGB(36,36,37)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(0, 250, 0, 20)
Title.Font = Enum.Font.SourceSans
Title.TextSize = 18
-- تغيير عنوان اللوحة الرئيسي باسمك وحقوقك
Title.Text = "7KM Hub Premium v" .. currentVersion
Title.TextColor3 = Color3.new(1, 1, 1)
Title.ZIndex = 10

Dark = Instance.new("Frame")
Dark.Name = "Dark"
Dark.Parent = Holder
Dark.Active = true
Dark.BackgroundColor3 = Color3.fromRGB(36, 36, 37)
Dark.BorderSizePixel = 0
Dark.Position = UDim2.new(0, 0, 0, 45)
Dark.Size = UDim2.new(0, 250, 0, 175)
Dark.ZIndex = 10

Cmdbar = Instance.new("TextBox")
Cmdbar.Name = "Cmdbar"
Cmdbar.Parent = Holder
Cmdbar.BackgroundTransparency = 1
Cmdbar.BorderSizePixel = 0
Cmdbar.Position = UDim2.new(0, 5, 0, 20)
Cmdbar.Size = UDim2.new(0, 240, 0, 25)
Cmdbar.Font = Enum.Font.SourceSans
Cmdbar.TextSize = 18
Cmdbar.TextXAlignment = Enum.TextXAlignment.Left
Cmdbar.TextColor3 = Color3.new(1, 1, 1)
Cmdbar.Text = ""
Cmdbar.ZIndex = 10
Cmdbar.PlaceholderText = "Type Command Here..."

CMDsF = Instance.new("ScrollingFrame")
CMDsF.Name = "CMDs"
CMDsF.Parent = Holder
CMDsF.BackgroundTransparency = 1
CMDsF.BorderSizePixel = 0
CMDsF.Position = UDim2.new(0, 5, 0, 45)
CMDsF.Size = UDim2.new(0, 245, 0, 175)
CMDsF.ScrollBarThickness = 8
CMDsF.ZIndex = 10

cmdListLayout = Instance.new("UIListLayout")
cmdListLayout.Parent = CMDsF

-- شريط الحقوق السفلي (مسح المطورين القدامى ووضع اسمك)
Credits = Instance.new("TextBox")
Credits.Name = "Credits"
Credits.Parent = Holder
Credits.BackgroundTransparency = 1
Credits.BorderSizePixel = 0
Credits.Position = UDim2.new(0, 0, 0.9, 30)
Credits.Size = UDim2.new(0, 250, 0, 20)
Credits.Font = Enum.Font.SourceSansLight
Credits.FontSize = Enum.FontSize.Size14
Credits.Text = "Developed & Optimized by 7KM © 2026"
Credits.TextColor3 = Color3.new(1, 1, 1)
Credits.ZIndex = 10

------------------------------------------------------------------------
-- [3] إضافة الأزرار والميزات داخل الـ Scrolling Frame حق قائمة الأوامر
------------------------------------------------------------------------
local function createCommandLabel(text, desc)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 25)
	btn.BackgroundTransparency = 1
	btn.Text = "  " .. text .. " - " .. desc
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 14
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = CMDsF
	return btn
end

-- متغيرات تشغيل الميزات الفيزيائية والأيم بوت
local WalkSpeedValue = 16
local SpeedActive = false
local FlySpeed = 50
local Flying = false
local Noclip = false
local InfJump = false
local AimActive = false
local IsRightClicking = false
local bV, bG

-- إعداد حلقة تحديد الهدف للـ Aimbot
local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Color = Color3.fromRGB(180, 0, 0)
FOV_Circle.Thickness = 1.5
FOV_Circle.NumSides = 64
FOV_Circle.Radius = 120
FOV_Circle.Visible = false

-- تفعيل الأوامر كأزرار قابلة للضغط داخل القائمة نفسها
local btnSpeed = createCommandLabel("speed [toggle]", "تفعيل السرعة الحادة بدون تزحلق")
local btnFly = createCommandLabel("fly [toggle]", "تفعيل الطيران الموجه مع الكاميرا")
local btnNoclip = createCommandLabel("noclip [toggle]", "اختراق الجدران والأبواب")
local btnInf = createCommandLabel("infjump [toggle]", "القفز اللانهائي في الهواء")
local btnAim = createCommandLabel("aimbot [toggle]", "تفعيل الايم بوت (كلك يمين)")

btnSpeed.MouseButton1Click:Connect(function()
	SpeedActive = not SpeedActive
	btnSpeed.TextColor3 = SpeedActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
end)

btnFly.MouseButton1Click:Connect(function()
	Flying = not Flying
	btnFly.TextColor3 = Flying and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
		local root = char.HumanoidRootPart
		local hum = char:FindFirstChildOfClass("Humanoid")
		if Flying then
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

btnNoclip.MouseButton1Click:Connect(function()
	Noclip = not Noclip
	btnNoclip.TextColor3 = Noclip and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
end)

btnInf.MouseButton1Click:Connect(function()
	InfJump = not InfJump
	btnInf.TextColor3 = InfJump and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
end)

btnAim.MouseButton1Click:Connect(function()
	AimActive = not AimActive
	FOV_Circle.Visible = AimActive
	btnAim.TextColor3 = AimActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
end)

------------------------------------------------------------------------
-- [4] تشغيل تنفيذ الأوامر عبر الكتابة في الـ Cmdbar الذكي
------------------------------------------------------------------------
Cmdbar.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local text = Cmdbar.Text:lower()
		Cmdbar.Text = ""
		
		if text == "speed" then
			SpeedActive = not SpeedActive
			btnSpeed.TextColor3 = SpeedActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
		elseif text:sub(1,6) == "speed " then
			local num = tonumber(text:sub(7))
			if num then WalkSpeedValue = num SpeedActive = true end
		elseif text == "fly" then
			Flying = not Flying
			-- تنفيذ دالة الطيران تلقائياً عند الكتابة
		elseif text == "noclip" then
			Noclip = not Noclip
		elseif text == "aimbot" then
			AimActive = not AimActive
			FOV_Circle.Visible = AimActive
		end
	end
end)

------------------------------------------------------------------------
-- [5] المحركات البرمجية المتوافقة مع فريمات اللعبة
------------------------------------------------------------------------
UserInputService.InputBegan:Connect(function(input, proc)
	if not proc and input.UserInputType == Enum.UserInputType.MouseButton2 then IsRightClicking = true end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then IsRightClicking = false end
end)

local function getClosestPlayer()
	local target, shortest = nil, math.huge
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
			if p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
				local screenPos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
				if onScreen then
					local dist = (Vector2.new(screenPos.X, screenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
					if dist <= FOV_Circle.Radius and dist < shortest then
						shortest = dist
						target = p.Character
					end
				end
			end
		end
	end
