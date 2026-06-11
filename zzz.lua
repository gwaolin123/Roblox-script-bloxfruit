-- Blox Fruits Script v6.1 - 1HIT + Auto Attack + Auto Quest | Password: astro
-- No mouse click spam, uses Damage Modifier and Auto Quest turn-in

getgenv().AstroPass = "astro"

-- Password gate
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
    
    local unlocked = false
    submitBtn.MouseButton1Click:Connect(function()
        if inputBox.Text == "astro" then
            unlocked = true
            passDialog:Destroy()
        else
            inputBox.Text = "WRONG"
            task.wait(1)
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
local runservice = game:GetService("RunService")
local teleportservice = game:GetService("TeleportService")
local playerservice = game:GetService("Players")
local coregui = game:GetService("CoreGui")
local replicated = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local http = game:GetService("HttpService")

-- 1HIT DAMAGE MODIFIER (sets all damage to kill instantly)
local function enableOneHit()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local character = localPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        -- Set max health and damage multipliers
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
    
    -- Modify all weapons to do instant kill damage
    for _, tool in pairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            local damageScript = tool:FindFirstChild("DamageScript")
            if damageScript then
                damageScript:Destroy()
            end
        end
    end
    
    -- Hook into combat remote
    local combatRemote = replicated:FindFirstChild("Combat") or replicated:FindFirstChild("Damage")
    if combatRemote then
        local oldFire = combatRemote.FireServer
        combatRemote.FireServer = function(self, ...)
            local args = {...}
            if args[2] then
                args[2] = 9999999
            end
            return oldFire(self, unpack(args))
        end
    end
end

-- Auto Quest (get and turn in)
local currentQuest = nil
local questMob = nil
local questCount = 0
local questRequired = 0

local function getQuest()
    local questGivers = {"Quest Giver", "Bartilo", "Monk", "Swan", "Elite Hunter"}
    for _, npcName in pairs(questGivers) do
        local npc = workspace.NPCs:FindFirstChild(npcName)
        if npc and npc:FindFirstChild("ClickDetector") then
            fireclickdetector(npc.ClickDetector)
            task.wait(0.5)
            -- Check if quest was taken
            local gui = plr.PlayerGui:FindFirstChild("Quest")
            if gui and gui:FindFirstChild("Frame") then
                local questText = gui.Frame:FindFirstChild("TextLabel")
                if questText then
                    local text = questText.Text
                    for _, mob in pairs({"Bandit", "Brute", "Pirate", "Monkey", "Shark", "Marine", "Raider", "Soldier"}) do
                        if text:find(mob) then
                            questMob = mob
                            local countMatch = string.match(text, "(%d+)/%d+")
                            if countMatch then
                                questCount = tonumber(countMatch) or 0
                            end
                            local reqMatch = string.match(text, "%d+/(%d+)")
                            if reqMatch then
                                questRequired = tonumber(reqMatch) or 5
                            end
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
    local questGivers = {"Quest Giver", "Bartilo", "Monk", "Swan", "Elite Hunter"}
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

-- Auto Attack (no mouse, uses FireServer)
local function attackTarget(target)
    if not target or not target:FindFirstChild("Humanoid") or target.Humanoid.Health <= 0 then
        return false
    end
    
    local combatRemote = replicated:FindFirstChild("Combat") or replicated:FindFirstChild("Attack")
    if combatRemote then
        pcall(function()
            combatRemote:FireServer(target, "Click")
        end)
    end
    
    -- Alternative: Use tool activation
    local character = plr.Character
    if character then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            pcall(function()
                tool:Activate()
            end)
        end
    end
    
    return true
end

-- GUI
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

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,35)
titleBar.BackgroundColor3 = Color3.fromRGB(35,35,50)
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1,-80,1,0)
titleText.Position = UDim2.new(0,10,0,0)
titleText.Text = "BLOX FRUITS v6.1 | 1HIT + AUTO QUEST"
titleText.TextColor3 = Color3.fromRGB(255,100,150)
titleText.TextSize = 14
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

-- Tab system
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1,0,0,40)
tabFrame.Position = UDim2.new(0,0,0,35)
tabFrame.BackgroundColor3 = Color3.fromRGB(25,25,40)
tabFrame.Parent = mainFrame

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
    content.CanvasSize = UDim2.new(0,0,0,400)
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
local combatTab = createTab("1HIT", 0.22)
local worldTab = createTab("QUEST", 0.42)
local miscTab = createTab("MISC", 0.62)

-- Features
local features = {
    OneHit = false, AutoAttack = false, AutoQuest = false,
    Farm = false, Stats = false, Bounty = false,
    FruitFind = false, Spin = false, Reset = false, Bypass = false
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
            if key == "OneHit" then enableOneHit() end
        else
            toggle.Text = "OFF"
            toggle.BackgroundColor3 = Color3.fromRGB(100,40,40)
        end
    end)
end

addToggle(mainTab, "Auto Farm (Teleport)", "Farm")
addToggle(mainTab, "Auto Stats", "Stats")
addToggle(mainTab, "Auto Bounty (PvP)", "Bounty")

addToggle(combatTab, "1 HIT KILL (God Mode)", "OneHit")
addToggle(combatTab, "Auto Attack (No Mouse)", "AutoAttack")

addToggle(worldTab, "Auto Quest (Get/Turn In)", "AutoQuest")
addToggle(worldTab, "Auto Fruit Finder", "FruitFind")
addToggle(worldTab, "Auto Spin Gacha", "Spin")

addToggle(miscTab, "Auto Reset Character", "Reset")
addToggle(miscTab, "Auto Bypass/Idle", "Bypass")

-- Show first tab
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
        
        -- AUTO QUEST
        if features.AutoQuest then
            local questGui = plr.PlayerGui:FindFirstChild("Quest")
            if not questGui or not questGui:FindFirstChild("Frame") then
                getQuest()
            else
                -- Check if quest complete
                local questText = questGui.Frame:FindFirstChild("TextLabel")
                if questText then
                    local text = questText.Text
                    local current, required = string.match(text, "(%d+)/(%d+)")
                    if current and required and tonumber(current) >= tonumber(required) then
                        turnInQuest()
                        task.wait(1)
                    end
                end
            end
        end
        
        -- AUTO FARM (with quest mob targeting)
        if features.Farm and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local mobs = {"Bandit", "Brute", "Pirate", "Monkey", "Shark", "Marine", "Raider", "Soldier"}
            -- If quest active, target only quest mob
            local targetMob = questMob or nil
            local target = nil
            local minDist = math.huge
            
            local enemyContainer = workspace:FindFirstChild("Enemies") or workspace
            for _, v in pairs(enemyContainer:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    local shouldTarget = false
                    if targetMob and v.Name:lower():find(targetMob:lower()) then
                        shouldTarget = true
                    elseif not targetMob then
                        for _, m in pairs(mobs) do
                            if v.Name == m or (v.Name and v.Name:lower():find(m:lower())) then
                                shouldTarget = true
                                break
                            end
                        end
                    end
                    
                    if shouldTarget then
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
                    task.wait(0.05)
                    if features.AutoAttack then
                        attackTarget(target)
                    end
                    -- Update quest count if needed
                    if features.AutoQuest and questMob and target.Name:lower():find(questMob:lower()) then
                        task.wait(0.1)
                    end
                end
            end
        end
        
        -- AUTO ATTACK (independent, hits nearest)
        if features.AutoAttack and not features.Farm then
            local mobs = {"Bandit", "Brute", "Pirate", "Monkey", "Shark", "Marine", "Raider", "Soldier"}
            local nearest = nil
            local minDist = math.huge
            local enemyContainer = workspace:FindFirstChild("Enemies") or workspace
            for _, v in pairs(enemyContainer:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    for _, m in pairs(mobs) do
                        if v.Name == m or (v.Name and v.Name:lower():find(m:lower())) then
                            local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Head")
                            if root and plr.Character then
                                local d = (root.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                                if d < minDist and d < 50 then
                                    minDist = d
                                    nearest = v
                                end
                            end
                            break
                        end
                    end
                end
            end
            if nearest then
                attackTarget(nearest)
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
            features.Spin = false
        end
        
        -- AUTO RESET
        if features.Reset and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.Health = 0
            features.Reset = false
        end
        
        task.wait(0.1)
    end
end)

-- AUTO BOUNTY
task.spawn(function()
    while true do
        if features.Bounty and plr.Character then
            for _, other in pairs(playerservice:GetPlayers()) do
                if other ~= plr and other.Character and other.Character:FindFirstChild("Humanoid") and other.Character.Humanoid.Health > 0 then
                    local otherRoot = other.Character:FindFirstChil
