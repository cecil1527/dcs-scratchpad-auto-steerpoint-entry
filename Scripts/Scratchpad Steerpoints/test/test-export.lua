

-- this will exist in the export environment, solely for the purposes of reading cockpit devices (MFDs, etc.), because i
-- can't find that functionality in the GUI environment...

-- append path so it knows where socket is
package.path = package.path .. ";.\\LuaSocket\\?.lua;"
package.cpath = package.cpath .. ";.\\LuaSocket\\?.dll;"

-- the table i'm going to store all of my functionality in
local TestExport = {
    last_write = 0
}

function TestExport.ReadDisplays()
    -- only read the displays like once every 5s or w/e
    local t = LoGetModelTime()
    if t - TestExport.last_write < 5 then
        return
    end

    TestExport.last_write = t
    
    local file = io.open(lfs.writedir()..[[\Scripts\Scratchpad Steerpoints\test-export.log]], "w")
    for i = 0, 100 do
        file:write(string.format("\n\nlist_indication(%d)", i))
        file:write(list_indication(i))
    end
    file:flush()
    file:close()
end

-- runs on each frame
function TestExport.Run()
    TestExport.ReadDisplays()
end

-- TODO do these actually need wrapped in do/end blocks? i saw other people doing it, but in order to test it
-- thoroughly, you have to see if it breaks other scripts, not this one, so i'm just going to do it for now.

do
	local PrevLuaExportAfterNextFrame=LuaExportAfterNextFrame;

	function LuaExportAfterNextFrame()

		TestExport.Run()
		
		if PrevLuaExportAfterNextFrame then
			PrevLuaExportAfterNextFrame();
		end
	end
end
