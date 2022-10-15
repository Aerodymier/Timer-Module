local Timer = {}
Timer.__index = Timer

local operationsMetatable = {} -- This will hook to goal and also current time tables

local function formatDateTimeElements(index: number, currentTime: table)
    if index == 2 then
        return 12
    elseif index == 3 then
        if currentTime.Month == 2 then
            if currentTime.Year % 4 == 0 then
                return 29
            else
                return 28
            end
        elseif currentTime.Month == 1 or currentTime.Month == 3 or currentTime.Month == 5 or currentTime.Month == 7 or currentTime.Month == 8 or currentTime.Month == 10 or currentTime.Month == 12 then
            return 31
        else
            return 30
        end
    elseif index == 4 then
        return 24
    elseif index == 5 or index == 6 then
        return 60
    end
end

function operationsMetatable.__eq(t, v)
	for index, _keys in pairs(t) do
		if t[index] ~= v[index] then
			return false
		end
	end
	return true
end

function operationsMetatable.__lt(t, v)
	-- configured for >
	for index, _keys in pairs(t) do
		if t[index] < v[index] then
			return true
		end
	end
	return false
end

function operationsMetatable.__sub(t, v)
	local returns = {}
    local currentTime = DateTime.now():ToUniversalTime()
	if t > v then
		for index, _values in pairs(t) do
			local tempResult = t[index] - v[index]
			if tempResult ~= 0 then
				if math.sign(tempResult) == -1 then
					tempResult += formatDateTimeElements(index, currentTime)
				end
				returns[index] = tempResult
			end
		end
	else
		for index, _values in pairs(v) do
			local tempResult = v[index] - t[index]
			if tempResult ~= 0 then
                if math.sign(tempResult) == -1 then
					tempResult += formatDateTimeElements(index, currentTime)
				end
				returns[index] = tempResult
			end
		end
	end
	
	return returns
end

local function subTimes(timeTable1: DateTime, timeTable2: DateTime)
	local returns = {0, 0, 0, 0, 0, 0}

	local unixTime1 = timeTable1.UnixTimestamp
	local unixTime2 = timeTable2.UnixTimestamp

	local diff = math.abs(unixTime2 - unixTime1)
	local A_YEAR = 31536000

	if diff > A_YEAR then
		repeat
			returns[1] += 1
			diff -= A_YEAR
		until
			A_YEAR > diff
	end

	local newUnixTime = DateTime.fromUnixTimestamp(diff):ToUniversalTime()
	returns[2] = newUnixTime.Month
	returns[3] = newUnixTime.Day
	returns[4] = newUnixTime.Hour
	returns[5] = newUnixTime.Minute
	returns[6] = newUnixTime.Second
	return returns
end

local function isOne(v)
	return v == 1
end

local function createText(result)
	local returnText = ""
	if result[1] then
		if result[1] ~= 0 then
			if isOne(result[1]) then
				returnText = returnText .. tostring(result[1]) .. " year, "
			else
				returnText = returnText .. tostring(result[1]) .. " years, "
			end
		end
	end
	if result[2] then
		if result[2] ~= 0 then
			if isOne(result[2]) and result[2] ~= 0 then
				returnText = returnText .. tostring(result[2]) .. " month, "
			else
				returnText = returnText .. tostring(result[2]) .. " months, "
			end
		end
	end
	if result[3] then
		if result[3] ~= 0 then
			if isOne(result[3]) and result[3] ~= 0 then
				returnText = returnText .. tostring(result[3]) .. " day, "
			else
				returnText = returnText .. tostring(result[3]) .. " days, "
			end
		end
	end
	if result[4] then
		if result[4] ~= 0 then
			if isOne(result[4]) and result[4] ~= 0 then
				returnText = returnText .. tostring(result[4]) .. " hour, "
			else
				returnText = returnText .. tostring(result[4]) .. " hours, "
			end
		end
	end
	if result[5] then
		if result[5] ~= 0 then
			if isOne(result[5]) and result[5] ~= 0 then
				returnText = returnText .. tostring(result[5]) .. " minute, "
			else
				returnText = returnText .. tostring(result[5]) .. " minutes, "
			end
		end
	end
	if result[6] then
		if result[6] ~= 0 then
			if isOne(result[6]) and result[6] ~= 0 then
				returnText = returnText .. tostring(result[6]) .. " second"
			else
				returnText = returnText .. tostring(result[6]) .. " seconds"
			end
		end
	end
	return returnText
end

function Timer:calculateTime(dt)
	if self.UseUnixTime then
		local result = subTimes(self.Goal, dt)
		
		if result == 0 then
			return false
		else
			return createText(result)
		end
	else
		local seperatedStringsTable = string.split(dt, " ") -- This will include everything separately, including year, month, day of the month
		setmetatable(seperatedStringsTable, operationsMetatable)
		--[[
			[1] = Year XXXX
			[2] = Month XX
			[3] = Day of the month XX
			[4] = Hour XX
			[5] = Minute XX
			[6] = Second XX
		--]]
		if seperatedStringsTable == self.Goal then
			return false -- finished
		else
			local result = self.Goal - seperatedStringsTable
			return createText(result)
		end
	end
end

Timer.new = function(goal: string | DateTime)
    local timer = setmetatable({}, Timer)
	local useUnixTime = if typeof(goal) == "DateTime" then true else false

    if goal then
        if typeof(goal) == "string" then
            if #string.split(goal, " ") > 1 then
                timer.Goal = setmetatable(string.split(goal, " "), operationsMetatable)
            else
               error("Goal was formatted wrong, check the documentation.") 
               return nil
            end
        else
			if useUnixTime then
				timer.Goal = goal
			else
				error("Unknown type for goal, provided type: " .. typeof(goal))
            	return nil
			end
        end
    else
       error("You need to specify a goal with new timers.")
       return nil
    end

	if useUnixTime then
		timer.UseUnixTime = useUnixTime
	end

    return timer
end

return Timer