
SCRATCHPAD_STEERPOINTS.f16 = {
    -- dt values for delaying the next button press (how long to hold the current button press or release). some keys
    -- require longer presses in certain circumstances. i find that if you're navigating through DED pages, you should
    -- wait a bit. but if you're entering steerpoint coordinate information, you can pretty much go as fast as you want.
    dtNorm = 0.1,
    dtVeryFast = 0.01, -- should basically hold it for one frame
    
    -- a table of commands
    commands = {
        -- each command will just be an array of deviceID, a buttonID, a pressValue, and a releaseValue
        ICP_BTN_0 =         {17, 3002,  1, 0},
        ICP_BTN_1 =         {17, 3003,  1, 0},
        ICP_BTN_2 =         {17, 3004,  1, 0},
        ICP_BTN_3 =         {17, 3005,  1, 0},
        ICP_BTN_4 =         {17, 3006,  1, 0},
        ICP_BTN_5 =         {17, 3007,  1, 0},
        ICP_BTN_6 =         {17, 3008,  1, 0},
        ICP_BTN_7 =         {17, 3009,  1, 0},
        ICP_BTN_8 =         {17, 3010,  1, 0},
        ICP_BTN_9 =         {17, 3011,  1, 0},
        ICP_ENTR_BTN =      {17, 3016,  1, 0},
        
        ICP_DED_SW_INC =    {17, 3030,  1, 0},
        ICP_DED_SW_DEC =    {17, 3030, -1, 0},
        
        ICP_DATA_RTN =      {17, 3032, -1, 0},
        ICP_DATA_SEQ =      {17, 3033,  1, 0},
        ICP_DATA_UP =       {17, 3034,  1, 0},
        ICP_DATA_DN =       {17, 3035, -1, 0},
    },

    -- a table to know which command to use for each character we have in a coordinate's char sequence
    charToUfcCommandKey = {
        ["0"] = "ICP_BTN_0",
        ["1"] = "ICP_BTN_1",
        ["2"] = "ICP_BTN_2",
        ["3"] = "ICP_BTN_3",
        ["4"] = "ICP_BTN_4",
        ["5"] = "ICP_BTN_5",
        ["6"] = "ICP_BTN_6",
        ["7"] = "ICP_BTN_7",
        ["8"] = "ICP_BTN_8",
        ["9"] = "ICP_BTN_9",

        ["N"] = "ICP_BTN_2",
        ["S"] = "ICP_BTN_8",
        ["W"] = "ICP_BTN_4",
        ["E"] = "ICP_BTN_6",

        -- for optional pressing of enter at the end of a char sequence
        [0] = "ICP_ENTR_BTN",
    }
}

-- executes commands for all of the steerpoints found in contentStr
function SCRATCHPAD_STEERPOINTS.f16.EnterSteerpoints(contentStr)

    SCRATCHPAD_STEERPOINTS.DisplayMessage("Starting F-16 Steerpoint Entry", 10)

    -- generate table of steerpoints. return if we don't have any
    local steerpoints = SCRATCHPAD_STEERPOINTS.generation.MakeSteerpoints(contentStr)
    if #steerpoints == 0 then
        local str = "Error: No steerpoints found in contentStr. Aborting!"
        SCRATCHPAD_STEERPOINTS.DisplayMessage(str, 5)
        SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.error, str)
        
        -- returns automatically kill the coroutine, so we don't have to do anything special.
        return
    end
    
    -- abort if none of the steerpoints have DDM info
    if not SCRATCHPAD_STEERPOINTS.generation.SteerpointsContainKey(steerpoints, "ddm") then
        local str = "Error: No steerpoints have DDM information. Aborting!"
        SCRATCHPAD_STEERPOINTS.DisplayMessage(str, 5)
        SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.error, str)
        return
    end

    local f16 = SCRATCHPAD_STEERPOINTS.f16
    -- ensure we're on the DED steerpoints page
    SCRATCHPAD_STEERPOINTS.ExecutePressRel(f16.commands.ICP_DATA_RTN, f16.dtNorm)
    SCRATCHPAD_STEERPOINTS.ExecutePressRel(f16.commands.ICP_DATA_RTN, f16.dtNorm)
    SCRATCHPAD_STEERPOINTS.ExecutePressRel(f16.commands.ICP_BTN_4, f16.dtNorm)

    for i = 1, #steerpoints do
        local steerpoint = steerpoints[i]
        
        -- only attempt to enter steerpoint if it has DDM information
        if not steerpoint.ddm then
            local str = "Error: Skipping steerpoint because it does not have DDM information!"
            SCRATCHPAD_STEERPOINTS.DisplayMessage(str, 5)
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.error, str)
        else
            -- prep strings for logging and displaying the message. wrap everything in tostring(), in case it's nil, because
            -- we want to be able to see if that's the case in the log.
            local numStr = tostring(steerpoint.num)
            local ddmStr = tostring(steerpoint.ddm)
            local elevStr = tostring(steerpoint.elev)

            -- make strings for executing char sequences
            local rawLat, rawLong, rawElev = unpack(SCRATCHPAD_STEERPOINTS.generation.GetRawLatLong(steerpoint, "ddm", true))
            local rawLatStr = string.format("%s%s%s%s", rawLat[1], rawLat[2], rawLat[3], rawLat[4])
            local rawLongStr = string.format("%s%s%s%s", rawLong[1], rawLong[2], rawLong[3], rawLong[4])
            local rawElevStr = tostring(rawElev[2])  -- grab elevation in feet

            -- log it.
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "F-16 Inputting Steerpoint")
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "Num: "..numStr)
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "DDM: "..ddmStr)
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "Elev: "..elevStr)
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "Raw Lat: "..rawLatStr)
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "Raw Long: "..rawLongStr)
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "Raw Elev: "..rawElevStr)
            
            -- and display message
            local msgStr = string.format(
                [[
                Inputting Steerpoint
                Num: %s
                DDM: %s
                Elev: %s
                ]],
                numStr, ddmStr, elevStr
            )
            SCRATCHPAD_STEERPOINTS.DisplayMessage(msgStr, 5)

            -- if the steerpoint has a dedicated number, enter it
            if steerpoint.num then
                SCRATCHPAD_STEERPOINTS.ExecuteCharSeq(steerpoint.num, f16.charToUfcCommandKey, f16.commands, f16.dtVeryFast, true)
            end



            -- navigate down and do latitude
            SCRATCHPAD_STEERPOINTS.ExecutePressRel(f16.commands.ICP_DATA_DN, f16.dtNorm)
            SCRATCHPAD_STEERPOINTS.ExecutePressRel(f16.commands.ICP_DATA_DN, f16.dtNorm)
            SCRATCHPAD_STEERPOINTS.ExecuteCharSeq(rawLatStr, f16.charToUfcCommandKey, f16.commands, f16.dtVeryFast, true)

            -- navigate down and do longitude
            SCRATCHPAD_STEERPOINTS.ExecutePressRel(f16.commands.ICP_DATA_DN, f16.dtNorm)
            SCRATCHPAD_STEERPOINTS.ExecuteCharSeq(rawLongStr, f16.charToUfcCommandKey, f16.commands, f16.dtVeryFast, true)

            -- navigate down and do elevation
            SCRATCHPAD_STEERPOINTS.ExecutePressRel(f16.commands.ICP_DATA_DN, f16.dtNorm)
            SCRATCHPAD_STEERPOINTS.ExecuteCharSeq(rawElevStr, f16.charToUfcCommandKey, f16.commands, f16.dtVeryFast, true)

            -- return to top
            SCRATCHPAD_STEERPOINTS.ExecutePressRel(f16.commands.ICP_DATA_DN, f16.dtNorm)
            SCRATCHPAD_STEERPOINTS.ExecutePressRel(f16.commands.ICP_DATA_DN, f16.dtNorm)

            -- if we have another steerpoint and it doesn't have a dedicated number, increment to the next steerpoint. this
            -- is at the bottom so we don't increment on the first steerpoint.
            if steerpoints[i+1] and not steerpoints[i+1].num then
                SCRATCHPAD_STEERPOINTS.ExecutePressRel(f16.commands.ICP_DED_SW_INC, f16.dtNorm)
            end
        end
    end

    -- return to DED home page (CNI? i think it's called)
    SCRATCHPAD_STEERPOINTS.ExecutePressRel(f16.commands.ICP_DATA_RTN, f16.dtNorm)

    local msgStr = "All done!"
    SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, msgStr)
    SCRATCHPAD_STEERPOINTS.DisplayMessage(msgStr, 5)
end
