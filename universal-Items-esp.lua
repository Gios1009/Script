-- Universal ESP Tool - Client-sided, Mobile Friendly
-- Place this script in StarterPlayerScripts or execute as LocalScript

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ESP Storage
local espObjects = {}
local espConnections = {}

-- Create main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalESP"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Main UI Frame (top middle)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 35, 0, 35)
mainFrame.Position = UDim2.new(0.5, -17.5, 0, 10)
mainFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Round corners for main frame
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 17.5)
mainCorner.Parent = mainFrame

-- Rainbow outline for main frame
local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 3
mainStroke.Color = Color3.new(1, 0, 0)
mainStroke.Parent = mainFrame

-- Magnify glass icon (main button)
local mainButton = Instance.new("TextButton")
mainButton.Name = "MainButton"
mainButton.Size = UDim2.new(1, 0, 1, 0)
mainButton.Position = UDim2.new(0, 0, 0, 0)
mainButton.BackgroundTransparency = 1
mainButton.Text = "🔍"
mainButton.TextColor3 = Color3.new(1, 1, 1)
mainButton.TextScaled = true
mainButton.Font = Enum.Font.SourceSansBold
mainButton.Parent = mainFrame

-- Sub UI Container
local subFrame = Instance.new("Frame")
subFrame.Name = "SubFrame"
subFrame.Size = UDim2.new(0, 150, 0, 90)
subFrame.Position = UDim2.new(0.5, -75, 1, 10)
subFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
subFrame.BorderSizePixel = 0
subFrame.Visible = false
subFrame.Parent = mainFrame

-- Round corners for sub frame
local subCorner = Instance.new("UICorner")
subCorner.CornerRadius = UDim.new(0, 10)
subCorner.Parent = subFrame

-- Rainbow outline for sub frame
local subStroke = Instance.new("UIStroke")
subStroke.Thickness = 2
subStroke.Color = Color3.new(1, 0, 0)
subStroke.Parent = subFrame

-- Search TextBox
local searchBox = Instance.new("TextBox")
searchBox.Name = "SearchBox"
searchBox.Size = UDim2.new(1, -10, 0, 20)
searchBox.Position = UDim2.new(0, 5, 0, 5)
searchBox.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
searchBox.BorderSizePixel = 0
searchBox.Text = "Enter object name..."
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.TextScaled = true
searchBox.Font = Enum.Font.SourceSans
searchBox.ClearTextOnFocus = true
searchBox.Parent = subFrame

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 3)
searchCorner.Parent = searchBox

-- Search Button
local searchButton = Instance.new("TextButton")
searchButton.Name = "SearchButton"
searchButton.Size = UDim2.new(0.48, 0, 0, 20)
searchButton.Position = UDim2.new(0, 5, 0, 30)
searchButton.BackgroundColor3 = Color3.new(0, 0.7, 0)
searchButton.BorderSizePixel = 0
searchButton.Text = "🔍 Search"
searchButton.TextColor3 = Color3.new(1, 1, 1)
searchButton.TextScaled = true
searchButton.Font = Enum.Font.SourceSansBold
searchButton.Parent = subFrame

local searchBtnCorner = Instance.new("UICorner")
searchBtnCorner.CornerRadius = UDim.new(0, 3)
searchBtnCorner.Parent = searchButton

-- UnESP Button
local unespButton = Instance.new("TextButton")
unespButton.Name = "UnespButton"
unespButton.Size = UDim2.new(0.48, 0, 0, 20)
unespButton.Position = UDim2.new(0.52, 0, 0, 30)
unespButton.BackgroundColor3 = Color3.new(0.7, 0, 0)
unespButton.BorderSizePixel = 0
unespButton.Text = "❌ UnESP"
unespButton.TextColor3 = Color3.new(1, 1, 1)
unespButton.TextScaled = true
unespButton.Font = Enum.Font.SourceSansBold
unespButton.Parent = subFrame

local unespBtnCorner = Instance.new("UICorner")
unespBtnCorner.CornerRadius = UDim.new(0, 3)
unespBtnCorner.Parent = unespButton

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -10, 0, 15)
statusLabel.Position = UDim2.new(0, 5, 0, 55)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Ready to search..."
statusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.SourceSans
statusLabel.Parent = subFrame

-- Rainbow animation function
local function animateRainbow(stroke)
    local hue = 0
    local connection
    connection = RunService.Heartbeat:Connect(function()
        hue = hue + 1
        if hue >= 360 then hue = 0 end
        stroke.Color = Color3.fromHSV(hue / 360, 1, 1)
    end)
    return connection
end

-- Start rainbow animations
local rainbowConnection1 = animateRainbow(mainStroke)
local rainbowConnection2 = animateRainbow(subStroke)

-- ESP Functions
local function createESP(obj)
    if not obj or not obj.Parent then return end
    
    -- Create Highlight for outline (visible through walls)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = obj
    highlight.FillColor = Color3.new(0, 1, 0) -- Green fill
    highlight.OutlineColor = Color3.new(0, 1, 0) -- Green outline
    highlight.FillTransparency = 0.8 -- Semi-transparent fill
    highlight.OutlineTransparency = 0 -- Solid outline
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Always visible through walls
    highlight.Parent = workspace
    
    -- Create BillboardGui for name display
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 50, 0, 25)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.Adornee = obj
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = workspace
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    nameLabel.BackgroundTransparency = 0.3
    nameLabel.BorderSizePixel = 0
    nameLabel.Text = obj.Name
    nameLabel.TextColor3 = Color3.new(0, 1, 0)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.SourceSans
    nameLabel.Parent = billboardGui
    
    local labelCorner = Instance.new("UICorner")
    labelCorner.CornerRadius = UDim.new(0, 3)
    labelCorner.Parent = nameLabel
    
    -- Store ESP objects
    local espData = {
        highlight = highlight,
        billboardGui = billboardGui,
        object = obj
    }
    
    table.insert(espObjects, espData)
    
    -- Clean up if object is removed
    local connection
    connection = obj.AncestryChanged:Connect(function()
        if not obj.Parent then
            highlight:Destroy()
            billboardGui:Destroy()
            connection:Disconnect()
            -- Remove from espObjects table
            for i, data in ipairs(espObjects) do
                if data == espData then
                    table.remove(espObjects, i)
                    break
                end
            end
        end
    end)
    
    table.insert(espConnections, connection)
end

local function searchAndESP(searchTerm)
    local foundCount = 0
    searchTerm = searchTerm:lower()
    
    -- Search in workspace
    local function searchInContainer(container)
        for _, obj in ipairs(container:GetDescendants()) do
            if obj.Name:lower():find(searchTerm) then
                -- Check if it's a suitable object for ESP
                if obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
                    createESP(obj)
                    foundCount = foundCount + 1
                end
            end
        end
    end
    
    searchInContainer(workspace)
    
    return foundCount
end

local function clearAllESP()
    -- Clear all ESP objects
    for _, espData in ipairs(espObjects) do
        if espData.highlight then espData.highlight:Destroy() end
        if espData.billboardGui then espData.billboardGui:Destroy() end
        if espData.distanceConnection then espData.distanceConnection:Disconnect() end
    end
    
    -- Clear all connections
    for _, connection in ipairs(espConnections) do
        connection:Disconnect()
    end
    
    espObjects = {}
    espConnections = {}
end

local function sendNotification(message)
    StarterGui:SetCore("SendNotification", {
        Title = "Universal ESP";
        Text = message;
        Duration = 3;
    })
end

-- UI Animation functions
local function showSubFrame()
    subFrame.Visible = true
    subFrame.Size = UDim2.new(0, 0, 0, 0)
    subFrame.Position = UDim2.new(0.5, 0, 1, 10)
    
    local tween = TweenService:Create(subFrame, 
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 150, 0, 90),
            Position = UDim2.new(0.5, -75, 1, 10)
        }
    )
    tween:Play()
end

local function hideSubFrame()
    local tween = TweenService:Create(subFrame, 
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 1, 10)
        }
    )
    tween:Play()
    tween.Completed:Connect(function()
        subFrame.Visible = false
    end)
end

-- Button Events
local subFrameVisible = false

mainButton.MouseButton1Click:Connect(function()
    if subFrameVisible then
        hideSubFrame()
        subFrameVisible = false
    else
        showSubFrame()
        subFrameVisible = true
    end
end)

searchButton.MouseButton1Click:Connect(function()
    local searchTerm = searchBox.Text:gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace
    
    if searchTerm == "" or searchTerm == "Enter object name..." then
        sendNotification("Please enter a search term!")
        statusLabel.Text = "Please enter a search term!"
        return
    end
    
    statusLabel.Text = "Searching..."
    wait(0.1) -- Small delay for UI feedback
    
    local foundCount = searchAndESP(searchTerm)
    
    if foundCount > 0 then
        sendNotification("Found " .. foundCount .. " items")
        statusLabel.Text = "Found " .. foundCount .. " items"
    else
        sendNotification("Item not found")
        statusLabel.Text = "Item not found"
    end
end)

unespButton.MouseButton1Click:Connect(function()
    clearAllESP()
    sendNotification("All ESP cleared")
    statusLabel.Text = "All ESP cleared"
end)

-- Mobile support - make UI larger on touch devices
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    mainFrame.Size = UDim2.new(0, 45, 0, 45)
    mainFrame.Position = UDim2.new(0.5, -22.5, 0, 10)
    mainCorner.CornerRadius = UDim.new(0, 22.5)
    
    subFrame.Size = UDim2.new(0, 170, 0, 100)
    searchBox.Size = UDim2.new(1, -10, 0, 25)
    searchButton.Size = UDim2.new(0.48, 0, 0, 25)
    unespButton.Size = UDim2.new(0.48, 0, 0, 25)
    searchButton.Position = UDim2.new(0, 5, 0, 35)
    unespButton.Position = UDim2.new(0.52, 0, 0, 35)
    statusLabel.Position = UDim2.new(0, 5, 0, 70)
end

-- Enter key support for search box
searchBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        searchButton.MouseButton1Click:Fire()
    end
end)

print("Universal ESP Tool loaded successfully!")
sendNotification("ESP Tool Ready!")