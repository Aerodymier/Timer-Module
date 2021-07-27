local Timer = require(script.Parent.TimerModule.TimerModule)

local newTimer = Timer.new("2021 12 12 20 00 00") -- YYYY MM DD HH MM SS, example: 2021 12 12 20 00 00

local gui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui"):WaitForChild("TextLabel")

while wait(1) do
	local dt = DateTime.now()
	local formattedText: string | boolean = newTimer:calculateUniversalTime(dt:FormatUniversalTime("YYYY MM DD HH mm ss", "en-us"))
	if typeof(formattedText) == "boolean" then
		gui.Text = "Ended!"
		break
	else
		gui.Text = formattedText
	end
end