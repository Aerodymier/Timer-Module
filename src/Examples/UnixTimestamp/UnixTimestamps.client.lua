local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Timer = require(ReplicatedStorage.TimerModule.TimerModule)

local newTimer = Timer.new(DateTime.fromUnixTimestamp(1672531201), true) -- YYYY MM DD HH MM SS, example: 2021 12 12 20 00 00

while true do
	task.wait(1)

	local dt = DateTime.now()
	local formattedText: string | boolean = newTimer:calculateUniversalTime(dt)
	if typeof(formattedText) == "boolean" then
		print("Ended!")
		break
	else
		print(formattedText)
	end
end