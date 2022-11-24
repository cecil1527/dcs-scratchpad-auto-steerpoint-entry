
local steerpointGeneration = dofile("steerpoint-generation.lua")

local function printSteerpoint(stptTable)
    print("Steerpoint")
    print("num: "..tostring(stptTable.num))
    print("ddm: "..tostring(stptTable.ddm))
    print("dms: "..tostring(stptTable.dms))
    print("mgrs: "..tostring(stptTable.mgrs))
    print("elev: "..tostring(stptTable.elev))
    print()
end

local function testSplitString()
    local str1 = "1,2,3,4,5"
    local str2 = "nswe6.7'8\"9°10"

    local splitStr1 = steerpointGeneration.SplitString(str1, ",")
    local splitStr2 = steerpointGeneration.SplitString(str2, "%D")  -- split by anything that's not a number

    print("splitStr1")
    for _, v in ipairs(splitStr1) do
        print(v)
    end

    print("splitStr2")
    for _, v in ipairs(splitStr2) do
        print(v)
    end
end

local function testTrimWhitespace()
    local str = "   sdfksdfsjdf    \t\t\t dkfsjdf \t\t   "
    print(str)
    print(steerpointGeneration.TrimWhitespace(str))

end

local function testLineRecognition()
    local stptNum = "    a;lskdj  sfjsl    fss ,.8ruo\t\txcv\nxntytrSteerpoint 12,xcvnw830374\t\t89590"
    print(steerpointGeneration.IsSteerpointNum(stptNum))

    local ddm = [[  test123               N 42°14.0488', E 42°09.6611']]
    print(steerpointGeneration.IsDdm(ddm))

    local dms = [[   sdfsdf    N 42°14'02.92", E 42°09'39.66"]]
    print(steerpointGeneration.IsDms(dms))

    local mgrs = "38 T KM 95501 72304"
    print(steerpointGeneration.IsMgrs(mgrs))

    local elev = "678m, 2223ft"
    print(steerpointGeneration.IsElevation(elev))
end

local contentStr = [[
    Steerpoint 11
    WP WP
    N 42°14'02.92", E 42°09'39.66"
    N 42°14.0488', E 42°09.6611'
    38 T KM 65736 79676
    34m, 111ft

    Steerpoint 12
    N 42°17.8094', E 42°13.3776'
    52m, 171ft

]]
local steerpoints = steerpointGeneration.MakeSteerpoints(contentStr)

local function testMakingSteerpoints()
    for _, steerpoint in ipairs(steerpoints) do
        printSteerpoint(steerpoint)
    end
end

local function printRawLatLong(rawLat, rawLong, rawElev)
    print("raw lat")
    for _, v in ipairs(rawLat) do
        print(v)
    end

    print("raw long")
    for _, v in ipairs(rawLong) do
        print(v)
    end

    print("raw elev")
    for _, v in ipairs(rawElev) do
        print(v)
    end
end

local function testRawInformation()
    printSteerpoint(steerpoints[1])
    
    local rawLat, rawLong, rawElev = unpack(steerpointGeneration.GetRawLatLong(steerpoints[1], "ddm", false))
    print("RAW DDM")
    printRawLatLong(rawLat, rawLong, rawElev)
    
    print()
    rawLat, rawLong, rawElev = unpack(steerpointGeneration.GetRawLatLong(steerpoints[1], "dms", false))
    print("RAW DMS")
    printRawLatLong(rawLat, rawLong, rawElev)

    print()
    local rawMgrs, rawElev = unpack(steerpointGeneration.GetRawMgrs(steerpoints[1]))
    print("RAW MGRS")
    for _, v in ipairs(rawMgrs) do
        print(v)
    end
    print("raw elev")
    for _, v in ipairs(rawElev) do
        print(v)
    end
end

local function testRounding()

    local n = 123.456
    print(steerpointGeneration.Round(n, 1))
    print(steerpointGeneration.Round(n, -2))

    local numStr = "72947"
    print(steerpointGeneration.RoundStrNum(numStr, -1))
end

-- testSplitString()
-- testTrimWhitespace()

-- testLineRecognition()
-- testMakingSteerpoints()

-- testRawInformation()

testRounding()

print("\nall done")