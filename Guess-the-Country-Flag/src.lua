local countryMap = loadstring(game:HttpGet("https://raw.githubusercontent.com/babyoutrhy/RLua/refs/heads/main/Guess-the-Country-Flag/Country-Flags-List.lua"))()

local function isInGame()
    local playerName = game.Players.LocalPlayer.Name
    local refs = workspace:FindFirstChild("References")
    if not refs then return false end
    
    local blocks = refs:FindFirstChild("Blocks")
    if not blocks then return false end
    
    return blocks:FindFirstChild(playerName) ~= nil
end

local function autoAnswer()
    if not isInGame() then return end
    
    local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end
    
    local gameUI = playerGui:FindFirstChild("GameUI")
    if not gameUI then return end
    
    local gameUIFrame = gameUI:FindFirstChild("REFERENCED__GameUIFrame")
    if not gameUIFrame then return end
    
    local topFlag = gameUIFrame:FindFirstChild("TopFlag")
    if not topFlag then return end
    
    local flagImage = topFlag:FindFirstChild("FlagImage")
    if not flagImage then return end
    
    local inputFrame = gameUIFrame:FindFirstChild("Input")
    if not inputFrame then return end
    
    local inputBox = inputFrame:FindFirstChild("InputBox")
    if not inputBox then return end

    local currentImage = flagImage.Image
    local country = countryMap[currentImage]
    
    if country and inputBox:IsDescendantOf(game) then
        inputBox:CaptureFocus()
        inputBox.Text = country
        task.wait(0.1)
        
        -- Submit the answer
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        task.wait(0.01)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    end
end

-- Main logic
while true do
    if isInGame() then
        -- Create connection to flag changes while in-game
        local connection
        connection = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.REFERENCED__GameUIFrame.TopFlag.FlagImage:GetPropertyChangedSignal("Image"):Connect(autoAnswer)
        
        -- Trigger immediately for the first flag
        autoAnswer()
        
        -- Wait until we're no longer in game
        repeat wait() until not isInGame()
        connection:Disconnect()
    end
    task.wait(0.5)
end
