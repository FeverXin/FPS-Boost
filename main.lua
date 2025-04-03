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
local AIM_SMOOTHNESS = 0.1  -- Smoothness for aimlock
local PIXEL_HIT_CHANCE = 1.0  -- Always hit
local TRIGGERBOT_REACTION_TIME = 0.0000001  -- Extremely fast triggerbot reaction time (in seconds)
local SILENT_AIM_FORCE = 100 -- The strength to curve the bullets toward the target
local AIMLOCK_KEY = Enum.UserInputType.MouseButton5 -- Mouse5 (Forward Switch button) to hold for aimlock

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

-- Silent Aim - Aggressive and Instant (Force-lock mechanism)
local function silentAim(target)
    if target then
        local targetPos = target.Position
        local direction = (targetPos - Camera.CFrame.Position).unit
        local newPos = Camera.CFrame.Position + direction * SILENT_AIM_FORCE
        Camera.CFrame = CFrame.new(newPos, targetPos)  -- Hard lock and curve toward target
    end
end

-- Third-Person Aimlock - Mouse Move based, smooth and locked on target
local function aimlock(target)
    if target then
        local targetPos = target.Position
        local mousePos = Vector2.new(Mouse.X, Mouse.Y)
        
        -- Create smooth aim movement towards the target
        local targetScreenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
        if onScreen then
            local aimOffset = Vector2.new(targetScreenPos.X - mousePos.X, targetScreenPos.Y - mousePos.Y)
            local smoothOffset = aimOffset * AIM_SMOOTHNESS
            Mouse.Move:Fire(mousePos.X + smoothOffset.X, mousePos.Y + smoothOffset.Y)
        end
    end
end

-- Triggerbot - Extremely Fast Reaction (0.0000001 seconds)
local triggerbotEnabled = false

local function triggerbot()
    while triggerbotEnabled do
        local target = getAimedTarget()
        if target then
            mouse1press()
            wait(0.0000001)  -- Extremely fast reaction time
            mouse1release()
        end
        wait(0.0000001) -- Reacts faster than the player can shoot, continuous check
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
        -- Stop all processes and remove all elements
        fovCircle.Visible = false
        triggerbotEnabled = false
        -- Disable silent aim and aimlock
        silentAim = function() end
        aimlock = function() end
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
        aimlock(target)    -- Apply smooth aimlock to the target
    end
end)

-- Aimlock activation with Mouse5 (Hold)
local aimlockActive = false

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == AIMLOCK_KEY then
        aimlockActive = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == AIMLOCK_KEY then
        aimlockActive = false
    end
end)

-- Call aimlock when Mouse5 is held
RunService.RenderStepped:Connect(function()
    if aimlockActive then
        local target = getAimedTarget()
        if target then
            aimlock(target)  -- Apply smooth aimlock
        end
    end
end)
