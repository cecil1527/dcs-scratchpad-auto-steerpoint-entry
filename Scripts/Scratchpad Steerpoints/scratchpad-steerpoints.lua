--[[
    naming convention:
    1. globals are SHOUTY_CASE.
    2. functions are PascalCase.
    3. variables and tables are camelCase.
]]

-- append path so it knows where socket is
package.path = package.path .. ";.\\LuaSocket\\?.lua;"
package.cpath = package.cpath .. ";.\\LuaSocket\\?.dll;"

-- global table i'm going to store all of my functionality in
SCRATCHPAD_STEERPOINTS = {
    logFile = nil,
    logLevels = {
        debug = {1, "DEBUG"},
        info =  {2, "INFO"},
        warn =  {3, "WARN"},
        error = {4, "ERROR"},
    },
    logLevel = 2,

    -- coroutine to be able to yield/resume when waiting between key presses and releases
    coroutineFunc = nil,
    
    -- for sending data to the export environment, until i figure out another way to do it (because afaik the only way
    -- to read cockpit devices is using the list_indication() function in the export environment :/)
    socket = nil,

    generation = dofile(lfs.writedir()..[[Scripts\Scratchpad Steerpoints\steerpoint generation\steerpoint-generation.lua]])
}

---writes to log file
---@param level table choose from SCRATCHPAD_STEERPOINTS.logLevels
---@param str string log message
function SCRATCHPAD_STEERPOINTS.Log(level, str)
    local levelNum = level[1]
    local levelStr = level[2]

    if SCRATCHPAD_STEERPOINTS.logLevel > levelNum then
        return
    end

    -- https://strftime.org/ except if you try to display microseconds it crashes? so i'm still giong to use os.clock()
    -- to have milliseconds, and i'm not going to combine them, because i don't think they're in phase? :/
    SCRATCHPAD_STEERPOINTS.logFile:write(string.format("%-12s %-12s %-10s %s\n", tostring(os.clock()), tostring(os.date("%X")), levelStr, str))
    SCRATCHPAD_STEERPOINTS.logFile:flush()
    -- TODO should i be flushing on every write?
    
    -- TODO os.clock() is nice because it does milliseconds. see if there's a way to get os.date() to do the same thing,
    -- so i don't have to keep both.
end

function SCRATCHPAD_STEERPOINTS.StartUp()
    -- ensure folder exists
    local folder = lfs.writedir()..[[\Scripts\Scratchpad Steerpoints\logs\]]
    lfs.mkdir(folder)

    -- TODO use pcalls or something here in case io.open() goes wrong
    SCRATCHPAD_STEERPOINTS.logFile = io.open(folder..[[scratchpad-steerpoints.log]], "w")
    SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "Log file opened")

    -- TODO same here in case require goes wrong
    SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "Setting up socket")
    local socket = require("socket")
    SCRATCHPAD_STEERPOINTS.socket = socket.udp()

    local ip = "127.0.0.1"
    local guiPort = 14321
    local exportPort = 14322

    local result, err = SCRATCHPAD_STEERPOINTS.socket:setsockname(ip, guiPort)
    if not result then
        SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.error, err)
    end

    result, err = SCRATCHPAD_STEERPOINTS.socket:setpeername(ip, exportPort)
    if not result then
        SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, err)
    end

    SCRATCHPAD_STEERPOINTS.socket:settimeout(0)
    -- TODO they do tcp with "tcp-nodelay" in their example Export.lua, instead of udp. idk why? isn't udp what you'd
    -- want for this?

    -- load all airframe files to fill out the global table
    SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "Loading airframe files")

    SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "Loading Ah-64")
    dofile(lfs.writedir()..[[Scripts\Scratchpad Steerpoints\airframes\ah64.lua]])
    
    SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "Loading F-16")
    dofile(lfs.writedir()..[[Scripts\Scratchpad Steerpoints\airframes\f16.lua]])
    
    SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "Loading F-18")
    dofile(lfs.writedir()..[[Scripts\Scratchpad Steerpoints\airframes\f18.lua]])

    SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "Startup complete")
end

function SCRATCHPAD_STEERPOINTS.ShutDown()
    SCRATCHPAD_STEERPOINTS.coroutineFunc = nil

    if SCRATCHPAD_STEERPOINTS.socket then
        SCRATCHPAD_STEERPOINTS.socket:close()
        SCRATCHPAD_STEERPOINTS.socket = nil
    end

    if SCRATCHPAD_STEERPOINTS.logFile then
        SCRATCHPAD_STEERPOINTS.logFile:flush()
        SCRATCHPAD_STEERPOINTS.logFile:close()
        SCRATCHPAD_STEERPOINTS.logFile = nil
    end
end

function SCRATCHPAD_STEERPOINTS.Abort()
    SCRATCHPAD_STEERPOINTS.coroutineFunc = nil
end

---calls performClickableAction() on the command supplied, then yields until duration has passed. if you wish to simply
--wait, and yield until duration has passed, supply nil for command (or don't supply one at all since it'll default to
--nil)
---@param duration number time in seconds to wait after executing command (or not executing command if it's nil)
---@param command array array of {deviceId, buttonId, pressVal, releaseVal}. pass in nil to wait without doing any commands.
---@param press boolean is this a press or release? uses command's pressVal for press and releaseVal for release
function SCRATCHPAD_STEERPOINTS.ExecuteCommand(duration, command, press)
    -- TODO do debug logging here?

    if command then
        -- commands are just arrays of:
        local deviceId =    command[1]
        local buttonId =    command[2]
        local pressVal =    command[3]
        local releaseVal =  command[4]

        -- the basic functionality is to do GetDevice(deviceId):performClickableAction(buttonId, value). depending on
        -- the device and button ID and the value supplied, you'll press/release/turn things in the cockpit.
        
        local val = nil
        if press then
            val = pressVal
        else
            val = releaseVal
        end
        -- execute command
        Export.GetDevice(deviceId):performClickableAction(buttonId, val)
    end
    
    -- now we yield until duration has passed
    local startTime = Export.LoGetModelTime()
    while true do
        -- test if we can exit function
        local totalTime = Export.LoGetModelTime() - startTime
        if totalTime >= duration then
            return
        end

        -- else yield. this'll let the game process another frame and we'll test again when our next frame callback
        -- resumes the coroutine.
        coroutine.yield()
    end
end

-- executes a press and release. duration is used for the press command and then used again for the release command
function SCRATCHPAD_STEERPOINTS.ExecutePressRel(command, duration)
    SCRATCHPAD_STEERPOINTS.ExecuteCommand(duration, command, true)
    SCRATCHPAD_STEERPOINTS.ExecuteCommand(duration, command, false)
end

---executes a sequence of button presses that correspond to the character sequence
---@param charSeq string character sequence (like N4415298)
---@param charToKey table table that takes in a character key and outputs a command key
---@param commands table table that takes in a command key and outputs a command array
---@param duration number how long in seconds each press and each release should be held for
---@param pressEnter boolean should we press enter at the end? (requires the charToKey table to have a key for enter at [0])
function SCRATCHPAD_STEERPOINTS.ExecuteCharSeq(charSeq, charToKey, commands, duration, pressEnter)

    -- for each char in the sequence, execute a press and release
    for i = 1, #charSeq do
        local char = charSeq:sub(i, i)
        local commandKey = charToKey[char]
        SCRATCHPAD_STEERPOINTS.ExecutePressRel(commands[commandKey], duration)
    end

    if pressEnter then
        local commandKey = charToKey[0]
        SCRATCHPAD_STEERPOINTS.ExecutePressRel(commands[commandKey], duration)
    end
end

-- helper function to resume the coroutine since i'm always going to want to check if it exists before hand and log any
-- errors that occur. takes in variable number of args to pass onto coroutine.resume()
function SCRATCHPAD_STEERPOINTS.ResumeCoroutine(...)
    -- early return if we don't have a coroutine
    if not SCRATCHPAD_STEERPOINTS.coroutineFunc then
        SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.debug, "Coroutine is nil")
        return
    end
    -- or if the coroutine is not suspended
    local coroutineStatus = coroutine.status(SCRATCHPAD_STEERPOINTS.coroutineFunc)
    if coroutineStatus ~= "suspended" then
        SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.debug, 
            "Coroutine not suspended, it is: "..coroutine.status(SCRATCHPAD_STEERPOINTS.coroutineFunc)
        )

        if coroutineStatus == "dead" then
            -- set it to nil, so that we don't keep checking its status when we attempt to resume in the future
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.debug, "Setting Coroutine to nil")
            SCRATCHPAD_STEERPOINTS.coroutineFunc = nil
        end

        return
    end

    -- else we're good to resume it
    SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.debug, "Resuming coroutine")
    local success, errorMsg = coroutine.resume(SCRATCHPAD_STEERPOINTS.coroutineFunc, ...)
    if not success then
        SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.error, "Coroutine Resume Error: "..errorMsg)
    end
end

---function that DCS Scratchpad calls on button press to input steerpoints into our airframe
---@param contentStr string the contents of the current Scratchpad page
function SCRATCHPAD_STEERPOINTS.EnterSteerpoints(contentStr)

    -- cancel anything that might be currently running
    SCRATCHPAD_STEERPOINTS.Abort()

    -- call different functions depending on what plane we're in
    local planeTypeStr = DCS.getPlayerUnitType()
    SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "planeTypeStr is: "..planeTypeStr)

    if planeTypeStr == "F-16C_50" then
        -- create a coroutine and store it in our table, so we can resume on each frame later
        SCRATCHPAD_STEERPOINTS.coroutineFunc = coroutine.create(SCRATCHPAD_STEERPOINTS.f16.EnterSteerpoints)
        -- in lua, coroutines start paused. you start them by calling resume for the first time. to pass an argument to
        -- the coroutined function, you pass the arguments to the first call of resume.
        SCRATCHPAD_STEERPOINTS.ResumeCoroutine(contentStr)

    elseif planeTypeStr == "FA-18C_hornet" then
        SCRATCHPAD_STEERPOINTS.coroutineFunc = coroutine.create(SCRATCHPAD_STEERPOINTS.f18.EnterSteerpoints)
        SCRATCHPAD_STEERPOINTS.ResumeCoroutine(contentStr)
    
    elseif planeTypeStr == "AH-64D_BLK_II" then
        SCRATCHPAD_STEERPOINTS.coroutineFunc = coroutine.create(SCRATCHPAD_STEERPOINTS.ah64.EnterSteerpoints)
        SCRATCHPAD_STEERPOINTS.ResumeCoroutine(contentStr)
    end
end

---displays a message in game in the top right corner for the duration
---@param str string string message
---@param duration number seconds
function SCRATCHPAD_STEERPOINTS.DisplayMessage(str, duration)
    -- their message function uses milliseconds
    -- gameMessages.addMessage(str, duration*1000)
    -- they changed this in 2.8. i don't think it's in the hook environment anymore :( idk how to send game messages anymore
end

-- alright, so here's the problem. DCS scratchpad has to run in the GUI environment, but AFAIK, you can't read MFDs from
-- that environment. so here's a table of functions and i'm going to send the index of a function over a socket to
-- another script in the Export environment to read MFDs, and it will send the answer back. :/ kind of janky, but idk
-- how else to do it at the moment.
SCRATCHPAD_STEERPOINTS.exportFunctions = {
    -- the duplicate name is just so i can log it, so i don't have to lookup function indices when reading the log.
    ["f18.IsPreciseBoxed"] =            {1, "f18.IsPreciseBoxed"},
    ["f18.IsLLModeSec"] =               {2, "f18.IsLLModeSec"},
    ["f18.GetCurrentWaypointNo"] =      {3, "f18.GetCurrentWaypointNo"},

    ["ah64.IsGunner"] =                 {11, "ah64.IsGunner"},
}

-- helper function to send function request to Export environment script, so i can easily log and yield while we wait on
-- it to get back to us.
function SCRATCHPAD_STEERPOINTS.RunExportFunction(exportFunction)
    -- functions are just an ID and it's name (only for easier log reading)
    local funcIdStr = tostring(exportFunction[1])
    local funcNameStr = exportFunction[2]
    
    SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, 
        string.format("Sending Export Function: %s (%s)", funcIdStr, funcNameStr)
    )

    -- send only the function's index to the Export script's socket
    SCRATCHPAD_STEERPOINTS.socket:send(funcIdStr)
    
    -- wait for result
    while true do
        local resultStr, timeoutStr = SCRATCHPAD_STEERPOINTS.socket:receive(1024)
        if not resultStr then
            coroutine.yield()
        else
            -- else we got a result
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "Export Function Returned: "..resultStr)
            return resultStr
        end
    end
    -- TODO do some sort of timeout where it'll return nil after some delay of not getting an answer and we can handle
    -- it per command?
end

-- setup callbacks ----------------------------------------------------------------------------------------------------

-- the new API is found in "...\Eagle Dynamics\DCS World\API\DCS_ControlAPI.html". you can set up callbacks like this
local callbackTable = {}
function callbackTable.onSimulationFrame()
    -- resume coroutine on each frame
    SCRATCHPAD_STEERPOINTS.ResumeCoroutine()
end
DCS.setUserCallbacks(callbackTable)

-- perform first time startup
SCRATCHPAD_STEERPOINTS.StartUp()
