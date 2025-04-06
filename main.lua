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

-- Aimlock Feature
local AimlockToggle = CreateSetting(MainTab, "Aimlock", "Lock onto players", function(Value)
    -- Implement Aimlock Logic Here
end)

MainTab:CreateInput({
    Name = "Aimlock Keybind",
    PlaceholderText = "Press Key...",
    RemoveTextAfterFocusLost = true,
    Callback = function(Key)
        -- Store and bind key logic here
    end
})

MainTab:CreateSlider({
    Name = "Aimlock Smoothness",
    Range = {0, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 20,
    Callback = function(Value)
        -- Implement Aimlock smoothness logic
    end
})

-- Triggerbot Feature
local TriggerbotToggle = CreateSetting(MainTab, "Triggerbot", "Auto-shoots visible targets", function(Value)
    -- Implement Triggerbot logic here
end)

MainTab:CreateSlider({
    Name = "Reaction Time (ms)",
    Range = {0.0000001, 1},
    Increment = 0.0000001,
    Suffix = "s", 
    CurrentValue = 0.01,
    Callback = function(Value)
        -- Adjust triggerbot reaction time
    end,
})

MainTab:CreateDropdown({
    Name = "Hit Pixels",
    Options = {"Head", "Torso", "Limbs"},
    CurrentOption = "Head",
    Callback = function(Value)
        -- Set the target hit area for triggerbot
    end,
})

CreateSetting(MainTab, "Wall Check", "Only shoot when player is exposed", function(Value)
    -- Implement wall check
end)

-- Always Hit Feature
local AlwaysHitToggle = CreateSetting(MainTab, "Always Hit", "Auto shoot visible targets in FOV", function(Value)
    -- Implement Always Hit logic
end)

MainTab:CreateSlider({
    Name = "FOV Circle Radius",
    Range = {10, 300},
    Increment = 1,
    Suffix = "px",
    CurrentValue = 100,
    Callback = function(Value)
        -- Implement FOV range logic
    end,
})

CreateSetting(MainTab, "Auto Trigger", "Shoots automatically", function(Value)
    -- Implement auto trigger logic
end)

MainTab:CreateSlider({
    Name = "Reaction Time (ms)",
    Range = {0.0000001, 1},
    Increment = 0.0000001,
    Suffix = "s",
    CurrentValue = 0.01,
    Callback = function(Value)
        -- Implement automatic trigger reaction time
    end,
})

-- Silent Aim Feature
CreateSetting(MainTab, "Silent Aim", "Hits targets silently", function(Value)
    -- Implement Silent Aim logic
end)

-- Kill All / Loop Kill All
CreateSetting(MainTab, "Kill All (MVSD)", "Kill all enemies instantly", function(Value)
    -- Implement Kill All logic (MVSD game logic required)
end)

CreateSetting(MainTab, "Loop Kill All (MVSD)", "Spam kill all 50 bullets/sec", function(Value)
    -- Implement Loop Kill All logic (MVSD game logic required)
end)

-- Bullet Teleportation
CreateSetting(MainTab, "Bullet Teleportation", "Instantly hits selected hitbox", function(Value)
    -- Implement Bullet Teleportation logic
end)

MainTab:CreateDropdown({
    Name = "Teleport Hitbox",
    Options = {"Head", "Torso", "Limbs"},
    CurrentOption = "Head",
    Callback = function(Value)
        -- Set teleport hitbox
    end,
})

-- Anti-Kick / Kick Bypass
CreateSetting(MainTab, "Anti-Kick / Kick Bypass", "Bypass kick detection", function(Value)
    -- Implement anti-kick logic
end)

-- Desync Movement
CreateSetting(MainTab, "Desync Movement", "Fake player position", function(Value)
    -- Implement desync movement logic
end)

MainTab:CreateSlider({
    Name = "Desync Strength",
    Range = {1, 10},
    Increment = 0.1,
    CurrentValue = 2,
    Callback = function(Value)
        -- Implement desync strength logic
    end,
})

-- Auto Dodge / Auto Jump Peek
CreateSetting(MainTab, "Auto Dodge", "Auto move away from aim", function(Value)
    -- Implement auto dodge logic
end)

CreateSetting(MainTab, "Auto Jump Peek", "Auto jump when peeking", function(Value)
    -- Implement auto jump peek logic
end)

-- Target Priority System
MainTab:CreateDropdown({
    Name = "Target Priority",
    Options = {"Closest", "Lowest Health", "Most Kills"},
    CurrentOption = "Closest",
    Callback = function(Value)
        -- Implement target priority logic
    end
})

-- Player Alert
CreateSetting(MainTab, "Player Alert", "Warns you when targeted", function(Value)
    -- Implement player alert logic
end)

MainTab:CreateDropdown({
    Name = "Alert Method",
    Options = {"Sound", "Visual"},
    CurrentOption = "Visual",
    Callback = function(Value)
        -- Set alert method (sound or visual)
    end
})

-- Rapid Fire
CreateSetting(MainTab, "Rapid Fire", "Increases fire rate", function(Value)
    -- Implement rapid fire logic
end)

MainTab:CreateSlider({
    Name = "Rounds/sec",
    Range = {1, 1000},
    Increment = 10,
    CurrentValue = 300,
    Callback = function(Value)
        -- Adjust fire rate
    end,
})

-- Weapon Cooldown Remover
CreateSetting(MainTab, "Weapon Cooldown Remover", "Removes weapon delay", function(Value)
    -- Implement cooldown remover logic
end)

-- Custom Hit Sound
CreateSetting(MainTab, "Custom Hit Sound", "Sound on hit", function(Value)
    -- Play custom sound on hit
end)

MainTab:CreateInput({
    Name = "Sound ID",
    PlaceholderText = "rbxassetid://...",
    RemoveTextAfterFocusLost = true,
    Callback = function(Value)
        -- Implement sound logic for hits
    end
})

-- Name ESP Enhancer
CreateSetting(MainTab, "Name ESP Enhancer", "Show distance, health, team", function(Value)
    -- Implement Name ESP logic
end)

-- Delete Developer Logs
CreateSetting(MainTab, "Delete Developer Logs", "Clear F9 console", function(Value)
    if Value then
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("DevConsoleVisible", false)
        wait(0.1)
        StarterGui:SetCore("DevConsoleVisible", true)
    end
end)

-- TAB KEY UI TOGGLE
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Tab then
        Rayfield:Toggle()
    end
end)
