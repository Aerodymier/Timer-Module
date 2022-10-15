local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Timer = require(ReplicatedStorage.Packages.TimerModule)

local newTimer = Timer.new(DateTime.fromUnixTimestamp(1672531201))

while true do
	task.wait(1)

	local dt = DateTime.now()
	local formattedText: string | boolean = newTimer:calculateTime(dt)
	if typeof(formattedText) == "boolean" then
		print("Ended!")
		break
	else
		print(formattedText)
	end
end