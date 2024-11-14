Config = {}

Config.UseTarget = "interact"  -- Choose the system you want to use: "ox," "qb," or "interact."

Config.vehicleMenuEnabled = true  -- Enable or disable the vehicle extraction zone.

Config.UseInventory = "old" -- new or old

Config.inventoryScriptName = 'qb-inventory' -- name of ur qb-inventory script

Config.MenuScriptName = 'qb-menu' -- name of ur qb-menu script

Config.QbCoreScriptName = 'qb-core' -- name of ur qb-core script

Config.bossMenuScriptName = 'qb' -- Here is your title as an example, starting with the script name, such as qb or code.

Config.bossmenu = {
    ["lostmc"] = {coords = vector3(1973.24, 4632.02, 40.27), type = "gang"},
    ["premiumdeluxe"] = {coords = vector3(-12.71, -1648.91, 28.49), type = "job"},
    ["gangmanager"] = {coords = vector3(1393.77, 1160.78, 114.34), type = "job"},
}

Config.stash = {
    ["lostmc"] = {coords = vector3(1967.24, 4633.91, 41.09), type = "gang"},
    ["gangmanager"] = {coords = vector3(1403.75, 1144.22, 113.34), type = "job"},
}

Config.clothingMenu = {
    ["lostmc"] = {coords = vector3(1959.16, 4627.73, 41.24), type = "gang"},
    ["albanymechanic"] = {coords = vector3(8.14, -1665.84, 28.49), type = "job"},
    ["gangmanager"] = {coords = vector3(1401.95, 1154.42, 116.49), type = "job"},
    ["ambulance"] = {coords = vector3(379.37, -1411.88, 32.33), type = "job"},
}

Config.Stashes = {
    ["lostmc"] = {
        stashName = "lostmcstash",
        maxweight = 400000000,
        slots = 500,
        type = "gang",
        coords = vector3(1967.24, 4633.91, 41.09) -- استبدل بالإحداثيات الحقيقية
    },
    ["gangmanager"] = {
        stashName = "gangmanagerstash",
        maxweight = 4000000,
        slots = 500,
        type = "job",
        coords = vector3(1403.75, 1144.22, 113.34) -- استبدل بالإحداثيات الحقيقية
    },
}

Config.personalStash = {
    ["lostmc"] = {coords = vector3(1923.87, 4620.94, 39.92), type = "gang"},
}

Config.vehicleMenu = {
    ["lostmc"] = {
        coords = vector3(1954.45, 4646.42, 39.72),
        type = "gang",
        vehicles = {"buccaneer2", "chino", "hermes"},
        spawnCoords = vector4(1956.21, 4649.93, 40.73, 261.61),
        npcCoords = vector4(1954.45, 4646.42, 39.72, 243.08),
        npcModel = "s_m_y_cop_01",
        returnCoords = vector3(1956.21, 4649.93, 40.73)
    },
}
Config.GroupRanks = {
    ["lostmc"] = true,
    ["gangmanager"] = true,
    ["premiumdeluxe"] = true,
    ["albanymechanic"] = true,
    ["ambulance"] = true,
}
