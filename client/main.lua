local QBCore = exports['qb-core']:GetCoreObject()
local Config = Config or {}

local function isGangAllowed(gang)
    local playerData = QBCore.Functions.GetPlayerData()
    if not playerData or not playerData.gang then
        return false
    end
    return playerData.gang.name == gang and Config.GangRanks[gang] == true
end

RegisterNetEvent('qb-gangs:client:OpenBossMenu', function()
    local playerData = QBCore.Functions.GetPlayerData()
    if not playerData or not playerData.gang then
        QBCore.Functions.Notify("Player data or gang data is missing!", "error")
        return
    end

    if not playerData.gang.isboss then 
        QBCore.Functions.Notify("Are You sure You are the Boss?", "error") 
        return 
    end
    
    local gangMenu = {}
    gangMenu[#gangMenu + 1] = {
        header = 'Gang Management - '.. string.upper(QBCore.Functions.GetPlayerData().gang.grade.name),
        icon = "fa-solid fa-circle-info",
        isMenuHeader = true,
    }
    gangMenu[#gangMenu + 1] = {
        header = 'Manage Employees',
        txt = 'Hire Gang Members',
        icon = "fa-solid fa-list",
        params = {
            event = "qb-gangmenu:client:HireMembers",
        }
    }
    gangMenu[#gangMenu + 1] = {
        header = "Manage Gang Members",
        txt = 'Recruit or Fire Gang Members',
        icon = "fa-solid fa-hand-holding",
        params = {
            event = "qb-gangmenu:client:ManageGang",
        }
    }
    gangMenu[#gangMenu + 1] = {
        header = "Storage Access",
        txt = 'Open Gang Stash',
        icon = "fa-solid fa-sack-dollar",
        params = {
            event = "qb-gangmenu:client:Stash",
        }
    }
    gangMenu[#gangMenu + 1] = {
        header = "Money Management",
        txt = 'Check your Gang Balance',
        icon = "fa-solid fa-sack-dollar",
        params = {
            event = "qb-gangmenu:client:SocietyMenu",
        }
    }
    gangMenu[#gangMenu + 1] = {
        header = "Close Menu",
        icon = "fa-duotone fa-circle-x",
        params = {
            event = "qb-menu:closeMenu",
        }
    }

    exports['qb-menu']:openMenu(gangMenu)
end)

-- Function to add Boss Menu Zone
local function addBossMenuZone(gang, coords)
    if Config.UseTarget == "ox" then
        exports.ox_target:addSphereZone({
            coords = coords,
            radius = 1.5,
            options = {
                {
                    name = gang .. '_boss_menu',
                    label = 'Open Boss Menu',
                    onSelect = function()
                        TriggerEvent('qb-gangs:client:OpenBossMenu')
                    end,
                    canInteract = function(entity, distance, coords, name)
                        return distance < 1.5 and isGangAllowed(gang)
                    end
                }
            }
        })
    elseif Config.UseTarget == "qb" then
        exports['qb-target']:AddBoxZone(gang .. '_boss_menu', coords, 1.5, 1.5, {
            name = gang .. '_boss_menu',
            heading = 0,
            debugPoly = false,
            minZ = coords.z - 1,
            maxZ = coords.z + 1
        }, {
            options = {
                {
                    type = "client",
                    event = "qb-gangs:client:OpenBossMenu",
                    icon = "fas fa-box",
                    label = "Open Boss Menu",
                    canInteract = function(entity, distance, coords, name)
                        return distance < 1.5 and isGangAllowed(gang)
                    end
                }
            },
            distance = 1.5
        })
    elseif Config.UseTarget == "orbit" then
        Citizen.CreateThread(function()
            while true do
                local playerCoords = GetEntityCoords(PlayerPedId())
                local distance = GetDistanceBetweenCoords(playerCoords, coords.x, coords.y, coords.z, true)
                if distance < 8 then
                    SetDrawOrigin(coords.x, coords.y, coords.z + 1, 0)
                    if distance > 1.5 and distance < 8 and isGangAllowed(gang) then
                        DrawSprite("orbit_ui", "point", 0, 0, 0.015, 0.025, 0, 255, 255, 255, 200)
                    elseif distance < 1.5 and isGangAllowed(gang) then 
                        DrawSprite("orbit_ui", "key", 0, 0, 0.018, 0.030, 0, 255, 255, 255, 255)
                        DrawSprite("orbit_ui", "test2", 0.044, 0, 0.06, 0.028, 0, 255, 255, 255, 255)
                        if IsControlJustPressed(0, 38) then   
                            TriggerEvent('qb-gangs:client:OpenBossMenu')
                        end
                    end
                    ClearDrawOrigin()
                end
                Wait(0)
            end
        end)
    end
end

-- Function to add Clothing Menu Zone
local function addClothingMenuZone(gang, coords)
    if Config.UseTarget == "ox" then
        exports.ox_target:addSphereZone({
            coords = coords,
            radius = 1.5,
            options = {
                {
                    name = gang .. '_clothing_menu',
                    label = 'Open Outfit Menu',
                    onSelect = function()
                        TriggerEvent('qb-clothing:client:openOutfitMenu')
                    end,
                    canInteract = function(entity, distance, coords, name)
                        return distance < 1.5 and isGangAllowed(gang)
                    end
                }
            }
        })
    elseif Config.UseTarget == "qb" then
        exports['qb-target']:AddBoxZone(gang .. '_clothing_menu', coords, 1.5, 1.5, {
            name = gang .. '_clothing_menu',
            heading = 0,
            debugPoly = false,
            minZ = coords.z - 1,
            maxZ = coords.z + 1
        }, {
            options = {
                {
                    type = "client",
                    event = "qb-clothing:client:openOutfitMenu",
                    icon = "fas fa-tshirt",
                    label = "Open Outfit Menu",
                    canInteract = function(entity, distance, coords, name)
                        return distance < 1.5 and isGangAllowed(gang)
                    end
                }
            },
            distance = 1.5
        })
    elseif Config.UseTarget == "orbit" then
        Citizen.CreateThread(function()
            while true do
                local playerCoords = GetEntityCoords(PlayerPedId())
                local distance = GetDistanceBetweenCoords(playerCoords, coords.x, coords.y, coords.z, true)
                if distance < 8 then
                    SetDrawOrigin(coords.x, coords.y, coords.z + 1, 0)
                    if distance > 1.5 and distance < 8 and isGangAllowed(gang) then
                        DrawSprite("orbit_ui", "point", 0, 0, 0.015, 0.025, 0, 255, 255, 255, 200)
                    elseif distance < 1.5 and isGangAllowed(gang) then 
                        DrawSprite("orbit_ui", "key", 0, 0, 0.018, 0.030, 0, 255, 255, 255, 255)
                        DrawSprite("orbit_ui", "outfitmenu", 0.044, 0, 0.06, 0.028, 0, 255, 255, 255, 255)
                        if IsControlJustPressed(0, 38) then   
                            TriggerEvent('qb-clothing:client:openOutfitMenu')
                        end
                    end
                    ClearDrawOrigin()
                end
                Wait(0)
            end
        end)
    end
end

-- Function to add Stash Zone
local function addStashZone(gang, coords)
    if Config.UseTarget == "ox" then
        exports.ox_target:addSphereZone({
            coords = coords,
            radius = 1.5,
            options = {
                {
                    name = gang .. '_stash',
                    label = 'Open Stash',
                    onSelect = function()
                        TriggerEvent('d3-gang:client:openStash')
                    end,
                    canInteract = function(entity, distance, coords, name)
                        local playerData = QBCore.Functions.GetPlayerData()
                        local PlayerGang = playerData.gang.name
                        return distance < 1.5 and Config.Stashes[PlayerGang] ~= nil
                    end
                }
            }
        })
    elseif Config.UseTarget == "qb" then
        exports['qb-target']:AddBoxZone(gang .. '_stash', coords, 1.5, 1.5, {
            name = gang .. '_stash',
            heading = 0,
            debugPoly = false,
            minZ = coords.z - 1,
            maxZ = coords.z + 1
        }, {
            options = {
                {
                    type = "client",
                    event = "d3-gang:client:openStash",
                    icon = "fas fa-box",
                    label = "Open Stash",
                    canInteract = function(entity, distance, coords, name)
                        return distance < 1.5 and isGangAllowed(gang)
                    end
                }
            },
            distance = 1.5
        })
    elseif Config.UseTarget == "orbit" then
        Citizen.CreateThread(function()
            while true do
                local playerCoords = GetEntityCoords(PlayerPedId())
                local distance = GetDistanceBetweenCoords(playerCoords, coords.x, coords.y, coords.z, true)
                if distance < 8 then
                    SetDrawOrigin(coords.x, coords.y, coords.z + 1, 0)
                    if distance > 1.5 and distance < 8 and isGangAllowed(gang) then
                        DrawSprite("orbit_ui", "point", 0, 0, 0.015, 0.025, 0, 255, 255, 255, 200)
                    elseif distance < 1.5 and isGangAllowed(gang) then 
                        DrawSprite("orbit_ui", "key", 0, 0, 0.018, 0.030, 0, 255, 255, 255, 255)
                        DrawSprite("orbit_ui", "openstash", 0.044, 0, 0.06, 0.028, 0, 255, 255, 255, 255)
                        if IsControlJustPressed(0, 38) then   
                            TriggerEvent('d3-gang:client:openStash')
                        end
                    end
                    ClearDrawOrigin()
                end
                Wait(0)
            end
        end)
    end
end

local function addPersonalStashZone(gang, coords)
    if Config.UseTarget == "ox" then
        exports.ox_target:addSphereZone({
            coords = coords,
            radius = 1.5,
            options = {
                {
                    name = gang .. '_personal_stash',
                    label = 'Open Personal Stash',
                    onSelect = function()
                        local playerData = QBCore.Functions.GetPlayerData()
                        local stashName = "personalstash_" .. playerData.citizenid
                        TriggerEvent("inventory:client:SetCurrentStash", stashName)
                        TriggerServerEvent("inventory:server:OpenInventory", "stash", stashName, {
                            maxweight = 50000,
                            slots = 10,
                        })
                    end,
                    canInteract = function(entity, distance, coords, name)
                        return distance < 1.5 and isGangAllowed(gang)
                    end
                }
            }
        })
    elseif Config.UseTarget == "qb" then
        exports['qb-target']:AddBoxZone(gang .. '_personal_stash', coords, 1.5, 1.5, {
            name = gang .. '_personal_stash',
            heading = 0,
            debugPoly = false,
            minZ = coords.z - 1,
            maxZ = coords.z + 1
        }, {
            options = {
                {
                    type = "client",
                    event = "inventory:client:SetCurrentStash",
                    icon = "fas fa-box",
                    label = "Open Personal Stash",
                    canInteract = function(entity, distance, coords, name)
                        return distance < 1.5 and isGangAllowed(gang)
                    end
                }
            },
            distance = 1.5
        })
    elseif Config.UseTarget == "orbit" then
        Citizen.CreateThread(function()
            while true do
                local playerCoords = GetEntityCoords(PlayerPedId())
                local distance = GetDistanceBetweenCoords(playerCoords, coords.x, coords.y, coords.z, true)
                if distance < 8 then
                    SetDrawOrigin(coords.x, coords.y, coords.z + 1, 0)
                    if distance > 1.5 and distance < 8 and isGangAllowed(gang) then
                        DrawSprite("orbit_ui", "point", 0, 0, 0.015, 0.025, 0, 255, 255, 255, 200)
                    elseif distance < 1.5 and isGangAllowed(gang) then 
                        DrawSprite("orbit_ui", "key", 0, 0, 0.018, 0.030, 0, 255, 255, 255, 255)
                        DrawSprite("orbit_ui", "personalstash", 0.044, 0, 0.06, 0.028, 0, 255, 255, 255, 255)
                        if IsControlJustPressed(0, 38) then   
                            local playerData = QBCore.Functions.GetPlayerData()
                            local stashName = "personalstash_" .. playerData.citizenid
                            TriggerEvent("inventory:client:SetCurrentStash", stashName)
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", stashName, {
                                maxweight = 50000,
                                slots = 10,
                            })
                        end
                    end
                    ClearDrawOrigin()
                end
                Wait(0)
            end
        end)
    end
end

RegisterNetEvent("d3-gang:client:openStash", function()
    local playerData = QBCore.Functions.GetPlayerData()
    local PlayerGang = playerData.gang.name

    if PlayerGang and Config.Stashes[PlayerGang] then
        local stashConfig = Config.Stashes[PlayerGang]
        local stashName = stashConfig.stashName or (PlayerGang .. "stash")
        local maxweight = stashConfig.maxweight or 4000000
        local slots = stashConfig.slots or 500


        TriggerServerEvent("inventory:server:OpenInventory", "stash", stashName, {
            maxweight = maxweight,
            slots = slots,
        })
        TriggerEvent("inventory:client:SetCurrentStash", stashName)
    else
        QBCore.Functions.Notify('You are not part of a gang or stash is not configured', 'error')
    end
end)

Citizen.CreateThread(function()
    for gang, coords in pairs(Config.bossmenu) do
        addBossMenuZone(gang, coords)
    end

    for name, coords in pairs(Config.clothingMenu) do
        addClothingMenuZone(name, coords)
    end

    for gang, coords in pairs(Config.stash) do
        addStashZone(gang, coords)
    end
    
    for gang, coords in pairs(Config.personalStash) do
        addPersonalStashZone(gang, coords)
    end
end)
