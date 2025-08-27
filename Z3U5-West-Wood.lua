-- Z3U5 Visual Aid Script
-- Mobile Horror Game ESP System

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Z3U5_ESP"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- ESP Storage
local ESPObjects = {
    monsters = {},
    players = {},
    items = {},
    cacheboxes = {},
    locations = {}
}

-- Settings
local ESPSettings = {
    MonsterESP = false,
    PlayerESP = false,
    HousesESP = false,
    ItemsESP = false,
    CacheBoxESP = false
}

-- UI Colors and Styling
local UIColors = {
    Background = Color3.fromRGB(45, 45, 45),
    ButtonColor = Color3.fromRGB(60, 60, 60),
    AccentColor = Color3.fromRGB(255, 215, 0),
    TextColor = Color3.fromRGB(255, 255, 255),
    MonsterColor = Color3.fromRGB(255, 50, 50),     -- Red for monsters
    PlayerColor = Color3.fromRGB(0, 255, 100),      -- Green for players
    ItemColor = Color3.fromRGB(255, 200, 0),        -- Yellow for items
    LocationColor = Color3.fromRGB(100, 200, 255),  -- Blue for locations
    CacheColor = Color3.fromRGB(255, 100, 255),     -- Pink for cacheboxes
    PaperColor = Color3.fromRGB(255, 165, 0)        -- Orange for code paper
}

-- Create Main Button
local MainButton = Instance.new("TextButton")
MainButton.Name = "MainButton"
MainButton.Size = UDim2.new(0, 60, 0, 60)
MainButton.Position = UDim2.new(0, 20, 0, 100)
MainButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MainButton.BorderSizePixel = 0
MainButton.Text = "⚡️"
MainButton.TextColor3 = UIColors.TextColor
MainButton.TextScaled = true
MainButton.Font = Enum.Font.SourceSansBold
MainButton.Parent = ScreenGui

-- Round the button
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0.5, 0)
Corner.Parent = MainButton

-- Main Menu Frame
local MainMenu = Instance.new("Frame")
MainMenu.Name = "MainMenu"
MainMenu.Size = UDim2.new(0, 250, 0, 350)
MainMenu.Position = UDim2.new(0, 100, 0, 100)
MainMenu.BackgroundColor3 = UIColors.Background
MainMenu.BorderSizePixel = 0
MainMenu.Visible = false
MainMenu.Parent = ScreenGui

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 12)
MenuCorner.Parent = MainMenu

-- Teleport Menu Frame
local TeleportMenu = Instance.new("Frame")
TeleportMenu.Name = "TeleportMenu"
TeleportMenu.Size = UDim2.new(0, 250, 0, 400)
TeleportMenu.Position = UDim2.new(0, 370, 0, 100)
TeleportMenu.BackgroundColor3 = UIColors.Background
TeleportMenu.BorderSizePixel = 0
TeleportMenu.Visible = false
TeleportMenu.Parent = ScreenGui

local TeleportMenuCorner = Instance.new("UICorner")
TeleportMenuCorner.CornerRadius = UDim.new(0, 12)
TeleportMenuCorner.Parent = TeleportMenu

-- Teleport Menu Title
local TeleportTitle = Instance.new("TextLabel")
TeleportTitle.Name = "TeleportTitle"
TeleportTitle.Size = UDim2.new(1, 0, 0, 40)
TeleportTitle.Position = UDim2.new(0, 0, 0, 0)
TeleportTitle.BackgroundTransparency = 1
TeleportTitle.Text = "Teleport Menu"
TeleportTitle.TextColor3 = UIColors.AccentColor
TeleportTitle.TextScaled = true
TeleportTitle.Font = Enum.Font.SourceSansBold
TeleportTitle.Parent = TeleportMenu

-- Scroll Frame for teleport buttons
local TeleportScroll = Instance.new("ScrollingFrame")
TeleportScroll.Name = "TeleportScroll"
TeleportScroll.Size = UDim2.new(1, -10, 1, -50)
TeleportScroll.Position = UDim2.new(0, 5, 0, 45)
TeleportScroll.BackgroundTransparency = 1
TeleportScroll.BorderSizePixel = 0
TeleportScroll.ScrollBarThickness = 6
TeleportScroll.Parent = TeleportMenu

-- Menu Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Z3U5 ESP"
Title.TextColor3 = UIColors.AccentColor
Title.TextScaled = true
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainMenu

-- Button Template Function
local function createESPButton(name, position, setting)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 0, position)
    button.BackgroundColor3 = UIColors.ButtonColor
    button.BorderSizePixel = 0
    button.Text = name .. ": OFF"
    button.TextColor3 = UIColors.TextColor
    button.TextScaled = true
    button.Font = Enum.Font.SourceSans
    button.Parent = MainMenu
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        ESPSettings[setting] = not ESPSettings[setting]
        button.Text = name .. ": " .. (ESPSettings[setting] and "ON" or "OFF")
        button.BackgroundColor3 = ESPSettings[setting] and UIColors.AccentColor or UIColors.ButtonColor
        
        if setting == "MonsterESP" then
            toggleMonsterESP()
        elseif setting == "PlayerESP" then
            togglePlayerESP()
        elseif setting == "HousesESP" then
            toggleLocationESP()
        elseif setting == "ItemsESP" then
            toggleItemESP()
        elseif setting == "CacheBoxESP" then
            toggleCacheBoxESP()
        end
    end)
    
    return button
end

-- Create ESP Buttons
createESPButton("Monster ESP", 60, "MonsterESP")
createESPButton("Player ESP", 110, "PlayerESP")
createESPButton("Houses ESP", 160, "HousesESP")
createESPButton("Items ESP", 210, "ItemsESP")
createESPButton("CacheBox ESP", 260, "CacheBoxESP")

-- Teleport Button
local TeleportButton = Instance.new("TextButton")
TeleportButton.Name = "TeleportButton"
TeleportButton.Size = UDim2.new(1, -20, 0, 40)
TeleportButton.Position = UDim2.new(0, 10, 0, 310)
TeleportButton.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
TeleportButton.BorderSizePixel = 0
TeleportButton.Text = "Teleport Menu"
TeleportButton.TextColor3 = UIColors.TextColor
TeleportButton.TextScaled = true
TeleportButton.Font = Enum.Font.SourceSans
TeleportButton.Parent = MainMenu

local teleportButtonCorner = Instance.new("UICorner")
teleportButtonCorner.CornerRadius = UDim.new(0, 8)
teleportButtonCorner.Parent = TeleportButton

-- Animation Functions
local function animateButtonPress(button)
    local tween = TweenService:Create(button, 
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true),
        {Size = UDim2.new(0, 55, 0, 55)}
    )
    tween:Play()
end

-- Teleport locations data
local teleportLocations = {
    -- Houses
    {name = "House 1", pos = Vector3.new(-1899.73, 13.55, -1019.22)},
    {name = "House 2", pos = Vector3.new(-1967.71, 5.20, -1265.53)},
    {name = "House 3", pos = Vector3.new(-2252.76, 4.56, -962.53)},
    {name = "House 4", pos = Vector3.new(-2350.38, 10.36, -1146.34)},
    {name = "House 5", pos = Vector3.new(-2229.85, 9.95, -1444.92)},
    {name = "House 6", pos = Vector3.new(-2397.95, 2.89, -1517.19)},
    {name = "House 7", pos = Vector3.new(-1915.93, 4.45, -1621.71)},
    {name = "House 8", pos = Vector3.new(-1696.46, 10.51, -1695.40)},
    {name = "House 9", pos = Vector3.new(-1695.99, 1.81, -1382.98)},
    {name = "House 10", pos = Vector3.new(-1531.26, 10.06, -1192.95)},
    {name = "House 11", pos = Vector3.new(-1483.31, 2.00, -1369.89)},
    {name = "House 12", pos = Vector3.new(-1427.03, 10.19, -1610.70)},
    -- Extra Buildings
    {name = "WaterPump", pos = Vector3.new(-1666.40, 11.56, -1080.11)},
    {name = "Power Station", pos = Vector3.new(-2124.63, 8.99, -1790.79)},
    {name = "Church", pos = Vector3.new(-1853.36, 11.98, -1864.70)},
    {name = "Shop", pos = Vector3.new(-1822.92, 2.65, -1470.27)},
    {name = "Npc Shop", pos = Vector3.new(-2080.18, 8.13, -1014.72)}
}

-- Teleport function
local function teleportToLocation(position)
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- Create teleport buttons
local function createTeleportButtons()
    local yPos = 0
    for i, location in ipairs(teleportLocations) do
        local button = Instance.new("TextButton")
        button.Name = "TeleportTo" .. location.name
        button.Size = UDim2.new(1, -10, 0, 35)
        button.Position = UDim2.new(0, 5, 0, yPos)
        button.BackgroundColor3 = UIColors.ButtonColor
        button.BorderSizePixel = 0
        button.Text = location.name
        button.TextColor3 = UIColors.TextColor
        button.TextScaled = true
        button.Font = Enum.Font.SourceSans
        button.Parent = TeleportScroll
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        -- Teleport functionality
        button.MouseButton1Click:Connect(function()
            teleportToLocation(location.pos)
            -- Visual feedback
            local originalColor = button.BackgroundColor3
            button.BackgroundColor3 = UIColors.AccentColor
            wait(0.2)
            button.BackgroundColor3 = originalColor
        end)
        
        yPos = yPos + 40
    end
    
    -- Set scroll frame canvas size
    TeleportScroll.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

-- Initialize teleport buttons
createTeleportButtons()

-- Toggle functions
local function toggleMenu()
    if MainMenu.Visible then
        local tween = TweenService:Create(MainMenu,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Size = UDim2.new(0, 0, 0, 0)}
        )
        tween:Play()
        tween.Completed:Connect(function()
            MainMenu.Visible = false
            MainMenu.Size = UDim2.new(0, 250, 0, 350)
        end)
    else
        MainMenu.Visible = true
        MainMenu.Size = UDim2.new(0, 0, 0, 0)
        local tween = TweenService:Create(MainMenu,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 250, 0, 350)}
        )
        tween:Play()
    end
end

local function toggleTeleportMenu()
    if TeleportMenu.Visible then
        local tween = TweenService:Create(TeleportMenu,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Size = UDim2.new(0, 0, 0, 0)}
        )
        tween:Play()
        tween.Completed:Connect(function()
            TeleportMenu.Visible = false
            TeleportMenu.Size = UDim2.new(0, 250, 0, 400)
        end)
    else
        TeleportMenu.Visible = true
        TeleportMenu.Size = UDim2.new(0, 0, 0, 0)
        local tween = TweenService:Create(TeleportMenu,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 250, 0, 400)}
        )
        tween:Play()
    end
end

-- Connect teleport button
TeleportButton.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(TeleportButton, 
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true),
        {Size = UDim2.new(1, -25, 0, 35)}
    )
    tween:Play()
    toggleTeleportMenu()
end)

MainButton.MouseButton1Click:Connect(function()
    animateButtonPress(MainButton)
    toggleMenu()
end)

-- ESP Creation Functions
local function createESPLabel(obj, text, color, offset)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Label"
    billboard.Size = UDim2.new(0, 100, 0, 25)  -- Made 50% smaller
    billboard.StudsOffset = offset or Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = obj
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextScaled = true
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Font = Enum.Font.SourceSansBold
    label.Parent = billboard
    
    return billboard
end

local function createHighlight(obj, color)
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Parent = obj
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    return highlight
end

-- Monster ESP Functions
local function addMonsterESP(monster)
    if ESPObjects.monsters[monster] then return end
    
    local highlight = createHighlight(monster, UIColors.MonsterColor)
    local label = createESPLabel(monster, "Wendigo", UIColors.MonsterColor, Vector3.new(0, 5, 0))
    
    ESPObjects.monsters[monster] = {highlight = highlight, label = label}
end

local function removeMonsterESP(monster)
    if ESPObjects.monsters[monster] then
        if ESPObjects.monsters[monster].highlight then
            ESPObjects.monsters[monster].highlight:Destroy()
        end
        if ESPObjects.monsters[monster].label then
            ESPObjects.monsters[monster].label:Destroy()
        end
        ESPObjects.monsters[monster] = nil
    end
end

local function scanForMonsters()
    local function searchDescendants(parent)
        for _, obj in pairs(parent:GetDescendants()) do
            if obj.Name == "WendigoAI" and obj:IsA("Model") then
                if ESPSettings.MonsterESP then
                    addMonsterESP(obj)
                end
            end
        end
    end
    
    searchDescendants(Workspace)
end

function toggleMonsterESP()
    if ESPSettings.MonsterESP then
        scanForMonsters()
        -- Connect to new spawns
        Workspace.DescendantAdded:Connect(function(obj)
            if obj.Name == "WendigoAI" and obj:IsA("Model") and ESPSettings.MonsterESP then
                wait(0.1)
                addMonsterESP(obj)
            end
        end)
    else
        for monster, _ in pairs(ESPObjects.monsters) do
            removeMonsterESP(monster)
        end
    end
end

-- Player ESP Functions
local function addPlayerESP(player)
    if player == LocalPlayer or not player.Character then return end
    if ESPObjects.players[player] then return end
    
    local character = player.Character
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local highlight = createHighlight(character, UIColors.PlayerColor)
    local healthText = player.Name .. " (" .. math.floor(humanoid.Health) .. "HP)"
    local label = createESPLabel(character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart"), 
                                healthText, UIColors.PlayerColor, Vector3.new(0, 3, 0))
    
    ESPObjects.players[player] = {highlight = highlight, label = label, humanoid = humanoid}
    
    -- Update health
    local connection
    connection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if ESPObjects.players[player] and ESPObjects.players[player].label then
            local newText = player.Name .. " (" .. math.floor(humanoid.Health) .. "HP)"
            ESPObjects.players[player].label.TextLabel.Text = newText
        else
            connection:Disconnect()
        end
    end)
end

local function removePlayerESP(player)
    if ESPObjects.players[player] then
        if ESPObjects.players[player].highlight then
            ESPObjects.players[player].highlight:Destroy()
        end
        if ESPObjects.players[player].label then
            ESPObjects.players[player].label:Destroy()
        end
        ESPObjects.players[player] = nil
    end
end

function togglePlayerESP()
    if ESPSettings.PlayerESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                addPlayerESP(player)
            end
        end
        
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                if ESPSettings.PlayerESP then
                    wait(1)
                    addPlayerESP(player)
                end
            end)
        end)
        
        Players.PlayerRemoving:Connect(function(player)
            removePlayerESP(player)
        end)
        
        for _, player in pairs(Players:GetPlayers()) do
            player.CharacterAdded:Connect(function()
                if ESPSettings.PlayerESP then
                    wait(1)
                    addPlayerESP(player)
                end
            end)
        end
    else
        for player, _ in pairs(ESPObjects.players) do
            removePlayerESP(player)
        end
    end
end

-- Location ESP Functions
local locations = {
    -- Houses
    {name = "House 1", pos = Vector3.new(-1899.73, 13.55, -1019.22)},
    {name = "House 2", pos = Vector3.new(-1967.71, 5.20, -1265.53)},
    {name = "House 3", pos = Vector3.new(-2252.76, 4.56, -962.53)},
    {name = "House 4", pos = Vector3.new(-2350.38, 10.36, -1146.34)},
    {name = "House 5", pos = Vector3.new(-2229.85, 9.95, -1444.92)},
    {name = "House 6", pos = Vector3.new(-2397.95, 2.89, -1517.19)},
    {name = "House 7", pos = Vector3.new(-1915.93, 4.45, -1621.71)},
    {name = "House 8", pos = Vector3.new(-1696.46, 10.51, -1695.40)},
    {name = "House 9", pos = Vector3.new(-1695.99, 1.81, -1382.98)},
    {name = "House 10", pos = Vector3.new(-1531.26, 10.06, -1192.95)},
    {name = "House 11", pos = Vector3.new(-1483.31, 2.00, -1369.89)},
    {name = "House 12", pos = Vector3.new(-1427.03, 10.19, -1610.70)},
    -- Extra Buildings
    {name = "WaterPump", pos = Vector3.new(-1666.40, 11.56, -1080.11)},
    {name = "Power Station", pos = Vector3.new(-2124.63, 8.99, -1790.79)},
    {name = "Church", pos = Vector3.new(-1853.36, 11.98, -1864.70)},
    {name = "Shop", pos = Vector3.new(-1822.92, 2.65, -1470.27)},
    {name = "Npc Shop", pos = Vector3.new(-2080.18, 8.13, -1014.72)}
}

local function createLocationMarker(locationData)
    local part = Instance.new("Part")
    part.Name = "LocationMarker_" .. locationData.name
    part.Size = Vector3.new(1, 1, 1)
    part.Position = locationData.pos
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Parent = Workspace
    
    local label = createESPLabel(part, locationData.name, UIColors.LocationColor, Vector3.new(0, 0, 0))
    
    return {part = part, label = label}
end

function toggleLocationESP()
    if ESPSettings.HousesESP then
        for _, locationData in pairs(locations) do
            local marker = createLocationMarker(locationData)
            ESPObjects.locations[locationData.name] = marker
        end
    else
        for name, marker in pairs(ESPObjects.locations) do
            if marker.part then marker.part:Destroy() end
            if marker.label then marker.label:Destroy() end
        end
        ESPObjects.locations = {}
    end
end

-- Item ESP Functions
local function addItemESP(item)
    if ESPObjects.items[item] then return end
    
    local highlight = createHighlight(item, UIColors.ItemColor)
    local label = createESPLabel(item, item.Name, UIColors.ItemColor, Vector3.new(0, 2, 0))
    
    ESPObjects.items[item] = {highlight = highlight, label = label}
end

local function removeItemESP(item)
    if ESPObjects.items[item] then
        if ESPObjects.items[item].highlight then
            ESPObjects.items[item].highlight:Destroy()
        end
        if ESPObjects.items[item].label then
            ESPObjects.items[item].label:Destroy()
        end
        ESPObjects.items[item] = nil
    end
end

local function scanForItems()
    local function searchDescendants(parent)
        for _, obj in pairs(parent:GetDescendants()) do
            if string.find(obj.Name:lower(), "pickup") and (obj:IsA("Model") or obj:IsA("Part")) then
                if ESPSettings.ItemsESP then
                    addItemESP(obj)
                end
            end
        end
    end
    
    searchDescendants(Workspace)
end

function toggleItemESP()
    if ESPSettings.ItemsESP then
        scanForItems()
        -- Slow scan for new items
        spawn(function()
            while ESPSettings.ItemsESP do
                wait(2) -- Slow scan every 2 seconds
                scanForItems()
            end
        end)
    else
        for item, _ in pairs(ESPObjects.items) do
            removeItemESP(item)
        end
    end
end

-- CacheBox ESP Functions
local function addCacheBoxESP(cache)
    if ESPObjects.cacheboxes[cache] then return end
    
    local highlight = createHighlight(cache, UIColors.CacheColor)
    local label = createESPLabel(cache, "CacheBox", UIColors.CacheColor, Vector3.new(0, 3, 0))
    
    ESPObjects.cacheboxes[cache] = {highlight = highlight, label = label}
end

local function addCodePaperESP(paper)
    if ESPObjects.cacheboxes[paper] then return end
    
    local highlight = createHighlight(paper, UIColors.PaperColor)
    local label = createESPLabel(paper, "Code Paper", UIColors.PaperColor, Vector3.new(0, 2, 0))
    
    ESPObjects.cacheboxes[paper] = {highlight = highlight, label = label}
end

local function findCodePaper()
    local caches = Workspace:FindFirstChild("Caches")
    if not caches then return end
    
    local paperLocations = caches:FindFirstChild("PaperLocations")
    if not paperLocations then return end
    
    -- Find the bottom-most paper
    local papers = {}
    for _, obj in pairs(paperLocations:GetChildren()) do
        if obj.Name:lower():find("paper") then
            table.insert(papers, {obj = obj, y = obj.Position.Y})
        end
    end
    
    if #papers > 0 then
        table.sort(papers, function(a, b) return a.y < b.y end)
        local bottomPaper = papers[1].obj
        
        if ESPSettings.CacheBoxESP then
            addCodePaperESP(bottomPaper)
        end
    end
end

local function scanForCacheBoxes()
    local function searchDescendants(parent)
        for _, obj in pairs(parent:GetDescendants()) do
            if obj.Name == "CacheBox" and (obj:IsA("Model") or obj:IsA("Part")) then
                if ESPSettings.CacheBoxESP then
                    addCacheBoxESP(obj)
                end
            end
        end
    end
    
    searchDescendants(Workspace)
    findCodePaper()
end

function toggleCacheBoxESP()
    if ESPSettings.CacheBoxESP then
        scanForCacheBoxes()
        -- Slow scan for new cacheboxes
        spawn(function()
            while ESPSettings.CacheBoxESP do
                wait(3) -- Very slow scan every 3 seconds
                scanForCacheBoxes()
            end
        end)
    else
        for cache, data in pairs(ESPObjects.cacheboxes) do
            if data.highlight then data.highlight:Destroy() end
            if data.label then data.label:Destroy() end
        end
        ESPObjects.cacheboxes = {}
    end
end

-- Cleanup function when objects are removed
Workspace.DescendantRemoving:Connect(function(obj)
    if ESPObjects.monsters[obj] then
        removeMonsterESP(obj)
    elseif ESPObjects.items[obj] then
        removeItemESP(obj)
    end
end)

-- Make button draggable
local dragging = false
local dragStart = nil
local startPos = nil

MainButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

print("Z3U5 Visual Aid Script Loaded Successfully!")