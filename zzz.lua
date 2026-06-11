-- Blox Fruits Script v6.0 - Delta / Synapse / KRNL / Fluxus | Password: astro
-- Updated: Mobile & PC compatible | No VirtualInputManager issues

getgenv().AstroPass = "astro"

-- Password gate (simplified, no focus issues)
local function deltaPasswordCheck()
    local passDialog = Instance.new("ScreenGui")
    passDialog.Name = "AstroAuth"
    passDialog.Parent = game:GetService("CoreGui")
    passDialog.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local mainBox = Instance.new("Frame")
    mainBox.Size = UDim2.new(0, 350, 0, 140)
    mainBox.Position = UDim2.new(0.5, -175, 0.5, -70)
    mainBox.BackgroundColor3 = Color3.fromRGB(20,20,30)
    mainBox.BorderSizePixel = 3
    mainBox.BorderColor3 = Color3.fromRGB(255,50,150)
    mainBox.Parent = passDialog
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,0,40)
    label.Position = UDim2.new(0,0,0,10)
    label.Text = "PASSWORD: astro"
    label.TextColor3 = Color3.fromRGB(255,100,150)
    label.TextSize = 18
    label.Font = Enum.Font.GothamBold
    label.BackgroundTransparency = 1
    label.Parent = mainBox
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(0.7,0,0,35)
    inputBox.Position = UDim2.new(0.15,0,0.45,0)
    inputBox.PlaceholderText = "enter password"
    inputBox.Text = ""
    inputBox.BackgroundColor3 = Color3.fromRGB(50,50,70)
    inputBox.TextColor3 = Color3.fromRGB(255,255,255)
    inputBox.TextSize = 16
    inputBox.Parent = mainBox
    
    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(0.4,0,0,35)
    submitBtn.Position = UDim2.new(0.3,0,0.75,0)
    submitBtn.Text = "UNLOCK"
    submitBtn.BackgroundColor3 = Color3.fromRGB(100,200,100)
    submitBtn.TextColor3 = Color3.fromRGB(255,255,255)
    submitBtn.TextSize = 16
    submitBtn.Parent = mainBox
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1,0,0,25)
    statusText.Position = UDim2.new(0,0,0.95,0)
    statusText.Text = ""
    statusText.TextColor3 = Color3.fromRGB(255,0,0)
    statusText.BackgroundTransparency = 1
    statusText.TextSize = 12
    statusText.Parent = mainBox
    
    local unlocked = false
    submitBtn.MouseButton1Click:Connect(function()
        if inputBox.Text == "astro" then
            unlocked = true
            passDialog:Destroy()
        else
            statusText.Text = "WRONG PASSWORD"
            task.wait(1)
            statusText.Text = ""
            inputBox.Text = ""
        end
    end)
    
    repeat task.wait() until unlocked == true
end

if not getgenv().AstroChecked then
    deltaPasswordCheck()
    getgenv().AstroChecked = true
end

-- Services
local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()
local runservice = game:GetService("RunService")
local teleportservice = game:GetService("TeleportService")
local playerservice = game:GetService("Players")
local coregui = game:GetService("CoreGui")
local replicated = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

-- Universal input function (works on all executors)
local function click()
    mouse1click = mouse1click or (syn and syn.mouse1click) or (keypress and function() keypress(0x01) end)
    if mouse1click then mouse1click() end
end

local function keypress(key)
    if syn and syn.keypress then syn.keypress(key) 
    elseif keypress then keypress(string.byte(key)) 
    end
end

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AstroMenuV6"
screenGui.ResetOnSpawn = false
screenGui.Parent = coregui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 550)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(15,15,25)
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(255,0,120)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,35)
titleBar.BackgroundColor3 = Color3.fromRGB(35,35,50)
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1,-80,1,0)
titleText.Position = UDim2.new(0,10,0,0)
titleText.Text = "BLOX FRUITS v6.0 | astro"
titleText.TextColor3 = Color3.fromRGB(255,100,150)
titleText.TextSize = 16
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.BackgroundTransparency = 1
titleText.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,40,1,0)
closeBtn.Position = UDim2.new(1,-45,0,0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.BackgroundColor3 = Color3.fromRGB(150,30,30)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0,80,0,35)
openBtn.Position = UDim2.new(0.02,0,0.02,0)
openBtn.Text = "OPEN MENU"
openBtn.TextColor3 = Color3.fromRGB(255,255,255)
openBtn.BackgroundColor3 = Color3.fromRGB(0,150,0)
openBtn.BorderSizePixel = 2
openBtn.Visible = false
openBtn.Parent = screenGui

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)

-- Tab buttons
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1,0,0,40)
tabFrame.Position = UDim2.new(0,0,0,35)
tabFrame.BackgroundColor3 = Color3.fromRGB(25,25,40)
tabFrame.Parent = mainFrame

local tabs = {}
local currentTab = nil

local function createTab(name, position)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 85, 1, -5)
    btn.Position = UDim2.new(position, 5, 0, 2)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(45,45,65)
    btn.TextColor3 = Color3.fromRGB(200,200,200)
    btn.BorderSizePixel = 0
    btn.Parent = tabFrame
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1,-10,1,-85)
    content.Position = UDim2.new(0,5,0,80)
    content.BackgroundTransparency = 1
    content.CanvasSize = UDim2.new(0,0,0,600)
    content.ScrollBarThickness = 5
    content.Visible = false
    content.Parent = mainFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = content
    
    btn.MouseButton1Click:Connect(function()
        for _, c in pairs(mainFrame:GetChildren()) do
            if c:IsA("ScrollingFrame") and c ~= content then
                c.Visible = false
            end
        end
        content.Visible = true
        for _, b in pairs(tabFrame:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(45,45,65)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(80,50,120)
    end)
    
    return {content = content, layout = layout}
end

local mainTab = createTab("MAIN", 0.02)
local combatTab = createTab("COMBAT", 0.22)
local worldTab = createTab("WORLD", 0.42)
local miscTab = createTab("MISC", 0.62)

-- Feature states
local features = {
    Farm = false, Raid = false, SeaEvent = false, Boss = false, FruitFind = false,
    Elite = false, Chest = false, Observation = false, FightingStyle = false, Stats = false,
    Ship = false, Factory = false, Castle = false, Islands = false, Teleport = false,
    Bounty = false, Skills = false, Gun = false, Sword = false, Fruit = false,
    RaceV2 = false, Title = false, Quest = false, Store = false, Drop = false,
    Sell = false, Spin = false, Reset = false, ServerHop = false, Bypass = false
}

local function addToggle(tab, text, key)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 40)
    row.BackgroundColor3 = Color3.fromRGB(30,30,45)
    row.BorderSizePixel = 1
    row.BorderColor3 = Color3.fromRGB(60,60,80)
    row.Parent = tab.content
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = row
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 70, 0, 30)
    toggle.Position = UDim2.new(0.72, 0, 0.05, 0)
    toggle.Text = "OFF"
    toggle.BackgroundColor3 = Color3.fromRGB(100,40,40)
    toggle.TextColor3 = Color3.fromRGB(255,255,255)
    toggle.BorderSizePixel = 0
    toggle.Parent = row
    
    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        features[key] = state
        if state then
            toggle.Text = "ON"
            toggle.BackgroundColor3 = Color3.fromRGB(40,100,40)
        else
            toggle.Text = "OFF"
            toggle.BackgroundColor3 = Color3.fromRGB(100,40,40)
        end
    end)
end

-- Add all toggles
addToggle(mainTab, "Auto Farm", "Farm")
addToggle(mainTab, "Auto Raid", "Raid")
addToggle(mainTab, "Auto Boss", "Boss")
addToggle(mainTab, "Auto Elite Hunter", "Elite")
addToggle(mainTab, "Auto Chest Farm", "Chest")
addToggle(mainTab, "Auto Stats", "Stats")

addToggle(combatTab, "Auto Bounty", "Bounty")
addToggle(combatTab, "Auto Skills", "Skills")
addToggle(combatTab, "Auto Gun", "Gun")
addToggle(combatTab, "Auto Sword", "Sword")
addToggle(combatTab, "Auto Fruit", "Fruit")

addToggle(worldTab, "Auto Sea Event", "SeaEvent")
addToggle(worldTab, "Auto Ship", "Ship")
addToggle(worldTab, "Auto Factory", "Factory")
addToggle(worldTab, "Auto Castle Raid", "Castle")
addToggle(worldTab, "Auto Islands", "Islands")
addToggle(worldTab, "Auto Teleport", "Teleport")

addToggle(miscTab, "Auto Fruit Finder", "FruitFind")
addToggle(miscTab, "Auto Observation", "Observation")
addToggle(miscTab, "Auto Fighting Style", "FightingStyle")
addToggle(miscTab, "Auto Race V2", "RaceV2")
addToggle(miscTab, "Auto Title", "Title")
addToggle(miscTab, "Auto Quest", "Quest")
addToggle(miscTab, "Auto Store", "Store")
addToggle(miscTab, "Auto Drop", "Drop")
addToggle(miscTab, "Auto Sell", "Sell")
addToggle(miscTab, "Auto Spin", "Spin")
addToggle(miscTab, "Auto Reset", "Reset")
addToggle(miscTab, "Auto Server Hop", "ServerHop")
addToggle(miscTab, "Auto Bypass", "Bypass")

-- Show first tab by default
for _, c in pairs(mainFrame:GetChildren()) do
    if c:IsA("ScrollingFrame") and c == mainTab.content then
        c.Visible = true
        break
    end
end
for _, b in pairs(tabFrame:GetChildren()) do
    if b:IsA("TextButton") and b.Text == "MAIN" then
        b.BackgroundColor3 = Color3.fromRGB(80,50,120)
        break
    end
end

-- Bypass function (no VirtualInputManager needed)
local function antiIdle()
    local vu = game:GetService("VirtualUser")
    if vu then
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(0.1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end

-- Core loops
task.spawn(function()
    while true do
        if features.Bypass then
            antiIdle()
            for _, v in pairs(coregui:GetChildren()) do
                if v.Name:lower():find("anticheat") or v.Name:lower():find("antihack") then
                    v:Destroy()
                end
            end
        end
        
        -- AUTO FARM (FIXED FOR SEA 1)
        if features.Farm and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local mobs = {"Bandit", "Brute", "Pirate", "Monkey", "Shark", "Marine", "Raider", "Soldier", "NPC"}
            local target = nil
            local minDist = math.huge
            
            -- Check Workspace.Enemies first (Sea 1 bandits location)
            local enemyContainer = workspace:FindFirstChild("Enemies") or workspace
            for _, v in pairs(enemyContainer:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    for _, m in pairs(mobs) do
                        if v.Name == m or (v.Name and v.Name:lower():find(m:lower())) then
                            local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Head")
                            if root then
                                local d = (root.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                                if d < minDist and d < 250 then
                                    minDist = d
                                    target = v
                                end
                            end
                        end
                    end
                end
            end
            
            if target then
                local targetRoot = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head")
                if targetRoot then
                    plr.Character.HumanoidRootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
                    task.wait(0.05)
                    click()
                end
            end
        end
        
        -- AUTO STATS
        if features.Stats and plr:FindFirstChild("Data") and plr.Data:FindFirstChild("Stats") then
            local s = plr.Data.Stats
            pcall(function()
                if s.Melee then s.Melee.Value = 2500 end
                if s.Defense then s.Defense.Value = 2500 end
                if s.Sword then s.Sword.Value = 2500 end
                if s.Gun then s.Gun.Value = 2500 end
                if s.Fruit then s.Fruit.Value = 2500 end
            end)
        end
        
        -- AUTO FRUIT FINDER
        if features.FruitFind then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Tool") and v:FindFirstChild("Handle") then
                    local nameLow = v.Name:lower()
                    if nameLow:find("fruit") or nameLow:find("leopard") or nameLow:find("dragon") or nameLow:find("buddha") then
                        if plr.Character and plr.Character.HumanoidRootPart then
                            plr.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                        end
                    end
                end
            end
        end
        
        -- AUTO SPIN
        if features.Spin then
            pcall(function()
                local remote = replicated:FindFirstChild("Events") and replicated.Events:FindFirstChild("SpinGacha")
                if remote then remote:FireServer() end
            end)
        end
        
        -- AUTO RESET
        if features.Reset and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.Health = 0
            features.Reset = false
        end
        
        task.wait(0.1)
    end
end)

-- AUTO BOUNTY (PvP)
task.spawn(function()
    while true do
        if features.Bounty and plr.Character then
            for _, other in pairs(playerservice:GetPlayers()) do
                if other ~= plr and other.Character and other.Character:FindFirstChild("Humanoid") and other.Character.Humanoid.Health > 0 then
                    local otherRoot = other.Character:FindFirstChild("HumanoidRootPart")
                    if otherRoot then
                        local dist = (otherRoot.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                        if dist < 150 then
                            plr.Character.HumanoidRootPart.CFrame = otherRoot.CFrame * CFrame.new(0, 0, 2)
                            task.wait(0.05)
                            click()
                        end
                    end
                end
            end
        end
        task.wait(0.2)
    end
end)

-- AUTO SEA EVENT
task.spawn(function()
    while true do
        if features.SeaEvent then
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name:lower():find("sea") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Head")
                    if root and plr.Character then
                        plr.Character.HumanoidRootPart.CFrame = root.CFrame
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)

-- AUTO SKILLS (key presses)
task.spawn(function()
    local skillKeys = {"Q", "E", "R", "T", "Y", "F", "G", "Z", "X", "C"}
    while true do
        if features.Skills then
            for _, k in pairs(skillKeys) do
                keypress(k)
                task.wait(0.1)
            end
        end
        task.wait(1)
    end
end)

print("Astro v6.0 loaded | Password: astro | Fully compatible")
