QBCore = exports['qb-core']:GetCoreObject()

local function isPlayerInGang(player, gangName)
    local playerGang = player.PlayerData.gang.name
    return playerGang == gangName
end

QBCore.Functions.CreateCallback('gang:canOpenStash', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local gangName = Player.PlayerData.gang.name

    if Config.GangRanks[gangName] then
        cb(isPlayerInGang(Player, gangName))
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('gang:getGangName', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    cb(Player.PlayerData.gang.name)
end)
