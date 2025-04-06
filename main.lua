-- Custom UI Setup for your Roblox Cheat

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Custom UI Elements
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TriggerBotToggle = Instance.new("TextButton")
local AimlockToggle = Instance.new("TextButton")
local FOVCircleSizeSlider = Instance.new("TextBox")
local ReactionTimeSlider = Instance.new("TextBox")
local KeybindSelector = Instance.new("TextButton")
local AlwaysHitToggle = Instance.new("TextButton")

-- Setup Main UI Frame
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "CustomCheatUI"  -- This can be your watermark or brand name
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 800, 0, 600)
MainFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(32, 0, 64)
MainFrame.BorderSizePixel = 0
MainFrame.Name = "MainFrame"  -- Custom name for your branding

-- Custom UI Elements (TextButtons and Sliders)

-- TriggerBot Toggle
TriggerBotToggle.Parent = MainFrame
TriggerBotToggle.Size = UDim2.new(0, 200, 0, 50)
TriggerBotToggle.Position = UDim2.new(0.1, 0, 0.1, 0)
TriggerBotToggle.BackgroundColor3 = Color3.fromRGB(120, 0, 240)
TriggerBotToggle.Text = "Triggerbot"
TriggerBotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
TriggerBotToggle.TextSize = 20

-- Aimlock Toggle
AimlockToggle.Parent = MainFrame
AimlockToggle.Size = UDim2.new(0, 200, 0, 50)
AimlockToggle.Position = UDim2.new(0.1, 0, 0.2, 0)
AimlockToggle.BackgroundColor3 = Color3.fromRGB(120, 0, 240)
AimlockToggle.Text = "Aimlock"
AimlockToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AimlockToggle.TextSize = 20

-- FOV Circle Size Slider (TextBox for input)
FOVCircleSizeSlider.Parent = MainFrame
FOVCircleSizeSlider.Size = UDim2.new(0, 200, 0, 50)
FOVCircleSizeSlider.Position = UDim2.new(0.1, 0, 0.3, 0)
FOVCircleSizeSlider.BackgroundColor3 = Color3.fromRGB(120, 0, 240)
FOVCircleSizeSlider.Text = "FOV Circle Size"
FOVCircleSizeSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVCircleSizeSlider.TextSize = 20

-- Reaction Time Slider (TextBox for input)
ReactionTimeSlider.Parent = MainFrame
ReactionTimeSlider.Size = UDim2.new(0, 200, 0, 50)
ReactionTimeSlider.Position = UDim2.new(0.1, 0, 0.4, 0)
ReactionTimeSlider.BackgroundColor3 = Color3.fromRGB(120, 0, 240)
ReactionTimeSlider.Text = "Reaction Time (ms)"
ReactionTimeSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
ReactionTimeSlider.TextSize = 20

-- Keybind Selector
KeybindSelector.Parent = MainFrame
KeybindSelector.Size = UDim2.new(0, 200, 0, 50)
KeybindSelector.Position = UDim2.new(0.1, 0, 0.5, 0)
KeybindSelector.BackgroundColor3 = Color3.fromRGB(120, 0, 240)
KeybindSelector.Text = "Select Keybind"
KeybindSelector.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindSelector.TextSize = 20

-- Always Hit Toggle
AlwaysHitToggle.Parent = MainFrame
AlwaysHitToggle.Size = UDim2.new(0, 200, 0, 50)
AlwaysHitToggle.Position = UDim2.new(0.1, 0, 0.6, 0)
AlwaysHitToggle.BackgroundColor3 = Color3.fromRGB(120, 0, 240)
AlwaysHitToggle.Text = "Always Hit"
AlwaysHitToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AlwaysHitToggle.TextSize = 20

-- Toggle States
local triggerBotEnabled = false
local aimlockEnabled = false
local alwaysHitEnabled = false

-- Setting Up UI Interactions
TriggerBotToggle.MouseButton1Click:Connect(function()
    triggerBotEnabled = not triggerBotEnabled
    TriggerBotToggle.Text = triggerBotEnabled and "Triggerbot Enabled" or "Triggerbot Disabled"
end)

AimlockToggle.MouseButton1Click:Connect(function()
    aimlockEnabled = not aimlockEnabled
    AimlockToggle.Text = aimlockEnabled and "Aimlock Enabled" or "Aimlock Disabled"
end)

AlwaysHitToggle.MouseButton1Click:Connect(function()
    alwaysHitEnabled = not alwaysHitEnabled
    AlwaysHitToggle.Text = alwaysHitEnabled and "Always Hit Enabled" or "Always Hit Disabled"
end)

-- Keybind Selector (Choose Keybind)
KeybindSelector.MouseButton1Click:Connect(function()
    -- Logic for Keybind selection (for example, Mouse1, Mouse2, etc.)
    -- This can be expanded based on user input for keybindings
end)

-- FOV Circle Size and Triggerbot Reaction Time
FOVCircleSizeSlider.FocusLost:Connect(function()
    local fovSize = tonumber(FOVCircleSizeSlider.Text)
    -- Adjust FOV circle size logic here
end)

ReactionTimeSlider.FocusLost:Connect(function()
    local reactionTime = tonumber(ReactionTimeSlider.Text)
    -- Adjust reaction time logic here for Triggerbot
end)

-- Triggerbot Functionality
local function triggerbot()
    -- Check for player in crosshair or FOV
    -- Check visibility (no walls)
    -- Shoot logic with reaction time and FOV adjustments
end

-- Aimlock Functionality
local function aimlock()
    -- Aimlock logic (smoothness, targetting)
    -- Lock onto closest target and move to their head/body
end

-- Always Hit Functionality
local function alwaysHit()
    -- Check if player is within FOV
    -- Automatically shoot if visible
end

-- Main Logic Loop
while true do
    if triggerBotEnabled then
        triggerbot()
    end
    if aimlockEnabled then
        aimlock()
    end
    if alwaysHitEnabled then
        alwaysHit()
    end
    wait(0.1)  -- This is adjustable for responsiveness
end
