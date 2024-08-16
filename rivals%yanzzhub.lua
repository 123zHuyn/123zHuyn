local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ฟังก์ชันเพื่อสร้าง ESP
local function createESP(character)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESP"
    billboardGui.Adornee = character:WaitForChild("Head")
    billboardGui.Size = UDim2.new(0, 100, 0, 100)
    billboardGui.AlwaysOnTop = true
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)

    local frame = Instance.new("Frame", billboardGui)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.5
    frame.BackgroundColor3 = Color3.new(1, 0, 0) -- สีแดงสำหรับศัตรู

    billboardGui.Parent = character:WaitForChild("Head")
end

-- เพิ่ม ESP ให้กับศัตรูที่มีอยู่ในปัจจุบัน
for _, player in pairs(Players:GetPlayers()) do
    if player.Team ~= LocalPlayer.Team and player.Character then
        createESP(player.Character)
    end

    player.CharacterAdded:Connect(function(character)
        if player.Team ~= LocalPlayer.Team then
            character:WaitForChild("HumanoidRootPart")
            createESP(character)
        end
    end)
end

-- เพิ่ม ESP ให้กับศัตรูที่เข้ามาใหม่
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if player.Team ~= LocalPlayer.Team then
            character:WaitForChild("HumanoidRootPart")
            createESP(character)
        end
    end)
end)

-- ฟังก์ชันเพื่อให้กระสุนติดตามศัตรู
local function bulletFollowEnemy(bullet)
    local closestEnemy = nil
    local closestDistance = math.huge

    for _, enemyPlayer in pairs(Players:GetPlayers()) do
        if enemyPlayer.Team ~= LocalPlayer.Team and enemyPlayer.Character and enemyPlayer.Character:FindFirstChild("Head") then
            local distance = (bullet.Position - enemyPlayer.Character.Head.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestEnemy = enemyPlayer.Character.Head
            end
        end
    end

    if closestEnemy then
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear)
        local goal = {Position = closestEnemy.Position}

        local tween = TweenService:Create(bullet, tweenInfo, goal)
        tween:Play()

        tween.Completed:Connect(function()
            if bullet then
                bullet:Destroy()
            end
        end)
    end
end

-- ฟังก์ชันที่ทำให้กระสุนติดตามศัตรูเมื่อถูกยิง
local function onBulletFired(bullet)
    if bullet and bullet.Parent then
        bulletFollowEnemy(bullet)
    end
end

-- ฟังก์ชันเพื่อสร้างกระสุนตัวอย่าง
local function createTestBullet()
    local bullet = Instance.new("Part")
    bullet.Size = Vector3.new(0.2, 0.2, 0.2)
    bullet.Position = LocalPlayer.Character.Head.Position
    bullet.Anchored = false
    bullet.CanCollide = false
    bullet.Parent = workspace

    bullet.Touched:Connect(function(hit)
        if hit and hit.Parent:FindFirstChild("Humanoid") and hit.Parent ~= LocalPlayer.Character then
            hit.Parent.Humanoid:TakeDamage(50)
            bullet:Destroy()
        end
    end)

    onBulletFired(bullet)
end

-- การตรวจจับการคลิกเมาส์เพื่อยิงกระสุน
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        createTestBullet()
    end
end)
