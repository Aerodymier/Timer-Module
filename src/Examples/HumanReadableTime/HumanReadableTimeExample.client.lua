local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Timer = require(ReplicatedStorage.TimerModule.TimerModule)

local newTimer = Timer.new("2023 11 1 12 0 1", false) -- YYYY MM DD HH MM SS, example: 2021 12 12 20 00 00

while true do
	task.wait(1)
	local dt = DateTime.now()
	local formattedText: string | boolean = newTimer:calculateUniversalTime(dt:FormatUniversalTime("YYYY MM DD HH mm ss", "en-us"))
	if typeof(formattedText) == "boolean" then
		print("Ended!")
		break
	else
		print(formattedText)
	end
end