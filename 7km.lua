-- Xeno Study Hub - Advanced Test Script
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local gui = Instance.new("ScreenGui")
gui.Name = "XenoStudyHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 520)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

-- Shadow Effect
local shadow = Instance.new("UIStroke")
shadow.Thickness = 2
shadow.Color = Color3.fromRGB(0, 170, 255)
shadow.Transparency = 0.7
shadow.Parent = mainFrame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
title.Text = "XENO STUDY HUB"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- Scrolling Frame
local scrolling = Instance.new("ScrollingFrame")
scrolling.Size = UDim2.new(1, -20, 1, -70)
scrolling.Position = UDim2.new(0, 10, 0, 60)
scrolling.BackgroundTransparency = 1
scrolling.ScrollBarThickness = 6
scrolling.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.Parent = scrolling

-- Functions
local flying = false
local noclipping = false
local speedValue = 50
local infJump = false

-- Fly Function
local function startFly()
    flying = true
    local bodyVelocity = Instance.new("BodyVelocity")
    local bodyGyro = Instance.new("BodyGyro")
    bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    bodyVelocity.Parent = character.HumanoidRootPart
    bodyGyro.Parent = character.HumanoidRootPart

    spawn(function()
        while flying and character and character:FindFirstChild("HumanoidRootPart") do
            local cam = workspace.CurrentCamera
            local moveDirection = Vector3.new()
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + cam.CFrame.LookVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - cam.CFrame.LookVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - cam.CFrame.RightVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + cam.CFrame.RightVector end
            bodyVelocity.Velocity = moveDirection.Unit * speedValue * 3
            bodyGyro.CFrame = cam.CFrame
            game:GetService("RunService").Heartbeat:Wait()
        end
        bodyVelocity:Destroy()
        bodyGyro:Destroy()
    end)
end

-- Buttons
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 50)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = scrolling
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

createButton("Speed: ON ("..speedValue..")", function()
    speedValue = speedValue + 20
    humanoid.WalkSpeed = speedValue
    print("Speed set to: " .. speedValue)
end)

createButton("Fly: Toggle", function()
    flying = not flying
    if flying then
        startFly()
        print("Fly Activated")
    else
        print("Fly Deactivated")
    end
end)

createButton("Noclip: Toggle", function()
    noclipping = not noclipping
    if noclipping then
        spawn(function()
            while noclipping do
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                game:GetService("RunService").Stepped:Wait()
            end
        end)
        print("Noclip Activated")
    else
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        print("Noclip Deactivated")
    end
end)

createButton("Infinite Jump: Toggle", function()
    infJump = not infJump
    print("Infinite Jump: " .. (infJump and "ON" or "OFF"))
end)

-- Infinite Jump Connection
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Animations Section
createButton("Animation: Strong Punch", function()
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://136801251"  -- Strong Punch
    humanoid:LoadAnimation(anim):Play()
end)

createButton("Animation: Epic Spin", function()
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://333333131"  -- Spin
    humanoid:LoadAnimation(anim):Play()
end)

createButton("Animation: Hero Pose", function()
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://101439041"  
    humanoid:LoadAnimation(anim):Play()
end)

print("✅ Xeno Study Hub Loaded Successfully - For Research Only")
