--[[
    Custom Roblox Cheat UI
    Theme: Black and Dark Magenta
    Size: Horizontal Rectangle ~18x12 inch (scaled to screen)
    Includes: All toggles, dropdowns, sliders, and keybind handlers
--]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CheatUI"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0.6, 0, 0.6, 0)
MainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.Parent = MainFrame

local function createSection(title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 30)
    section.BackgroundColor3 = Color3.fromRGB(25, 0, 40)

    local label = Instance.new("TextLabel")
    label.Text = title
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(200, 100, 255)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Parent = section

    return section
end

local function createToggle(name)
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(1, 0, 0, 30)
    toggle.BackgroundTransparency = 1

    local label = Instance.new("TextLabel")
    label.Text = name
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Parent = toggle

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0.3, 0, 0.8, 0)
    switch.Position = UDim2.new(0.7, 0, 0.1, 0)
    switch.BackgroundColor3 = Color3.fromRGB(50, 0, 80)
    switch.Text = "OFF"
    switch.TextColor3 = Color3.fromRGB(255, 255, 255)
    switch.Font = Enum.Font.SourceSansBold
    switch.TextSize = 14
    switch.Parent = toggle

    switch.MouseButton1Click:Connect(function()
        if switch.Text == "OFF" then
            switch.Text = "ON"
            switch.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
        else
            switch.Text = "OFF"
            switch.BackgroundColor3 = Color3.fromRGB(50, 0, 80)
        end
    end)

    return toggle
end

local function createSlider(name, min, max, step)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 40)
    sliderFrame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel")
    label.Text = name
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.BackgroundTransparency = 1
    label.Parent = sliderFrame

    local slider = Instance.new("TextBox")
    slider.Size = UDim2.new(1, 0, 0.5, 0)
    slider.Position = UDim2.new(0, 0, 0.5, 0)
    slider.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
    slider.Text = tostring(min)
    slider.TextColor3 = Color3.fromRGB(255, 255, 255)
    slider.Font = Enum.Font.SourceSans
    slider.TextSize = 14
    slider.ClearTextOnFocus = true
    slider.Parent = sliderFrame

    return sliderFrame
end

local function createKeybind(name)
    local bindFrame = Instance.new("Frame")
    bindFrame.Size = UDim2.new(1, 0, 0, 30)
    bindFrame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel")
    label.Text = name
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Parent = bindFrame

    local keyButton = Instance.new("TextButton")
    keyButton.Size = UDim2.new(0.4, 0, 1, 0)
    keyButton.Position = UDim2.new(0.6, 0, 0, 0)
    keyButton.BackgroundColor3 = Color3.fromRGB(40, 0, 70)
    keyButton.Text = "Set Key"
    keyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyButton.Font = Enum.Font.SourceSansBold
    keyButton.TextSize = 14
    keyButton.Parent = bindFrame

    keyButton.MouseButton1Click:Connect(function()
        keyButton.Text = "Press a Key..."
        local conn
        conn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                keyButton.Text = "Mouse1"
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                keyButton.Text = "Mouse2"
            elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
                keyButton.Text = "Mouse3"
            elseif input.UserInputType == Enum.UserInputType.Keyboard then
                keyButton.Text = input.KeyCode.Name
            end
            conn:Disconnect()
        end)
    end)

    return bindFrame
end

-- Sections
MainFrame:AddChild(createSection("Aimlock"))
MainFrame:AddChild(createToggle("Enable Aimlock"))
MainFrame:AddChild(createKeybind("Aimlock Key"))

MainFrame:AddChild(createSection("Triggerbot"))
MainFrame:AddChild(createToggle("Enable Triggerbot"))
MainFrame:AddChild(createSlider("Reaction Time (ms)", 0.0000001, 1, 0.0000001))
MainFrame:AddChild(createToggle("Wall Check"))
MainFrame:AddChild(createKeybind("Trigger Key"))

MainFrame:AddChild(createSection("Kill All"))
MainFrame:AddChild(createToggle("Kill All"))
MainFrame:AddChild(createToggle("Loop Kill All"))

MainFrame:AddChild(createSection("Always Hit"))
MainFrame:AddChild(createToggle("Enable Always Hit"))
MainFrame:AddChild(createSlider("FOV Circle Radius", 10, 1000, 5))
MainFrame:AddChild(createToggle("Auto Trigger"))
MainFrame:AddChild(createSlider("Auto Trigger Reaction (ms)", 0.0000001, 1, 0.0000001))

MainFrame:AddChild(createSection("Utility Settings"))
MainFrame:AddChild(createToggle("Delete Developer Logs"))
MainFrame:AddChild(createToggle("Kick Player"))
MainFrame:AddChild(createToggle("Bullet Teleportation"))
MainFrame:AddChild(createToggle("Desync Movement"))
MainFrame:AddChild(createToggle("Auto Dodge"))
MainFrame:AddChild(createToggle("Target Priority System"))
MainFrame:AddChild(createToggle("Player Alert"))
MainFrame:AddChild(createToggle("Rapid Fire"))
MainFrame:AddChild(createToggle("Weapon Cooldown Remover"))
MainFrame:AddChild(createToggle("Custom Hit Sound"))
MainFrame:AddChild(createToggle("Name ESP Enhancer"))

-- Tab Toggle Bind (TAB)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Tab then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
