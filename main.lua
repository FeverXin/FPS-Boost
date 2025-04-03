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
local PIXEL_HIT_CHANCE = 1.0  -- Always hit

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

        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        highlight.Adornee = rootPart

        local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
        if onScreen then
            nameTag.Position = Vector2.new(screenPos.X, screenPos.Y + 30)
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

-- Triggerbot
local triggerbotEnabled = false

local function triggerbot()
    while triggerbotEnabled do
        local target = getAimedTarget()
        if target then
            mouse1press()
            wait(0.01)
            mouse1release()
        end
        wait(0.001) -- Reacts in 1/10 of a millisecond
    end
end

-- Input Events
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == TRIGGERBOT_HOLD_KEY then
        triggerbotEnabled = true
        triggerbot()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == TRIGGERBOT_HOLD_KEY then
        triggerbotEnabled = false
    end
end)
