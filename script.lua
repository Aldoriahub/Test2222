local success, data = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/Aldoriahub/Test2222/refs/heads/main/keys.lua', true))()
end)

local inputedkey = LDKey  -- Replace with actual key input logic

-- Ensure `isValidKey` is defined, and check the validity
local function isValidKey(key, devkeys)
    -- Example check: Ensure that the key is valid by comparing it to the devkeys
    for _, validKey in pairs(devkeys) do
        if key == validKey then
            return true
        end
    end
    return false
end

-- Store the keys in a global variable
getgenv().keys = data.keys
getgenv().devkeys = data.devkeys

-- Debug: Ensure keys exist and are tables
if type(getgenv().keys) == "table" then
    
else
    print("Key eror: 255")
end

if type(getgenv().devkeys) == "table" then
    
else
    print("Key eror: 256")
end



local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
loadstring(game:HttpGet('https://aldoriahub.se/virtualhub/obf/apivirtual.lua'))("")

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    -- Set Center to true if you want the menu to appear in the center
    -- Set AutoShow to true if you want the menu to appear when it is created
    -- Position and Size are also valid options here
    -- but you do not need to define them unless you are changing them :)

    Title = 'VirtualHub Arsenal',
    Center = true,
    AutoShow = true,
    TabPadding = 8
})


local Tabs = {
    -- Creates a new tab titled Main
    Main = Window:AddTab('Main'),
    ESP = Window:AddTab('ESP'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
    
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Speed, jump , amo, rainbow')
local LeftGroupBox3 = Tabs.Main:AddLeftGroupbox('Aimbot')
local LeftGroupBox2 = Tabs.ESP:AddLeftGroupbox('Box esp')

LeftGroupBox:AddSlider('Speed', {
    Text = 'Speed',
    Default = 16,
    Min = 16,
    Max = 500,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        _G.Speed(Value)
    end
})

local aimbotEnabled = false
local showFOV = false
local fovSize = 100

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local teamCheckEnabled = false

LeftGroupBox3:AddToggle('Aimbot', {
    Text = 'Silent aim',
    Default = false, -- Default value (true / false)
    Tooltip = 'When on hold right click to aimbot', -- Information shown when you hover over the toggle

    Callback = function(Value)
        aimbotEnabled = Value
    end
})

LeftGroupBox3:AddToggle('FOV', {
    Text = 'Show FOV',
    Default = false, -- Default value (true / false)
    Tooltip = 'When on FOV shows', -- Information shown when you hover over the toggle

    Callback = function(Value)
        showFOV = Value
    end
})

LeftGroupBox3:AddSlider('FOVslider', {
    Text = 'FOV Size',
    Default = 100,
    Min = 1,
    Max = 500,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        fovSize = Value
    end
})

LeftGroupBox3:AddToggle('Teamcheck', {
    Text = 'Team check',
    Default = false,
    Tooltip = 'Check if the player is on the same team',
    Callback = function(Value)
        teamCheckEnabled = Value
    end
})

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = fovSize

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not teamCheckEnabled or player.Team ~= LocalPlayer.Team then
                local pos = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)).magnitude

                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end

    return closestPlayer
end

local aimPart = "HumanoidRootPart"

LeftGroupBox3:AddDropdown('aimpart', {
    Values = { 'Head', 'HumanoidRootPart', 'Both' },
    Default = 2,
    Multi = false,
    Text = 'Aim Part',
    Tooltip = 'Select the part to aim at',
    Callback = function(Value)
        if Value == 'Head' then
            aimPart = "Head"
        elseif Value == 'HumanoidRootPart' then
            aimPart = "HumanoidRootPart"
        else
            aimPart = "Both"
        end
    end
})

local function aimAt(target)
    if target and target.Character then
        if aimPart == "Both" then
            local head = target.Character:FindFirstChild("Head")
            local rootPart = target.Character:FindFirstChild("HumanoidRootPart")
            if head and rootPart then
                local headPos = Camera:WorldToViewportPoint(head.Position)
                local rootPos = Camera:WorldToViewportPoint(rootPart.Position)
                local aimPos = (headPos + rootPos) / 2
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPos)
            end
        else
            local part = target.Character:FindFirstChild(aimPart)
            if part then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayer()
        aimAt(target)
    end

    if showFOV then
        -- Draw FOV circle
        if not fovCircle then
            fovCircle = Drawing.new("Circle")
            fovCircle.Thickness = 2
            fovCircle.Color = Color3.fromRGB(255, 255, 255)
            fovCircle.Filled = false
        end
        fovCircle.Radius = fovSize
        fovCircle.Position = UserInputService:GetMouseLocation()
        fovCircle.Visible = true
    elseif fovCircle then
        fovCircle.Visible = false
    end
end)


local amoEnabled = false

LeftGroupBox:AddToggle('INF Amo', {
    Text = 'INF Amo',
    Default = false, -- Default value (true / false)
    Tooltip = 'Gives inf amo when its on', -- Information shown when you hover over the toggle

    Callback = function(Value)
        amoEnabled = not amoEnabled
        while amoEnabled do
            game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount.Value = 999
            game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount2.Value = 999
            wait() 
        end
    end
})

if isValidKey(inputedkey, data.devkeys) then
    LeftGroupBox:AddToggle('win', {
        Text = 'Kill',
        Default = false,
        Tooltip = 'Kill everyone',
        Callback = function(Value)
            local isKilling = false
            local teamCheck = true  -- Enable team checking

            -- Function to kill all players
            local function killAll()
                local lastTarget = nil

                while Value do
                    local targetFound = false
                    local currentTarget = nil

                    -- Ensure LocalPlayer has a valid character
                    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        wait(0.5)
                        continue
                    end

                    -- Search for a new target if needed
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") then
                            if (not teamCheck or player.Team ~= LocalPlayer.Team) and (player ~= lastTarget) then
                                local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                                if distance <= 100 then
                                    currentTarget = player
                                    targetFound = true
                                    break
                                end
                            end
                        end
                    end

                    -- If a valid target is found
                    if targetFound and currentTarget then
                        local humanoid = currentTarget.Character:FindFirstChildOfClass("Humanoid")
                        local head = currentTarget.Character:FindFirstChild("Head")

                        if humanoid and humanoid.Health > 0 and head then
                            while humanoid.Health > 0 and Value do
                                if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
                                    LocalPlayer.Character:SetPrimaryPartCFrame(head.CFrame * CFrame.new(0, 0, -3))
                                end
                                Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
                                wait(0.05)
                            end
                            lastTarget = currentTarget
                        end
                    end

                    if not targetFound then
                        wait(0.5)
                    end
                end

                isKilling = false
            end

            -- Start or stop the kill function
            if Value then
                if not isKilling then
                    isKilling = true
                    spawn(killAll)  -- Use `spawn` instead of coroutine for simplicity
                end
            else
                isKilling = false
            end
        end
    })
end




LeftGroupBox:AddButton({
    Text = 'Rainbow Gun',
    Func = function()
        local function zigzag(X)
            return math.acos(math.cos(X * math.pi)) / math.pi
        end
        local c = 0
        game:GetService("RunService").RenderStepped:Connect(function()
            if game.Workspace.Camera:FindFirstChild('Arms') then
                for _, v in pairs(game.Workspace.Camera.Arms:GetDescendants()) do
                    if v.ClassName == 'MeshPart' then
                        v.Color = Color3.fromHSV(zigzag(c), 1, 1)
                        c = c + .0001
                    end
                end
            end
        end)
    end,
    DoubleClick = false,
    Tooltip = 'Makes guns rainbow'
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ESP Table
local ESP_Enabled = false
local HPBar_Enabled = false
local NameTag_Enabled = false
local ESP_Boxes = {}
local HP_Bars = {}
local HP_BarBackgrounds = {}
local NameTags = {}

-- Function to create a box
local function CreateESP(Player)
    if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local Box = Drawing.new("Square")
        Box.Thickness = 2
        Box.Color = Color3.fromRGB(255, 0, 0)
        Box.Filled = false
        Box.Visible = false
        ESP_Boxes[Player] = Box
        
        local HP_BarBackground = Drawing.new("Square")
        HP_BarBackground.Thickness = 1
        HP_BarBackground.Filled = true
        HP_BarBackground.Color = Color3.fromRGB(50, 50, 50)
        HP_BarBackground.Visible = false
        HP_BarBackgrounds[Player] = HP_BarBackground
        
        local HP_Bar = Drawing.new("Square")
        HP_Bar.Thickness = 1
        HP_Bar.Filled = true
        HP_Bar.Color = Color3.fromRGB(0, 255, 0)
        HP_Bar.Visible = false
        HP_Bars[Player] = HP_Bar
        
        local NameTag = Drawing.new("Text")
        NameTag.Color = Color3.fromRGB(255, 255, 255)
        NameTag.Size = 14 -- Adjusted size for better proportion
        NameTag.Center = true -- Centers text to avoid huge name issue
        NameTag.Outline = true
        NameTag.Visible = false
        NameTags[Player] = NameTag
    end
end

-- Function to refresh ESP for team checks
local function RefreshESP()
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            if Player.Team ~= LocalPlayer.Team then
                if not ESP_Boxes[Player] then
                    CreateESP(Player)
                end
            else
                if ESP_Boxes[Player] then
                    ESP_Boxes[Player]:Remove()
                    ESP_Boxes[Player] = nil
                end
                if HP_Bars[Player] then
                    HP_Bars[Player]:Remove()
                    HP_Bars[Player] = nil
                end
                if HP_BarBackgrounds[Player] then
                    HP_BarBackgrounds[Player]:Remove()
                    HP_BarBackgrounds[Player] = nil
                end
                if NameTags[Player] then
                    NameTags[Player]:Remove()
                    NameTags[Player] = nil
                end
            end
        end
    end
end

-- Toggle ESP Function
local function ToggleESP(State)
    ESP_Enabled = State
    if not State then
        for _, Box in pairs(ESP_Boxes) do Box:Remove() end
        for _, HP_Bar in pairs(HP_Bars) do HP_Bar:Remove() end
        for _, HP_BarBackground in pairs(HP_BarBackgrounds) do HP_BarBackground:Remove() end
        for _, NameTag in pairs(NameTags) do NameTag:Remove() end
        ESP_Boxes = {}
        HP_Bars = {}
        HP_BarBackgrounds = {}
        NameTags = {}
    else
        RefreshESP()
    end
end

-- Toggle HP Bar Function
local function ToggleHPBar(State)
    HPBar_Enabled = State
end

-- Toggle Name Tag Function
local function ToggleNameTag(State)
    NameTag_Enabled = State
end

-- Updating ESP
RunService.RenderStepped:Connect(function()
    if ESP_Enabled then
        RefreshESP()
        for Player, Box in pairs(ESP_Boxes) do
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Humanoid") then
                local RootPart = Player.Character.HumanoidRootPart
                local Head = Player.Character:FindFirstChild("Head")
                local Humanoid = Player.Character.Humanoid
                
                if Head then
                    local HeadPos, OnScreenHead = Camera:WorldToViewportPoint(Head.Position)
                    local FootPos, OnScreenFoot = Camera:WorldToViewportPoint(RootPart.Position - Vector3.new(0, Humanoid.HipHeight + 2, 0))
                    
                    if OnScreenHead and OnScreenFoot and HeadPos.Z > 0 then -- Ensuring the player is in front
                        local Height = math.abs(FootPos.Y - HeadPos.Y)
                        local Width = Height / 2
                        Box.Size = Vector2.new(Width, Height) -- Fixed size scaling
                        Box.Position = Vector2.new(HeadPos.X - Width / 2, HeadPos.Y)
                        Box.Visible = true
                        
                        if HPBar_Enabled then
                            local HP_Percentage = Humanoid.Health / Humanoid.MaxHealth
                            local HP_Height = math.clamp(HP_Percentage * Height, 0, Height)
                            HP_Bars[Player].Size = Vector2.new(4, HP_Height)
                            HP_Bars[Player].Position = Vector2.new(HeadPos.X - Width / 2 - 6, FootPos.Y - HP_Height)
                            HP_Bars[Player].Color = Humanoid.Health < 20 and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
                            HP_Bars[Player].Visible = true
                            
                            HP_BarBackgrounds[Player].Size = Vector2.new(4, Height)
                            HP_BarBackgrounds[Player].Position = Vector2.new(HeadPos.X - Width / 2 - 6, FootPos.Y - Height)
                            HP_BarBackgrounds[Player].Visible = true
                        else
                            HP_Bars[Player].Visible = false
                            HP_BarBackgrounds[Player].Visible = false
                        end
                        
                        if NameTag_Enabled then
                            NameTags[Player].Text = Player.Name
                            NameTags[Player].Size = math.clamp(14 * (150 / Height), 10, 14) -- Adjusted name scaling
                            NameTags[Player].Position = Vector2.new(HeadPos.X, HeadPos.Y - 20)
                            NameTags[Player].Visible = true
                        else
                            NameTags[Player].Visible = false
                        end
                    else
                        Box.Visible = false
                        HP_Bars[Player].Visible = false
                        HP_BarBackgrounds[Player].Visible = false
                        NameTags[Player].Visible = false
                    end
                end
            else
                Box.Visible = false
                HP_Bars[Player].Visible = false
                HP_BarBackgrounds[Player].Visible = false
                NameTags[Player].Visible = false
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(Player)
    Player:GetPropertyChangedSignal("Team"):Connect(function()
        RefreshESP()
    end)
end)

LeftGroupBox2:AddToggle('Box ESP', {
    Text = 'Box ESP',
    Default = false,
    Tooltip = 'Shows boxes around enemies',
    Callback = function(Value)
        ToggleESP(Value)
    end
})

LeftGroupBox2:AddToggle('HP Bar', {
    Text = 'HP Bar',
    Default = false,
    Tooltip = 'Displays enemy HP bar',
    Callback = function(Value)
        ToggleHPBar(Value)
    end
})

LeftGroupBox2:AddToggle('Name Tag', {
    Text = 'Name Tag',
    Default = false,
    Tooltip = 'Displays enemy names',
    Callback = function(Value)
        ToggleNameTag(Value)
    end
})


Library:OnUnload(function()
    print('Unloaded!')
    Library.Unloaded = true
end)

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

-- I set NoUI so it does not show up in the keybinds menu
MenuGroup:AddButton('Unload', function() Library:Unload() end)
