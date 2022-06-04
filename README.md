# Timer Module
This is a timer module which can be used with Luau to make countdowns.

# Installation
## Instructions for Rojo
- You can copy the module in shared folder and put to your project.

## Instructions for Wally
- Add this to your [dependencies],

```
TimerModule = "aerodymier/timermodule^@0.1.0"
```

and then run ``wally install`` in your current directory.

## Instructions for Roblox Studio
- You can get this model (https://www.roblox.com/library/9820188808/TimerModule) and drag that to your game.

# Usage
This module has two modes, one mode lets you set a goal with an unix timestamp and other one lets you set a goal with human readable format.

## Using with Unix timestamp
You can create a new Timer with the only parameter being ``DateTime.fromUnixTimestamp(unixTimestamp)``

```lua
local newTimer = Timer.new(DateTime.fromUnixTimestamp(1672531201))
```

## Using with human readable string
You can also create a new Timer with human readable format. That means you just type the date in an order.

```lua
local newTimer = Timer.new("2023 11 1 12 0 1") -- YYYY MM DD HH MM SS
```

## Handling the timer value
This part depends on how you want to implement it however I generally use it with a loop. ``calculateTime()`` gets a ``DateTime`` type of parameter and that's where the module will count from.

```lua
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
```

Human readable format works similar, I used universal time here but you can get client's timezone and calculate the time with that if you want.

```lua
while true do
	task.wait(1)

	local dt = DateTime.now()
	local formattedText: string | boolean = newTimer:calculateTime(dt:FormatUniversalTime("YYYY MM DD HH mm ss", "en-us"))
	if typeof(formattedText) == "boolean" then
		print("Ended!")
		break
	else
		print(formattedText)
	end
end
```

Module returns a bool type when countdown ends and starts to count in reverse when goal is before the current date.

# Examples
There are examples for both methods in src/Examples folder.

# Issues
If you face any issues while using this model consider opening an issue or making a PR.