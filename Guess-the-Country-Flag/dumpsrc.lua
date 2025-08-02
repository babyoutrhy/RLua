-- Main script for Guess the Country Flag auto-answer
local rawCountryMap = loadstring(game:HttpGet("https://raw.githubusercontent.com/babyoutrhy/RLua/refs/heads/main/Guess-the-Country-Flag/Country-Flags-List.lua", true))()

-- Create normalized country map
local countryMap = {}
for key, value in pairs(rawCountryMap) do
    local id = key:match("rbxassetid://(%d+)") or key:match("^(%d+)$")
    if id then
        countryMap["rbxassetid://"..id] = value
        countryMap[id] = value
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
local currentFlagId = nil

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
    local country = countryMap[imageId] or countryMap["rbxassetid://"..imageId]
    
    if country and inputBox:IsDescendantOf(game) then
        -- Store current flag ID for interruption handling
        currentFlagId = imageId
        inputBox:CaptureFocus()
        
        if instantSubmit then
            -- Instant submission mode
            inputBox.Text = country
            wait(0.05)
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            wait(0.01)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        else
            -- Realistic typing mode with interruption handling
            local function typeCountry()
                inputBox.Text = ""
                local initialDelay = math.random(0.8, 2.5)
                local startTime = tick()
                
                while tick() - startTime < initialDelay do
                    wait(0.1)
                    -- Check if flag changed or user interfered
                    if flagImage.Image ~= currentImage then
                        isTyping = false
                        return
                    end
                end
                
                for i = 1, #country do
                    if not isInGame() or flagImage.Image ~= currentImage then
                        break
                    end
                    
                    inputBox.Text = string.sub(country, 1, i)
                    
                    local charDelay = math.random(50, 180)/1000
                    local charStart = tick()
                    
                    while tick() - charStart < charDelay do
                        wait(0.05)
                        -- Check if user cleared the textbox
                        if #inputBox.Text < i then
                            -- Restart typing for current flag
                            if flagImage.Image == currentImage then
                                typeCountry()
                            end
                            return
                        end
                    end
                    
                    -- Simulate occasional typing mistakes
                    if math.random(1, 20) == 1 then
                        inputBox.Text = string.sub(country, 1, i-1) .. string.char(math.random(97, 122))
                        wait(math.random(50, 150)/1000)
                        inputBox.Text = string.sub(country, 1, i)
                    end
                end
                
                -- Final submission check
                if isInGame() and flagImage.Image == currentImage and inputBox.Text == country then
                    local submitDelay = math.random(0.3, 1.2)
                    wait(submitDelay)
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    wait(0.01)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                end
            end
            
            typeCountry()
        end
    end
    
    isTyping = false
end

-- Restart handler for interrupted typing
local function checkForRestart()
    while true do
        wait(0.5)
        if isInGame() and currentFlagId and not isTyping then
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
            local imageId = currentImage:match("rbxassetid://(%d+)") or currentImage
            
            -- Check if same flag is still displayed but not answered
            if imageId == currentFlagId and inputBox.Text ~= countryMap[imageId] then
                autoAnswer()
            end
        end
    end
end

-- Start the restart handler
spawn(checkForRestart)

-- Main loop
while true do
    if isInGame() then
        local connection
        connection = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.REFERENCED__GameUIFrame.TopFlag.FlagImage:GetPropertyChangedSignal("Image"):Connect(function()
            currentFlagId = nil
            autoAnswer()
        end)
        autoAnswer()
        repeat wait() until not isInGame()
        connection:Disconnect()
        currentFlagId = nil
    end
    wait(0.5)
end
