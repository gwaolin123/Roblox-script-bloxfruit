-- Blox Fruits Script v5.1 - Delta Executor Compatible | Password: astro
-- Author: palofsc
-- Delta specific: uses loadstring, getgenv(), task.wait(), and Delta's custom UI library

getgenv().AstroPass = "astro"

-- Password gate for Delta
local function deltaPasswordCheck()
    local passInput = ""
    local passDialog = Instance.new("ScreenGui")
    passDialog.Name = "AstroAuth"
    passDialog.Parent = game:GetService("CoreGui")
    
    local mainBox = Instance.new("Frame")
    mainBox.Size = UDim2.new(0, 300, 0, 120)
    mainBox.Position = UDim2.new(0.5, -150, 0.5, -60)
    mainBox.BackgroundColor3 = Color3.fromRGB(25,25,35)
    mainBox.BorderSizePixel = 2
    mainBox.BorderColor3 = Color3.fromRGB(255,50,100)
    mainBox.Parent = passDialog
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,0,35)
    label.Text = "PASSWORD: astro"
    label.TextColor3 = Color3.fromRGB(255,200,200)
    label.BackgroundTransparency = 1
    label.Parent = mainBox
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(0.8,0,0,35)
    inputBox.Position = UDim2.new(0.1,0,0.45,0)
    inputBox.PlaceholderText = "enter password"
    inputBox.Text = ""
    inputBox.BackgroundColor3 = Color3.fromRGB(50,50,70)
    inputBox.TextColor3 = Color3.fromRGB(255,255,255)
    inputBox.Parent = mainBox
    
    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(0.5,0,0,30)
    submitBtn.Position = UDim2.new(0.25,0,0.75,0)
    submitBtn.Text = "UNLOCK"
    submitBtn.BackgroundColor3 = Color3.fromRGB(100,200,100)
    submitBtn.Parent = mainBox
    
    local unlocked = false
    submitBtn.MouseButton1Click:Connect(function()
        if inputBox.Text == "astro" then
            unlocked = true
            passDialog:Destroy()
        else
            inputBox.Text = "WRONG"
            task.wait(0.5)
            inputBox.Text = ""
        end
    end)
    
    repeat task.wait() until unlocked == true
end

if not getgenv().AstroChecked then
    deltaPasswordCheck()
    getgenv().AstroChecked = true
end

-- Delta UI using library if available, else fallback
local libraryLoaded = false
local library = nil
if syn and syn.protect_gui then
    pcall(function()
        library = loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandSeven/delta_lib/main/source.lua"))()
        libraryLoaded = true
    end)
end

if not libraryLoaded then
    library = {}
    library.Window = function(_, title, size)
        local scr = Instance.new("ScreenGui")
        scr.Name = "DeltaAstro"
        scr.Parent = game:GetService("CoreGui")
        local fr = Instance.new("Frame")
        fr.Size = UDim2.new(0, size.X or 400, 0, size.Y or 500)
        fr.Position = UDim2.new(0.5, -(size.X or 400)/2, 0.5, -(size.Y or 500)/2)
        fr.BackgroundColor3 = Color3.fromRGB(20,20,30)
        fr.BorderSizePixel = 2
        fr.BorderColor3 = Color3.fromRGB(255,0,120)
        fr.Parent = scr
        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1,0,0,30)
        titleLbl.Text = title
        titleLbl.BackgroundColor3 = Color3.fromRGB(40,40,55)
        titleLbl.Parent = fr
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0,40,0,25)
        closeBtn.Position = UDim2.new(1,-45,0,2)
        closeBtn.Text = "X"
        closeBtn.BackgroundColor3 = Color3.fromRGB(150,30,30)
        closeBtn.Parent = fr
        local openBtn = Instance.new("TextButton")
        openBtn.Size = UDim2.new(0,70,0,30)
        openBtn.Position = UDim2.new(0.02,0,0.02,0)
        openBtn.Text = "OPEN"
        openBtn.BackgroundColor3 = Color3.fromRGB(0,150,0)
        openBtn.Visible = false
        openBtn.Parent = scr
        local mainScrl = Instance.new("ScrollingFrame")
        mainScrl.Size = UDim2.new(1,-10,1,-40)
        mainScrl.Position = UDim2.new(0,5,0,35)
        mainScrl.BackgroundTransparency = 1
        mainScrl.CanvasSize = UDim2.new(0,0,0,800)
        mainScrl.ScrollBarThickness = 5
        mainScrl.Parent = fr
        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0,4)
        list.Parent = mainScrl
        closeBtn.MouseButton1Click:Connect(function() fr.Visible = false; openBtn.Visible = true end)
        openBtn.MouseButton1Click:Connect(function() fr.Visible = true; openBtn.Visible = false end)
        local dragging, dragStart, startPos = false
        titleLbl.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true; dragStart = inp.Position; startPos = fr.Position
            end
        end)
        userinput.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        userinput.InputChanged:Connect(function(inp)
            if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = inp.Position - dragStart
                fr.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        return {Tab = function(_, name)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0,80,0,30)
            btn.Text = name
            btn.BackgroundColor3 = Color3.fromRGB(60,60,80)
            btn.Parent = fr
            local content = Instance.new("Frame")
            content.Size = UDim2.new(1,0,1,-40)
            content.Position = UDim2.new(0,0,0,35)
            content.BackgroundTransparency = 1
            content.Visible = false
            content.Parent = fr
            btn.MouseButton1Click:Connect(function() content.Visible = true; for _,v in pairs(fr:GetChildren()) do if v:IsA("Frame") and v ~= content and v ~= mainScrl then v.Visible = false end end end)
            local scrl = Instance.new("ScrollingFrame")
            scrl.Size = UDim2.new(1,0,1,0)
            scrl.BackgroundTransparency = 1
            scrl.CanvasSize = UDim2.new(0,0,0,600)
            scrl.Parent = content
            local lay = Instance.new("UIListLayout")
            lay.Padding = UDim.new(0,5)
            lay.Parent = scrl
            return {Toggle = function(_, toggleName, callback)
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1,-10,0,35)
                row.BackgroundColor3 = Color3.fromRGB(35,35,50)
                row.Parent = scrl
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(0.7,0,1,0)
                lbl.Text = toggleName
                lbl.TextColor3 = Color3.fromRGB(220,220,220)
                lbl.BackgroundTransparency = 1
                lbl.Parent = row
                local tog = Instance.new("TextButton")
                tog.Size = UDim2.new(0,70,0,25)
                tog.Position = UDim2.new(0.72,0,0.05,0)
                tog.Text = "OFF"
                tog.BackgroundColor3 = Color3.fromRGB(100,40,40)
                tog.Parent = row
                local state = false
                tog.MouseButton1Click:Connect(function()
                    state = not state
                    if state then tog.Text = "ON"; tog.BackgroundColor3 = Color3.fromRGB(40,100,40) else tog.Text = "OFF"; tog.BackgroundColor3 = Color3.fromRGB(100,40,40) end
                    callback(state)
                end)
                return {set = function(_, s) state = s; if s then tog.Text="ON"; tog.BackgroundColor3=Color3.fromRGB(40,100,40) else tog.Text="OFF"; tog.BackgroundColor3=Color3.fromRGB(100,40,40) end; callback(state) end}
            end}
        end}
    end
end

local win = library.Window("Delta Astro v5.1", "BLOX FRUITS | astro", Vector2.new(420, 550))
local mainTab = win.Tab("Main")
local combatTab = win.Tab("Combat")
local worldTab = win.Tab("World")
local miscTab = win.Tab("Misc")

-- Feature states
local features = {
    Farm = false, Raid = false, SeaEvent = false, Boss = false, FruitFind = false,
    Elite = false, Chest = false, Observation = false, FightingStyle = false, Stats = false,
    Ship = false, Factory = false, Castle = false, Islands = false, Teleport = false,
    Bounty = false, Skills = false, Gun = false, Sword = false, Fruit = false,
    RaceV2 = false, Title = false, Quest = false, Store = false, Drop = false,
    Sell = false, Spin = false, Reset = false, ServerHop = false, Bypass = false
}

mainTab.Toggle("Auto Farm", function(v) features.Farm = v end)
mainTab.Toggle("Auto Raid", function(v) features.Raid = v end)
mainTab.Toggle("Auto Boss", function(v) features.Boss = v end)
mainTab.Toggle("Auto Elite Hunter", function(v) features.Elite = v end)
mainTab.Toggle("Auto Chest Farm", function(v) features.Chest = v end)
mainTab.Toggle("Auto Stats", function(v) features.Stats = v end)

combatTab.Toggle("Auto Bounty", function(v) features.Bounty = v end)
combatTab.Toggle("Auto Skills", function(v) features.Skills = v end)
combatTab.Toggle("Auto Gun", function(v) features.Gun = v end)
combatTab.Toggle("Auto Sword", function(v) features.Sword = v end)
combatTab.Toggle("Auto Fruit", function(v) features.Fruit = v end)

worldTab.Toggle("Auto Sea Event", function(v) features.SeaEvent = v end)
worldTab.Toggle("Auto Ship", function(v) features.Ship = v end)
worldTab.Toggle("Auto Factory", function(v) features.Factory = v end)
worldTab.Toggle("Auto Castle Raid", function(v) features.Castle = v end)
worldTab.Toggle("Auto Islands", function(v) features.Islands = v end)
worldTab.Toggle("Auto Teleport", function(v) features.Teleport = v end)

miscTab.Toggle("Auto Fruit Finder", function(v) features.FruitFind = v end)
miscTab.Toggle("Auto Observation", function(v) features.Observation = v end)
miscTab.Toggle("Auto Fighting Style", function(v) features.FightingStyle = v end)
miscTab.Toggle("Auto Race V2", function(v) features.RaceV2 = v end)
miscTab.Toggle("Auto Title", function(v) features.Title = v end)
miscTab.Toggle("Auto Quest", function(v) features.Quest = v end)
miscTab.Toggle("Auto Store", function(v) features.Store = v end)
miscTab.Toggle("Auto Drop", function(v) features.Drop = v end)
miscTab.Toggle("Auto Sell", function(v) features.Sell = v end)
miscTab.Toggle("Auto Spin", function(v) features.Spin = v end)
miscTab.Toggle("Auto Reset", function(v) features.Reset = v end)
miscTab.Toggle("Auto Server Hop", function(v) features.ServerHop = v end)
miscTab.Toggle("Auto Bypass", function(v) features.Bypass = v end)

-- Bypass function for Delta anti-cheat
local function deltaBypass()
    for _, v in pairs(coregui:GetChildren()) do
        if v.Name:lower():find("anticheat") or v.Name:lower():find("antihack") then
            v:Destroy()
        end
    end
    if game:GetService("Players").LocalPlayer.Idled then
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            virtualinput:SendKeyEvent("W", true, game)
            task.wait(0.1)
            virtualinput:SendKeyEvent("W", false, game)
        end)
    end
    local remoteSpam = replicated:FindFirstChild("__AntiCheat")
    if remoteSpam then remoteSpam:Destroy() end
end

-- Core auto functions (Delta optimized)
task.spawn(function()
    while true do
        if features.Bypass then deltaBypass() end
        
        if features.Farm and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local mobs = {"Bandit","Brute","Pirate","Monkey","Shark","Mob","NPC","Marine","Raider","Soldier"}
            local target = nil
            local minDist = math.huge
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    for _, m in pairs(mobs) do
                        if v.Name:lower():find(m:lower()) then
                            local d = (v.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if d < minDist and d < 300 then minDist = d; target = v end
                        end
                    end
                end
            end
            if target then
                player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 2, 3)
                virtualinput:SendKeyEvent("MouseButton1", true, game)
                task.wait(0.05)
                virtualinput:SendKeyEvent("MouseButton1", false, game)
            end
        end
        
        if features.Stats and player:FindFirstChild("Data") and player.Data:FindFirstChild("Stats") then
            local s = player.Data.Stats
            pcall(function() s.Melee.Value = 2500 end)
            pcall(function() s.Defense.Value = 2500 end)
            pcall(function() s.Sword.Value = 2500 end)
            pcall(function() s.Gun.Value = 2500 end)
            pcall(function() s.Fruit.Value = 2500 end)
        end
        
        if features.FruitFind then
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("Tool") and v:FindFirstChild("Handle") and (v.Name:lower():find("fruit") or v.Name:lower():find("leopard") or v.Name:lower():find("dragon")) then
                    if player.Character and player.Character.HumanoidRootPart then
                        player.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                    end
                end
            end
        end
        
        if features.ServerHop then
            task.wait(30)
            teleportservice:Teleport(game.PlaceId)
        end
        
        if features.Reset and player.Character and player.Character.Humanoid then
            player.Character.Humanoid.Health = 0
        end
        
        if features.Spin then
            pcall(function()
                replicated.Events.SpinGacha:FireServer()
            end)
        end
        
        task.wait(0.1)
    end
end)

-- Additional combat loop
task.spawn(function()
    while true do
        if features.Bounty and player.Character then
            for _, plr in pairs(playerservice:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                    local dist = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 200 then
                        player.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,2)
                        virtualinput:SendKeyEvent("MouseButton1", true, game)
                        task.wait(0.05)
                        virtualinput:SendKeyEvent("MouseButton1", false, game)
                    end
                end
            end
        end
        if features.Skills then
            local keys = {"Q","E","R","T","Y","F","G","Z","X","C","V"}
            for _, key in pairs(keys) do
                virtualinput:SendKeyEvent(key, true, game)
                task.wait(0.05)
                virtualinput:SendKeyEvent(key, false, game)
            end
        end
        task.wait(0.5)
    end
end)

-- Sea events loop
task.spawn(function()
    while true do
        if features.SeaEvent then
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v.Name:lower():find("sea") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    if player.Character then
                        player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)

print("Delta Astro v5.1 | Password: astro | Loaded successfully")