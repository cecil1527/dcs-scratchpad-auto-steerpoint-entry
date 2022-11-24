
SCRATCHPAD_STEERPOINTS.f18 = {
    -- things can be kind of laggy in the F-18, so you need different slow speeds to choose from
    dtFast = 0.05,
    dtNorm = 0.15,
    dtSlow = 0.3,
    dtVerySlow = 0.5,
    
    allCommands = {
        --AMPCD
        AMPCD_PB_01 = {37, 3011, 1, 0},
        AMPCD_PB_02 = {37, 3012, 1, 0},
        AMPCD_PB_03 = {37, 3013, 1, 0},
        AMPCD_PB_04 = {37, 3014, 1, 0},
        AMPCD_PB_05 = {37, 3015, 1, 0},
        AMPCD_PB_06 = {37, 3016, 1, 0},
        AMPCD_PB_07 = {37, 3017, 1, 0},
        AMPCD_PB_08 = {37, 3018, 1, 0},
        AMPCD_PB_09 = {37, 3019, 1, 0},
        AMPCD_PB_10 = {37, 3020, 1, 0},
        AMPCD_PB_11 = {37, 3021, 1, 0},
        AMPCD_PB_12 = {37, 3022, 1, 0},
        AMPCD_PB_13 = {37, 3023, 1, 0},
        AMPCD_PB_14 = {37, 3024, 1, 0},
        AMPCD_PB_15 = {37, 3025, 1, 0},
        AMPCD_PB_16 = {37, 3026, 1, 0},
        AMPCD_PB_17 = {37, 3027, 1, 0},
        AMPCD_PB_18 = {37, 3028, 1, 0},
        AMPCD_PB_19 = {37, 3029, 1, 0},
        AMPCD_PB_20 = {37, 3030, 1, 0},
        
        --UFC
        UFC_OS1 = {25, 3010, 1, 0},
        UFC_OS2 = {25, 3011, 1, 0},
        UFC_OS3 = {25, 3012, 1, 0},
        UFC_OS4 = {25, 3013, 1, 0},
        UFC_OS5 = {25, 3014, 1, 0},
    
        UFC_0 =   {25, 3018, 1, 0},
        UFC_1 =   {25, 3019, 1, 0},
        UFC_2 =   {25, 3020, 1, 0},
        UFC_3 =   {25, 3021, 1, 0},
        UFC_4 =   {25, 3022, 1, 0},
        UFC_5 =   {25, 3023, 1, 0},
        UFC_6 =   {25, 3024, 1, 0},
        UFC_7 =   {25, 3025, 1, 0},
        UFC_8 =   {25, 3026, 1, 0},
        UFC_9 =   {25, 3027, 1, 0},
        UFC_CLR = {25, 3028, 1, 0},
        UFC_ENT = {25, 3029, 1, 0},
    },

    -- a table to know what UFC button to press for each character we have in a steerpoint's coord char sequence
    charToUfcCommandKey = {
        ["0"] = "UFC_0",
        ["1"] = "UFC_1",
        ["2"] = "UFC_2",
        ["3"] = "UFC_3",
        ["4"] = "UFC_4",
        ["5"] = "UFC_5",
        ["6"] = "UFC_6",
        ["7"] = "UFC_7",
        ["8"] = "UFC_8",
        ["9"] = "UFC_9",

        ["N"] = "UFC_2",
        ["S"] = "UFC_8",
        ["W"] = "UFC_4",
        ["E"] = "UFC_6",

        -- enter on the UFC lags so don't worry about a key for it. i'll just do it manually
        -- [0] = "UFC_ENT"
    }
}

-- executes commands to select the desired waypoint. assumes we're on the HSI page
function SCRATCHPAD_STEERPOINTS.f18.SelectWaypoint(desiredWaypointNo)
    local f18 = SCRATCHPAD_STEERPOINTS.f18
    local currentWaypointNo = SCRATCHPAD_STEERPOINTS.RunExportFunction(SCRATCHPAD_STEERPOINTS.exportFunctions["f18.GetCurrentWaypointNo"])
    currentWaypointNo = tonumber(currentWaypointNo)

    if currentWaypointNo == desiredWaypointNo then
        return
    end
    
    -- assign AMPCD command depending on if we need to increment or decrement waypoint
    local command = nil
    local requiredSteps = desiredWaypointNo - currentWaypointNo
    if requiredSteps > 0 then
        command = f18.allCommands.AMPCD_PB_12
    else
        command = f18.allCommands.AMPCD_PB_13
    end

    -- mash button to get to the waypoint we want.
    for i = 1, math.abs(requiredSteps) do
        SCRATCHPAD_STEERPOINTS.ExecutePressRel(command, f18.dtFast)
    end

    -- wait a bit after the last press since the F-18 is kind of laggy :/
    SCRATCHPAD_STEERPOINTS.ExecuteCommand(f18.dtSlow)
end

-- executes commands for all of the steerpoints found in contentStr
function SCRATCHPAD_STEERPOINTS.f18.EnterSteerpoints(contentStr)
    SCRATCHPAD_STEERPOINTS.DisplayMessage("Starting F-18 Waypoint Entry", 10)

    -- abort if we don't have any steerpoints
    local steerpoints = SCRATCHPAD_STEERPOINTS.generation.MakeSteerpoints(contentStr)
    if #steerpoints == 0 then
        local str = "Error: No steerpoints found in contentStr. Aborting!"
        SCRATCHPAD_STEERPOINTS.DisplayMessage(str, 10)
        SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.error, str)
        return
    end
    
    -- abort if none of the steerpoints have DMS info
    if not SCRATCHPAD_STEERPOINTS.generation.SteerpointsContainKey(steerpoints, "dms") then
        local str = "Error: No steerpoints have DMS information. Aborting!"
        SCRATCHPAD_STEERPOINTS.DisplayMessage(str, 5)
        SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.error, str)
        return
    end

    local f18 = SCRATCHPAD_STEERPOINTS.f18

    -- make sure we're on HSI WYPT page
    SCRATCHPAD_STEERPOINTS.ExecutePressRel(f18.allCommands.AMPCD_PB_18, f18.dtNorm)
    SCRATCHPAD_STEERPOINTS.ExecutePressRel(f18.allCommands.AMPCD_PB_18, f18.dtNorm)
    SCRATCHPAD_STEERPOINTS.ExecutePressRel(f18.allCommands.AMPCD_PB_02, f18.dtNorm)
    SCRATCHPAD_STEERPOINTS.ExecutePressRel(f18.allCommands.AMPCD_PB_10, f18.dtNorm)

    -- preselect UFC since it lags
    SCRATCHPAD_STEERPOINTS.ExecutePressRel(f18.allCommands.AMPCD_PB_05, f18.dtNorm)

    -- make sure jet is in LL SEC mode
    SCRATCHPAD_STEERPOINTS.DisplayMessage("Making sure jet is in LATLN SEC mode", 10)
    SCRATCHPAD_STEERPOINTS.ExecutePressRel(f18.allCommands.AMPCD_PB_06, f18.dtNorm)
    local isLLModeSec = SCRATCHPAD_STEERPOINTS.RunExportFunction(SCRATCHPAD_STEERPOINTS.exportFunctions["f18.IsLLModeSec"])
    if isLLModeSec == "false" then
        SCRATCHPAD_STEERPOINTS.ExecutePressRel(f18.allCommands.AMPCD_PB_15, f18.dtVerySlow)
    end
    SCRATCHPAD_STEERPOINTS.ExecutePressRel(f18.allCommands.AMPCD_PB_07, f18.dtVerySlow)

    -- make sure Precise is boxed
    SCRATCHPAD_STEERPOINTS.DisplayMessage("Making sure PRECISE is boxed", 10)
    local isPreciseBoxed = SCRATCHPAD_STEERPOINTS.RunExportFunction(SCRATCHPAD_STEERPOINTS.exportFunctions["f18.IsPreciseBoxed"])
    if isPreciseBoxed == "false" then
        SCRATCHPAD_STEERPOINTS.ExecutePressRel(f18.allCommands.AMPCD_PB_19, f18.dtVerySlow)
    end

    -- enter steerpoints
    for i=1, #steerpoints do
        -- grab steerpoint and its raw info
        local steerpoint = steerpoints[i]
        
        -- only attempt to enter steerpoint if it has DMS information
        if not steerpoint.dms then
            local str = "Error: Skipping steerpoint because it does not have degree minute second information!"
            SCRATCHPAD_STEERPOINTS.DisplayMessage(str, 5)
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.error, str)
        else
            -- prep strings for logging and displaying the message. wrap everything in tostring(), in case it's nil,
            -- because we want to be able to see if that's the case in the log.
            local numStr = tostring(steerpoint.num)
            local dmsStr = tostring(steerpoint.dms)
            local elevStr = tostring(steerpoint.elev)

            -- make strings for executing char sequences
            local rawLat, rawLong, rawElev = unpack(SCRATCHPAD_STEERPOINTS.generation.GetRawLatLong(steerpoint, "dms", false))
            local rawLatStr = tostring(rawLat[1])..tostring(rawLat[2])..tostring(rawLat[3])..tostring(rawLat[4])..tostring(rawLat[5])
            local rawLongStr = tostring(rawLong[1])..tostring(rawLong[2])..tostring(rawLong[3])..tostring(rawLong[4])..tostring(rawLong[5])
            local rawElevStr = tostring(rawElev[2])  -- grab feet

            -- log it.
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "F-18 Inputting Steerpoint")
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "Num: "..numStr)
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "DMS: "..dmsStr)
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "Elev: "..elevStr)
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "Raw Lat: "..rawLatStr)
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "Raw Long: "..rawLongStr)
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "Raw Elev: "..rawElevStr)

            -- select desired steerpoint number if we have one
            if steerpoint.num then
                SCRATCHPAD_STEERPOINTS.DisplayMessage("Selecting Waypoint "..steerpoint.num, 10)
                f18.SelectWaypoint(steerpoint.num)
            end
            
            -- and display message
            local msgStr = string.format(
                "Inputting Steerpoint\n"..
                "Num: %s\n"..
                "DMS: %s\n"..
                "Elev: %s",
                numStr, dmsStr, elevStr
            )
            SCRATCHPAD_STEERPOINTS.DisplayMessage(msgStr, 10)

            -- select POSN
            SCRATCHPAD_STEERPOINTS.ExecutePressRel(f18.allCommands.UFC_OS1, f18.dtNorm)

            -- enter latitude cardinal, degrees, minutes, and seconds
            SCRATCHPAD_STEERPOINTS.ExecuteCharSeq(rawLat[1]..rawLat[2]..rawLat[3]..rawLat[4], f18.charToUfcCommandKey, f18.allCommands, f18.dtFast, false)
            -- f-18 UFC lags when pressing enter, so i'm going to do it manually with a longer duration
            SCRATCHPAD_STEERPOINTS.ExecutePressRel(f18.allCommands.UFC_ENT, f18.dtSlow)
            -- enter latitude decimals
            SCRATCHPAD_STEERPOINTS.ExecuteCharSeq(rawLat[5], f18.charToUfcCommandKey, f18.allCommands, f18.dtFast, false)
            SCRATCHPAD_STEERPOINTS.ExecutePressRel(f18.allCommands.UFC_ENT, f18.dtSlow)

            -- enter longitude cardinal, degrees, minutes, and seconds
            SCRATCHPAD_STEERPOINTS.ExecuteCharSeq(rawLong[1]..rawLong[2]..rawLong[3]..rawLong[4], f18.charToUfcCommandKey, f18.allCommands, f18.dtFast, false)
            SCRATCHPAD_STEERPOINTS.ExecutePressRel(f18.allCommands.UFC_ENT, f18.dtSlow)
            -- enter longitude decimals
            SCRATCHPAD_STEERPOINTS.ExecuteCharSeq(rawLong[5], f18.charToUfcCommandKey, f18.allCommands, f18.dtFast, false)
            SCRATCHPAD_STEERPOINTS.ExecutePressRel(f18.allCommands.UFC_ENT, f18.dtSlow)

            -- select ELEV and FT
            SCRATCHPAD_STEERPOINTS.ExecutePressRel(f18.allCommands.UFC_OS3, f18.dtNorm)
            SCRATCHPAD_STEERPOINTS.ExecutePressRel(f18.allCommands.UFC_OS1, f18.dtNorm)
            
            -- enter elevation
            SCRATCHPAD_STEERPOINTS.ExecuteCharSeq(rawElevStr, f18.charToUfcCommandKey, f18.allCommands, f18.dtFast, false)
            SCRATCHPAD_STEERPOINTS.ExecutePressRel(f18.allCommands.UFC_ENT, f18.dtSlow)

            -- if we have another steerpoint and it doesn't have a dedicated number, increment to the next steerpoint. this
            -- is at the bottom so we don't increment on the first steerpoint
            if steerpoints[i+1] and not steerpoints[i+1].num then
                SCRATCHPAD_STEERPOINTS.DisplayMessage("Incrementing Waypoint", 10)
                SCRATCHPAD_STEERPOINTS.ExecutePressRel(f18.allCommands.AMPCD_PB_12, f18.dtNorm)
            end
        end
    end
    
    --clear UFC
    SCRATCHPAD_STEERPOINTS.ExecutePressRel(f18.allCommands.UFC_CLR, f18.dtNorm)
    -- return to HSI page
    SCRATCHPAD_STEERPOINTS.ExecutePressRel(f18.allCommands.AMPCD_PB_10, f18.dtNorm)

    SCRATCHPAD_STEERPOINTS.DisplayMessage("All done!", 5)
end
