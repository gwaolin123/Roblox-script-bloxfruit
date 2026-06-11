-- Blox Fruits Script v6.2 - GUI Fix | Password: astro
-- Fixed: Button visibility, CoreGui issues, Delta compatibility

getgenv().AstroPass = "astro"

-- Password gate (simplified, no GUI conflicts)
local function passwordGate()
    local success = false
    local dialog = Instance.new("ScreenGui")
    dialog.Name = "AstroPassGate"
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
    title.Text = "PASSWORD: astro"
    title.TextColor3 = Color3.fromRGB(255,100,200)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.BackgroundTransparency = 1
    title.Parent = frame
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.7,0,0,35)
    input.Position = UDim2.new(0.15,0,0.4,0)
    input.PlaceholderText = "enter password"
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
        if input.Text == "astro" then
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
local replicated = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local playerservice = game:GetService("Players")

-- Clear old GUI if exists
local oldGui = coregui:FindFirstChild("AstroMenuV6")
if oldGui then oldGui:Destroy() end

-- Create NEW GUI with high priority
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AstroMenuV6"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = coregui

-- Main frame (visible by default)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 480, 0, 560)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -280)
mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,35)
mainFrame.BorderSizePixel = 4
mainFrame.BorderColor3 = Color3.fromRGB(255,50,150)
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
titleText.Text = "BLOX FRUITS v6.2 | 1HIT + AUTO QUEST"
titleText.TextColor3 = Color3.fromRGB(255,100,200)
titleText.TextSize = 16
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
    content.CanvasSize = UDim2.new(0,0,0,650)
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

local mainTab = createTab("MAIN", 0.01)
local hitTab = createTab("1HIT", 0.24)
local questTab = createTab("QUEST", 0.47)
local miscTab = createTab("MISC", 0.70)

-- Features
local features = {
    OneHit = false, AutoAttack = false, AutoQuest = false,
    Farm = false, Stats = false, Bounty = false,
    FruitFind = false, Spin = false, Reset = false, Bypass = false
}

-- Function to add toggle button
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
            if key == "OneHit" then
                -- Enable 1HIT
                pcall(function()
                    local char = plr.Character
                    if char and char:FindFirstChild("Humanoid") then
                        char.Humanoid.MaxHealth = math.huge
                        char.Humanoid.Health = math.huge
                    end
                    local combatRemote = replicated:FindFirstChild("Combat")
                    if combatRemote then
                        local old = combatRemote.FireServer
                        combatRemote.FireServer = function(self, ...)
                            local args = {...}
                            if args[2] then args[2] = 999999 end
                            return old(self, unpack(args))
                        end
                    end
                end)
            end
        else
            toggleBtn.Text = "OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
        end
    end)
end

-- Add all toggles
addToggle(mainTab, "🔁 AUTO FARM (Teleport)", "Farm")
addToggle(mainTab, "📊 AUTO STATS (2500)", "Stats")
addToggle(mainTab, "⚔️ AUTO BOUNTY (PvP)", "Bounty")

addToggle(hitTab, "💀 1 HIT KILL (God Mode)", "OneHit")
addToggle(hitTab, "🤖 AUTO ATTACK (No Mouse)", "AutoAttack")

addToggle(questTab, "📜 AUTO QUEST (Get/Turn In)", "AutoQuest")
addToggle(questTab, "🍎 AUTO FRUIT FINDER", "FruitFind")
addToggle(questTab, "🎰 AUTO SPIN GACHA", "Spin")

addToggle(miscTab, "🔄 AUTO RESET CHARACTER", "Reset")
addToggle(miscTab, "🛡️ AUTO BYPASS (Anti-Idle)", "Bypass")

-- Show MAIN tab by default
mainTab.content.Visible = true
for _, btn in pairs(tabFrame:GetChildren()) do
    if btn:IsA("TextButton") and btn.Text == "MAIN" then
        btn.BackgroundColor3 = Color3.fromRGB(120,50,180)
        break
    end
end

-- 1HIT damage modifier function
local function enableOneHit()
    local char = plr.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.MaxHealth = math.huge
        char.Humanoid.Health = math.huge
    end
    local combatRemote = replicated:FindFirstChild("Combat")
    if combatRemote then
        local old = combatRemote.FireServer
        combatRemote.FireServer = function(self, ...)
            local args = {...}
            if args[2] then args[2] = 999999 end
            return old(self, unpack(args))
        end
    end
end

-- Attack function (no mouse)
local function attackTarget(target)
    if not target then return end
    pcall(function()
        local combatRemote = replicated:FindFirstChild("Combat")
        if combatRemote then
            combatRemote:FireServer(target, "Click")
        end
        local char = plr.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end)
end

-- Auto Quest
local questMob = nil
local function getQuest()
    local questGivers = {"Quest Giver", "Bartilo", "Monk", "Swan"}
    for _, npcName in pairs(questGivers) do
        local npc = workspace.NPCs:FindFirstChild(npcName)
        if npc and npc:FindFirstChild("ClickDetector") then
            fireclickdetector(npc.ClickDetector)
            task.wait(0.5)
            local gui = plr.PlayerGui:FindFirstChild("Quest")
            if gui and gui:FindFirstChild("Frame") then
                local textLabel = gui.Frame:FindFirstChild("TextLabel")
                if textLabel then
                    local text = textLabel.Text
                    for _, mob in pairs({"Bandit","Brute","Pirate","Monkey","Shark","Marine"}) do
                        if text:find(mob) then
                            questMob = mob
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

local function turnInQuest()
    local questGivers = {"Quest Giver", "Bartilo", "Monk", "Swan"}
    for _, npcName in pairs(questGivers) do
        local npc = workspace.NPCs:FindFirstChild(npcName)
        if npc and npc:FindFirstChild("ClickDetector") then
            fireclickdetector(npc.ClickDetector)
            task.wait(0.3)
            return true
        end
    end
    return false
end

-- Anti-idle
local function antiIdle()
    local vu = game:GetService("VirtualUser")
    if vu then
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(0.1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end

-- MAIN LOOP
task.spawn(function()
    while true do
        if features.Bypass then antiIdle() end
        
        -- Auto Quest
        if features.AutoQuest then
            local questGui = plr.PlayerGui:FindFirstChild("Quest")
            if not questGui or not questGui:FindFirstChild("Frame") then
                getQuest()
            else
                local textLabel = questGui.Frame:FindFirstChild("TextLabel")
                if textLabel then
                    local current, required = string.match(textLabel.Text, "(%d+)/(%d+)")
                    if current and required and tonumber(current) >= tonumber(required) then
                        turnInQuest()
                        task.wait(1)
                    end
                end
            end
        end
        
        -- Auto Farm
        if features.Farm and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local mobs = {"Bandit","Brute","Pirate","Monkey","Shark","Marine","Raider","Soldier"}
            local targetMob = questMob or nil
            local target = nil
            local minDist = math.huge
            
            local enemyContainer = workspace:FindFirstChild("Enemies") or workspace
            for _, v in pairs(enemyContainer:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    local match = false
                    if targetMob and v.Name:lower():find(targetMob:lower()) then
                        match = true
                    elseif not targetMob then
                        for _, m in pairs(mobs) do
                            if v.Name:lower():find(m:lower()) then
                                match = true
                                break
                            end
                        end
                    end
                    if match then
                        local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Head")
                        if root then
                            local d = (root.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                            if d < minDist and d < 300 then
                                minDist = d
                                target = v
                            end
                        end
                    end
                end
            end
            
            if target then
                local targetRoot = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head")
                if targetRoot then
                    plr.Character.HumanoidRootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 4)
                    if features.AutoAttack then
                        attackTarget(target)
                    end
                end
            end
        end
        
        -- Auto Stats
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
        
        -- Auto Fruit Finder
        if features.FruitFind then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Tool") and v:FindFirstChild("Handle") then
                    local nameLow = v.Name:lower()
                    if nameLow:find("fruit") or nameLow:find("leopard") or nameLow:find("dragon") then
                        if plr.Character then
                            plr.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                        end
                    end
                end
            end
        end
        
        -- Auto Spin
        if features.Spin then
            pcall(function()
                local remote = replicated:FindFirstChild("Events") and replicated.Events:FindFirstChild("SpinGacha")
                if remote then remote:FireServer() end
            end)
            features.Spin = false
        end
        
        -- Auto Reset
        if features.Reset and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.Health = 0
            features.Reset = false
        end
        
        -- 1HIT keep enabled
        if features.OneHit then
            enableOneHit()
        end
        
        task.wait(0.1)
    end
end)

-- Auto Bounty
task.spawn(function()
    while true do
        if features.Bounty and plr.Character then
            for _, other in pairs(playerservice:GetPlayers()) do
                if other ~= plr and other.Character and other.Character:FindFirstChild("Humanoid") and other.Character.Humanoid.Health > 0 then
                    local otherRoot = other.Character:FindFirstChild("HumanoidRootPart")
                    if otherRoot then
                        local dist = (otherRoot.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                        if dist < 150 then
                            plr.Character.HumanoidRootPart.CFrame = otherRoot.CFrame * CFrame.new(0, 0, 3)
                            if features.AutoAttack then
                                attackTarget(other.Character)
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.2)
    end
end)

print("✅ Astro v6.2 LOADED | GUI should appear now | Password: astro")
print("⚠️ If no GUI, try re-executing or check Delta executor version")
