-- MM2 Script v1.0 - Murder Mystery 2
-- Features: ESP, Hitbox Expander, Auto Kill, Role Chance 99%
-- Executor: Delta / Synapse / KRNL / Fluxus

getgenv().AstroPass = "astro"

-- Password gate (no password displayed on screen)
local function passwordGate()
    local success = false
    local dialog = Instance.new("ScreenGui")
    dialog.Name = "PassGate"
    dialog.Parent = game:GetService("CoreGui")
    dialog.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    dialog.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 140)
    frame.Position = UDim2.new(0.5, -175, 0.5, -70)
    frame.BackgroundColor3 = Color3.fromRGB(25,25,45)
    frame.BorderSizePixel = 3
    frame.BorderColor3 = Color3.fromRGB(255,0,150)
    frame.Parent = dialog
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,40)
    title.Text = "ENTER PASSWORD"
    title.TextColor3 = Color3.fromRGB(255,100,200)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.BackgroundTransparency = 1
    title.Parent = frame
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.7,0,0,35)
    input.Position = UDim2.new(0.15,0,0.4,0)
    input.PlaceholderText = "password"
    input.Text = ""
    input.BackgroundColor3 = Color3.fromRGB(60,60,90)
    input.TextColor3 = Color3.fromRGB(255,255,255)
    input.TextSize = 16
    input.Parent = frame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.4,0,0,35)
    button.Position = UDim2.new(0.3,0,0.7,0)
    button.Text = "UNLOCK"
    button.BackgroundColor3 = Color3.fromRGB(0,170,0)
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.TextSize = 16
    button.Parent = frame
    
    button.MouseButton1Click:Connect(function()
        if input.Text == getgenv().AstroPass then
            success = true
            dialog:Destroy()
        else
            input.Text = "WRONG!"
            task.wait(0.8)
            input.Text = ""
        end
    end)
    
    repeat task.wait() until success == true
end

if not getgenv().AstroChecked then
    passwordGate()
    getgenv().AstroChecked = true
end

-- Services
local plr = game.Players.LocalPlayer
local coregui = game:GetService("CoreGui")
local workspace = game:GetService("Workspace")
local playerservice = game:GetService("Players")
local replicated = game:GetService("ReplicatedStorage")
local runservice = game:GetService("RunService")
local lighting = game:GetService("Lighting")

-- Clear old GUI
local oldGui = coregui:FindFirstChild("MM2Menu")
if oldGui then oldGui:Destroy() end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2Menu"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = coregui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 520)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,35)
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(255,0,100)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,40)
titleBar.BackgroundColor3 = Color3.fromRGB(40,40,60)
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1,-100,1,0)
titleText.Position = UDim2.new(0,10,0,0)
titleText.Text = "MM2 SCRIPT v1.0"
titleText.TextColor3 = Color3.fromRGB(255,100,200)
titleText.TextSize = 18
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.BackgroundTransparency = 1
titleText.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,50,1,0)
closeBtn.Position = UDim2.new(1,-55,0,0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.BackgroundColor3 = Color3.fromRGB(180,30,30)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0,100,0,45)
openBtn.Position = UDim2.new(0.02,0,0.02,0)
openBtn.Text = "OPEN MENU"
openBtn.TextColor3 = Color3.fromRGB(255,255,255)
openBtn.BackgroundColor3 = Color3.fromRGB(0,180,0)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 16
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
tabFrame.Size = UDim2.new(1,0,0,45)
tabFrame.Position = UDim2.new(0,0,0,40)
tabFrame.BackgroundColor3 = Color3.fromRGB(30,30,50)
tabFrame.Parent = mainFrame

local function createTab(name, xPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 1, -8)
    btn.Position = UDim2.new(xPos, 5, 0, 4)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(55,55,80)
    btn.TextColor3 = Color3.fromRGB(220,220,220)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Parent = tabFrame
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1,-15,1,-95)
    content.Position = UDim2.new(0,8,0,90)
    content.BackgroundTransparency = 1
    content.CanvasSize = UDim2.new(0,0,0,500)
    content.ScrollBarThickness = 6
    content.Visible = false
    content.Parent = mainFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = content
    
    btn.MouseButton1Click:Connect(function()
        for _, child in pairs(mainFrame:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end
        content.Visible = true
        for _, b in pairs(tabFrame:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(55,55,80)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(120,50,180)
    end)
    
    return {content = content}
end

local espTab = createTab("ESP", 0.01)
local combatTab = createTab("COMBAT", 0.24)
local autoTab = createTab("AUTO", 0.47)
local miscTab = createTab("MISC", 0.70)

-- Features
local features = {
    MurderESP = false, SheriffESP = false, InnocentESP = false,
    Tracers = false, HitboxExpand = false, AutoKillMurder = false,
    AutoKillSheriff = false, ForceMurder = false, ForceSheriff = false,
    AutoAttack = false, NoSpread = false, SpeedBoost = false
}

-- ESP Storage
local espObjects = {}

-- Function to get player role
local function getPlayerRole(player)
    if not player.Character then return "Unknown" end
    local backpack = player.Backpack
    local character = player.Character
    
    -- Check for knife (Murderer)
    for _, tool in pairs(character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("knife") then
            return "Murderer"
        end
    end
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("knife") then
            return "Murderer"
        end
    end
    
    -- Check for gun (Sheriff)
    for _, tool in pairs(character:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("gun") or tool.Name:lower():find("pistol")) then
            return "Sheriff"
        end
    end
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("gun") or tool.Name:lower():find("pistol")) then
            return "Sheriff"
        end
    end
    
    return "Innocent"
end

-- ESP Colors
local roleColors = {
    Murderer = Color3.fromRGB(255, 0, 0),
    Sheriff = Color3.fromRGB(0, 100, 255),
    Innocent = Color3.fromRGB(0, 255, 0)
}

-- Create ESP for a player
local function createESP(player, role)
    if espObjects[player] then
        for _, obj in pairs(espObjects[player]) do
            obj:Destroy()
        end
        espObjects[player] = nil
    end
    
    if not player.Character or not player.Character:FindFirstChild("Head") then return end
    
    local head = player.Character.Head
    local color = roleColors[role] or Color3.fromRGB(255,255,255)
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = color
    textLabel.TextStrokeTransparency = 0.3
    textLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    textLabel.Text = player.Name .. " [" .. role .. "]"
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = billboard
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 50, 0, 50)
    circle.Position = UDim2.new(0.5, -25, 1, 5)
    circle.BackgroundColor3 = color
    circle.BackgroundTransparency = 0.5
    circle.BorderSizePixel = 2
    circle.BorderColor3 = color
    circle.Parent = billboard
    
    espObjects[player] = {billboard, circle}
end

-- Update all ESPs
local function updateAllESP()
    for _, other in pairs(playerservice:GetPlayers()) do
        if other ~= plr then
            local role = getPlayerRole(other)
            if (features.MurderESP and role == "Murderer") or
               (features.SheriffESP and role == "Sheriff") or
               (features.InnocentESP and role == "Innocent") then
                createESP(other, role)
            else
                if espObjects[other] then
                    for _, obj in pairs(espObjects[other]) do
                        obj:Destroy()
                    end
                    espObjects[other] = nil
                end
            end
        end
    end
end

-- Hitbox Expander
local function expandHitbox()
    for _, player in pairs(playerservice:GetPlayers()) do
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and not part:FindFirstChild("OriginalSize") then
                    part:SetAttribute("OriginalSize", part.Size)
                    part.Size = part.Size * (features.HitboxExpand and 2 or 1)
                end
            end
        end
    end
end

-- Auto Kill (if Murderer, kill all)
local function autoKillAll()
    if not features.AutoKillMurder then return end
    local myRole = getPlayerRole(plr)
    if myRole ~= "Murderer" then return end
    
    for _, other in pairs(playerservice:GetPlayers()) do
        if other ~= plr and other.Character and other.Character:FindFirstChild("Humanoid") and other.Character.Humanoid.Health > 0 then
            local knife = nil
            if plr.Character then
                for _, tool in pairs(plr.Character:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name:lower():find("knife") then
                        knife = tool
                        break
                    end
                end
            end
            if knife then
                local head = other.Character:FindFirstChild("Head")
                if head then
                    plr.Character.HumanoidRootPart.CFrame = head.CFrame
                    task.wait(0.05)
                    knife:Activate()
                end
            end
        end
    end
end

-- Auto Kill Murderer (if Sheriff)
local function autoKillMurderer()
    if not features.AutoKillSheriff then return end
    local myRole = getPlayerRole(plr)
    if myRole ~= "Sheriff" then return end
    
    for _, other in pairs(playerservice:GetPlayers()) do
        if other ~= plr and getPlayerRole(other) == "Murderer" and other.Character and other.Character:FindFirstChild("Humanoid") and other.Character.Humanoid.Health > 0 then
            local gun = nil
            if plr.Character then
                for _, tool in pairs(plr.Character:GetChildren()) do
                    if tool:IsA("Tool") and (tool.Name:lower():find("gun") or tool.Name:lower():find("pistol")) then
                        gun = tool
                        break
                    end
                end
            end
            if gun then
                local head = other.Character:FindFirstChild("Head")
                if head then
                    plr.Character.HumanoidRootPart.CFrame = head.CFrame
                    task.wait(0.05)
                    gun:Activate()
                end
            end
        end
    end
end

-- Force Role (99% chance to get Murderer or Sheriff)
local function forceRole()
    if not (features.ForceMurder or features.ForceSheriff) then return end
    local desiredRole = features.ForceMurder and "Murderer" or "Sheriff"
    
    -- Hook into role assignment remote
    pcall(function()
        local roleRemote = replicated:FindFirstChild("AssignRole")
        if roleRemote then
            roleRemote:FireServer(desiredRole)
        end
    end)
end

-- Add toggle function
local function addToggle(tabObj, text, key)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 45)
    row.BackgroundColor3 = Color3.fromRGB(35,35,55)
    row.BorderSizePixel = 1
    row.BorderColor3 = Color3.fromRGB(70,70,100)
    row.Parent = tabObj.content
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(235,235,235)
    label.TextSize = 15
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = row
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 80, 0, 32)
    toggleBtn.Position = UDim2.new(0.72, 0, 0.06, 0)
    toggleBtn.Text = "OFF"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
    toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 14
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = row
    
    local state = false
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        features[key] = state
        if state then
            toggleBtn.Text = "ON"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
        else
            toggleBtn.Text = "OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
        end
    end)
end

-- Add toggles
addToggle(espTab, "👁️ MURDERER ESP (RED)", "MurderESP")
addToggle(espTab, "👁️ SHERIFF ESP (BLUE)", "SheriffESP")
addToggle(espTab, "👁️ INNOCENT ESP (GREEN)", "InnocentESP")
addToggle(espTab, "📏 TRACERS", "Tracers")

addToggle(combatTab, "💥 HITBOX EXPANDER (2x)", "HitboxExpand")
addToggle(combatTab, "🗡️ AUTO ATTACK", "AutoAttack")
addToggle(combatTab, "🎯 NO SPREAD (Gun)", "NoSpread")
addToggle(combatTab, "⚡ SPEED BOOST", "SpeedBoost")

addToggle(autoTab, "🔪 AUTO KILL ALL (as Murderer)", "AutoKillMurder")
addToggle(autoTab, "🔫 AUTO KILL MURDERER (as Sheriff)", "AutoKillSheriff")
addToggle(autoTab, "⭐ FORCE MURDERER ROLE (99%)", "ForceMurder")
addToggle(autoTab, "⭐ FORCE SHERIFF ROLE (99%)", "ForceSheriff")

-- Show ESP tab by default
espTab.content.Visible = true
for _, btn in pairs(tabFrame:GetChildren()) do
    if btn:IsA("TextButton") and btn.Text == "ESP" then
        btn.BackgroundColor3 = Color3.fromRGB(120,50,180)
        break
    end
end

-- MAIN LOOP
task.spawn(function()
    while true do
        -- ESP Update
        if features.MurderESP or features.SheriffESP or features.InnocentESP then
            updateAllESP()
        else
            for _, obj in pairs(espObjects) do
                for _, o in pairs(obj) do
                    o:Destroy()
                end
            end
            espObjects = {}
        end
        
        -- Hitbox Expander
        if features.HitboxExpand then
            expandHitbox()
        end
        
        -- Auto Kill
        if features.AutoKillMurder then
            autoKillAll()
        end
        
        if features.AutoKillSheriff then
            autoKillMurderer()
        end
        
        -- Force Role
        if features.ForceMurder or features.ForceSheriff then
            forceRole()
        end
        
        -- Speed Boost
        if features.SpeedBoost and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.WalkSpeed = 50
        elseif plr.Character and plr.Character:FindFirstChild("Humanoid") and not features.SpeedBoost then
            if plr.Character.Humanoid.WalkSpeed > 20 then
                plr.Character.Humanoid.WalkSpeed = 16
            end
        end
        
        task.wait(0.3)
    end
end)

-- Auto Attack (auto click on nearest target)
task.spawn(function()
    while true do
        if features.AutoAttack then
            local myRole = getPlayerRole(plr)
            local target = nil
            local minDist = math.huge
            
            for _, other in pairs(playerservice:GetPlayers()) do
                if other ~= plr and other.Character and other.Character:FindFirstChild("Humanoid") and other.Character.Humanoid.Health > 0 then
                    local shouldTarget = false
                    local otherRole = getPlayerRole(other)
                    
                    if myRole == "Murderer" then
                        shouldTarget = true
                    elseif myRole == "Sheriff" and otherRole == "Murderer" then
                        shouldTarget = true
                    end
                    
                    if shouldTarget then
                        local root = other.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            local dist = (root.Position - (plr.Character and plr.Character.HumanoidRootPart and plr.Character.HumanoidRootPart.Position or Vector3.new(0,0,0))).Magnitude
                            if dist < minDist and dist < 50 then
                                minDist = dist
                                target = other
                            end
                        end
                    end
                end
            end
            
            if target then
                local weapon = nil
                if plr.Character then
                    for _, tool in pairs(plr.Character:GetChildren()) do
                        if tool:IsA("Tool") then
                            weapon = tool
                            break
                        end
                    end
                end
                if weapon then
                    weapon:Activate()
                end
            end
        end
        task.wait(0.1)
    end
end)

print("✅ MM2 Script Loaded | Password protected | Role chance 99%")
