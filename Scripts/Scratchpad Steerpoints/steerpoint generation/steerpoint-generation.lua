
-- this table will hold all the functionality required for reading a bunch of text and generating steerpoints from it.
local steerpointGeneration = {}

function steerpointGeneration.SplitString(inputStr, sep)
    -- https://stackoverflow.com/questions/1426954/split-string-in-lua
    -- basically it's matching anything that isn't our separator. https://www.lua.org/pil/20.2.html

    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputStr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function steerpointGeneration.RemoveLeadingWhiteSpace(inputStr)
    for i = 1, #inputStr do
        -- run through each char and if it matches a non-whitespace char, return the string from that point on.
        local c = inputStr:sub(i, i)
        if c:match("%S") then
            return inputStr:sub(i, #inputStr)
        end
    end

    -- else there was no leading whitespace, so return the string as it came
    return inputStr
end

function steerpointGeneration.RemoveTrailingWhiteSpace(inputStr)
    for i = #inputStr, 1, -1 do
        -- run through each char and if it matches a non-whitespace char, return the string from that point on.
        local c = inputStr:sub(i, i)
        if c:match("%S") then
            return inputStr:sub(1, i)
        end
    end

    -- else there was no trailing whitespace, so return the string as it came
    return inputStr
end

function steerpointGeneration.TrimWhitespace(inputStr)
    inputStr = steerpointGeneration.RemoveLeadingWhiteSpace(inputStr)
    inputStr = steerpointGeneration.RemoveTrailingWhiteSpace(inputStr)
    return inputStr
end

-- returns true if the inputStr marks the start of a steerpoint
function steerpointGeneration.IsSteerpointNum(inputStr)
    return inputStr:match("Steerpoint %d+")
end

-- returns true if the inputStr is a lat long degree decimal line
function steerpointGeneration.IsDdm(inputStr)
    --succeeds if we find something in the form of: N 44°34.423', E 38°00.337'
    return inputStr:match("[NS]%s%d+°%d+%.%d+',%s[EW]%s%d+°%d+%.%d+'")
end

-- returns true if the inputStr is a lat long degree minute second line
function steerpointGeneration.IsDms(inputStr)
    --succeeds if we find something in the form of: N 42°14'38.86", E 42°02'21.76"
    return inputStr:match([[[NS]%s%d+°%d+'%d+%.%d+",%s[EW]%s%d+°%d+'%d+%.%d+"]])
end

-- returns true if the inputStr is an MGRS line
function steerpointGeneration.IsMgrs(inputStr)
    --succeeds if we find something in the form of: 38T KM 93136 72724
    return inputStr:match("%d+%s%u%s%u%u%s%d+%s%d+")  -- gross
end

-- returns true if the inputStr is an elevation line
function steerpointGeneration.IsElevation(inputStr)
    --succeeds if we find someting in the form of: 22m, 73ft
    return inputStr:match("%d+m,%s%d+ft")
end

-- returns true if at least one steerpoint contains information using the key. use "dms" or "ddm" or "mgrs" to probe if
-- at least one steerpoint has the information you're looking for before pushing buttons
function steerpointGeneration.SteerpointsContainKey(steerpoints, key)
    for _, steerpoint in ipairs(steerpoints) do
        if steerpoint[key] then
            return true
        end
    end

    return false
end

---@param contentStr string content string from Scratchpad
---@return steerpoints table returns a table of steerpoints containing lat, long, elev, and optional num. all values are human readable strings with symbols preserved.
function steerpointGeneration.MakeSteerpoints(contentStr)
    --[[
        Steerpoints will be formatted like this for DDM:
            Steerpoint 10
            N 42°11.059', E 42°28.604'
            45m, 148ft

            Steerpoint 
            N 42°51.531', E 41°07.176'
            13m, 43ft

        or like this for DMS
            Steerpoint 19
            N 42°19'12.43", E 42°08'25.56"
            38 T KM 64358 89280
            159m, 521ft
        
        or like this for MGRS
            Steerpoint 
            38 T KM 64358 89280
            159m, 521ft
    ]]
    -- so i always start them with the word "Steerpoint" for easier identification. then the lines that follow should be
    -- coord information, either LL DDM and/or LL DMS and/or MGRS, and then it always ends with elevation information.
    -- also they can have an optional number next to steerpoint, and an optional label line, which is only allowed to
    -- contain alphanumeric chars.

    -- TODO i feel like this function could be better, but it's good enough for now

    local steerpoints = {}
    local steerpoint = {}

    local lines = steerpointGeneration.SplitString(contentStr, "\n")
    for _, line in ipairs(lines) do
		
        -- test to see what the line is. (i'm doing it this way since the regex will automatically strip out leading and
        -- trailing whitespace, incase the user accidentally has any.)
        local stptInfo = line:match("Steerpoint")
        local ddmInfo = steerpointGeneration.IsDdm(line)
        local dmsInfo = steerpointGeneration.IsDms(line)
        local mgrsInfo = steerpointGeneration.IsMgrs(line)
        local elevInfo = steerpointGeneration.IsElevation(line)

		-- ignore blank lines or first char being '#' (for comments)
		if #line == 0 or line:sub(1, 1) == '#' then
			-- do nothing. lua doesn't have a continue?!
		
		-- check if it's the start of a new steerpoint (signaled by the word: Steerpoint)
		elseif stptInfo then
            -- clear table
            steerpoint = {}

            -- and add optional steerpoint number if it was provided
            local num = line:match("%d+")
            if num then
                -- no need to trim whitespace. this'll just match the number
                steerpoint.num = num
            end
    
		elseif ddmInfo then
            steerpoint.ddm = ddmInfo
		
		elseif dmsInfo then
			steerpoint.dms = dmsInfo
        
        elseif mgrsInfo then
            steerpoint.mgrs = mgrsInfo

		elseif elevInfo then
			steerpoint.elev = elevInfo
			
            -- elevation info marks the end of a steerpoint, but only if we've also found coordinate information!
            if steerpoint.ddm or steerpoint.dms or steerpoint.mgrs then
                -- insert it into the steerpoints list
                table.insert(steerpoints, steerpoint)
			    -- clear steerpoint so that we don't keep referencing the same table
                steerpoint = {}
            end
		
        else
            -- else we'll assume it's a label to the steerpoint, which some aircraft can use
            steerpoint.label = steerpointGeneration.TrimWhitespace(line)
        end

    end

    return steerpoints
end

-- since i stored steerpoint information as human readable strings, i need functions to strip out symbols before it's
-- ready for input.

---comment
---@param steerpoint steerpoint table
---@param typeStr string "ddm" or "dms"
---@param includeLeadingLongZero bool whether to include leading zero on raw longitude degrees (ex. 042 instead of just 42)
---@return table table of {rawLat, rawLong, rawElev}
function steerpointGeneration.GetRawLatLong(steerpoint, typeStr, includeLeadingLongZero)
    -- separate line
    local latStr, longStr
    if typeStr == "ddm" then
        latStr, longStr = unpack(steerpointGeneration.SplitString(steerpoint.ddm, ","))
    else
        latStr, longStr = unpack(steerpointGeneration.SplitString(steerpoint.dms, ","))
    end

    --strip whitespace
    latStr = latStr:gsub("%s+", "")
    longStr = longStr:gsub("%s+", "")

    -- grab cardinals
	local latCardinal = latStr:sub(1, 1)
	local longCardinal = longStr:sub(1, 1)

    -- split using anything that isn't a number. this leaves us with a table of just numbers
    local rawLat = steerpointGeneration.SplitString(latStr, "%D")
    local rawLong = steerpointGeneration.SplitString(longStr, "%D")

    if includeLeadingLongZero then
        rawLong[1] = string.format("%03d", rawLong[1])
    end

    -- insert cardinal in the beginning of the table
    table.insert(rawLat, 1, latCardinal)
    table.insert(rawLong, 1, longCardinal)

    -- do elevation. split by anything not a number to leave a table of numbers
    local rawElev = steerpointGeneration.SplitString(steerpoint.elev, "%D")

    return {rawLat, rawLong, rawElev}
end

---comment
---@param steerpoint steerpoint table
---@return table table of {rawMgrs, rawElev}
function steerpointGeneration.GetRawMgrs(steerpoint)
    local rawMgrs = steerpointGeneration.SplitString(steerpoint.mgrs, " ")
    local rawElev = steerpointGeneration.SplitString(steerpoint.elev, "%D")

    return {rawMgrs, rawElev}
end

function steerpointGeneration.Round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- same thing as the normal round except i converts a string to a num and back
function steerpointGeneration.RoundStrNum(numStr, numDecimalPlaces)
    local n = tonumber(numStr)
    n = steerpointGeneration.Round(n, numDecimalPlaces)
    n = tostring(n)
    return n
end

return steerpointGeneration