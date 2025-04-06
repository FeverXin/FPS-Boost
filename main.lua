-- Create a new ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MVSD_Pro_UI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Helper function to create a button
local function createButton(parent, name, position, size, text, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = size
    button.Position = position
    button.Text = text
    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    button.TextColor3 = Color3.fromRGB(255, 0, 255)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 14
    button.Parent = parent
    
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Helper function to create a toggle switch
local function createToggle(parent, name, position, text, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0, 200, 0, 40)
    toggleFrame.Position = position
    toggleFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    toggleFrame.Parent = parent
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Text = text
    toggleLabel.Size = UDim2.new(1, 0, 0.5, 0)
    toggleLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
    toggleLabel.Font = Enum.Font.SourceSans
    toggleLabel.TextSize = 14
    toggleLabel.Parent = toggleFrame
    
    local toggleSwitch = Instance.new("TextButton")
    toggleSwitch.Size = UDim2.new(0, 50, 0, 20)
    toggleSwitch.Position = UDim2.new(0.8, 0, 0.3, 0)
    toggleSwitch.Text = "OFF"
    toggleSwitch.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
    toggleSwitch.Parent = toggleFrame
    
    toggleSwitch.MouseButton1Click:Connect(function()
        if toggleSwitch.Text == "OFF" then
            toggleSwitch.Text = "ON"
            callback(true)
        else
            toggleSwitch.Text = "OFF"
            callback(false)
        end
    end)
    
    return toggleFrame
end

-- Helper function to create a slider
local function createSlider(parent, name, position, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0, 200, 0, 40)
    sliderFrame.Position = position
    sliderFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    sliderFrame.Parent = parent
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Text = name
    sliderLabel.Size = UDim2.new(1, 0, 0.3, 0)
    sliderLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
    sliderLabel.Font = Enum.Font.SourceSans
    sliderLabel.TextSize = 14
    sliderLabel.Parent = sliderFrame
    
    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(0, 150, 0, 20)
    slider.Position = UDim2.new(0, 25, 0.6, 0)
    slider.Text = ""
    slider.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
    slider.Parent = sliderFrame
    
    local sliderIndicator = Instance.new("Frame")
    sliderIndicator.Size = UDim2.new(0, 0, 1, 0)
    sliderIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderIndicator.Parent = slider
    
    slider.MouseButton1Down:Connect(function()
        local mouse = game.Players.LocalPlayer:GetMouse()
        local dragging = true
        while dragging do
            local mouseX = math.clamp(mouse.X - slider.Position.X.Offset, 0, slider.Size.X.Offset)
            sliderIndicator.Size = UDim2.new(mouseX / slider.Size.X.Offset, 0, 1, 0)
            local value = math.floor((mouseX / slider.Size.X.Offset) * (max - min) + min)
            callback(value)
            wait(0.01)
        end
    end)
    
    slider.MouseButton1Up:Connect(function()
        dragging = false
    end)
    
    return sliderFrame
end

-- Helper function to create an input box
local function createInput(parent, name, position, placeholder, callback)
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(0, 200, 0, 40)
    inputFrame.Position = position
    inputFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    inputFrame.Parent = parent
    
    local inputLabel = Instance.new("TextLabel")
    inputLabel.Text = name
    inputLabel.Size = UDim2.new(1, 0, 0.3, 0)
    inputLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
    inputLabel.Font = Enum.Font.SourceSans
    inputLabel.TextSize = 14
    inputLabel.Parent = inputFrame
    
    local inputBox = Instance.new("TextBox")
    inputBox.PlaceholderText = placeholder
    inputBox.Size = UDim2.new(1, 0, 0.7, 0)
    inputBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    inputBox.Parent = inputFrame
    
    inputBox.FocusLost:Connect(function()
        callback(inputBox.Text)
    end)
    
    return inputFrame
end

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 600)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.Parent = screenGui

-- Add buttons, sliders, and toggles
createButton(mainFrame, "Kill All", UDim2.new(0, 50, 0, 50), UDim2.new(0, 300, 0, 40), "Kill All", function()
    -- placeholder for Kill All logic
end)

createButton(mainFrame, "Loop Kill All", UDim2.new(0, 50, 0, 100), UDim2.new(0, 300, 0, 40), "Loop Kill All", function()
    -- placeholder for Loop Kill All logic
end)

createToggle(mainFrame, "Aimlock", UDim2.new(0, 50, 0, 150), "Aimlock", function(Value)
    -- placeholder for Aimlock toggle logic
end)

createSlider(mainFrame, "Aimlock Smoothness", UDim2.new(0, 50, 0, 200), 0, 100, 20, function(Value)
    -- placeholder for Aimlock Smoothness slider logic
end)

createInput(mainFrame, "Aimlock Keybind", UDim2.new(0, 50, 0, 250), "Press Key...", function(Key)
    -- placeholder for Aimlock Keybind input logic
end)

-- Other features go here following similar methods...

-- Toggle UI with TAB key
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.Tab then
        if screenGui.Enabled then
            screenGui.Enabled = false
        else
            screenGui.Enabled = true
        end
    end
end)

-- Set the UI to be enabled initially
screenGui.Enabled = true
