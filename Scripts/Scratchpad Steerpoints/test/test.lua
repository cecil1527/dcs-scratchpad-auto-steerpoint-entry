
------------------------------------------------------------------------
-- based on:
-- "Dir (objects introspection like Python's dir) - Lua"
-- http://snipplr.com/view/13085/
-- (added iteration through getmetatable of userdata, and recursive call)
-- make a global function here (in case it's needed in requires)
--- Returns string representation of object obj
-- @return String representation of obj
------------------------------------------------------------------------
local function dir(obj,level)
  local s,t = '', type(obj)

  level = level or ' '

  if (t=='nil') or (t=='boolean') or (t=='number') or (t=='string') then
    s = tostring(obj)
    if t=='string' then
      s = '"' .. s .. '"'
    end
  elseif t=='function' then s='function'
  elseif t=='userdata' then
    s='userdata'
    for n,v in pairs(getmetatable(obj)) do  s = s .. " (" .. n .. "," .. dir(v) .. ")" end
  elseif t=='thread' then s='thread'
  elseif t=='table' then
    s = '{'
    for k,v in pairs(obj) do
      local k_str = tostring(k)
      if type(k)=='string' then
        k_str = '["' .. k_str .. '"]'
      end
      s = s .. k_str .. ' = ' .. dir(v,level .. level) .. ', '
    end
    s = string.sub(s, 1, -3)
    s = s .. '}'
  end
  return s
end

-- https://stackoverflow.com/questions/51095022/inspect-function-signature-in-lua-5-1
local function FuncSig(f)
    assert(type(f) == 'function', "bad argument #1 to 'funcsign' (function expected)")
    local p = {}
    pcall(
       function()
          local oldhook
          local delay = 2
          local function hook(event, line)
             delay = delay - 1
             if delay == 0 then
                for i = 1, math.huge do
                   local k, v = debug.getlocal(2, i)
                   if type(v) == "table" then
                      table.insert(p, "...")
                      break
                   elseif (k or '('):sub(1, 1) == '(' then
                      break
                   else
                      table.insert(p, k)
                   end
                end
                if debug.getlocal(2, -1) then
                   table.insert(p, "...")
                end
                debug.sethook(oldhook)
                error('aborting the call')
             end
          end
          oldhook = debug.sethook(hook, "c")
          local arg = {}
          for j = 1, 64 do arg[#arg + 1] = true end
          f((table.unpack or unpack)(arg))
       end)
    return "function("..table.concat(p, ",")..")"
 end
 
---explores table recursively and returns a string detailing what it's found. it will either dump all keys and values
-- to the string, or if you supply a findStr, then it'll only dump lines when it finds a key string containing the pattern.
---@param t table table you want to recursively search through
---@param tableName string string name of the table for labeling in log output
---@param depthLimit number number to limit to recrusive depth. beware of circular references, it'll loop forever
---@param findPatternStr string string to search for in keys. if supplied, then it'll only log keys containing this
---@param s string don't use. it's only used internally
---@param depth number don't use. it's only used internally
---@return string
local function ExploreTable(t, tableName, depthLimit, findPatternStr, s, depth)
    depthLimit = depthLimit or 1
    -- change everything to lowercase to make search case insensitive
    if findPatternStr then
        findPatternStr = string.lower(findPatternStr)
    else
        findPatternStr = ""
    end

    s = s or ""
    depth = depth or 1

    -- just a bool to more easily keep track of dumping vs searching
    local dump = false
    if findPatternStr == "" then
      dump = true
    end

    -- nested function to write the table information into the string, s
    local function WriteTblToStr(tbl)
        for k, v in pairs(tbl) do
            if dump or string.find(string.lower(tostring(k)), findPatternStr) then
                local typeStr = string.format("%-15s%-15s", type(k), type(v))
                local kvStr = string.format("%s.%s\t%s", tableName, tostring(k), tostring(v))
                s = s..string.format("\n%s%s", typeStr, kvStr)
            end
            
            -- if the value is another table, recurse. but don't do it if the table is called _G. i think some tables
            -- kept references to the global table or something, since i was getting a lot of recursive repeats.
            if type(v) == "table" and tostring(k) ~= "_G" then
                if depth < depthLimit then
                    -- TODO how to properly label meta tables? as of right now i'm assuming all values are prefixed with "__"
                    s = ExploreTable(v, tableName.."."..tostring(k), depthLimit, findPatternStr, s, depth+1)
                else
                    if dump then
                        -- only print this out on a full table dump, not when searching for keys
                        s = s.."\nDEPTH LIMIT REACHED!"
                    end
                end
            end
        end
    end

    -- explore metatable if it has one
    local mt = getmetatable(t)
    if mt then
        if type(mt) == "string" and dump then
            s = s..string.format("mt is string?: "..mt)
        else
            -- WriteTblToStr(mt)
        end
    end

    -- do the same there here, but on the actual table
    WriteTblToStr(t)

    return s
end

local function WriteToFile(str)
    local file = io.open(lfs.writedir()..[[Scripts\Scratchpad Steerpoints\test\test.log]], "a")
    file:write("\n\n"..str)
    file:flush()
    file:close()
end

local function SearchTables()
    local dumpStr = ExploreTable(_G.Export, "_G.Export", 5)
    WriteToFile(dumpStr)
end

local function TestButtonPresses()
    Export.GetDevice(17):performClickableAction(3004, 1)
end

local function TestSockets()
    local socket = require("socket")
    local udpSocket = socket.udp()
    
    local guiPort = 4321
    local exportPort = 4322
    
    local result, err = udpSocket:setsockname("127.0.0.1", guiPort)
    net.log(string.format("setsockname: %s %s", tostring(result), tostring(err)))
    
    result, err = udpSocket:setpeername("127.0.0.1", exportPort)
    net.log(string.format("setpeername: %s %s", tostring(result), tostring(err)))
    
    udpSocket:settimeout(0)
    
    for i=1, 10 do
        udpSocket:send("hello from the other side :)")
    end
    udpSocket:close()
end

local function TestCoords()
    
    local file = io.open(lfs.writedir()..[[Scripts\Scratchpad Steerpoints\test\test.log]], "w")
    
    local pos = Export.LoGetCameraPosition()
    local dumpStr = ExploreTable(pos, "pos", 5)
    WriteToFile(dumpStr)

    pos = pos.p

    local alt = Terrain.GetSurfaceHeightWithSeabed(pos.x, pos.z)
    local str = "\n Alt: "..tostring(alt).." type: "..type(alt)

    local lat, lon = Terrain.convertMetersToLatLon(pos.x, pos.z)
    str = str.."\n lat: "..tostring(lat).." type: "..type(lat)
    str = str.."\n lon: "..tostring(lon).." type: "..type(lon)

    local mgrs = Terrain.GetMGRScoordinates(pos.x, pos.z)
    str = str.."\n mgrs: "..tostring(mgrs).." type: "..type(mgrs)

    WriteToFile(str)

    -- yeah... you get a ton of decimal places with lat long. i think doing LL Decimal in the f-18 is better, since it's
    -- 1/10,000th of a minute (since it gets 4 decimal places) instead of 1/6,000th of a minute (1/100th of a second)
end

local function TestDebug()

    for i = 0, 10 do
        local result = debug.getinfo(i)

        local str = ExploreTable(result, string.format("debug.getinfo(%s)", i))
        WriteToFile(str)
    end
end

local function TestMessages()
    gameMessages.addMessage("Test123", 5000)
    gameMessages.addMessage("Test123", 5000)
    gameMessages.addMessage("Test123", 5000)
end

local function TestMapPos()
    local result = _G.gui_map.GetScale()
    WriteToFile(tostring(result))


end

local function TestGetIndicator()
    local result = Export.GetIndicator(1)
    WriteToFile(tostring(result))

    local dumpStr = ExploreTable(result, "GetIndicator(1)", 5)
    WriteToFile(dumpStr)

end

local function TestEngineInfo()
    local acType = DCS.getPlayerUnitType()
    WriteToFile(tostring(acType))

    local engineInfo = Export.LoGetEngineInfo()
    local dumpStr = ExploreTable(engineInfo, "engineInfo", 5)
    WriteToFile(dumpStr)

end


-- SearchTables()
-- TestSockets()
-- TestCoords()
-- TestDebug()
-- TestMessages()

-- TestMapPos()

-- TestGetIndicator()

TestEngineInfo()


