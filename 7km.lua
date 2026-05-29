-- Xeno Study Hub v2 - Enhanced for Research
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local gui = Instance.new("ScreenGui")
gui.Name = "XenoStudyHubV2"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 580)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -290)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 55)
title.BackgroundColor3 = Color3.fromRGB(0, 110, 230)
title.Text = "XENO STUDY HUB v2"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -75)
scroll.Position = UDim2.new(0, 10, 0, 65)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 8
scroll.Parent = mainFrame

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 12)
list.Parent = scroll

-- Variables
local flying = false
local noclipping = false
local infJump = false
local speedValue = 50

-- Better Fly Function
local function toggleFly()
    flying = not flying
    if flying then
        local bv = Instance.new("BodyVelocity")
        local bg = Instance.new("BodyGyro")
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = root
        bg.Parent = root
        
        spawn(function()
            while flying and root and root.Parent do
                local cam = workspace.CurrentCamera
                local dir = Vector3.new(0,0,0)
                local uis = game:GetService("UserInputService")
                
                if uis:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
                if uis:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
                
                bv.Velocity = dir.Unit * speedValue * 4
                bg.CFrame = cam.CFrame
                wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end)
        print("✅ Fly Activated")
    else
        print("❌ Fly Deactivated")
    end
end

-- Create Button Function
local function addButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 55)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 17
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = scroll
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

-- === Movement Section ===
addButton("Speed: Set Value", function()
    local value = tonumber(game:GetService("StarterGui"):SetCore("PromptForInput", {
        Title = "Set Speed",
        Description = "أدخل السرعة (مثال: 100)",
        DefaultText = tostring(speedValue)
    }))
    if value then
        speedValue = value
        humanoid.WalkSpeed = value
        print("Speed set to: " .. value)
    end
end)

addButton("Fly: Toggle", toggleFly)

addButton("Noclip: Toggle", function()
    noclipping = not noclipping
    print("Noclip: " .. (noclipping and "ON" or "OFF"))
    spawn(function()
        while noclipping do
            for _, v in pairs(character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
            game:GetService("RunService").Stepped:Wait()
        end
    end)
end)

addButton("Infinite Jump: Toggle", function()
    infJump = not infJump
    print("Infinite Jump: " .. (infJump and "ON" or "OFF"))
end)

-- === Aimbot Section ===
addButton("Aimbot: Toggle (Nearest)", function()
    -- Simple Aimbot
    local target = nil
    local dist = math.huge
    
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            local d = (p.Character.Head.Position - root.Position).Magnitude
            if d < dist then
                dist = d
                target = p.Character.Head
            end
        end
    end
    
    if target then
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position)
        print("Aimbot locked on: " .. target.Parent.Name)
    else
        print("No target found")
    end
end)

-- Animations
addButton("Animation: Strong Attack", function()
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://136801251"
    humanoid:LoadAnimation(anim):Play()
end)

addButton("Animation: Spin Kick", function()
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://333333131"
    humanoid:LoadAnimation(anim):Play()
end)

addButton("Animation: Hero Landing", function()
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://101439041"
    humanoid:LoadAnimation(anim):Play()
end)

-- Infinite Jump
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

print("✅ Xeno Study Hub v2 Loaded - Use for Research & Anti-Cheat Testing Only")
