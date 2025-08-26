-- Mobile ESP Script

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ESP Settings
local espSettings = {
    enabled = false,
    names = true,
    health = true,
    distance = true,
    boxes = false
}

-- Storage for ESP objects
local espObjects = {}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESP_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main UI Circle Button
local mainButton = Instance.new("Frame")
mainButton.Name = "MainButton"
mainButton.Size = UDim2.new(0, 36, 0, 36)
mainButton.Position = UDim2.new(0, 20, 0, 100)
mainButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainButton.BorderSizePixel = 0
mainButton.Parent = screenGui

-- Make button circular
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.5, 0)
corner.Parent = mainButton

-- Rainbow outline effect
local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Parent = mainButton

-- Icon for button
local icon = Instance.new("TextLabel")
icon.Name = "Icon"
icon.Size = UDim2.new(0.7, 0, 0.7, 0)
icon.Position = UDim2.new(0.15, 0, 0.15, 0)
icon.BackgroundTransparency = 1
icon.Text = "👁"
icon.TextColor3 = Color3.fromRGB(255, 255, 255)
icon.TextScaled = true
icon.Font = Enum.Font.SourceSansBold
icon.Parent = mainButton

-- Menu Frame
local menuFrame = Instance.new("Frame")
menuFrame.Name = "MenuFrame"
menuFrame.Size = UDim2.new(0, 200, 0, 250)
menuFrame.Position = UDim2.new(0, 90, 0, 50)
menuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false
menuFrame.Parent = screenGui

-- Menu corner radius
local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 10)
menuCorner.Parent = menuFrame

-- Menu rainbow outline
local menuStroke = Instance.new("UIStroke")
menuStroke.Thickness = 2
menuStroke.Color = Color3.fromRGB(255, 0, 0)
menuStroke.Parent = menuFrame

-- Menu title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ESP Settings"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = menuFrame

-- Function to create toggle button
local function createToggle(name, position, setting)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name .. "Toggle"
    toggleFrame.Size = UDim2.new(1, -20, 0, 35)
    toggleFrame.Position = UDim2.new(0, 10, 0, position)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = menuFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 60, 0, 25)
    button.Position = UDim2.new(1, -65, 0.5, -12.5)
    button.BackgroundColor3 = espSettings[setting] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
    button.BorderSizePixel = 0
    button.Text = espSettings[setting] and "ON" or "OFF"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSansBold
    button.Parent = toggleFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        espSettings[setting] = not espSettings[setting]
        button.BackgroundColor3 = espSettings[setting] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
        button.Text = espSettings[setting] and "ON" or "OFF"
        
        if setting == "enabled" and not espSettings[setting] then
            clearAllESP()
        end
    end)
    
    return toggleFrame
end

-- Create toggle buttons
createToggle("ESP", 40, "enabled")
createToggle("Names", 80, "names")
createToggle("Health", 120, "health")
createToggle("Distance", 160, "distance")
createToggle("Boxes", 200, "boxes")

-- Rainbow effect animation
local rainbowTween = TweenService:Create(
    stroke,
    TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
    {Color = Color3.fromHSV(1, 1, 1)}
)

local menuRainbowTween = TweenService:Create(
    menuStroke,
    TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
    {Color = Color3.fromHSV(1, 1, 1)}
)

-- Start rainbow effects
spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            stroke.Color = Color3.fromHSV(i, 1, 1)
            menuStroke.Color = Color3.fromHSV(i, 1, 1)
            wait(0.05)
        end
    end
end)

-- Menu toggle functionality
local menuOpen = false

local function toggleMenu()
    menuOpen = not menuOpen
    menuFrame.Visible = menuOpen
    
    if menuOpen then
        menuFrame:TweenSize(UDim2.new(0, 200, 0, 250), "Out", "Quad", 0.3)
    end
end

-- Button click detection
mainButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleMenu()
    end
end)

-- Make button draggable for mobile
local dragging = false
local dragStart = nil
local startPos = nil

mainButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainButton.Position
    end
end)

mainButton.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

mainButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ESP Functions
local function getTeamColor(targetPlayer)
    if targetPlayer.Team then
        return targetPlayer.Team.TeamColor.Color
    end
    return Color3.fromRGB(255, 255, 255)
end

local function createHighlight(targetPlayer)
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = targetPlayer.Character
    highlight.FillColor = getTeamColor(targetPlayer)
    highlight.OutlineColor = getTeamColor(targetPlayer)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = targetPlayer.Character
    
    return highlight
end

local function createBoxESP(targetPlayer)
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local character = targetPlayer.Character
    local rootPart = character.HumanoidRootPart
    
    -- Remove old highlight if exists
    local oldHighlight = character:FindFirstChild("ESP_Highlight")
    if oldHighlight then
        oldHighlight:Destroy()
    end
    
    -- Create BoxHandleAdornment
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESP_Box"
    box.Adornee = rootPart
    box.Size = Vector3.new(4, 6, 1)
    box.Color3 = getTeamColor(targetPlayer)
    box.Transparency = 0.7
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Parent = rootPart
    
    -- Create bright highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_BoxHighlight"
    highlight.Adornee = character
    highlight.FillColor = getTeamColor(targetPlayer)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.8
    highlight.OutlineTransparency = 0.3
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character
    
    return {box, highlight}
end

local function createNameESP(targetPlayer)
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("Head") then
        return nil
    end
    
    local head = targetPlayer.Character.Head
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Name"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 80, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = targetPlayer.Name
    nameLabel.TextColor3 = getTeamColor(targetPlayer)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Parent = billboard
    
    return billboard
end

local function createDistanceESP(targetPlayer)
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("Head") then
        return nil
    end
    
    local head = targetPlayer.Character.Head
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Distance"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 40, 0, 10)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 1, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0 studs"
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distanceLabel.TextScaled = true
    distanceLabel.Font = Enum.Font.SourceSans
    distanceLabel.Parent = billboard
    
    return billboard
end

local function createHealthESP(targetPlayer)
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("Head") or not targetPlayer.Character:FindFirstChild("Humanoid") then
        return nil
    end
    
    local head = targetPlayer.Character.Head
    local humanoid = targetPlayer.Character.Humanoid
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Health"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 40, 0, 10)
    billboard.StudsOffset = Vector3.new(0, -2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 1, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    healthLabel.TextStrokeTransparency = 0
    healthLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    healthLabel.TextScaled = true
    healthLabel.Font = Enum.Font.SourceSans
    healthLabel.Parent = billboard
    
    return billboard
end

local function updateESP(targetPlayer)
    if targetPlayer == player or not targetPlayer.Character then
        return
    end
    
    local character = targetPlayer.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not espObjects[targetPlayer] then
        espObjects[targetPlayer] = {}
    end
    
    -- Update highlight/box ESP
    if espSettings.enabled then
        if espSettings.boxes then
            -- Remove regular highlight if switching to boxes
            if espObjects[targetPlayer].highlight then
                espObjects[targetPlayer].highlight:Destroy()
                espObjects[targetPlayer].highlight = nil
            end
            
            if not espObjects[targetPlayer].box then
                local boxObjs = createBoxESP(targetPlayer)
                if boxObjs then
                    espObjects[targetPlayer].box = boxObjs[1]
                    espObjects[targetPlayer].boxHighlight = boxObjs[2]
                end
            end
        else
            -- Remove box ESP if switching to regular highlight
            if espObjects[targetPlayer].box then
                espObjects[targetPlayer].box:Destroy()
                espObjects[targetPlayer].box = nil
            end
            if espObjects[targetPlayer].boxHighlight then
                espObjects[targetPlayer].boxHighlight:Destroy()
                espObjects[targetPlayer].boxHighlight = nil
            end
            
            if not espObjects[targetPlayer].highlight then
                espObjects[targetPlayer].highlight = createHighlight(targetPlayer)
            end
        end
    else
        -- Remove all ESP if disabled
        if espObjects[targetPlayer].highlight then
            espObjects[targetPlayer].highlight:Destroy()
            espObjects[targetPlayer].highlight = nil
        end
        if espObjects[targetPlayer].box then
            espObjects[targetPlayer].box:Destroy()
            espObjects[targetPlayer].box = nil
        end
        if espObjects[targetPlayer].boxHighlight then
            espObjects[targetPlayer].boxHighlight:Destroy()
            espObjects[targetPlayer].boxHighlight = nil
        end
    end
    
    -- Update name ESP
    if espSettings.enabled and espSettings.names then
        if not espObjects[targetPlayer].nameESP then
            espObjects[targetPlayer].nameESP = createNameESP(targetPlayer)
        end
    else
        if espObjects[targetPlayer].nameESP then
            espObjects[targetPlayer].nameESP:Destroy()
            espObjects[targetPlayer].nameESP = nil
        end
    end
    
    -- Update distance ESP
    if espSettings.enabled and espSettings.distance then
        if not espObjects[targetPlayer].distanceESP then
            espObjects[targetPlayer].distanceESP = createDistanceESP(targetPlayer)
        end
        
        -- Update distance text
        if espObjects[targetPlayer].distanceESP and humanoidRootPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
            espObjects[targetPlayer].distanceESP.TextLabel.Text = math.floor(distance) .. " studs"
        end
    else
        if espObjects[targetPlayer].distanceESP then
            espObjects[targetPlayer].distanceESP:Destroy()
            espObjects[targetPlayer].distanceESP = nil
        end
    end
    
    -- Update health ESP
    if espSettings.enabled and espSettings.health then
        if not espObjects[targetPlayer].healthESP then
            espObjects[targetPlayer].healthESP = createHealthESP(targetPlayer)
        end
        
        -- Update health text and color
        if espObjects[targetPlayer].healthESP and humanoid then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            local color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
            espObjects[targetPlayer].healthESP.TextLabel.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
            espObjects[targetPlayer].healthESP.TextLabel.TextColor3 = color
        end
    else
        if espObjects[targetPlayer].healthESP then
            espObjects[targetPlayer].healthESP:Destroy()
            espObjects[targetPlayer].healthESP = nil
        end
    end
end

function clearAllESP()
    for targetPlayer, objects in pairs(espObjects) do
        for _, obj in pairs(objects) do
            if obj and obj.Destroy then
                obj:Destroy()
            end
        end
        espObjects[targetPlayer] = {}
    end
end

-- Handle player leaving
Players.PlayerRemoving:Connect(function(targetPlayer)
    if espObjects[targetPlayer] then
        for _, obj in pairs(espObjects[targetPlayer]) do
            if obj and obj.Destroy then
                obj:Destroy()
            end
        end
        espObjects[targetPlayer] = nil
    end
end)

-- Handle character respawning
Players.PlayerAdded:Connect(function(targetPlayer)
    targetPlayer.CharacterAdded:Connect(function()
        wait(1) -- Wait for character to load
        if espObjects[targetPlayer] then
            for _, obj in pairs(espObjects[targetPlayer]) do
                if obj and obj.Destroy then
                    obj:Destroy()
                end
            end
            espObjects[targetPlayer] = {}
        end
    end)
end)

-- Handle existing players
for _, targetPlayer in pairs(Players:GetPlayers()) do
    if targetPlayer ~= player then
        targetPlayer.CharacterAdded:Connect(function()
            wait(1)
            if espObjects[targetPlayer] then
                for _, obj in pairs(espObjects[targetPlayer]) do
                    if obj and obj.Destroy then
                        obj:Destroy()
                    end
                end
                espObjects[targetPlayer] = {}
            end
        end)
    end
end

-- Main update loop
RunService.Heartbeat:Connect(function()
    if espSettings.enabled then
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer ~= player and targetPlayer.Character then
                updateESP(targetPlayer)
            end
        end
    end
end)