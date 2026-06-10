-- Blox Fruits Auto-Farm + ESP Script (Mobile Compatible)
-- Password: blox2026
-- Works on Delta, Arceus X, Hydrogen, Krnl

local password = "blox2026"
local input = game:GetService("TextBoxService"):GetText("Enter Password:")
if input ~= password then
    game.Players.LocalPlayer:Kick("Wrong password! Contact seller.")
    return
end

-- ========== SETTINGS ==========
local Settings = {
    AutoFarm = true,
    AutoQuest = true,
    AutoCollect = true,
    ESP = true,
    TeleportToIsland = true,
    TargetIsland = "Pirate Village",
    SpeedHack = true,
    SpeedValue = 45,
    NoClip = true,
    AutoDropFruit = true,
    FruitToDrop = "Bomb",
    AutoStoreFruit = false,
    SafeMode = true
}

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInput = game:GetService("VirtualInputManager")

-- ========== UTILITIES ==========
local function getNearestEnemy()
    local nearest = nil
    local nearestDist = 150
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = char.HumanoidRootPart
    
    for _, v in pairs(Workspace.Enemies:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local dist = (hrp.Position - v.HumanoidRootPart.Position).Magnitude
            if dist < nearestDist then
                nearest = v
                nearestDist = dist
            end
        end
    end
    return nearest, nearestDist
end

local function getQuestNPC()
    for _, v in pairs(Workspace.NPCs:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
            if v.Name:lower():find("quest") or v.Name:lower():find("npc") or v.Name:lower():find("teacher") then
                return v
            end
        end
    end
    return nil
end

local function teleportTo(position)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

local function autoQuest()
    local questNPC = getQuestNPC()
    if questNPC then
        teleportTo(questNPC.HumanoidRootPart.Position)
        wait(0.5)
        VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        wait(0.1)
        VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end
end

local function autoCollect()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:lower():find("fruit") or v.Name:lower():find("chest") then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local dist = (char.HumanoidRootPart.Position - v.Position).Magnitude
                if dist < 50 then
                    teleportTo(v.Position)
                    wait(0.2)
                end
            end
        end
    end
end

-- ========== ESP ==========
if Settings.ESP then
    local function createESP(model)
        if model:FindFirstChild("ESP_Highlight") then return end
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.6
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Adornee = model
        highlight.Parent = model
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Name"
        billboard.Size = UDim2.new(0, 100, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = model
        
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = model.Name
        text.TextColor3 = Color3.fromRGB(255, 255, 255)
        text.TextScaled = true
        text.Parent = billboard
    end
    
    Workspace.Enemies.ChildAdded:Connect(createESP)
    Workspace.NPCs.ChildAdded:Connect(createESP)
    for _, v in pairs(Workspace.Enemies:GetChildren()) do createESP(v) end
    for _, v in pairs(Workspace.NPCs:GetChildren()) do createESP(v) end
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
                    if tool then
                        tool:Activate()
                    end
                else
                    teleportTo(enemy.HumanoidRootPart.Position)
                end
            end
        else
            if Settings.AutoQuest then autoQuest() end
            if Settings.AutoCollect then autoCollect() end
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

-- ========== AUTO DROP FRUIT ==========
if Settings.AutoDropFruit then
    spawn(function()
        while wait(0.5) do
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if backpack then
                for _, tool in pairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name:lower():find(Settings.FruitToDrop:lower()) then
                        tool.Parent = Workspace
                    end
                end
            end
        end
    end)
end

-- ========== TELEPORT TO ISLAND ==========
if Settings.TeleportToIsland then
    spawn(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name:lower():find(Settings.TargetIsland:lower()) then
                if v:FindFirstChild("SpawnLocation") then
                    teleportTo(v.SpawnLocation.Position)
                elseif v:FindFirstChild("Baseplate") then
                    teleportTo(v.Baseplate.Position)
                end
                break
            end
        end
    end)
end

-- ========== SAFE MODE ==========
if Settings.SafeMode then
    LocalPlayer.Idled:Connect(function()
        VirtualInput:SendKeyEvent("W", true, nil)
        wait(0.1)
        VirtualInput:SendKeyEvent("W", false, nil)
    end)
end

-- ========== GUI MENU (Simple) ==========
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
addToggle("Safe Mode", "SafeMode", 290)

print("[✓] BLOX FRUITS SCRIPT LOADED | Password: blox2026")
print("[✓] Features: Auto Farm, ESP, Speed Hack, No Clip, Auto Drop Fruit")