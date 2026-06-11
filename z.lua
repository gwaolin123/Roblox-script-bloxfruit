-- Blox Fruits Auto-Farm + ESP (UPDATED for current version)
-- NO PASSWORD REQUIRED
-- Works on Delta, Arceus X, Hydrogen

-- ========== SETTINGS ==========
local Settings = {
    AutoFarm = true,
    AutoQuest = true,
    AutoCollect = true,
    ESP = true,
    SpeedHack = true,
    SpeedValue = 45,
    NoClip = true,
    SafeMode = true
}

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local VirtualInput = game:GetService("VirtualInputManager")

-- ========== FIND ENEMIES (UPDATED) ==========
local function getNearestEnemy()
    local nearest = nil
    local nearestDist = 150
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = char.HumanoidRootPart
    
    -- Try multiple possible enemy locations
    local enemyContainers = {
        Workspace.Enemies,
        Workspace:FindFirstChild("Enemies"),
        Workspace:FindFirstChild("Mobs"),
        workspace:FindFirstChild("NPCs")
    }
    
    for _, container in pairs(enemyContainers) do
        if container then
            for _, v in pairs(container:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    local dist = (hrp.Position - v.HumanoidRootPart.Position).Magnitude
                    if dist < nearestDist then
                        nearest = v
                        nearestDist = dist
                    end
                end
            end
        end
    end
    return nearest, nearestDist
end

-- ========== FIND QUEST NPC ==========
local function getQuestNPC()
    local npcContainers = {
        Workspace.NPCs,
        Workspace:FindFirstChild("NPCs"),
        workspace:FindFirstChild("QuestGivers")
    }
    
    for _, container in pairs(npcContainers) do
        if container then
            for _, v in pairs(container:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                    return v
                end
            end
        end
    end
    return nil
end

-- ========== TELEPORT ==========
local function teleportTo(position)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- ========== ESP (UPDATED) ==========
if Settings.ESP then
    local function createESP(model)
        if model:FindFirstChild("ESP_Highlight") then return end
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Adornee = model
        highlight.Parent = model
    end
    
    local function scanForTargets()
        local containers = {Workspace.Enemies, Workspace:FindFirstChild("Enemies"), Workspace:FindFirstChild("Mobs")}
        for _, container in pairs(containers) do
            if container then
                for _, v in pairs(container:GetChildren()) do
                    if v:IsA("Model") then
                        createESP(v)
                    end
                end
            end
        end
    end
    
    scanForTargets()
    Workspace.ChildAdded:Connect(function(child)
        if child.Name == "Enemies" or child.Name == "Mobs" then
            child.ChildAdded:Connect(createESP)
        end
    end)
    print("[✓] ESP Loaded")
end

-- ========== AUTO FARM ==========
spawn(function()
    while Settings.AutoFarm and wait(0.1) do
        local enemy, dist = getNearestEnemy()
        if enemy then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position, enemy.HumanoidRootPart.Position)
                if dist < 15 then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                else
                    teleportTo(enemy.HumanoidRootPart.Position)
                end
            end
        end
    end
end)

-- ========== SPEED HACK ==========
spawn(function()
    while Settings.SpeedHack and wait(0.5) do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Settings.SpeedValue
            char.Humanoid.JumpPower = 80
        end
    end
end)

-- ========== NO CLIP ==========
spawn(function()
    while Settings.NoClip and wait(0.2) do
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- ========== SAFE MODE (Anti-AFK) ==========
if Settings.SafeMode then
    LocalPlayer.Idled:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Jump = true
        end
    end)
end

-- ========== GUI MENU ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BloxFruitsGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 320)
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

local function addToggle(text, setting, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = UDim2.new(0.5, -100, 0, yPos)
    btn.Text = text .. ": " .. (Settings[setting] and "ON" or "OFF")
    btn.BackgroundColor3 = Settings[setting] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(150, 0, 0)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = mainFrame
    
    btn.MouseButton1Click:Connect(function()
        Settings[setting] = not Settings[setting]
        btn.Text = text .. ": " .. (Settings[setting] and "ON" or "OFF")
        btn.BackgroundColor3 = Settings[setting] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(150, 0, 0)
    end)
end

addToggle("Auto Farm", "AutoFarm", 50)
addToggle("Auto Quest", "AutoQuest", 90)
addToggle("Auto Collect", "AutoCollect", 130)
addToggle("ESP", "ESP", 170)
addToggle("Speed Hack", "SpeedHack", 210)
addToggle("No Clip", "NoClip", 250)

mainFrame.Draggable = true
mainFrame.Active = true

print("[✓] BLOX FRUITS SCRIPT LOADED (UPDATED)")
print("[✓] Features: Auto Farm, ESP, Speed Hack, No Clip")