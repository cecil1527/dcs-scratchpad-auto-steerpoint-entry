-- TODO
-- 1. add case insensitivity to tables? it could be done programattically in the apache's Setup()

SCRATCHPAD_STEERPOINTS.ah64 = {
    dtFast = 0.05,
    dtNorm = 0.15,
    dtSlow = 0.3,
    dtVerySlow = 0.5,
    
    plt_mpd_l = {
        T1 =      {42, 3001, 1, 0},
        T2 =      {42, 3002, 1, 0},
        T3 =      {42, 3003, 1, 0},
        T4 =      {42, 3004, 1, 0},
        T5 =      {42, 3005, 1, 0},
        T6 =      {42, 3006, 1, 0},
        R1 =      {42, 3007, 1, 0},
        R2 =      {42, 3008, 1, 0},
        R3 =      {42, 3009, 1, 0},
        R4 =      {42, 3010, 1, 0},
        R5 =      {42, 3011, 1, 0},
        R6 =      {42, 3012, 1, 0},
        B1 =      {42, 3018, 1, 0},
        B2 =      {42, 3017, 1, 0},
        B3 =      {42, 3016, 1, 0},
        B4 =      {42, 3015, 1, 0},
        B5 =      {42, 3014, 1, 0},
        B6 =      {42, 3013, 1, 0},
        L1 =      {42, 3024, 1, 0},
        L2 =      {42, 3023, 1, 0},
        L3 =      {42, 3022, 1, 0},
        L4 =      {42, 3021, 1, 0},
        L5 =      {42, 3020, 1, 0},
        L6 =      {42, 3019, 1, 0},
        AST =     {42, 3025, 1, 0},
        VID =     {42, 3026, 1, 0},
        COM =     {42, 3027, 1, 0},
        AC =      {42, 3028, 1, 0},
        TSD =     {42, 3029, 1, 0},
        WPN =     {42, 3030, 1, 0},
        FCR =     {42, 3031, 1, 0},
    },

    plt_ku = {
        KU_A =          {29, 3007, 1, 0},
        KU_B =          {29, 3008, 1, 0},
        KU_C =          {29, 3009, 1, 0},
        KU_D =          {29, 3010, 1, 0},
        KU_E =          {29, 3011, 1, 0},
        KU_F =          {29, 3012, 1, 0},
        KU_G =          {29, 3013, 1, 0},
        KU_H =          {29, 3014, 1, 0},
        KU_I =          {29, 3015, 1, 0},
        KU_J =          {29, 3016, 1, 0},
        KU_K =          {29, 3017, 1, 0},
        KU_L =          {29, 3018, 1, 0},
        KU_M =          {29, 3019, 1, 0},
        KU_N =          {29, 3020, 1, 0},
        KU_O =          {29, 3021, 1, 0},
        KU_P =          {29, 3022, 1, 0},
        KU_Q =          {29, 3023, 1, 0},
        KU_R =          {29, 3024, 1, 0},
        KU_S =          {29, 3025, 1, 0},
        KU_T =          {29, 3026, 1, 0},
        KU_U =          {29, 3027, 1, 0},
        KU_V =          {29, 3028, 1, 0},
        KU_W =          {29, 3029, 1, 0},
        KU_X =          {29, 3030, 1, 0},
        KU_Y =          {29, 3031, 1, 0},
        KU_Z =          {29, 3032, 1, 0},
        KU_SLASH =      {29, 3045, 1, 0},
        KU_0 =          {29, 3043, 1, 0},
        KU_1 =          {29, 3033, 1, 0},
        KU_2 =          {29, 3034, 1, 0},
        KU_3 =          {29, 3035, 1, 0},
        KU_4 =          {29, 3036, 1, 0},
        KU_5 =          {29, 3037, 1, 0},
        KU_6 =          {29, 3038, 1, 0},
        KU_7 =          {29, 3039, 1, 0},
        KU_8 =          {29, 3040, 1, 0},
        KU_9 =          {29, 3041, 1, 0},
        KU_DOT =        {29, 3042, 1, 0},
        KU_SIGN =       {29, 3044, 1, 0},
        KU_BKS =        {29, 3002, 1, 0},
        KU_SPC =        {29, 3003, 1, 0},
        KU_MULTI =      {29, 3049, 1, 0},
        KU_DIV =        {29, 3048, 1, 0},
        KU_PLUS =       {29, 3046, 1, 0},
        KU_MINUS =      {29, 3047, 1, 0},
        KU_CLR =        {29, 3001, 1, 0},
        KU_LEFT =       {29, 3004, 1, 0},
        KU_RIGHT =      {29, 3005, 1, 0},
        KU_ENT =        {29, 3006, 1, 0},
    },

    -- a table to know what buttons to press for each character we have in a char sequence
    charToKuCommandKey = {
        ["0"] = "KU_0",
        ["1"] = "KU_1",
        ["2"] = "KU_2",
        ["3"] = "KU_3",
        ["4"] = "KU_4",
        ["5"] = "KU_5",
        ["6"] = "KU_6",
        ["7"] = "KU_7",
        ["8"] = "KU_8",
        ["9"] = "KU_9",

        ["A"] = "KU_A",
        ["B"] = "KU_B",
        ["C"] = "KU_C",
        ["D"] = "KU_D",
        ["E"] = "KU_E",
        ["F"] = "KU_F",
        ["G"] = "KU_G",
        ["H"] = "KU_H",
        ["I"] = "KU_I",
        ["J"] = "KU_J",
        ["K"] = "KU_K",
        ["L"] = "KU_L",
        ["M"] = "KU_M",
        ["N"] = "KU_N",
        ["O"] = "KU_O",
        ["P"] = "KU_P",
        ["Q"] = "KU_Q",
        ["R"] = "KU_R",
        ["S"] = "KU_S",
        ["T"] = "KU_T",
        ["U"] = "KU_U",
        ["V"] = "KU_V",
        ["W"] = "KU_W",
        ["X"] = "KU_X",
        ["Y"] = "KU_Y",
        ["Z"] = "KU_Z",

        -- [0] = "KU_ENT"
    },

    wpTypeToMfdBtn = {
        ["WP"] = "L3",
        ["HZ"] = "L4",
        ["CM"] = "L5",
        ["TG"] = "L6",
    },

    -- i'm going to try and add some data validation to the waypoint types and their identifiers. for the individual
    -- ident codes, you can find their raw TSD lua tables in
    -- "...\Mods\aircraft\AH-64D\Cockpit\Scripts\Displays\Common\MPD_TSD_PointsId.lua". you can also find the
    -- information in the AH-64 quick start manual in appendix B on pg347.
    validWpIdents = {
        [""]   = 1,         -- blanks are allowed in apache
        ["LZ"] = 1,			-- Landing Zone
        ["CC"] = 1,			-- Communication Checkpoint
        ["PP"] = 1,			-- Passage Point
        ["RP"] = 1,			-- Release Point
        ["SP"] = 1,			-- Start Point
        ["WP"] = 1,			-- Waypoint
    },

    validHzIdents = {
        [""]   = 1,         -- blanks are allowed in apache
        ["TO"] = 1,			-- Tower Over 1000' AGL
        ["TU"] = 1,			-- Tower Under 1000' AGL
        ["WL"] = 1,			-- Wires - Power Lines
        ["WS"] = 1,			-- Wires - Telephone
    },

    validCmIdents = {
        [""]   = 1,         -- blanks are allowed in apache
        ["AB"] = 1,			-- Friendly Airborne
        ["AD"] = 1,			-- Friendly Air Defense
        ["AH"] = 1,			-- Friendly Attack Helicopter
        ["AM"] = 1,			-- Friendly Armor
        ["AS"] = 1,			-- Friendly Air Assault
        ["AV"] = 1,			-- Friendly Air Cavalry
        ["CA"] = 1,			-- Friendly Armored Cavalry
        ["CF"] = 1,			-- Friendly Chemical
        ["DF"] = 1,			-- Friendly Decontamination
        ["EN"] = 1,			-- Friendly Engineer
        ["FG"] = 1,			-- Friendly General Army Helicopter
        ["FI"] = 1,			-- Friendly Infantry
        ["FL"] = 1,			-- Friendly Field Artillery
        ["FU"] = 1,			-- Friendly Unit ID	
        ["FW"] = 1,			-- Friendly Electronic Warfare
        ["HO"] = 1,			-- Friendly Hospital / Aid Station
        ["MA"] = 1,			-- Friendly Aviation Maintenance
        ["MD"] = 1,			-- Friendly Medical
        ["MI"] = 1,			-- Friendly Mechanized Infantry
        ["TF"] = 1,			-- Friendly Tactical Operations Center
        ["WF"] = 1,			-- Friendly Fixed Wing
        ["CE"] = 1,			-- Enemy Chemical
        ["DE"] = 1,			-- Enemy Decontamination
        ["AE"] = 1,			-- Enemy Armor
        ["EB"] = 1,			-- Enemy Airborne
        ["EC"] = 1,			-- Enemy Armored Cavalry
        ["ED"] = 1,			-- Enemy Air Defense
        ["EE"] = 1,			-- Enemy Engineer
        ["EF"] = 1,			-- Enemy Field Artillery
        ["EH"] = 1,			-- Enemy Hospital / Aid Station
        ["EI"] = 1,			-- Enemy Infantry
        ["EK"] = 1,			-- Enemy Attack Helicopter
        ["EM"] = 1,			-- Enemy Mechanized Infantry
        ["ES"] = 1,			-- Enemy Air Assault
        ["ET"] = 1,			-- Enemy Tactical Operations Center
        ["EU"] = 1,			-- Enemy Unit ID
        ["EV"] = 1,			-- Enemy Air Cavalry
        ["EX"] = 1,			-- Enemy Medical
        ["HG"] = 1,			-- Enemy General Army Helicopter
        ["ME"] = 1,			-- Enemy Aviation Maintenance
        ["WE"] = 1,			-- Enemy Fixed Wing
        ["WR"] = 1,			-- Enemy Electronic Warfare
        ["BR"] = 1,			-- Bridge or Gap
        ["CP"] = 1,			-- Checkpoint
        ["BE"] = 1,			-- Nondirectional Beacon (NDB)
        ["RH"] = 1,			-- Railhead-point
        ["AA"] = 1,			-- Assembly Area
        ["AP"] = 1,			-- Air Control Point
        ["BP"] = 1,			-- Battle Position
        ["FA"] = 1,			-- Forward Assembly Area
        ["HA"] = 1,			-- Holding Area
        ["AG"] = 1,			-- Airfield - General
        ["AI"] = 1,			-- Airfield - Instrumented
        ["AL"] = 1,			-- Lighted Airport
        ["GL"] = 1,			-- Ground Lights / Small Town
        ["F1"] = 1,			-- Artillery Fire Registration / Concentration Point - Part 1
        ["F2"] = 1,			-- Artillery Fire Registration / Concentration Point - Part 2
        ["FC"] = 1,			-- FARP - Fuel and Ammunition
        ["FF"] = 1,			-- FARP - Fuel Only
        ["FM"] = 1,			-- FARP - Ammunition Only
        ["ID"] = 1,			-- IDM Subscriber
        ["BD"] = 1,			-- Brigade
        ["BN"] = 1,			-- Battalion
        ["CO"] = 1,			-- Company
        ["CR"] = 1,			-- CORPS
        ["DI"] = 1,			-- Division
        ["GP"] = 1,			-- Regiment / Group
        ["NB"] = 1,			-- Nuclear, Biological and Chemical Contaminated Area
        ["US"] = 1,			-- US Army
    },

    validTgIdents = {
        [""]   = 1,         -- blanks are allowed in apache
        ["TG"] = 1,			-- Target ID
        ["GU"] = 1,			-- Generic ADU
        ["1"] =  1,			-- SA-1 ADU
        ["2"] =  1,			-- SA-2 ADU
        ["3"] =  1,			-- SA-3 ADU
        ["4"] =  1,			-- SA-4 ADU
        ["5"] =  1,			-- SA-5 ADU
        ["6"] =  1,			-- SA-6 ADU
        ["7"] =  1,			-- SA-7 ADU
        ["8"] =  1,			-- SA-8 ADU
        ["9"] =  1,			-- SA-9 ADU
        ["10"] = 1,			-- SA-10 ADU
        ["11"] = 1,			-- SA-11 ADU
        ["12"] = 1,			-- SA-12 ADU
        ["13"] = 1,			-- SA-13/19 ADU
        ["14"] = 1,			-- SA-14 ADU
        ["15"] = 1,			-- SA-15 ADU
        ["16"] = 1,			-- SA-16 ADU
        ["17"] = 1,			-- SA-17 ADU
        ["S6"] = 1,			-- ADU
        ["ZU"] = 1,			-- ZSU-23/4 ADU
        ["AS"] = 1,			-- ASIPDE ADU
        ["83"] = 1,			-- M1983 ADU
        ["HK"] = 1,			-- HAWK/IHAWK ADU
        ["RO"] = 1,			-- ROLAND ADU
        ["AA"] = 1,			-- AAA (> 57mm) ADU
        ["C2"] = 1,			-- CSA-21/X ADU
        ["CT"] = 1,			-- CROTALE ADU
        ["RA"] = 1,			-- RAPIER ADU
        ["GT"] = 1,			-- Towed Air Defense Gun (> 57mm)
        ["GS"] = 1,			-- Self-Propelled Air Defense Gun (< 57mm)
        ["TR"] = 1,			-- Target Acquisition Radar
        ["U"] =  1,			-- Unknown ADU
        ["SA"] = 1,			-- Towed Multi-vehicle SAM ADU
        ["SP"] = 1,			-- Self-Propelled SAM ADU
        ["70"] = 1,			-- RBS-70 ADU
        ["SR"] = 1,			-- Battlefield Surveillance Radar
        ["NV"] = 1,			-- Naval ADU
        ["G1"] = 1,			-- Growth 1 ADU
        ["G2"] = 1,			-- Growth 2 ADU
        ["G3"] = 1,			-- Growth 3 ADU
        ["G4"] = 1,			-- Growth 4 ADU
        ["PT"] = 1,			-- M1M-104 PATRIOT ADU
        ["ST"] = 1,			-- STINGER or LAW-ADS ADU
        ["RE"] = 1,			-- REDEYE ADU
        ["CH"] = 1,			-- CHAPARRAL ADU
        ["TC"] = 1,			-- TIGERCAT Towed Multi-vehicle SAM ADU
        ["SD"] = 1,			-- SPADA Towed Multi-vehicle SAM ADU
        ["BH"] = 1,			-- BLOODHOUND Towed Multi-vehicle SAM ADU
        ["SS"] = 1,			-- SHORTS STARSTREAK ADU
        ["JA"] = 1,			-- SHORTS JAVELIN ADU
        ["BP"] = 1,			-- SHORTS BLOWPIPW ADU
        ["SM"] = 1,			-- SAMP ADU
        ["SC"] = 1,			-- SATCP ADU
        ["SH"] = 1,			-- SHAHINE/R440 ADU
        ["GP"] = 1,			-- GEPARD Towed ADG (< 57mm)
        ["VU"] = 1,			-- VULCAN Towed ADG (< 57mm)
        ["MK"] = 1,			-- Marconi MARKSMAN ADU
        ["SB"] = 1,			-- SABRE ADU
        ["AX"] = 1,			-- AMX-13 ADU
        ["AD"] = 1,			-- Friendly ADU
    },

    -- tables that'll get initialized in the SCRATCHPAD_STEERPOINTS.ah64.Setup() call
    plt_mpd_r = {},
    cpg_mpd_l = {},
    cpg_mpd_r = {},
    cpg_ku = {},
    wpTypeToIdentTable = {},
}

function SCRATCHPAD_STEERPOINTS.ah64.Setup()
    -- since i designed all button presses to take in a command table, i now have to have a ton of redundant tables
    -- since the only difference between the pilot and gunner left and right MFDs is just the deviceId... same with the
    -- pilot and gunner KU. so i'm just going to fill those out programmatically. it's much easier.

    local ah64 = SCRATCHPAD_STEERPOINTS.ah64

    -- all button presses are the same for these devices, it's just the device IDs that are different
    for key, command_table in pairs(ah64.plt_mpd_l) do
        -- create a new table when we set them to the string key, since command_table is a reference. and remember that
        -- command tables are {deviceId, buttonId, pressVal, relVal}.
        ah64.plt_mpd_r[key] = {43, command_table[2], command_table[3], command_table[4]}
        ah64.cpg_mpd_l[key] = {44, command_table[2], command_table[3], command_table[4]}
        ah64.cpg_mpd_r[key] = {45, command_table[2], command_table[3], command_table[4]}
    end

    for key, command_table in pairs(ah64.plt_ku) do
        ah64.cpg_ku[key] = {30, command_table[2], command_table[3], command_table[4]}
    end

    -- i guess this has to be here? you can't initialize a table containing other tables that i guess haven't yet been
    -- initialized, because the table constructor {} hasn't yet been closed
    ah64.wpTypeToIdentTable[""] =   SCRATCHPAD_STEERPOINTS.ah64.validWpIdents  -- a blank waypoint type defaults to WP in the apache
    ah64.wpTypeToIdentTable["WP"] = SCRATCHPAD_STEERPOINTS.ah64.validWpIdents
    ah64.wpTypeToIdentTable["HZ"] = SCRATCHPAD_STEERPOINTS.ah64.validHzIdents
    ah64.wpTypeToIdentTable["CM"] = SCRATCHPAD_STEERPOINTS.ah64.validCmIdents
    ah64.wpTypeToIdentTable["TG"] = SCRATCHPAD_STEERPOINTS.ah64.validTgIdents
end

-- returns whether waypoint type and ident code are valid
function SCRATCHPAD_STEERPOINTS.ah64.ValidateWpTypeAndIdentCode(wpTypeStr, identCodeStr)
    -- at this point, string is guaranteed to not be nil.

    -- grab the ident code table, using the wp type string as a key
    local identCodeTable = SCRATCHPAD_STEERPOINTS.ah64.wpTypeToIdentTable[wpTypeStr]
    if identCodeTable == nil then
        -- return false, nil since we don't know if ident code was valid or not
        return false, nil
    end

    -- check if code is valid in this table
    if identCodeTable[identCodeStr] == nil then
        -- then yeah, the waypoint type was valid, but the ident code is not
        return true, false
    end

    -- else both were valid
    return true, true
end

-- executes commands for all of the steerpoints found in contentStr
function SCRATCHPAD_STEERPOINTS.ah64.EnterSteerpoints(contentStr)
    SCRATCHPAD_STEERPOINTS.DisplayMessage("Starting AH-64 Waypoint Entry", 10)
    SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "Starting AH-64 Waypoint Entry")
    
    local steerpoints = SCRATCHPAD_STEERPOINTS.generation.MakeSteerpoints(contentStr)

    -- abort if we don't have any steerpoints
    if #steerpoints == 0 then
        local str = "Error: No steerpoints found in contentStr. Aborting!"
        SCRATCHPAD_STEERPOINTS.DisplayMessage(str, 10)
        SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.error, str)
        return
    end
    
    -- abort if no steerpoints have mgrs info
    if not SCRATCHPAD_STEERPOINTS.generation.SteerpointsContainKey(steerpoints, "mgrs") then
        local str = "Error: No steerpoints have MGRS info. Aborting!"
        SCRATCHPAD_STEERPOINTS.DisplayMessage(str, 10)
        SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.error, str)
        return
    end

    local ah64 = SCRATCHPAD_STEERPOINTS.ah64

    -- test which seat we're in
    local str = "Testing Seat Position"
    SCRATCHPAD_STEERPOINTS.DisplayMessage(str, 2)
    local isGunner = SCRATCHPAD_STEERPOINTS.RunExportFunction(SCRATCHPAD_STEERPOINTS.exportFunctions["ah64.IsGunner"])
    
    -- assign devices depending on which seat we're in
    local tsd_device, ku_device = nil, nil
    if isGunner == "true" then
        str = "Gunner Seat Identified"
        SCRATCHPAD_STEERPOINTS.DisplayMessage(str, 2)
        
        tsd_device = ah64.cpg_mpd_r
        ku_device = ah64.cpg_ku
    else
        str = "Pilot Seat Identified"
        SCRATCHPAD_STEERPOINTS.DisplayMessage(str, 2)

        tsd_device = ah64.plt_mpd_r
        ku_device = ah64.plt_ku
    end
    
    -- make sure we're on TSD page
    SCRATCHPAD_STEERPOINTS.ExecutePressRel(tsd_device.TSD, ah64.dtNorm)
    -- select Point
    SCRATCHPAD_STEERPOINTS.ExecutePressRel(tsd_device.B6, ah64.dtNorm)

    -- enter steerpoints
    for i=1, #steerpoints do
        local steerpoint = steerpoints[i]

        -- only attempt to enter steerpoint if it has MGRS information
        if not steerpoint.mgrs then
            local str = "Error: Skipping steerpoint because it does not have MGRS information!"
            SCRATCHPAD_STEERPOINTS.DisplayMessage(str, 5)
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.error, str)
        else

            local rawMgrs, rawElev = unpack(SCRATCHPAD_STEERPOINTS.generation.GetRawMgrs(steerpoint))

            -- prep waypoint type, ident code, and free text strings
            local wpTypeStr, identCodeStr, freeTextStr = nil, nil, nil
            -- if we have a label, fill in the info. apache labels should be space separated
            if steerpoint.label then
                wpTypeStr, identCodeStr, freeTextStr = unpack(SCRATCHPAD_STEERPOINTS.generation.SplitString(steerpoint.label, " "))
            end

            -- if anything is nil, set it to be blank, since blank is allowed in the apache
            if not wpTypeStr then wpTypeStr = "" end
            if not identCodeStr then identCodeStr = "" end
            if not freeTextStr then freeTextStr = "" end
            freeTextStr = freeTextStr:sub(1, 3)  -- free text can't be more than 3 chars in the apache

            -- prep the rest of the strings. use tostring() in case anything is nil
            local mgrsStr = tostring(steerpoint.mgrs)
            local elevStr = tostring(steerpoint.elev)

            -- he includes 1 more number than required for each dimension of MGRS for apache. i guess so you can round.
            -- so do rounding here
            local easting = SCRATCHPAD_STEERPOINTS.generation.RoundStrNum(rawMgrs[4], -1)
            local northing = SCRATCHPAD_STEERPOINTS.generation.RoundStrNum(rawMgrs[5], -1)
            -- drop the trailing zero
            easting = easting:sub(1, 4)
            northing = northing:sub(1, 4)

            local rawMgrsStr = tostring(rawMgrs[1])..tostring(rawMgrs[2])..tostring(rawMgrs[3])..easting..northing
            local rawElevStr = tostring(rawElev[2])  -- grab feet

            -- log entry
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "AH-64 Inputting Waypoint:")
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "label: "..tostring(steerpoint.label))
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "wpTypeStr: "..wpTypeStr)
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "identCodeStr: "..identCodeStr)
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, "freeTextStr: "..freeTextStr)
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, string.format("MGRS: %s (%s)", mgrsStr, rawMgrsStr))
            SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, string.format("Elev: %s (%s)", elevStr, rawElevStr))
            
            -- validate waypoint type and ident code
            local validWpType, validIdentCode = ah64.ValidateWpTypeAndIdentCode(wpTypeStr, identCodeStr)

            if not validWpType then
                str = string.format([[Waypoint Type: "%s" is not valid. Aborting!]], wpTypeStr)
                SCRATCHPAD_STEERPOINTS.DisplayMessage(str, 10)
                SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.error, str)
            elseif not validIdentCode then
                str = string.format([[Ident Code: "%s" is not valid. Aborting!]], identCodeStr)
                SCRATCHPAD_STEERPOINTS.DisplayMessage(str, 10)
                SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.error, str)
            else
                -- else both strings are valid, so continue
                
                -- display message
                str = string.format(
                    "Inputting Waypoint\n"..
                    "Type: %s\n"..
                    "Ident: %s\n"..
                    "Free Text: %s\n"..
                    "MGRS: %s\n"..
                    "Elev: %s",
                    wpTypeStr, identCodeStr, freeTextStr, mgrsStr, elevStr
                )
                SCRATCHPAD_STEERPOINTS.DisplayMessage(str, 10)

                -- click add
                SCRATCHPAD_STEERPOINTS.ExecutePressRel(tsd_device.L2, ah64.dtNorm)

                -- select waypoint type using MPD button, if one was given
                local wpTypeKey = ah64.wpTypeToMfdBtn[wpTypeStr]
                SCRATCHPAD_STEERPOINTS.ExecutePressRel(tsd_device[wpTypeKey], ah64.dtNorm)

                -- select ident
                SCRATCHPAD_STEERPOINTS.ExecutePressRel(tsd_device.L1, ah64.dtNorm)
                -- enter identifier information into KU
                SCRATCHPAD_STEERPOINTS.ExecuteCharSeq(identCodeStr, ah64.charToKuCommandKey, ku_device, ah64.dtFast, false)
                SCRATCHPAD_STEERPOINTS.ExecutePressRel(ku_device.KU_ENT, ah64.dtSlow)

                -- enter free text
                SCRATCHPAD_STEERPOINTS.ExecuteCharSeq(freeTextStr, ah64.charToKuCommandKey, ku_device, ah64.dtFast, false)
                SCRATCHPAD_STEERPOINTS.ExecutePressRel(ku_device.KU_ENT, ah64.dtSlow)

                -- enter full MGRS coord
                SCRATCHPAD_STEERPOINTS.ExecutePressRel(ku_device.KU_CLR, ah64.dtNorm)
                SCRATCHPAD_STEERPOINTS.ExecuteCharSeq(rawMgrsStr, ah64.charToKuCommandKey, ku_device, ah64.dtFast, false)
                SCRATCHPAD_STEERPOINTS.ExecutePressRel(ku_device.KU_ENT, ah64.dtSlow)

                -- enter elevation
                SCRATCHPAD_STEERPOINTS.ExecutePressRel(ku_device.KU_CLR, ah64.dtNorm)
                SCRATCHPAD_STEERPOINTS.ExecuteCharSeq(rawElevStr, ah64.charToKuCommandKey, ku_device, ah64.dtFast, false)
                SCRATCHPAD_STEERPOINTS.ExecutePressRel(ku_device.KU_ENT, ah64.dtSlow)
            end
        end
    end

    SCRATCHPAD_STEERPOINTS.ExecutePressRel(tsd_device.TSD, ah64.dtNorm)
    
    str = "All done!"
    SCRATCHPAD_STEERPOINTS.DisplayMessage(str, 5)
    SCRATCHPAD_STEERPOINTS.Log(SCRATCHPAD_STEERPOINTS.logLevels.info, str)
end

SCRATCHPAD_STEERPOINTS.ah64.Setup()