-- Cart Ride Man Adventures (Roblox) ESP + Aimbot + Misc
-- Delta Executor compatible
-- Works on Roblox game "Cart Ride Man Adventures"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ESP Settings
local espEnabled = true
local aimbotEnabled = true
local teamCheck = false
local fovRadius = 200
local smoothness = 5

-- Create ESP objects
local function createESP(plr)
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
    local box = Drawing.new("Box")
    local nameTag = Drawing.new("Text")
    local distanceText = Drawing.new("Text")
    
    box.Thickness = 1
    box.Transparency = 1
    box.Color = plr.TeamColor ~= LocalPlayer.TeamColor and Color3.new(1,0,0) or Color3.new(0,1,0)
    nameTag.Color = Color3.new(1,1,1)
    nameTag.Size = 14
    nameTag.Center = true
    nameTag.Outline = true
    distanceText.Color = Color3.new(1,1,0)
    distanceText.Size = 12
    distanceText.Center = true
    
    local espData = {box = box, nameTag = nameTag, distance = distanceText}
    
    RunService.RenderStepped:Connect(function()
        if not espEnabled or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            box.Visible = false
            nameTag.Visible = false
            distanceText.Visible = false
            return
        end
        
        local rootPart = plr.Character.HumanoidRootPart
        local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
        if onScreen then
            local distance = (Camera.CFrame.Position - rootPart.Position).Magnitude
            local scale = 3 / distance * 5
            local height = 5 * scale
            local width = 3 * scale
            box.Size = Vector2.new(width * 50, height * 50)
            box.Position = Vector2.new(screenPos.X - width * 25, screenPos.Y - height * 25)
            box.Visible = true
            nameTag.Text = plr.Name .. " | " .. math.floor(plr.Character.Humanoid.Health) .. " HP"
            nameTag.Position = Vector2.new(screenPos.X, screenPos.Y - height * 25 - 10)
            nameTag.Visible = true
            distanceText.Text = math.floor(distance) .. " studs"
            distanceText.Position = Vector2.new(screenPos.X, screenPos.Y + height * 25 + 5)
            distanceText.Visible = true
        else
            box.Visible = false
            nameTag.Visible = false
            distanceText.Visible = false
        end
    end)
end

-- Aimbot
local function getClosestPlayer()
    local closest = nil
    local shortestDist = fovRadius
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if teamCheck and plr.Team == LocalPlayer.Team then continue end
            local rootPos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(rootPos.X, rootPos.Y) - mousePos).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closest = plr
                end
            end
        end
    end
    return closest
end

-- Aimbot lock
if aimbotEnabled then
    RunService.RenderStepped:Connect(function()
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.Position
            local lookVector = (targetPos - Camera.CFrame.Position).Unit
            local newCFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + lookVector)
            Camera.CFrame = Camera.CFrame:Lerp(newCFrame, 1 / smoothness)
        end
    end)
end

-- Infinite Jump
local infiniteJump = true
local jumpConn
jumpConn = UserInputService.JumpRequest:Connect(function()
    if infiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Speed Hack
local speedHackEnabled = true
local speedMultiplier = 3
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    local origWalkSpeed = hum.WalkSpeed
    while speedHackEnabled and hum and hum.Parent do
        hum.WalkSpeed = origWalkSpeed * speedMultiplier
        task.wait()
    end
end)

-- NoClip
local noclipEnabled = false
local noclipConn
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CanCollide = false
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CanCollide = true
        end
    end
end

-- ESP activation for existing players
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        createESP(plr)
    end
end
Players.PlayerAdded:Connect(function(plr)
    if plr ~= LocalPlayer then
        createESP(plr)
    end
end)

-- GUI Menu
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local title = Instance.new("TextLabel")
local espBtn = Instance.new("TextButton")
local aimBtn = Instance.new("TextButton")
local speedBtn = Instance.new("TextButton")
local noclipBtn = Instance.new("TextButton")
local jumpBtn = Instance.new("TextButton")

screenGui.Parent = game:GetService("CoreGui")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 200, 0, 250)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0

title.Parent = frame
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Cart Ride Man | Delta"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1

espBtn.Parent = frame
espBtn.Size = UDim2.new(0, 180, 0, 30)
espBtn.Position = UDim2.new(0, 10, 0, 40)
espBtn.Text = "ESP: ON"
espBtn.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    espBtn.BackgroundColor3 = espEnabled and Color3.new(0.2, 0.6, 0.2) or Color3.new(0.6, 0.2, 0.2)
end)

aimBtn.Parent = frame
aimBtn.Size = UDim2.new(0, 180, 0, 30)
aimBtn.Position = UDim2.new(0, 10, 0, 80)
aimBtn.Text = "Aimbot: ON"
aimBtn.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
aimBtn.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimBtn.Text = aimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
    aimBtn.BackgroundColor3 = aimbotEnabled and Color3.new(0.2, 0.6, 0.2) or Color3.new(0.6, 0.2, 0.2)
end)

speedBtn.Parent = frame
speedBtn.Size = UDim2.new(0, 180, 0, 30)
speedBtn.Position = UDim2.new(0, 10, 0, 120)
speedBtn.Text = "Speed x3: ON"
speedBtn.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
speedBtn.MouseButton1Click:Connect(function()
    speedHackEnabled = not speedHackEnabled
    speedBtn.Text = speedHackEnabled and "Speed x3: ON" or "Speed x3: OFF"
    speedBtn.BackgroundColor3 = speedHackEnabled and Color3.new(0.2, 0.6, 0.2) or Color3.new(0.6, 0.2, 0.2)
end)

noclipBtn.Parent = frame
noclipBtn.Size = UDim2.new(0, 180, 0, 30)
noclipBtn.Position = UDim2.new(0, 10, 0, 160)
noclipBtn.Text = "NoClip: OFF"
noclipBtn.BackgroundColor3 = Color3.new(0.6, 0.2, 0.2)
noclipBtn.MouseButton1Click:Connect(function()
    toggleNoclip()
    noclipBtn.Text = noclipEnabled and "NoClip: ON" or "NoClip: OFF"
    noclipBtn.BackgroundColor3 = noclipEnabled and Color3.new(0.2, 0.6, 0.2) or Color3.new(0.6, 0.2, 0.2)
end)

jumpBtn.Parent = frame
jumpBtn.Size = UDim2.new(0, 180, 0, 30)
jumpBtn.Position = UDim2.new(0, 10, 0, 200)
jumpBtn.Text = "Inf Jump: ON"
jumpBtn.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
jumpBtn.MouseButton1Click:Connect(function()
    infiniteJump = not infiniteJump
    jumpBtn.Text = infiniteJump and "Inf Jump: ON" or "Inf Jump: OFF"
    jumpBtn.BackgroundColor3 = infiniteJump and Color3.new(0.2, 0.6, 0.2) or Color3.new(0.6, 0.2, 0.2)
end)
