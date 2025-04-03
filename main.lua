local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Table to store ESP objects
local ESP_Boxes = {}

-- Function to create ESP
local function createESP(player)
    if player == LocalPlayer then return end -- Don't ESP yourself

    local highlight = Instance.new("BoxHandleAdornment")
    highlight.Size = Vector3.new(4, 6, 0) -- Box dimensions (adjust as needed)
    highlight.Color3 = Color3.new(1, 1, 1) -- White color
    highlight.Adornee = nil
    highlight.AlwaysOnTop = true
    highlight.ZIndex = 5
    highlight.Parent = game.CoreGui

    local nameTag = Drawing.new("Text")
    nameTag.Size = 18
    nameTag.Color = Color3.new(1, 1, 1)
    nameTag.Outline = true
    nameTag.Center = true
    nameTag.Visible = false

    ESP_Boxes[player] = { Box = highlight, NameTag = nameTag }

    local function updateESP()
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
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

-- Triggerbot Setup
local triggerbotEnabled = false

local function isTargetVisible(target)
    local origin = Camera.CFrame.Position
    local targetPos = target.Position

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = { LocalPlayer.Character }
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local result = workspace:Raycast(origin, (targetPos - origin).unit * 500, raycastParams)

    if result and result.Instance:IsDescendantOf(target.Parent) then
        return true
    else
        return false
    end
end

local function getAimedTarget()
    local closestTarget = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if distance < shortestDistance and isTargetVisible(rootPart) then
                    shortestDistance = distance
                    closestTarget = rootPart
                end
            end
        end
    end

    return closestTarget
end

local function triggerbot()
    while triggerbotEnabled do
        local target = getAimedTarget()
        if target then
            mouse1press()
            wait(0.0001) -- 1/10th of a millisecond
            mouse1release()
        end
        wait(0.0001) -- Adjusted for ultra-fast reaction time
    end
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        triggerbotEnabled = true
        triggerbot()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        triggerbotEnabled = false
    end
end)
