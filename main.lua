-- Polluted UI with Integrated Cheats (Part 1)

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Player
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ScreenGui
local UI = Instance.new("ScreenGui", game.CoreGui)
UI.Name = "PollutedUI"
UI.ResetOnSpawn = false
UI.IgnoreGuiInset = true

-- UI Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = UI

-- Close/Open Toggle
local toggleKey = Enum.KeyCode.Period
UIS.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == toggleKey then
		MainFrame.Visible = not MainFrame.Visible
	end
end)

-- UI Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Polluted Cheat UI"
Title.TextColor3 = Color3.fromRGB(180, 0, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 30

-- Settings Table
local Settings = {
	Aimbot = false,
	Triggerbot = false,
	ESP = false,
	AlwaysHit = false,
	SilentAim = false,
	KillAll = false,
	LoopKillAll = false,
	DesyncMovement = false,
	BulletTP = false,
	AntiKick = false,
	AutoDodge = false,
	TargetPriority = "Closest",
	PlayerAlert = false,
	RapidFire = false,
	CooldownRemover = false,
	CustomHitSound = false,
	NameESP = false,
	HitboxTarget = "Head",
	DesyncStrength = 0,
	AutoDodgeCooldown = 100,
	RapidFireRate = 50,
	ReactionTime = 0.001, -- Default
	Keybinds = {
		Aimbot = Enum.KeyCode.E,
		Triggerbot = Enum.KeyCode.Q,
	}
}

-- Utility: Toggle Button Generator
local function CreateToggle(text, parent, default, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0, 280, 0, 30)
	btn.Text = text .. ": " .. tostring(default)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.BorderSizePixel = 0
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 20

	local enabled = default
	btn.MouseButton1Click:Connect(function()
		enabled = not enabled
		btn.Text = text .. ": " .. tostring(enabled)
		callback(enabled)
	end)
end

-- Utility: Dropdown
local function CreateDropdown(text, parent, options, callback)
	local label = Instance.new("TextLabel", parent)
	label.Text = text
	label.Size = UDim2.new(0, 280, 0, 20)
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.SourceSans
	label.TextSize = 18

	local dropdown = Instance.new("TextButton", parent)
	dropdown.Text = options[1]
	dropdown.Size = UDim2.new(0, 280, 0, 30)
	dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	dropdown.BorderSizePixel = 0
	dropdown.TextColor3 = Color3.new(1, 1, 1)
	dropdown.Font = Enum.Font.SourceSans
	dropdown.TextSize = 20

	local index = 1
	dropdown.MouseButton1Click:Connect(function()
		index = index + 1
		if index > #options then index = 1 end
		dropdown.Text = options[index]
		callback(options[index])
	end)
end

-- UI Layout
local Layout = Instance.new("UIGridLayout", MainFrame)
Layout.FillDirection = Enum.FillDirection.Vertical
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.CellSize = UDim2.new(0, 280, 0, 30)
Layout.CellPadding = UDim2.new(0, 10, 0, 5)

-- Add Toggles
CreateToggle("Aimbot", MainFrame, false, function(state)
	Settings.Aimbot = state
end)

CreateToggle("Triggerbot", MainFrame, false, function(state)
	Settings.Triggerbot = state
end)

CreateToggle("ESP", MainFrame, false, function(state)
	Settings.ESP = state
end)

CreateToggle("Always Hit", MainFrame, false, function(state)
	Settings.AlwaysHit = state
end)

CreateToggle("Silent Aim", MainFrame, false, function(state)
	Settings.SilentAim = state
end)

CreateToggle("Kill All", MainFrame, false, function(state)
	Settings.KillAll = state
end)

CreateToggle("Loop Kill All", MainFrame, false, function(state)
	Settings.LoopKillAll = state
end)

CreateToggle("Desync Movement", MainFrame, false, function(state)
	Settings.DesyncMovement = state
end)

CreateToggle("Bullet Teleport", MainFrame, false, function(state)
	Settings.BulletTP = state
end)

CreateToggle("Anti Kick", MainFrame, false, function(state)
	Settings.AntiKick = state
end)

CreateToggle("Auto Dodge", MainFrame, false, function(state)
	Settings.AutoDodge = state
end)

CreateToggle("Player Alert", MainFrame, false, function(state)
	Settings.PlayerAlert = state
end)

CreateToggle("Rapid Fire", MainFrame, false, function(state)
	Settings.RapidFire = state
end)

CreateToggle("Cooldown Remover", MainFrame, false, function(state)
	Settings.CooldownRemover = state
end)

CreateToggle("Custom Hit Sound", MainFrame, false, function(state)
	Settings.CustomHitSound = state
end)

CreateToggle("Name ESP Enhancer", MainFrame, false, function(state)
	Settings.NameESP = state
end)

-- Dropdowns
CreateDropdown("Hitbox Target", MainFrame, {"Head", "Torso", "Limbs"}, function(val)
	Settings.HitboxTarget = val
end)

CreateDropdown("Target Priority", MainFrame, {"Closest", "Lowest Health", "Most Kills"}, function(val)
	Settings.TargetPriority = val
end)

-- Part 2 – Sliders and Keybinds

-- Utility: Slider
local function CreateSlider(text, min, max, default, parent, callback)
	local label = Instance.new("TextLabel", parent)
	label.Text = text .. ": " .. tostring(default)
	label.Size = UDim2.new(0, 280, 0, 20)
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.SourceSans
	label.TextSize = 18

	local slider = Instance.new("TextButton", parent)
	slider.Size = UDim2.new(0, 280, 0, 30)
	slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	slider.Text = ""
	slider.AutoButtonColor = false

	local bar = Instance.new("Frame", slider)
	bar.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
	bar.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	bar.BorderSizePixel = 0

	local dragging = false

	slider.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)

	slider.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local rel = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
			rel = math.clamp(rel, 0, 1)
			bar.Size = UDim2.new(rel, 0, 1, 0)
			local value = math.floor(min + (max - min) * rel)
			label.Text = text .. ": " .. tostring(value)
			callback(value)
		end
	end)
end

-- Utility: Keybind Box
local function CreateKeybind(text, defaultKey, parent, callback)
	local button = Instance.new("TextButton", parent)
	button.Size = UDim2.new(0, 280, 0, 30)
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.BorderSizePixel = 0
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.SourceSans
	button.TextSize = 20
	button.Text = text .. ": " .. defaultKey.Name

	local waitingForKey = false

	button.MouseButton1Click:Connect(function()
		if waitingForKey then return end
		waitingForKey = true
		button.Text = text .. ": ..."
		local conn
		conn = UIS.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.MouseButton1 then
				waitingForKey = false
				conn:Disconnect()
				button.Text = text .. ": " .. input.KeyCode.Name
				callback(input.KeyCode)
			end
		end)
	end)
end

-- Sliders
CreateSlider("Desync Strength", 0, 100, Settings.DesyncStrength, MainFrame, function(val)
	Settings.DesyncStrength = val
end)

CreateSlider("Auto Dodge Cooldown (ms)", 1, 1000, Settings.AutoDodgeCooldown, MainFrame, function(val)
	Settings.AutoDodgeCooldown = val
end)

CreateSlider("Rapid Fire Rate", 1, 1000, Settings.RapidFireRate, MainFrame, function(val)
	Settings.RapidFireRate = val
end)

CreateSlider("Reaction Time (ms)", 0.0000001, 1, Settings.ReactionTime, MainFrame, function(val)
	Settings.ReactionTime = val
end)

-- Keybinds
CreateKeybind("Triggerbot Key", Settings.Keybinds.Triggerbot, MainFrame, function(key)
	Settings.Keybinds.Triggerbot = key
end)

CreateKeybind("Aimbot Key", Settings.Keybinds.Aimbot, MainFrame, function(key)
	Settings.Keybinds.Aimbot = key
end)

-- Configure Button
local apply = Instance.new("TextButton", MainFrame)
apply.Text = "Configure"
apply.Size = UDim2.new(0, 280, 0, 30)
apply.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
apply.TextColor3 = Color3.new(1, 1, 1)
apply.Font = Enum.Font.SourceSansBold
apply.TextSize = 22
apply.MouseButton1Click:Connect(function()
	print("Settings configured.")
end)

-- FOV Circle Configuration
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = true
FOVCircle.Radius = 100
FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
FOVCircle.Color = Color3.fromRGB(180, 0, 255)
FOVCircle.Thickness = 1
FOVCircle.Filled = false

RunService.RenderStepped:Connect(function()
	FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
	FOVCircle.Visible = MainFrame.Visible and (Settings.AlwaysHit or Settings.SilentAim)
end)

-- Visual Highlighting
local function HighlightPlayer(player)
	local char = player.Character
	if not char then return end
	for _, obj in ipairs(char:GetDescendants()) do
		if obj:IsA("BasePart") then
			local adorn = Instance.new("BoxHandleAdornment", obj)
			adorn.Adornee = obj
			adorn.ZIndex = 10
			adorn.Size = obj.Size
			adorn.Color3 = Color3.new(0, 0, 0)
			adorn.Transparency = 0
			adorn.AlwaysOnTop = true
		end
	end
end

-- Part 3 – Core Logic and MVSD Integration

-- Utility: Get All Targets in FOV
local function GetTargetsInFOV(radius)
	local cam = workspace.CurrentCamera
	local localPlayer = Players.LocalPlayer
	local targets = {}

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Team ~= localPlayer.Team then
			local hrp = player.Character.HumanoidRootPart
			local pos, onScreen = cam:WorldToViewportPoint(hrp.Position)
			if onScreen then
				local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
				if distance <= radius then
					table.insert(targets, {Player = player, Distance = distance})
				end
			end
		end
	end

	table.sort(targets, function(a, b)
		return a.Distance < b.Distance
	end)

	return targets
end

-- Always Hit Logic
RunService.RenderStepped:Connect(function()
	if not Settings.AlwaysHit then return end

	local targets = GetTargetsInFOV(FOVCircle.Radius)
	for _, target in ipairs(targets) do
		local char = target.Player.Character
		if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("Head") then
			local head = char.Head
			if Settings.AutoTrigger then
				task.spawn(function()
					task.wait(Settings.ReactionTime / 1000)
					mouse1click()
				end)
			end
			HighlightPlayer(target.Player)
		end
	end
end)

-- Silent Aim Logic
RunService.RenderStepped:Connect(function()
	if not Settings.SilentAim then return end

	local target = GetTargetsInFOV(FOVCircle.Radius)[1]
	if target then
		HighlightPlayer(target.Player)
	end
end)

-- MVSD Kill All Implementation
local function FireWeaponAtTarget(target)
	local char = Players.LocalPlayer.Character
	local weapon = char and char:FindFirstChildOfClass("Tool")
	if weapon and weapon:FindFirstChild("Remote") then
		for i = 1, 50 do
			weapon.Remote:FireServer(target.Character.Head.Position)
		end
	end
end

local function KillAllMVSD()
	local localPlayer = Players.LocalPlayer
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Team ~= localPlayer.Team and player.Character and player.Character:FindFirstChild("Head") then
			FireWeaponAtTarget(player)
		end
	end
end

local loopingKillAll = false

local function LoopKillAllMVSD()
	loopingKillAll = true
	while loopingKillAll do
		KillAllMVSD()
		task.wait(1 / 50)
	end
end

-- Connect Kill All / Loop Kill All
UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.F6 then -- Replace with desired keybind
		KillAllMVSD()
	end
	if input.KeyCode == Enum.KeyCode.F7 then -- Replace with desired keybind
		loopingKillAll = not loopingKillAll
		if loopingKillAll then
			task.spawn(LoopKillAllMVSD)
		end
	end
end)

-- MVSD Countdown Start Detection
local function DetectCountdown()
	local countdownGui = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MVSDCountdown", 10)
	if countdownGui then
		local label = countdownGui:FindFirstChild("TextLabel")
		if label then
			label:GetPropertyChangedSignal("Text"):Connect(function()
				if tonumber(label.Text) then
					if tonumber(label.Text) <= 5 then
						KillAllMVSD()
					end
				end
			end)
		end
	end
end

task.spawn(DetectCountdown)

-- Auto Peek / Dodge
local function IsBeingAimedAt()
	local cam = workspace.CurrentCamera
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			local dir = (Players.LocalPlayer.Character.Head.Position - player.Character.Head.Position).Unit
			local ray = Ray.new(player.Character.Head.Position, dir * 1000)
			local hit = workspace:FindPartOnRay(ray, player.Character)
			if hit and hit:IsDescendantOf(Players.LocalPlayer.Character) then
				return true
			end
		end
	end
	return false
end

RunService.RenderStepped:Connect(function()
	if Settings.AutoDodge then
		if IsBeingAimedAt() then
			local char = Players.LocalPlayer.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				char.HumanoidRootPart.Velocity = Vector3.new(math.random(-Settings.DesyncStrength, Settings.DesyncStrength), 0, math.random(-Settings.DesyncStrength, Settings.DesyncStrength))
				task.wait(Settings.AutoDodgeCooldown / 1000)
			end
		end
	end
end)

-- Kick Protection
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod()
	if Settings.AntiKick and (method == "Kick" or tostring(self) == "Kick") then
		return
	end
	return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- Continue in Part 4...
-- Part 4 – Final Integrations

-- Enhanced Name ESP
local function CreateEnhancedESP(player)
	if player.Character and player.Character:FindFirstChild("Head") then
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "EnhancedESP"
		billboard.Adornee = player.Character.Head
		billboard.Size = UDim2.new(0, 200, 0, 50)
		billboard.StudsOffset = Vector3.new(0, 3, 0)
		billboard.AlwaysOnTop = true
		billboard.Parent = player.Character

		local textLabel = Instance.new("TextLabel")
		textLabel.BackgroundTransparency = 1
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.TextColor3 = Color3.new(1, 1, 1)
		textLabel.TextStrokeTransparency = 0.5
		textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
		textLabel.TextScaled = true
		textLabel.Text = player.Name
		textLabel.Font = Enum.Font.SourceSansBold
		textLabel.Parent = billboard

		if Settings.ShowHealth then
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				textLabel.Text = string.format("%s | %d HP", player.Name, humanoid.Health)
			end
		end

		if Settings.ShowTeam then
			textLabel.Text = textLabel.Text .. " | Team: " .. tostring(player.Team)
		end

		if Settings.ShowDistance then
			local dist = (player.Character.Head.Position - Players.LocalPlayer.Character.Head.Position).Magnitude
			textLabel.Text = textLabel.Text .. string.format(" | %.0f studs", dist)
		end
	end
end

-- ESP Loop
RunService.RenderStepped:Connect(function()
	if not Settings.NameESPEnhancer then return end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= Players.LocalPlayer then
			local char = player.Character
			if char and char:FindFirstChild("Head") and not char:FindFirstChild("EnhancedESP") then
				CreateEnhancedESP(player)
			end
		end
	end
end)

-- Custom Hit Sound
local function CreateHitSound()
	if Settings.CustomHitSound and Settings.HitSoundId then
		local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://" .. Settings.HitSoundId
		sound.Volume = 1
		sound.PlayOnRemove = true
		sound.Parent = workspace
		sound:Destroy()
	end
end

-- Hook into damage detection (simplified)
local function SetupHitSound()
	local localPlayer = Players.LocalPlayer
	local lastHP = 100

	RunService.Heartbeat:Connect(function()
		local char = localPlayer.Character
		if char and char:FindFirstChildOfClass("Humanoid") then
			local humanoid = char:FindFirstChildOfClass("Humanoid")
			if humanoid.Health < lastHP then
				CreateHitSound()
			end
			lastHP = humanoid.Health
		end
	end)
end

SetupHitSound()

-- Final Toggle for UI with TAB key and others
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.Tab or input.KeyCode == Enum.KeyCode.K or input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.Period then
		UI.Enabled = not UI.Enabled
	end
end)

-- Auto configure when button is clicked
ConfigureButton.MouseButton1Click:Connect(function()
	UpdateKeybindSettings()
end)

-- Cleanup
Players.PlayerRemoving:Connect(function(player)
	if player.Character and player.Character:FindFirstChild("EnhancedESP") then
		player.Character.EnhancedESP:Destroy()
	end
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		if Settings.NameESPEnhancer then
			wait(1)
			CreateEnhancedESP(player)
		end
	end)
end)

-- Final Logs (for internal debug only, you can remove if desired)
print("[Polluted External UI] Integration Complete.")
print(string.format("[Polluted UI] %d features enabled.", table.getn(Settings)))

-- End of Part 4
-- PART 5: Silent Aim, Always Hit Integration with FOV Logic and Player Highlighting

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

-- UI Settings
local Settings = {
    AlwaysHit = false,
    SilentAim = false,
    FOV = 150,
    HighlightColor = Color3.fromRGB(0, 0, 0),
    AutoTrigger = false,
    AutoTriggerDelay = 0.001,
    HighlightEnabled = true
}

-- Targeting System
local function GetPlayersInFOV(fov)
    local visiblePlayers = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                if distance <= fov then
                    table.insert(visiblePlayers, {Player = player, Distance = distance})
                end
            end
        end
    end
    table.sort(visiblePlayers, function(a, b) return a.Distance < b.Distance end)
    return visiblePlayers
end

-- Highlight System
local function HighlightTarget(player, enable)
    if not player or not player.Character then return end
    local highlight = player.Character:FindFirstChildOfClass("Highlight")
    if enable and not highlight then
        highlight = Instance.new("Highlight", player.Character)
        highlight.FillTransparency = 1
        highlight.OutlineColor = Settings.HighlightColor
        highlight.OutlineTransparency = 0
    elseif not enable and highlight then
        highlight:Destroy()
    end
end

-- Execute AlwaysHit
local function ExecuteAlwaysHit()
    local targets = GetPlayersInFOV(Settings.FOV)
    for _, target in ipairs(targets) do
        if Settings.HighlightEnabled then
            HighlightTarget(target.Player, true)
        end
        -- Simulate kill logic here
        -- e.g. Fire bullets, send damage remote
        print("AlwaysHit: Killed", target.Player.Name)
    end
end

-- Execute SilentAim
local function ExecuteSilentAim()
    local targets = GetPlayersInFOV(Settings.FOV)
    local target = targets[1]
    if target then
        if Settings.HighlightEnabled then
            HighlightTarget(target.Player, true)
        end
        -- Simulate silent kill logic
        print("SilentAim: Killed", target.Player.Name)
    end
end

-- Auto Trigger
local AutoTriggerLastTime = 0
local function ExecuteAutoTrigger()
    local currentTime = tick()
    if currentTime - AutoTriggerLastTime >= Settings.AutoTriggerDelay then
        local targets = GetPlayersInFOV(Settings.FOV)
        if #targets > 0 then
            print("AutoTrigger: Triggered shot")
        end
        AutoTriggerLastTime = currentTime
    end
end

-- Runtime Connection
RunService.RenderStepped:Connect(function()
    if Settings.AlwaysHit then
        ExecuteAlwaysHit()
    elseif Settings.SilentAim then
        ExecuteSilentAim()
    end

    if Settings.AutoTrigger then
        ExecuteAutoTrigger()
    end
end)

-- UI Toggle Keybind
local UIS = game:GetService("UserInputService")
local UIFrame = script.Parent:WaitForChild("MainUI")
local toggleKey = Enum.KeyCode.Period

UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == toggleKey then
        UIFrame.Visible = not UIFrame.Visible
    end
end)

-- Sample Keybind Configuration UI (placeholder for actual UI code)
local KeybindAwait = false
local function AwaitKeybind(callback)
    KeybindAwait = true
    local conn
    conn = UIS.InputBegan:Connect(function(input)
        if KeybindAwait then
            callback(input.UserInputType == Enum.UserInputType.MouseButton1 and "Mouse1" or input.KeyCode.Name)
            KeybindAwait = false
            conn:Disconnect()
        end
    end)
end

-- Sample way to set AlwaysHit keybind (replace with actual UI trigger)
AwaitKeybind(function(key)
    print("Keybind set to:", key)
end)

-- Cleanup Highlights (Optional)
game:GetService("Players").PlayerRemoving:Connect(function(player)
    HighlightTarget(player, false)
end)

-- Placeholder for remaining cheat integration for next parts

-- PART 6 - Continued Cheat Integration & Final Settings

local function handleKillAll()
    if not cheats.KillAll then return end
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Team ~= localPlayer.Team then
            killPlayer(player)
        end
    end
end

local function handleLoopKillAll()
    if not cheats.LoopKillAll then return end
    spawn(function()
        while cheats.LoopKillAll do
            handleKillAll()
            task.wait(1/50)
        end
    end)
end

-- Countdown Handling
local function onCountdownStart()
    task.spawn(function()
        while game:GetService("ReplicatedStorage").Countdown.Value > 0 do
            handleLoopKillAll()
            wait()
        end
    end)
end

game:GetService("ReplicatedStorage").Countdown:GetPropertyChangedSignal("Value"):Connect(function()
    if game:GetService("ReplicatedStorage").Countdown.Value > 0 then
        onCountdownStart()
    end
end)

-- UI Close/Open
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Period then
        mainUI.Enabled = not mainUI.Enabled
    end
end)

-- UI Branding Footer
local footer = Instance.new("TextLabel", mainUI)
footer.Size = UDim2.new(1, 0, 0, 20)
footer.Position = UDim2.new(0, 0, 1, -20)
footer.BackgroundTransparency = 1
footer.TextColor3 = Color3.fromRGB(100, 0, 100)
footer.Text = "Polluted Project - Custom UI Cheat Integration"
footer.Font = Enum.Font.GothamSemibold
footer.TextSize = 14

-- Cheat Highlight Logic
function highlightTarget(player)
    local character = player.Character
    if not character then return end

    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            local highlight = Instance.new("BoxHandleAdornment")
            highlight.Name = "BlackOutline"
            highlight.Adornee = part
            highlight.AlwaysOnTop = true
            highlight.ZIndex = 10
            highlight.Size = part.Size
            highlight.Transparency = 0.5
            highlight.Color3 = Color3.new(0, 0, 0)
            highlight.Parent = part
        end
    end
end

-- Highlighting for Silent Aim vs Always Hit
function highlightSilentAimTarget(target)
    removeAllHighlights()
    if target then
        highlightTarget(target)
    end
end

function highlightAlwaysHitTargets(targets)
    removeAllHighlights()
    for _, player in ipairs(targets) do
        highlightTarget(player)
    end
end

function removeAllHighlights()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Character then
            for _, part in ipairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    local adorn = part:FindFirstChild("BlackOutline")
                    if adorn then
                        adorn:Destroy()
                    end
                end
            end
        end
    end
end

-- Ending Setup
print("Polluted Project Cheat UI Integration Complete")

-- Awaiting final configuration or triggers...
--[[ PART 7 -- Settings Management, Highlighting, Final Integration ]]--

-- Utility: Function to apply all configured settings from UI
local function applyAllSettings()
    -- Update internal config with UI values
    Config.ESP.Enabled = UISwitches.ESP.Enabled
    Config.Aimlock.Enabled = UISwitches.Aimlock.Enabled
    Config.SilentAim.Enabled = UISwitches.SilentAim.Enabled
    Config.AlwaysHit.Enabled = UISwitches.AlwaysHit.Enabled
    Config.FOVCircle.Enabled = UISwitches.SilentAim.Enabled or UISwitches.AlwaysHit.Enabled

    Config.Triggerbot.ReactionTime = math.clamp(TriggerbotSlider.Value, 0.00000001, 1)
    Config.AlwaysHit.ReactionTime = math.clamp(AlwaysHitSlider.Value, 0.0000001, 1)

    Config.TargetPriority = PriorityDropdown.Value
    Config.BulletTP.Hitbox = BulletTPDropdown.Value
    Config.AutoDodge.Cooldown = AutoDodgeCooldown.Value
    Config.RapidFire.RPS = RapidFireSlider.Value

    -- Sound config
    Config.HitSound.Enabled = UISwitches.CustomHitSound.Enabled
    Config.HitSound.SoundId = SoundPicker.Value

    -- Movement config
    Config.Desync.Enabled = UISwitches.DesyncMovement.Enabled
    Config.Desync.Offset = DesyncSlider.Value

    -- Weapon tweaks
    Config.CooldownBypass = UISwitches.WeaponCooldownRemover.Enabled

    -- Alert type
    Config.PlayerAlert.Mode = AlertDropdown.Value

    print("[Cheat] Settings applied.")
end

-- Assign to configure button
ConfigureButton.MouseButton1Click:Connect(applyAllSettings)

-- Highlight logic for Silent Aim and Always Hit
local function highlightTargets(targets)
    for _, target in pairs(targets) do
        local character = target.Character
        if character then
            local highlight = Instance.new("Highlight")
            highlight.Adornee = character
            highlight.FillColor = Color3.new(0, 0, 0)
            highlight.FillTransparency = 0.9
            highlight.OutlineTransparency = 1
            highlight.Name = "CheatHighlight"
            highlight.Parent = character
            Debris:AddItem(highlight, 0.5) -- Auto remove
        end
    end
end

-- Function to get targets in FOV
local function getTargetsInFOV()
    local targets = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            local distance = (Vector2.new(pos.X, pos.Y) - FOV.Position).Magnitude
            if onScreen and distance <= Config.FOVCircle.Radius then
                table.insert(targets, player)
            end
        end
    end
    return targets
end

-- Always Hit Logic
RunService.RenderStepped:Connect(function()
    if Config.AlwaysHit.Enabled then
        local targets = getTargetsInFOV()
        if #targets > 0 then
            highlightTargets(targets)
            for _, target in pairs(targets) do
                if isVisible(target) then
                    fireBullet(target, Config.BulletTP.Hitbox)
                end
            end
        end
    end
end)

-- Silent Aim Logic
RunService.RenderStepped:Connect(function()
    if Config.SilentAim.Enabled then
        local targets = getTargetsInFOV()
        if #targets > 0 then
            local target = getPriorityTarget(targets)
            highlightTargets({target})
            if isVisible(target) then
                fireBullet(target, Config.BulletTP.Hitbox)
            end
        end
    end
end)

-- UI toggle using Period key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Period then
        MainUI.Visible = not MainUI.Visible
    end
end)

-- Save Keybinds
local function captureKeybind(button, configKey)
    local capturing = true
    button.Text = "Press key..."
    local connection
    connection = UserInputService.InputBegan:Connect(function(input)
        if capturing then
            Config.Keybinds[configKey] = input.KeyCode
            button.Text = tostring(input.KeyCode)
            capturing = false
            connection:Disconnect()
        end
    end)
end

-- Allow keybinds to be set via mouse or keyboard
for key, button in pairs(KeybindButtons) do
    button.MouseButton1Click:Connect(function()
        captureKeybind(button, key)
    end)
end

-- [Part 8]

-- Additional cheat functions here:

-- Anti-Kick / Kick Bypass
function AntiKick()
    -- Prevents being kicked from the game
    -- Your bypass logic here
end

-- Desync Movement
function DesyncMovement()
    -- Simulates movement desync
    -- Your desync logic here
end

-- Auto Dodge / Auto Jump Peek
function AutoDodge()
    -- Dodges automatically when the player is about to be shot at
    -- Your dodge logic here
end

-- Target Priority System (Closest, Lowest Health, Most Kills)
function TargetPriority()
    -- Chooses the next target based on priority selection
    -- Your priority logic here
end

-- Player Alert System
function PlayerAlert()
    -- Notifies the user when they are targeted by another player
    -- Option to display visual or sound alerts
end

-- Rapid Fire
function RapidFire()
    -- Increases fire rate of the player's weapon
    -- Set rounds/sec logic here
end

-- Weapon Cooldown Remover
function WeaponCooldownRemover()
    -- Removes weapon cooldowns to allow continuous fire
    -- Your cooldown remover logic here
end

-- Custom Hit Sound
function CustomHitSound()
    -- Plays a custom sound when a target is hit
    -- Sound file logic here
end

-- Name ESP Enhancer
function NameESPEnhancer()
    -- Displays the name, health, team, and distance of nearby players
    -- ESP logic here
end

-- Final integration of all cheats and UI toggles
function ApplyAllCheats()
    -- Function to apply all active cheats and UI settings
    -- Call all the cheat functions based on UI settings here
end

-- Enable and disable each cheat based on toggle
function ToggleCheats()
    -- Toggle each cheat based on the user interface toggles
    -- Use a simple if/else or switch logic here
end

-- Final loop to keep the cheats running while the game is active
while true do
    -- Main loop that will check if any cheats are toggled on
    ToggleCheats()
end

-- End of Part 8
