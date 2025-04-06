-- Main UI Setup
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Create Core UI
local cheatUI = Instance.new("ScreenGui")
cheatUI.Name = "CheatUI"
cheatUI.ResetOnSpawn = false
cheatUI.IgnoreGuiInset = true
cheatUI.DisplayOrder = 1000
cheatUI.Parent = game.CoreGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 700, 0, 450)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = cheatUI

-- UI Corner
local mainUICorner = Instance.new("UICorner")
mainUICorner.CornerRadius = UDim.new(0, 12)
mainUICorner.Parent = mainFrame

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(25, 0, 40)
titleLabel.Text = "Polluted External Cheat Config"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextColor3 = Color3.fromRGB(200, 100, 255)
titleLabel.TextSize = 24
titleLabel.Parent = mainFrame

-- Drag support
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
titleLabel.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
titleLabel.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Toggle UI visibility with TAB
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.Tab then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

-- Helper function: Create Toggle
local function createToggle(name, position, parent)
	local toggleFrame = Instance.new("Frame")
	toggleFrame.Size = UDim2.new(0, 300, 0, 40)
	toggleFrame.Position = position
	toggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	toggleFrame.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = toggleFrame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.Font = Enum.Font.SourceSans
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 20
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Position = UDim2.new(0, 10, 0, 0)
	label.Parent = toggleFrame

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.25, 0, 0.6, 0)
	button.Position = UDim2.new(0.72, 0, 0.2, 0)
	button.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
	button.Text = "OFF"
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.SourceSansBold
	button.TextSize = 18
	button.Parent = toggleFrame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8)
	btnCorner.Parent = button

	local state = false
	button.MouseButton1Click:Connect(function()
		state = not state
		button.Text = state and "ON" or "OFF"
		button.BackgroundColor3 = state and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(100, 0, 200)
	end)

	return state
end

-- Helper function: Keybind Box
local function createKeybindBox(name, position, parent)
	local keybindFrame = Instance.new("Frame")
	keybindFrame.Size = UDim2.new(0, 300, 0, 40)
	keybindFrame.Position = position
	keybindFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	keybindFrame.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = keybindFrame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.5, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.Font = Enum.Font.SourceSans
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 20
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Position = UDim2.new(0, 10, 0, 0)
	label.Parent = keybindFrame

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.4, 0, 0.6, 0)
	button.Position = UDim2.new(0.55, 0, 0.2, 0)
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.Text = "Click to Bind"
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.SourceSans
	button.TextSize = 18
	button.Parent = keybindFrame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8)
	btnCorner.Parent = button

	local binding = false
	local currentKey = ""

	button.MouseButton1Click:Connect(function()
		binding = true
		button.Text = "Press Key"
	end)

	UserInputService.InputBegan:Connect(function(input)
		if binding then
			if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
				currentKey = input.KeyCode.Name or input.UserInputType.Name
				button.Text = currentKey
				binding = false
			end
		end
	end)

	return currentKey
end

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Radius = 120
fovCircle.Thickness = 2
fovCircle.Transparency = 1
fovCircle.Color = Color3.fromRGB(255, 0, 255)
fovCircle.Visible = true
RunService.RenderStepped:Connect(function()
	local mouse = UserInputService:GetMouseLocation()
	fovCircle.Position = Vector2.new(mouse.X, mouse.Y)
end)

-- Sample Toggles and Keybinds
createToggle("Aimlock", UDim2.new(0, 20, 0, 60), mainFrame)
createToggle("Triggerbot", UDim2.new(0, 20, 0, 110), mainFrame)
createKeybindBox("Aimlock Key", UDim2.new(0, 360, 0, 60), mainFrame)
createKeybindBox("Triggerbot Key", UDim2.new(0, 360, 0, 110), mainFrame)
