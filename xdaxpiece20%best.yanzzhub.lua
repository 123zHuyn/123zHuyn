local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local screenGui = Instance.new("ScreenGui")
local enemiesFolder = workspace:WaitForChild("Enemies")

screenGui.Name = "AutoFarmGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local farmButton = Instance.new("TextButton")
farmButton.Size = UDim2.new(0, 200, 0, 50)
farmButton.Position = UDim2.new(0.5, -100, 0.1, 0)
farmButton.Text = "Start Auto Farm"
farmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
farmButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
farmButton.Parent = screenGui

local autoFarmEnabled = false

local function getClosestEnemy()
    local closestEnemy = nil
    local closestDistance = math.huge

    for _, enemy in pairs(enemiesFolder:GetChildren()) do
        if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid").Health > 0 then
            local distance = (humanoidRootPart.Position - enemy.HumanoidRootPart.Position).magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestEnemy = enemy
            end
        end
    end

    return closestEnemy
end

local function attackEnemy(enemy)
    while autoFarmEnabled and enemy and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid").Health > 0 do
        humanoidRootPart.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + Vector3.new(0, 2, 0))
        wait(0.2)
        player.Backpack:FindFirstChild("Weapon"):Activate()
        wait(0.2)
    end
end

local function autoFarm()
    while autoFarmEnabled do
        local enemy = getClosestEnemy()
            if enemy then
            attackEnemy(enemy)
        else
            wait(2)
        end
    end
end

farmButton.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    if autoFarmEnabled then
        farmButton.Text = "Stop Auto Farm"
        spawn(autoFarm)
    else
        farmButton.Text = "Start Auto Farm"
    end
end)

local UIS = game:GetService("UserInputService")
local dragging = false
local dragInput, mousePos, framePos

farmButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = farmButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

farmButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        farmButton.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)
