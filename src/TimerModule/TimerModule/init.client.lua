local endDate = string.split("2021 07 14 20 00 00", " ")
local mt = {}

function mt.__eq(t, v)
    -- selene: allow(unused_variable)
	for index, keys in pairs(t) do
        -- selene: allow(empty_if)
		if t[index] == v[index] then
			-- nothing
		else
			return false
		end
	end
	return true
end

function mt.__lt(t, v)
	-- configured for >
    -- selene: allow(unused_variable)
	for index, keys in pairs(t) do
        -- selene: allow(empty_if)
		if t[index] > v[index] then
			-- nothing
		else
			return true
		end
	end
	return false
end

function mt.__sub(t, v)
	local returns = {}
	if t > v then
        -- selene: allow(unused_variable)
		for index, values in pairs(t) do
			local tempResult = t[index] - v[index]
			if tempResult ~= 0 then
				if math.sign(tempResult) == -1 then
					tempResult = tempResult + 59
				end
				returns[index] = tempResult
			end
		end
		return returns
	else
        -- selene: allow(unused_variable)
		for index, values in pairs(v) do
			local tempResult = v[index] - t[index]
			if tempResult ~= 0 then
				returns[index] = tempResult
			end
		end
		return returns
	end
end

setmetatable(endDate, mt)

function isOne(v)
	return v == 1
end

function calculateLocalTime(dt)
	local strings = string.split(dt, " ")
	setmetatable(strings, mt)
	--[[
		[1] = Year XXXX
		[2] = Month XX
		[3] = Day of the month XX
		[4] = Hour XX
		[5] = Minute XX
		[6] = Second XX
	--]]
	if strings == endDate then
		return false -- finished
	else
		local result = endDate - strings
		local returnText = ""
		if result[1] then
			if isOne(result[1]) then -- this might be grammatically wrong, it's also a very bad method ik
				returnText = returnText .. tostring(result[1]) .. " Year, "
			else
				returnText = returnText .. tostring(result[1]) .. " Years, "
			end
		end
		if result[2] then
			if isOne(result[2]) then
				returnText = returnText .. tostring(result[2]) .. " Month, "
			else
				returnText = returnText .. tostring(result[2]) .. " Months, "
			end
		end
		if result[3] then
			if isOne(result[3]) then
				returnText = returnText .. tostring(result[3]) .. " Day, "
			else
				returnText = returnText .. tostring(result[3]) .. " Days, "
			end
		end
		if result[4] then
			if isOne(result[4]) then
				returnText = returnText .. tostring(result[4]) .. " Hour, "
			else
				returnText = returnText .. tostring(result[4]) .. " Hours, "
			end
		end
		if result[5] then
			if isOne(result[5]) then
				returnText = returnText .. tostring(result[5]) .. " Minute, "
			else
				returnText = returnText .. tostring(result[5]) .. " Minutes, "
			end
		end
		if result[6] then
			if isOne(result[6]) then
				returnText = returnText .. tostring(result[6]) .. " Second"
			else
				returnText = returnText .. tostring(result[6]) .. " Seconds"
			end
		end
		return returnText
	end
end

while wait(1) do
	local dt = DateTime.now()
	local formattedText: string | boolean = calculateLocalTime(dt:FormatLocalTime("YYYY MM DD HH mm ss", "en-us"))
	if typeof(formattedText) == "boolean" then
		script.Parent.Text = "Ended!"
		break
	else
		script.Parent.Text = formattedText
	end
end