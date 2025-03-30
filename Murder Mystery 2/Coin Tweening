local character = game.Players.LocalPlayer.Character
local player = game.Players.LocalPlayer
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
local MarketplaceService = game:GetService("MarketplaceService")

if not character or not humanoidRootPart then
    warn("Character or HumanoidRootPart not found.")
    return
end

local tweenService = game:GetService("TweenService")
local coinParts = {}
local visitedCoins = {}

local gamepassId = 429957 -- Elite gamepass
local coinsToCollect = 40

-- Check if player owns gamepass and set coinsToCollect accordingly
if MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamepassId) then
    coinsToCollect = 50
end

local function findNearestCoinServer(currentPart)
    local minDistance = math.huge
    local nearestPart = nil

    for _, part in ipairs(coinParts) do
        if part:IsA("BasePart") and part.Name == "Coin_Server" and part ~= currentPart and not table.find(visitedCoins, part) then
            local distance = (humanoidRootPart.Position - part.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                nearestPart = part
            end
        end
    end
    return nearestPart
end

local function addCoinPart(part)
    if part:IsA("BasePart") and part.Name == "Coin_Server" then
        table.insert(coinParts, part)
    end
end

local function removeCoinPart(part)
    for i, coinPart in ipairs(coinParts) do
        if coinPart == part then
            table.remove(coinParts, i)
            break
        end
    end
end

-- Initialize the coinParts table
for _, part in ipairs(workspace:GetDescendants()) do
    addCoinPart(part)
end

-- Listen for DescendantAdded and DescendantRemoving events
workspace.DescendantAdded:Connect(addCoinPart)
workspace.DescendantRemoving:Connect(removeCoinPart)

local currentCoin = findNearestCoinServer(nil)

if currentCoin then
    humanoidRootPart.CFrame = currentCoin.CFrame * CFrame.new(0, 2, 0) -- 2 studs above
    table.insert(visitedCoins, currentCoin)
end

while true do
    wait()

    if character and humanoidRootPart and currentCoin then
        local touchInterest = currentCoin:FindFirstChild("TouchInterest")

        if not touchInterest then
            local nextCoin = findNearestCoinServer(currentCoin)

            if nextCoin then
                local targetCFrame = nextCoin.CFrame * CFrame.new(0, 2, 0) -- 2 studs above
                local tweenInfo = TweenInfo.new(
                    (humanoidRootPart.Position - targetCFrame.Position).Magnitude / 16,
                    Enum.EasingStyle.Linear,
                    Enum.EasingDirection.Out,
                    0,
                    false,
                    0
                )

                local tween = tweenService:Create(
                    humanoidRootPart,
                    tweenInfo,
                    {CFrame = targetCFrame}
                )

                local tweenConnection

                tweenConnection = tween.Completed:Connect(function()
                    tweenConnection:Disconnect()
                    currentCoin = nextCoin
                    table.insert(visitedCoins, currentCoin)
                end)

                tween:Play()

                -- Check for coinsToCollect during the tween
                local startTime = tick()
                while tween.PlaybackState ~= Enum.PlaybackState.Completed and tick() - startTime < 5 do
                    wait()
                    local coinsText = player.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.CurrencyFrame.Icon.Coins
                    if coinsText and coinsText.Text == tostring(coinsToCollect) then
                        game.Players.LocalPlayer.Character.Humanoid.Health = 0
                        return
                    end
                end

                if tween.PlaybackState ~= Enum.PlaybackState.Completed then
                    game.Players.LocalPlayer.Character.Humanoid.Health = 0
                    return
                end
            else
                warn("No other Coin_Server parts found.")
                return
            end
        end
    else
        warn("Character, HumanoidRootPart, or currentCoin lost.")
        return
    end
end
