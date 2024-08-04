Config = {}

Config.UseTarget = "orbit"  -- اختر النظام الذي تريد استخدامه: "ox" أو "qb" أو "orbit"

Config.vehicleMenuEnabled = true  -- تمكين أو تعطيل منطقة استخراج السيارات

Config.UseInventory = "new" -- new or old


Config.bossmenu = {
    ["vagos"] = {coords = vector3(1973.24, 4632.02, 40.27), type = "gang"},
    -- ["vagos"] = {coords = vector3(344.67, -2022.14, 22.39), type = "gang"},
    -- ["police"] = {coords = vector3(441.34, -981.85, 30.69), type = "job"},
}

Config.stash = {
    ["vagos"] = {coords = vector3(1967.24, 4633.91, 41.09), type = "gang"},
    -- ["vagos"] = {coords = vector3(343.0, -2021.0, 22.0), type = "gang"},
    -- ["police"] = {coords = vector3(451.7, -973.5, 30.69), type = "job"},
}

Config.clothingMenu = {
    ["vagos"] = {coords = vector3(1959.16, 4627.73, 41.24), type = "gang"},
    -- ["vagos"] = {coords = vector3(299.3, -598.4, 43.3), type = "gang"},
    -- ["police"] = {coords = vector3(461.9, -998.6, 30.69), type = "job"},
}

Config.Stashes = {
    ["vagos"] = {
        stashName = "vagosstash",
        maxweight = 4000000,
        slots = 500,
        type = "gang"
    },
    ["police"] = {
        stashName = "policestash",
        maxweight = 3000000,
        slots = 400,
        type = "job"
    },
}

Config.personalStash = {
    ["vagos"] = {coords = vector3(1923.87, 4620.94, 39.92), type = "gang"},
    -- ["vagos"] = {coords = vector3(345.0, -2023.0, 22.0), type = "gang"},
    -- ["police"] = {coords = vector3(471.6, -991.2, 30.69), type = "job"},
}

Config.vehicleMenu = {
    ["vagos"] = {
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
    ["ballas"] = true,
    ["vagos"] = true,
    ["police"] = true,
    ["lostmc"] = true,
}
