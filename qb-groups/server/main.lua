QBCore = exports[Config.QbCoreScriptName]:GetCoreObject()

local function isPlayerInGroup(player, groupName)
    local playerJob = player.PlayerData.job.name
    local playerGang = player.PlayerData.gang.name
    return playerJob == groupName or playerGang == groupName
end

QBCore.Functions.CreateCallback('group:canOpenStash', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local jobOrGangName = Player.PlayerData.job.name or Player.PlayerData.gang.name

    if Config.GroupRanks[jobOrGangName] then
        cb(isPlayerInGroup(Player, jobOrGangName))
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('group:getGroupName', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    cb(Player.PlayerData.job.name or Player.PlayerData.gang.name)
end)

RegisterNetEvent('qb-groups:server:stash', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerGroup = Player.PlayerData.gang and Player.PlayerData.gang.name or Player.PlayerData.job and Player.PlayerData.job.name
    local PlayerType = Player.PlayerData.gang and Player.PlayerData.gang.name and 'gang' or 'job'

    if PlayerGroup and Config.Stashes[PlayerGroup] then
        local stashConfig = Config.Stashes[PlayerGroup]
        local stashName = stashConfig.stashName or (PlayerGroup .. "stash_" .. playerData.citizenid)
        local maxweight = stashConfig.maxweight or 4000000
        local slots = stashConfig.slots or 500
        exports[Config.inventoryScriptName]:OpenInventory(src, stashName)
    end
end)

RegisterNetEvent('qb-groups:server:personalStash', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid

    if citizenid then
        local stashName = "personalstash_" .. citizenid
        local maxweight = 4000000 -- يمكن تغيير الوزن الأقصى هنا
        local slots = 500 -- يمكن تغيير عدد الفتحات هنا
        exports[Config.inventoryScriptName]:OpenInventory(src, stashName)
    end
end)
