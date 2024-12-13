local function rhynotif(Title, Text, Icon, Duration) -- You can change the function's name to anything you want.
game.StarterGui:SetCore("SendNotification", {
Title = Title;
Text = Text;
Icon = Icon;
Duration = Duration;
})
end

--[[ Example:
rhynotif("Your title", "Your text", "rbxassetid://11207341665" , "5")
]]--
