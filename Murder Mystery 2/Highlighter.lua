
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function createHighlight(player)
    if not player.Character or player.Character:FindFirstChild("Highlight") then
        return -- Exit if character doesn't exist or highlight already exists
    end

    local highlight = Instance.new("Highlight")
    highlight.Parent = player.Character
    return highlight
end

local function updateHighlight(player)
    if not player.Character or not player.Character:FindFirstChild("Highlight") then
        return -- Exit if character doesn't exist or highlight doesn't exist
    end

    local highlight = player.Character:FindFirstChild("Highlight")
    local highlightColor = Color3.fromRGB(0, 225, 0) -- Default green

    -- Check for tools in Backpack and Character
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character

    local function checkTools(container)
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") then
                    if tool.Name == "Knife" then
                        return Color3.fromRGB(225, 0, 0) -- Red for Knife
                    elseif tool.Name == "Gun" then
                        return Color3.fromRGB(0, 0, 225) -- Blue for Gun
                    end
                end
            end
        end
        return nil
    end

    local toolColor = checkTools(backpack) or checkTools(character)
    if toolColor then
        highlightColor = toolColor
    end

    highlight.FillColor = highlightColor
    highlight.OutlineColor = highlightColor
end

local function applyHighlights()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if _G.ToggleName then -- Check if toggle is on
                if player.Character and not player.Character:FindFirstChild("Highlight") then
                    createHighlight(player)
                end
                if player.Character then -- Add this check
                    updateHighlight(player)
                end
            elseif player.Character then -- Add this check
                if player.Character:FindFirstChild("Highlight") then
                    player.Character:FindFirstChild("Highlight"):Destroy()
                end
            end
        end
    end
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        if _G.ToggleName then -- Check if toggle is on
            if player.Character then -- Add this check
                createHighlight(player)
                updateHighlight(player)
            end
        end
    end)

    if player.Character and _G.ToggleName then -- Check if toggle is on
        createHighlight(player)
        updateHighlight(player)
    end
end

local function onPlayerRemoving(player)
    if player.Character and player.Character:FindFirstChild("Highlight") then
        player.Character:FindFirstChild("Highlight"):Destroy()
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        onPlayerAdded(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        onPlayerAdded(player)
    end
end)

Players.PlayerRemoving:Connect(onPlayerRemoving)


RunService.RenderStepped:Connect(applyHighlights)


_G.ToggleName = {} -- Optional.
