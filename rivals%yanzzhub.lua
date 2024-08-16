-- LocalScript in StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Function to create ESP
local function createESP(character)
    local highlight = Instance.new("BoxHandleAdornment")
    highlight.Size = character.PrimaryPart.Size
    highlight.Adornee = character.PrimaryPart
    highlight.AlwaysOnTop = true
    highlight.ZIndex = 10
    highlight.Transparency = 0.5
    highlight.Color3 = Color3.new(1, 0, 0) -- Red color for enemies
    highlight.Parent = character.PrimaryPart
end

-- Add ESP to existing enemy players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character then
        createESP(player.Character)
    end

    player.CharacterAdded:Connect(function(character)
        if player.Team ~= LocalPlayer.Team then
            character:WaitForChild("HumanoidRootPart")
            createESP(character)
        end
    end)
end

-- Add ESP to newly joined enemy players
Players.PlayerAdded:Connect(function(player)
    if player.Team ~= LocalPlayer.Team then
        player.CharacterAdded:Connect(function(character)
            character:WaitForChild("HumanoidRootPart")
            createESP(character)
        end)
    end
end)

-- Function to make bullets follow enemies
local function onBulletFired(bullet, origin, target)
    local direction = (target.Position - origin.Position).Unit
    local bulletTween = TweenService:Create(bullet, TweenInfo.new(1), {CFrame = CFrame.new(target.Position)})
    bulletTween:Play()

    bullet.Touched:Connect(function(hit)
        if hit and hit.Parent:FindFirstChild("Humanoid") and hit.Parent ~= LocalPlayer.Character then
            hit.Parent.Humanoid:TakeDamage(50)
                    bullet:Destroy()
        end
    end)
end

-- Function to create a test bullet
local function createTestBullet()
    local bullet = Instance.new("Part")
    bullet.Size = Vector3.new(0.2, 0.2, 0.2)
    bullet.Position = LocalPlayer.Character.Head.Position
    bullet.Anchored = false
    bullet.CanCollide = false
    bullet.Parent = workspace

    local closestEnemy = nil
    local minDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player.Team ~= LocalPlayer.Team and player.Character and player.Character:FindFirstChild("Head") then
            local distance = (LocalPlayer.Character.Head.Position - player.Character.Head.Position).Magnitude
            if distance < minDistance then
                closestEnemy = player.Character.Head
                minDistance = distance
            end
        end
    end

    if closestEnemy then
        onBulletFired(bullet, LocalPlayer.Character.Head, closestEnemy)
    end
end

-- Detect mouse click to fire bullet
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        createTestBullet()
    end
end)
