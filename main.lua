--[[ 
⚠️ You must be using an executor that supports UI libraries and full-featured Lua scripts
This UI is built using Rayfield Library (or similar), so make sure to install it if not using Synapse X, Fluxus, etc.
]]

-- Load UI Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Main Window
local Window = Rayfield:CreateWindow({
	Name = "MVSD Pro UI",
	LoadingTitle = "Loading...",
	LoadingSubtitle = "by Polluted",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "MVSD_UI",
		FileName = "Settings"
	},
        Discord = {
        	Enabled = false,
        	Invite = "", 
        	RememberJoins = true
    	},
	KeySystem = false
})

-- Tab
local MainTab = Window:CreateTab("Main", 4483362458)

-- SECTION: FUNCTION TO HOLD SETTINGS
local function CreateSetting(tab, name, description, callback)
	return tab:CreateToggle({
		Name = name,
		CurrentValue = false,
		Flag = name,
		Callback = callback
	})
end

-- AIMLOCK
local AimlockToggle = CreateSetting(MainTab, "Aimlock", "Lock onto players", function(Value) end)
MainTab:CreateInput({
	Name = "Aimlock Keybind",
	PlaceholderText = "Press Key...",
	RemoveTextAfterFocusLost = true,
	Callback = function(Key) end
})
MainTab:CreateSlider({
	Name = "Aimlock Smoothness",
	Range = {0, 100},
	Increment = 1,
	Suffix = "%",
	CurrentValue = 20,
	Callback = function(Value) end,
})

-- TRIGGERBOT
local TriggerbotToggle = CreateSetting(MainTab, "Triggerbot", "Auto-shoots visible targets", function(Value) end)
MainTab:CreateSlider({
	Name = "Reaction Time (ms)",
	Range = {0.0000001, 1},
	Increment = 0.0000001,
	Suffix = "ms",
	CurrentValue = 0.01,
	Callback = function(Value) end,
})
MainTab:CreateDropdown({
	Name = "Hit Pixels",
	Options = {"Head", "Torso", "Limbs"},
	CurrentOption = "Head",
	Callback = function(Value) end,
})
CreateSetting(MainTab, "Wall Check", "Only shoot when player is exposed", function(Value) end)

-- SILENT AIM
CreateSetting(MainTab, "Silent Aim", "Hits targets silently", function(Value) end)

-- ALWAYS HIT
local AlwaysHitToggle = CreateSetting(MainTab, "Always Hit", "Auto shoot visible targets in FOV", function(Value) end)
MainTab:CreateSlider({
	Name = "FOV Circle Radius",
	Range = {10, 300},
	Increment = 1,
	Suffix = "px",
	CurrentValue = 100,
	Callback = function(Value) end,
})
CreateSetting(MainTab, "Auto Trigger", "Shoots automatically", function(Value) end)
MainTab:CreateSlider({
	Name = "Reaction Time (ms)",
	Range = {0.0000001, 1},
	Increment = 0.0000001,
	Suffix = "s",
	CurrentValue = 0.01,
	Callback = function(Value) end,
})

-- ESP
CreateSetting(MainTab, "ESP", "Visual player boxes", function(Value) end)
MainTab:CreateColorPicker({
	Name = "ESP Color",
	Color = Color3.fromRGB(255, 0, 255),
	Callback = function(Color) end
})

-- FOV Circle
CreateSetting(MainTab, "Show FOV", "Show visible FOV circle", function(Value) end)
MainTab:CreateColorPicker({
	Name = "FOV Color",
	Color = Color3.fromRGB(255, 0, 255),
	Callback = function(Color) end
})

-- HBE / SMART HBE
CreateSetting(MainTab, "Smart HBE", "Hits visible exposed enemies", function(Value) end)
CreateSetting(MainTab, "Visualize Smart HBE", "Show Smart HBE range", function(Value) end)
MainTab:CreateSlider({
	Name = "Hitbox Size",
	Range = {1, 10},
	Increment = 0.1,
	CurrentValue = 1.5,
	Callback = function(Value) end,
})

-- KILL ALL / LOOP KILL ALL
CreateSetting(MainTab, "Kill All (MVSD)", "Kill all enemies instantly", function(Value)
	-- placeholder for MVSD game logic
end)
CreateSetting(MainTab, "Loop Kill All (MVSD)", "Spam kill all 50 bullets/sec", function(Value)
	-- placeholder for MVSD game logic
end)

-- DELETE DEV LOGS
CreateSetting(MainTab, "Delete Developer Logs", "Clear F9 console", function(Value)
	if Value then
		local StarterGui = game:GetService("StarterGui")
		StarterGui:SetCore("DevConsoleVisible", false)
		wait(0.1)
		StarterGui:SetCore("DevConsoleVisible", true)
	end
end)

-- KICK PLAYER
CreateSetting(MainTab, "Kick Player", "Kick specified player", function(Value) end)
MainTab:CreateInput({
	Name = "Enter Username to Kick",
	PlaceholderText = "username",
	RemoveTextAfterFocusLost = true,
	Callback = function(username)
		local Players = game:GetService("Players")
		local Target = Players:FindFirstChild(username)
		if Target then
			Target:Kick("You were kicked from the game.")
		end
	end
})

-- MISC ADDITIONAL FEATURES
CreateSetting(MainTab, "Bullet Teleportation", "Instantly hits selected hitbox", function(Value) end)
MainTab:CreateDropdown({
	Name = "Teleport Hitbox",
	Options = {"Head", "Torso", "Limbs"},
	CurrentOption = "Head",
	Callback = function(Value) end,
})
CreateSetting(MainTab, "Anti-Kick / Kick Bypass", "Bypass kick detection", function(Value) end)
CreateSetting(MainTab, "Desync Movement", "Fake player position", function(Value) end)
MainTab:CreateSlider({
	Name = "Desync Strength",
	Range = {1, 10},
	Increment = 0.1,
	CurrentValue = 2,
	Callback = function(Value) end,
})
CreateSetting(MainTab, "Auto Dodge", "Auto move away from aim", function(Value) end)
MainTab:CreateSlider({
	Name = "Dodge Cooldown (ms)",
	Range = {50, 1000},
	Increment = 10,
	CurrentValue = 300,
	Callback = function(Value) end,
})
MainTab:CreateDropdown({
	Name = "Target Priority",
	Options = {"Closest", "Lowest Health", "Most Kills"},
	CurrentOption = "Closest",
	Callback = function(Value) end
})
CreateSetting(MainTab, "Player Alert", "Warns you when targeted", function(Value) end)
MainTab:CreateDropdown({
	Name = "Alert Method",
	Options = {"Sound", "Visual"},
	CurrentOption = "Visual",
	Callback = function(Value) end
})
CreateSetting(MainTab, "Rapid Fire", "Increases fire rate", function(Value) end)
MainTab:CreateSlider({
	Name = "Rounds/sec",
	Range = {1, 1000},
	Increment = 10,
	CurrentValue = 300,
	Callback = function(Value) end,
})
CreateSetting(MainTab, "Remove Weapon Cooldown", "Removes weapon delay", function(Value) end)
CreateSetting(MainTab, "Custom Hit Sound", "Sound on hit", function(Value) end)
MainTab:CreateInput({
	Name = "Sound ID",
	PlaceholderText = "rbxassetid://...",
	RemoveTextAfterFocusLost = true,
	Callback = function(Value) end
})
CreateSetting(MainTab, "Name ESP Enhancer", "Show distance, health, team", function(Value) end)

-- TAB KEY UI TOGGLE
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.Tab then
		Rayfield:Toggle()
	end
end)
