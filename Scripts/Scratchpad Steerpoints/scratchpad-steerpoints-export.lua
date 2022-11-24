

-- this will exist in the export environment, solely for the purposes of reading cockpit devices (MFDs, etc.), because i
-- can't find that functionality in the GUI environment...

-- append path so it knows where socket is
package.path = package.path .. ";.\\LuaSocket\\?.lua;"
package.cpath = package.cpath .. ";.\\LuaSocket\\?.dll;"

-- the table i'm going to store all of my functionality in
local ScratchpadSteerpointsExport = {
    logFile = nil,
    logLevels = {
        debug = {1, "DEBUG"},
        info =  {2, "INFO"},
        warn =  {3, "WARN"},
        error = {4, "ERROR"},
    },
    logLevel = 2,

    -- socket for sending data back to the Gui environment, until i figure out another way to do it
    socket = nil,
}

function ScratchpadSteerpointsExport.Log(level, str)
    local levelNum = level[1]
    local levelStr = level[2]

    if ScratchpadSteerpointsExport.logLevel > levelNum then
        return
    end

    ScratchpadSteerpointsExport.logFile:write(string.format("%-12s %-12s %-10s %s \n", tostring(os.clock()), tostring(os.date("%X")), levelStr, str))
    ScratchpadSteerpointsExport.logFile:flush()
end

function ScratchpadSteerpointsExport.StartUp()
    -- TODO use pcalls or something here in case io.open() goes wrong
    ScratchpadSteerpointsExport.logFile = io.open(lfs.writedir()..[[\Scripts\Scratchpad Steerpoints\logs\scratchpad-steerpoints-export.log]], "w")
    ScratchpadSteerpointsExport.Log(ScratchpadSteerpointsExport.logLevels.info, "Log file opened")

    -- TODO same here in case require goes wrong
    ScratchpadSteerpointsExport.Log(ScratchpadSteerpointsExport.logLevels.info, "Setting up socket")
    local socket = require("socket")
    ScratchpadSteerpointsExport.socket = socket.udp()

    local ip = "127.0.0.1"
    local guiPort = 14321
    local exportPort = 14322

    local result, err = ScratchpadSteerpointsExport.socket:setsockname(ip, exportPort)
    if not result then
        ScratchpadSteerpointsExport.Log(ScratchpadSteerpointsExport.logLevels.error, err)
    end

    result, err = ScratchpadSteerpointsExport.socket:setpeername(ip, guiPort)
    if not result then
        ScratchpadSteerpointsExport.Log(ScratchpadSteerpointsExport.logLevels.info, err)
    end

    ScratchpadSteerpointsExport.socket:settimeout(0)
    -- TODO they do tcp with "tcp-nodelay" in their example Export.lua, instead of udp?

    ScratchpadSteerpointsExport.Log(ScratchpadSteerpointsExport.logLevels.info, "Startup complete")
end

function ScratchpadSteerpointsExport.ShutDown()

    if ScratchpadSteerpointsExport.socket then
        ScratchpadSteerpointsExport.Log(ScratchpadSteerpointsExport.logLevels.info, "Closing socket")
        ScratchpadSteerpointsExport.socket:close()
        ScratchpadSteerpointsExport.socket = nil
    end

    if ScratchpadSteerpointsExport.logFile then
        ScratchpadSteerpointsExport.Log(ScratchpadSteerpointsExport.logLevels.info, "Closing log file")
        ScratchpadSteerpointsExport.logFile:flush()
        ScratchpadSteerpointsExport.logFile:close()
        ScratchpadSteerpointsExport.logFile = nil
    end
end

-- helper function to send data over the socket, because i'm always going to want to log
function ScratchpadSteerpointsExport.SocketSend(str)
    ScratchpadSteerpointsExport.Log(ScratchpadSteerpointsExport.logLevels.info, "Socket Sending: "..str)
    ScratchpadSteerpointsExport.socket:send(str)
end

-- f-18 section -------------------------------------------------------------------------------------------------------

ScratchpadSteerpointsExport.f18 = {}

-- returns whether Precise is boxed on the F-18's HSI WYPT page. this function assumes we're already on that page.
function ScratchpadSteerpointsExport.f18.IsPreciseBoxed()
    -- you can read cockpit devices (like MFDs) using list_indication(id) *as long as you're in the Export
    -- environment!*. if you dump a bunch of list_indication() calls (ids ranging 0 through 100 for example), you'll see
    -- that the AMPCD is #4. when you're on the HSI WYPT page, then "WYPT _1_box__id:5" will be present because it'll be
    -- boxed on the AMPCD. and if precise is boxed, then "PRECISE_1_box__id:26" will be present.

    local str = list_indication(4)

    -- test if we're even on the HSI WYPT page
    local start, stop = str:find("WYPT _1_box__id:5")
    if not start then
        ScratchpadSteerpointsExport.Log(ScratchpadSteerpointsExport.logLevels.error,
            "f18.IsPreciseBoxed() is attempting to see if PRECISE is boxed, but AMPCD is not on the HSI WYPT page!"
        )
        ScratchpadSteerpointsExport.SocketSend("nil")
        return
    end

    -- test if precise is boxed
    start, stop = str:find("PRECISE_1_box__id:26")
    if start then
        ScratchpadSteerpointsExport.SocketSend("true")
        return
    else
        ScratchpadSteerpointsExport.SocketSend("false")
        return
    end
end

-- returns whether we're in lat long second mode. assumes that we're on the HSI A/C page.
function ScratchpadSteerpointsExport.f18.IsLLModeSec()
    -- same deal, except now we check for the presence of LATLN and SEC to make sure we're in lat/long seconds mode.

    local str = list_indication(4)
    -- test if we're even on the HSI A/C page. if we are, it wil be boxed and this line will be present.
    local start, stop = str:find("A/C  _1_box__id:6")
    if not start then
        ScratchpadSteerpointsExport.Log(ScratchpadSteerpointsExport.logLevels.error, 
            "f18.IsLLModeSec() is attempting to see if LL mode is SEC, but AMPCD is not on the HSI A/C page!"
        )
        ScratchpadSteerpointsExport.SocketSend("nil")
        return
    end

    -- test if we're in seconds mode
    local start, stop = str:find("_1__id:17\nS\nE\nC")
    if start then
        ScratchpadSteerpointsExport.SocketSend("true")
        return
    else
        ScratchpadSteerpointsExport.SocketSend("false")
        return
    end
end

-- returns the current waypoint number.
function ScratchpadSteerpointsExport.f18.GetCurrentWaypointNo()
    -- again, we use AMPCD's list_indication() id of 4.
    local str = list_indication(4)

    -- test if we're on a page that displays waypoint number
    local start, stop = str:find("WYPT_Page_Number\n%d+")
    if not start then
        ScratchpadSteerpointsExport.Log(ScratchpadSteerpointsExport.logLevels.error, 
            "f18.GetCurrentWaypointNo() is attempting to read the waypoint number, but AMPCD is not displaying the waypoint number!"
        )
        ScratchpadSteerpointsExport.SocketSend("nil")
        return
    end

    -- else we have valid waypoint information displaying on the AMPCD.
    start = start + 17  -- skip "WYPT_Page_Number\n"
    local waypointNum = str:sub(start, stop)
    ScratchpadSteerpointsExport.SocketSend(waypointNum)
end

-- ah-64 section ------------------------------------------------------------------------------------------------------

ScratchpadSteerpointsExport.ah64 = {}

-- returns whether you're gunner or not
function ScratchpadSteerpointsExport.ah64.IsGunner()
    -- you can just check if TADs is being drawn. idk if there's an easier way to determine if you're the gunner.
    
    -- TADS is device 19. if you're in the pilot seat, this string will be empty. if you're in the gunner seat, it'll be
    -- filled with a bunch of TADs labels
    local str = list_indication(19)

    if #str == 0 then
        ScratchpadSteerpointsExport.SocketSend("false")
    else
        ScratchpadSteerpointsExport.SocketSend("true")
    end
end

-- a table of functions to read cockpit devices. we'll get a number (an index to this array) over the socket to tell us
-- when and which function to call, then we'll send the answer back.
ScratchpadSteerpointsExport.functionTable = {
    -- hold the function and a string name for logging
    [1] = {ScratchpadSteerpointsExport.f18.IsPreciseBoxed,          "f18.IsPreciseBoxed"},
    [2] = {ScratchpadSteerpointsExport.f18.IsLLModeSec,             "f18.IsLLModeSec"},
    [3] = {ScratchpadSteerpointsExport.f18.GetCurrentWaypointNo,    "f18.GetCurrentWaypointNo"},
    
    [11] = {ScratchpadSteerpointsExport.ah64.IsGunner,              "ah64.IsGunner"},
}

-- runs on each frame
function ScratchpadSteerpointsExport.CheckAndExecuteCommands()
    local funcIdStr, timeoutStr = ScratchpadSteerpointsExport.socket:receive(1024)
    if not funcIdStr then
        return
    end

    -- else we got a message to run a function
    local funcArray = ScratchpadSteerpointsExport.functionTable[tonumber(funcIdStr)]
    local func = funcArray[1]
    local funcNameStr = funcArray[2]
    ScratchpadSteerpointsExport.Log(ScratchpadSteerpointsExport.logLevels.info, 
        string.format("Socket Received Function Index: %s (%s)", funcIdStr, funcNameStr)
    )
    -- call the function and it'll send the result back
    func()
end

-- TODO do these actually need wrapped in do/end blocks? i saw other people doing it, but in order to test it
-- thoroughly, you have to see if it breaks other scripts, not this one, so i'm just going to do it for now.
do
	local PrevLuaExportStart=LuaExportStart;

	function LuaExportStart()

		ScratchpadSteerpointsExport.StartUp()

		if PrevLuaExportStart then
			PrevLuaExportStart();
		end
	end
end

do
	local PrevLuaExportStop=LuaExportStop;

	function LuaExportStop()

		ScratchpadSteerpointsExport.ShutDown()
		
		if PrevLuaExportStop then
			PrevLuaExportStop();
		end
	end
end

do
	local PrevLuaExportAfterNextFrame=LuaExportAfterNextFrame;

	function LuaExportAfterNextFrame()

		ScratchpadSteerpointsExport.CheckAndExecuteCommands()
		
		if PrevLuaExportAfterNextFrame then
			PrevLuaExportAfterNextFrame();
		end
	end
end
