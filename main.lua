-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Settings
local FOV_RADIUS = 150  -- Adjust circle size
local TRIGGERBOT_HOLD_KEY = Enum.KeyCode.E
local ESP_COLOR = Color3.fromRGB(255, 255, 255)
local AIM_SMOOTHNESS = 0.05  -- Aggressive, faster snapping for silent aim
local PIXEL_HIT_CHANCE = 1.0  -- Always hit
local TRIGGERBOT_REACTION_TIME = 0.01  -- Extremely fast triggerbot reaction time

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

-- Function to check if a player is visible
local function isTargetVisible(target)
    local origin = Camera.CFrame.Position
    local targetPos = target.Position

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = { LocalPlayer.Character }
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local result = workspace:Raycast(origin, (targetPos - origin).unit * 500, raycastParams)

    return result and result.Instance:IsDescendantOf(target.Parent)
end

-- Function to get the closest visible target within FOV
local function getAimedTarget()
    local closestTarget = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid").Health > 0 then
            local rootPart = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if distance < FOV_RADIUS and distance < shortestDistance and isTargetVisible(rootPart) then
                    shortestDistance = distance
                    closestTarget = rootPart
                end
            end
        end
    end

    return closestTarget
end

-- Silent Aim - Aggressive and Instant
local function silentAim(target)
    if target then
        local targetPos = target.Position
        -- Directly set camera position towards target with a high level of "snap"
        local newPos = Camera.CFrame.Position:Lerp(targetPos, AIM_SMOOTHNESS)
        Camera.CFrame = CFrame.new(newPos, targetPos)  -- Instant lock on target's position
    end
end

-- Triggerbot - Extremely Fast Reaction
local triggerbotEnabled = false

local function triggerbot()
    while triggerbotEnabled do
        local target = getAimedTarget()
        if target then
            mouse1press()
            wait(0.001)  -- Extremely fast reaction time, reacting in milliseconds
            mouse1release()
        end
        wait(0.001) -- Reacts faster than the player can shoot, continuous check
    end
end

-- Input Events
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == TRIGGERBOT_HOLD_KEY then
        triggerbotEnabled = true
        triggerbot()
    end

    -- Kill switch: Press F9 to stop the script
    if input.KeyCode == Enum.KeyCode.F9 then
        -- Stop all processes and remove all the elements
        fovCircle.Visible = false
        triggerbotEnabled = false
        -- Remove ESP
        for _, player in pairs(Players:GetPlayers()) do
            removeESP(player)
        end
        -- Stop the script execution
        return
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == TRIGGERBOT_HOLD_KEY then
        triggerbotEnabled = false
    end
end)

-- FOV Circle Update: Make the FOV circle follow the mouse
RunService.RenderStepped:Connect(function()
    fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    local target = getAimedTarget()
    if target then
        silentAim(target)  -- Call silent aim for the target within the FOV circle
    end
end)
