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

-- Function to update text on button click
local function updateKeybind(button, key)
    button.Text = button.Text:gsub("...", key)
end

-- Listen for key press for setting the keybinds
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Update Triggerbot Key if selected
    if selectedTriggerbotKey then
        if input.KeyCode then
            selectedTriggerbotKey = input.KeyCode
        elseif input.UserInputType then
            selectedTriggerbotKey = input.UserInputType
        end
        updateKeybind(TriggerbotKeyBox, selectedTriggerbotKey.Name)
        selectedTriggerbotKey = nil -- Reset after setting
    end

    -- Update Aimlock Key if selected
    if selectedAimlockKey then
        if input.KeyCode then
            selectedAimlockKey = input.KeyCode
        elseif input.UserInputType then
            selectedAimlockKey = input.UserInputType
        end
        updateKeybind(AimlockKeyBox, selectedAimlockKey.Name)
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

-- Update ESP and FOV colors
ESPColorPicker.MouseButton1Click:Connect(function()
    -- Add color picker code here
    ESP_COLOR = Color3.fromRGB(255, 0, 0)  -- Example for red, replace with color picker logic
end)

FOVColorPicker.MouseButton1Click:Connect(function()
    -- Add color picker code here
    fovCircle.Color = Color3.fromRGB(0, 0, 255)  -- Example for blue, replace with color picker logic
end)

-- Configure button to apply settings
ConfigureButton.MouseButton1Click:Connect(function()
    -- Apply the settings
    print("Settings configured!")
    -- Example of applying selected settings
    -- 1. Apply ESP color
    -- 2. Apply FOV color
    -- 3. Apply selected triggerbot and aimlock keybinds
end)

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Color = ESP_COLOR
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
