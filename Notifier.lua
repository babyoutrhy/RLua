local function rhynotif(Title, Text, Icon, Duration)
game.StarterGui:SetCore("SendNotification", {
Title = Title;
Text = Text;
Icon = Icon;
Duration = Duration;
})
end
