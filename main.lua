-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local ESPColorPicker = Instance.new("TextButton")
ESPColorPicker.Size = UDim2.new(0, 200, 0, 50)
ESPColorPicker.Position = UDim2.new(0.5, -100, 0.2, 0)
ESPColorPicker.Text = "Select ESP Color"
ESPColorPicker.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ESPColorPicker.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPColorPicker.Parent = ScreenGui

local FOVColorPicker = Instance.new("TextButton")
FOVColorPicker.Size = UDim2.new(0, 200, 0, 50)
FOVColorPicker.Position = UDim2.new(0.5, -100, 0.3, 0)
FOVColorPicker.Text = "Select FOV Color"
FOVColorPicker.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FOVColorPicker.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVColorPicker.Parent = ScreenGui

local TriggerbotKeyBox = Instance.new("TextButton")
TriggerbotKeyBox.Size = UDim2.new(0, 200, 0, 50)
TriggerbotKeyBox.Position = UDim2.new(0.5, -100, 0.4, 0)
TriggerbotKeyBox.Text = "Triggerbot Key: ..."
TriggerbotKeyBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TriggerbotKeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TriggerbotKeyBox.Parent = ScreenGui

local AimlockKeyBox = Instance.new("TextButton")
AimlockKeyBox.Size = UDim2.new(0, 200, 0, 50)
AimlockKeyBox.Position = UDim2.new(0.5, -100, 0.5, 0)
AimlockKeyBox.Text = "Aimlock Key: ..."
AimlockKeyBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AimlockKeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
AimlockKeyBox.Parent = ScreenGui

local ConfigureButton = Instance.new("TextButton")
ConfigureButton.Size = UDim2.new(0, 200, 0, 50)
ConfigureButton.Position = UDim2.new(0.5, -100, 0.6, 0)
ConfigureButton.Text = "Configure"
ConfigureButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
ConfigureButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfigureButton.Parent = ScreenGui

-- Variables for selected keybinds (No preset values)
local selectedTriggerbotKey = nil
local selectedAimlockKey = nil
local ESP_COLOR = Color3.fromRGB(255, 255, 255)  -- Default ESP color
local FOV_COLOR = Color3.fromRGB(255, 255, 255)  -- Default FOV color
local FOV_RADIUS = 150  -- Adjust the FOV size as needed

-- Function to update text on button click
local function updateKeybind(button, key)
    button.Text = "Selected: " .. key
end

-- Create Color Picker (similar to Discord Role Color Picker)
local function createColorPicker(button, colorType)
    local colorPicker = Instance.new("Frame")
    colorPicker.Size = UDim2.new(0, 300, 0, 300)
    colorPicker.Position = UDim2.new(0.5, -150, 0.5, -150)
    colorPicker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    colorPicker.Parent = ScreenGui

    -- Create color boxes for the picker
    local colors = {
        Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0)
    }
    
    local xPos, yPos = 0, 0
    for _, color in ipairs(colors) do
        local colorBox = Instance.new("TextButton")
        colorBox.Size = UDim2.new(0, 40, 0, 40)
        colorBox.Position = UDim2.new(0, xPos, 0, yPos)
        colorBox.BackgroundColor3 = color
        colorBox.Parent = colorPicker

        -- When a color box is clicked, set the ESP or FOV color
        colorBox.MouseButton1Click:Connect(function()
            if colorType == "ESP" then
                ESP_COLOR = color
                ESPColorPicker.BackgroundColor3 = color
            elseif colorType == "FOV" then
                FOV_COLOR = color
                FOVColorPicker.BackgroundColor3 = color
            end
            colorPicker:Destroy()  -- Close the color picker
        end)

        xPos = xPos + 45
        if xPos > 255 then
            xPos = 0
            yPos = yPos + 45
        end
    end
end

-- Listen for key press for setting the keybinds
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Update Triggerbot Key if selected
    if selectedTriggerbotKey then
        if input.KeyCode then
            selectedTriggerbotKey = input.KeyCode.Name
        elseif input.UserInputType then
            selectedTriggerbotKey = input.UserInputType.Name
        end
        updateKeybind(TriggerbotKeyBox, selectedTriggerbotKey)
        selectedTriggerbotKey = nil -- Reset after setting
    end

    -- Update Aimlock Key if selected
    if selectedAimlockKey then
        if input.KeyCode then
            selectedAimlockKey = input.KeyCode.Name
        elseif input.UserInputType then
            selectedAimlockKey = input.UserInputType.Name
        end
        updateKeybind(AimlockKeyBox, selectedAimlockKey)
        selectedAimlockKey = nil -- Reset after setting
    end
end)

-- Button click to set keybind for Triggerbot
TriggerbotKeyBox.MouseButton1Click:Connect(function()
    TriggerbotKeyBox.Text = "Press a key for Triggerbot..."
    selectedTriggerbotKey = true -- Indicate that Triggerbot keybind is being set
end)

-- Button click to set keybind for Aimlock
AimlockKeyBox.MouseButton1Click:Connect(function()
    AimlockKeyBox.Text = "Press a key for Aimlock..."
    selectedAimlockKey = true -- Indicate that Aimlock keybind is being set
end)

-- Button click to select ESP color
ESPColorPicker.MouseButton1Click:Connect(function()
    createColorPicker(ESPColorPicker, "ESP")
end)

-- Button click to select FOV color
FOVColorPicker.MouseButton1Click:Connect(function()
    createColorPicker(FOVColorPicker, "FOV")
end)

-- Configure button to apply settings
ConfigureButton.MouseButton1Click:Connect(function()
    -- Apply the settings
    print("Settings configured!")
    -- You can add actual logic here to apply these settings to the game
    -- Close UI after configuring
    ScreenGui:Destroy()
end)

-- FOV Circle Drawing
local fovCircle = Drawing.new("Circle")
fovCircle.Color = FOV_COLOR
fovCircle.Thickness = 1.5
fovCircle.Radius = FOV_RADIUS
fovCircle.Filled = false
fovCircle.Transparency = 1
fovCircle.Visible = true

-- ESP Storage
local ESP_Boxes = {}

-- Function to create ESP
local function createESP(player)
    if player == LocalPlayer then return end

    local highlight = Instance.new("BoxHandleAdornment")
    highlight.Size = Vector3.new(4, 6, 0)
    highlight.Color3 = ESP_COLOR
    highlight.Transparency = 1  -- Non-filled box
    highlight.Adornee = nil
    highlight.AlwaysOnTop = true
    highlight.ZIndex = 5
    highlight.Parent = game.CoreGui

    local nameTag = Drawing.new("Text")
    nameTag.Size = 18
    nameTag.Color = ESP_COLOR
    nameTag.Outline = true
    nameTag.Center = true
    nameTag.Visible = false

    ESP_Boxes[player] = { Box = highlight, NameTag = nameTag }

    local function updateESP()
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Humanoid").Health <= 0 then
            highlight.Adornee = nil
            nameTag.Visible = false
            return
        end

        local rootPart = player.Character.HumanoidRootPart
        highlight.Adornee = rootPart

        local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
        if onScreen then
            nameTag.Position = Vector2.new(screenPos.X, screenPos.Y + 30)  -- Adjusted to be near the feet
            nameTag.Text = player.DisplayName
            nameTag.Visible = true
        else
            nameTag.Visible = false
        end
    end

    RunService.RenderStepped:Connect(updateESP)
end

-- Function to remove ESP when player leaves
local function removeESP(player)
    if ESP_Boxes[player] then
        ESP_Boxes[player].Box:Destroy()
        ESP_Boxes[player].NameTag:Remove()
        ESP_Boxes[player] = nil
    end
end

-- Apply ESP to all players
for _, player in pairs(Players:GetPlayers()) do
    createESP(player)
end

-- Listen for new players joining
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

-- Add additional functions here for Triggerbot, Aimlock, Silent Aim, etc.
