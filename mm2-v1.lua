local player = game.Players.LocalPlayer
local premiumItems = {"https://www.roblox.com/game-pass/429957/Elite", "https://www.roblox.com/game-pass/1308795/Radio", "https://www.roblox.com/game-pass/850293409/GODLY-Pearlshine", "https://www.roblox.com/game-pass/850387075/BUNDLE-Pearls", "https://www.roblox.com/game-pass/850003963/GODLY-Pearl"}

local function unlockAllPremiums()
for _, itemName in ipairs(premiumItems) do
local item = player:WaitForChild("Backpack"):FindFirstChild(itemName)
if item then
item.Value = true
else
local newItem = Instance.new("BoolValue")
newItem.Name = itemName
newItem.Value = true
newItem.Parent = player:WaitForChild("Backpack")
end
end
print("All Premiums Unlocked")
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PremiumUnlocker"
screenGui.Parent = player:WaitForChild("PlayerGui")

local unlockButton = Instance.new("TextButton")
unlockButton.Size = UDim2.new(0, 200, 0, 50)
unlockButton.Position = UDim2.new(0.5, -100, 0.5, -25)
unlockButton.Text = "Unlock All Premiums"
unlockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
unlockButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
unlockButton.Parent = screenGui

unlockButton.MouseButton1Click:Connect(function()
unlockAllPremiums()
end)

local UIS = game:GetService("UserInputService")
local dragging = false
local dragInput, mousePos, framePos

unlockButton.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = true
mousePos = input.Position
framePos = unlockButton.Position

input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
dragging = false
end
end)
end
end)

unlockButton.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement then
dragInput = input
end
end)

UIS.InputChanged:Connect(function(input)
if input == dragInput and dragging then
local delta = input.Position - mousePos
unlockButton.Position = UDim2.new(
framePos.X.Scale,
framePos.X.Offset + delta.X,
framePos.Y.Scale,
framePos.Y.Offset + delta.Y
)
end
end)