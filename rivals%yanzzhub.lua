local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local function createESP(character)
local highlight = Instance.new("Highlight")
highlight.Parent = character
highlight.Adornee = character
highlight.FillColor = Color3.new(1, 0, 0) -- สีแดงสำหรับศัตรู
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.FillTransparency = 0.5
end

for _, player in pairs(game.Players:GetPlayers()) do
if player.Team ~= game.Players.LocalPlayer.Team then
player.CharacterAdded:Connect(function(character)
createESP(character)
end)
if player.Character then
createESP(player.Character)
end
end
end

game.Players.PlayerAdded:Connect(function(newPlayer)
if newPlayer.Team ~= game.Players.LocalPlayer.Team then
newPlayer.CharacterAdded:Connect(function(character)
createESP(character)
end)
end
end)

local function bulletFollowEnemy(bullet)
local closestEnemy = nil
local closestDistance = math.huge

for _, enemyPlayer in pairs(game.Players:GetPlayers()) do
if enemyPlayer.Team ~= player.Team and enemyPlayer.Character and enemyPlayer.Character:FindFirstChild("Head") then
local distance = (bullet.Position - enemyPlayer.Character.Head.Position).magnitude
if distance < closestDistance then
closestDistance = distance
closestEnemy = enemyPlayer.Character.Head
end
end
end

if closestEnemy then
local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local goal = {CFrame = CFrame.new(closestEnemy.Position)}

local tween = tweenService:Create(bullet, tweenInfo, goal)
tween:Play()
end
end

local function onBulletFired(bullet)
runService.RenderStepped:Connect(function()
if bullet and bullet.Parent then
bulletFollowEnemy(bullet)
end
end)
end

local function createTestBullet()
local bullet = Instance.new("Part")
bullet.Size = Vector3.new(0.2, 0.2, 0.2)
bullet.Position = character.Head.Position
bullet.Parent = workspace
bullet.Anchored = false
bullet.CanCollide = false

bullet.Touched:Connect(function(hit)
if hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
hit.Parent:FindFirstChild("Humanoid"):TakeDamage(10)
end
bullet:Destroy()
end)

onBulletFired(bullet)
end

UIS.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
createTestBullet()
end
end)
