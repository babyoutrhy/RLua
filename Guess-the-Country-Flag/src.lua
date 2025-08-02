local rawCountryFlag = loadstring(game:HttpGet("https://raw.githubusercontent.com/babyoutrhy/RLua/refs/heads/main/Guess-the-Country-Flag/Country-Flags-List.lua", true))()

-- Create normalized country flag
local countryFlag = {}
for key, value in pairs(rawCountryFlag) do
    local id = key:match("rbxassetid://(%d+)") or key:match("^(%d+)$")
    if id then
        countryFlag["rbxassetid://"..id] = value
        countryFlag[id] = value
    end
end

local function isInGame()
    local playerName = game.Players.LocalPlayer.Name
    local refs = workspace:FindFirstChild("References")
    if not refs then return false end
    
    local blocks = refs:FindFirstChild("Blocks")
    if not blocks then return false end
    
    return blocks:FindFirstChild(playerName) ~= nil
end

local isTyping = false

local function autoAnswer()
    if not isInGame() or isTyping then return end
    isTyping = true
    
    local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then isTyping = false return end
    
    local gameUI = playerGui:FindFirstChild("GameUI")
    if not gameUI then isTyping = false return end
    
    local gameUIFrame = gameUI:FindFirstChild("REFERENCED__GameUIFrame")
    if not gameUIFrame then isTyping = false return end
    
    local topFlag = gameUIFrame:FindFirstChild("TopFlag")
    if not topFlag then isTyping = false return end
    
    local flagImage = topFlag:FindFirstChild("FlagImage")
    if not flagImage then isTyping = false return end
    
    local inputFrame = gameUIFrame:FindFirstChild("Input")
    if not inputFrame then isTyping = false return end
    
    local inputBox = inputFrame:FindFirstChild("InputBox")
    if not inputBox then isTyping = false return end

    local currentImage = flagImage.Image
    local imageId = currentImage:match("rbxassetid://(%d+)") or currentImage
    local country = countryFlag[imageId] or countryFlag["rbxassetid://"..imageId]
    
    if country and inputBox:IsDescendantOf(game) then
        inputBox:CaptureFocus()
        
        if instantSubmit then
            -- Instant submission mode
            inputBox.Text = country
            task.wait(0.05)
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            task.wait(0.01)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        else
            -- Realistic typing mode
            inputBox.Text = ""
            local initialDelay = math.random(0.8, 2.5)
            task.wait(initialDelay)
            
            for i = 1, #country do
                if not isInGame() then break end
                inputBox.Text = string.sub(country, 1, i)
                
                local charDelay = math.random(50, 180)/1000
                if math.random(1, 20) == 1 then
                    task.wait(charDelay)
                    inputBox.Text = string.sub(country, 1, i-1) .. string.char(math.random(97, 122))
                    task.wait(math.random(50, 150)/1000)
                    inputBox.Text = string.sub(country, 1, i)
                end
                
                task.wait(charDelay)
            end
            
            local submitDelay = math.random(0.3, 1.2)
            task.wait(submitDelay)
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            task.wait(0.01)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        end
    end
    
    isTyping = false
end

-- Main loop
while true do
    if isInGame() then
        local connection
        connection = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.REFERENCED__GameUIFrame.TopFlag.FlagImage:GetPropertyChangedSignal("Image"):Connect(autoAnswer)
        autoAnswer()
        repeat task.wait() until not isInGame()
        connection:Disconnect()
    end
    task.wait(0.5)
end
