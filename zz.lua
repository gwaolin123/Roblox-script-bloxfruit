-- Blox Fruits WORKING SCRIPT (Current Version)
-- NO PASSWORD - GUI with working Auto Farm

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Find all enemies in the game
local function findAllEnemies()
    local enemies = {}
    -- Search through all models in workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            local humanoid = obj.Humanoid
            if humanoid.Health > 0 and obj ~= LocalPlayer.Character then
                -- Check if it's an NPC/enemy (not another player)
                local isNPC = true
                if Players:FindFirstChild(obj.Name) then
                    isNPC = false
                end
                if isNPC then
                    table.insert(enemies, obj)
                end
            end
        end
    end
    return enemies
end

-- Speed Hack
local function setSpeed()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 45
        char.Humanoid.JumpPower = 80
    end
end

-- Auto Farm (attack nearest enemy)
local function autoFarm()
    local enemies = findAllEnemies()
    local nearest = nil
    local nearestDist = 50
    
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    for _, enemy in pairs(enemies) do
        if enemy:FindFirstChild("HumanoidRootPart") then
            local dist = (hrp.Position - enemy.HumanoidRootPart.Position).Magnitude
            if dist < nearestDist then
                nearest = enemy
                nearestDist = dist
            end
        end
    end
    
    if nearest then
        -- Face the enemy
        hrp.CFrame = CFrame.new(hrp.Position, nearest.HumanoidRootPart.Position)
        -- Move close if far
        if nearestDist > 10 then
            hrp.CFrame = nearest.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
        end
        -- Attack
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
    end
end

-- Auto Collect (fruits and chests)
local function autoCollect()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Tool") then
            local name = obj.Name:lower()
            if name:find("fruit") or name:find("chest") or name:find("apple") or name:find("orange") then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local dist = (char.HumanoidRootPart.Position - obj.Position).Magnitude
                    if dist < 30 then
                        char.HumanoidRootPart.CFrame = CFrame.new(obj.Position)
                    end
                end
            end
        end
    end
end

-- ESP (see enemies through walls)
local function addESP()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= LocalPlayer.Character then
            if not obj:FindFirstChild("ESPBox") then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "ESPBox"
                box.Size = Vector3.new(4, 5, 2)
                box.Color3 = Color3.fromRGB(255, 0, 0)
                box.Transparency = 0.5
                box.AlwaysOnTop = true
                box.ZIndex = 0
                box.Adornee = obj
                box.Parent = obj
            end
        end
    end
end

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BloxFruitsGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 350)
mainFrame.Position = UDim2.new(0, 10, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "⚡ BLOX FRUITS ULTIMATE ⚡"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.Gotham
closeBtn.TextSize = 14
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

local autoFarmEnabled = true
local autoCollectEnabled = true
local espEnabled = true
local speedEnabled = true

local function addToggle(text, yPos, varName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = UDim2.new(0.5, -100, 0, yPos)
    btn.Text = text .. ": ON"
    btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = mainFrame
    
    local state = true
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(150, 0, 0)
        if varName == "autoFarm" then autoFarmEnabled = state end
        if varName == "autoCollect" then autoCollectEnabled = state end
        if varName == "esp" then espEnabled = state end
        if varName == "speed" then speedEnabled = state end
    end)
end

addToggle("Auto Farm", 50, "autoFarm")
addToggle("Auto Collect", 90, "autoCollect")
addToggle("ESP", 130, "esp")
addToggle("Speed Hack", 170, "speed")

mainFrame.Draggable = true
mainFrame.Active = true

print("[✓] BLOX FRUITS SCRIPT LOADED")

-- Main loops
spawn(function()
    while wait(0.5) do
        if speedEnabled then
            setSpeed()
        end
        if espEnabled then
            addESP()
        end
    end
end)

spawn(function()
    while wait(0.1) do
        if autoFarmEnabled then
            autoFarm()
        end
        if autoCollectEnabled then
            autoCollect()
        end
    end
end)