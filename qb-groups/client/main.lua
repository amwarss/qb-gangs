local QBCore = exports[Config.QbCoreScriptName]:GetCoreObject()
local Config = Config or {}

local function isGroupAllowed(group, type)
    local playerData = QBCore.Functions.GetPlayerData()
    if not playerData then
        return false
    end
    
    if type == "gang" then
        return playerData.gang.name == group and Config.GroupRanks[group] == true
    elseif type == "job" then
        return playerData.job.name == group and Config.GroupRanks[group] == true
    end
    
    return false
end

RegisterNetEvent('qb-groups:client:OpenBossMenu', function()
    local playerData = QBCore.Functions.GetPlayerData()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local groupName, groupType

    for name, data in pairs(Config.bossmenu) do
        if #(playerCoords - data.coords) < 2.0 then
            groupName = name
            groupType = data.type
            break
        end
    end

    if not playerData or not groupName or not groupType then
        QBCore.Functions.Notify("Player data or group data is missing!", "error")
        return
    end

    if not playerData[groupType].isboss then 
        QBCore.Functions.Notify("Are You sure You are the Boss?", "error") 
        return 
    end
    
    local bossMenu = {}
    local gangMenu = {}

    if groupType == "job" then
        bossMenu[#bossMenu + 1] = {
            header = 'Boss Management - '.. string.upper(QBCore.Functions.GetPlayerData()[groupType].grade.name),
            icon = "fa-solid fa-circle-info",
            isMenuHeader = true,
        }
        bossMenu[#bossMenu + 1] = {
            header = 'Manage Employees',
            txt = 'Check your Employees List',
            icon = "fa-solid fa-list",
            params = {
                event = Config.bossMenuScriptName .. '-bossmenu:client:employeelist',
            }
        }
        bossMenu[#bossMenu + 1] = {
            header = "Hire Employees",
            txt = 'Hire Nearby Civilians',
            icon = "fa-solid fa-hand-holding",
            params = {
                event = Config.bossMenuScriptName .. '-bossmenu:client:HireMenu',
            }
        }
        bossMenu[#bossMenu + 1] = {
            header = "Storage Access",
            txt = 'Open Stash',
            icon = "fa-solid fa-sack-dollar",
            params = {
                event = Config.bossMenuScriptName .. '-bossmenu:client:Stash',
            }
        }
        bossMenu[#bossMenu + 1] = {
            header = "Money Management",
            txt = 'Check your Company Balance',
            icon = "fa-solid fa-sack-dollar",
            params = {
                event = Config.bossMenuScriptName .. '-bossmenu:client:SocietyMenu',
            }
        }
        bossMenu[#bossMenu + 1] = {
            header = "Close Menu",
            icon = "fa-duotone fa-circle-x",
            params = {
                event = Config.MenuScriptName .. ':closeMenu',
            }
        }
        exports[Config.MenuScriptName]:openMenu(bossMenu)
    elseif groupType == "gang" then
        gangMenu[#gangMenu + 1] = {
            header = 'Gang Management - '.. string.upper(QBCore.Functions.GetPlayerData()[groupType].grade.name),
            icon = "fa-solid fa-circle-info",
            isMenuHeader = true,
        }
        gangMenu[#gangMenu + 1] = {
            header = 'Manage Members',
            txt = 'Check your Members List',
            icon = "fa-solid fa-list",
            params = {
                event =  Config.bossMenuScriptName .. '-gangmenu:client:memberlist',
            }
        }
        gangMenu[#gangMenu + 1] = {
            header = "Recruit Members",
            txt = 'Recruit Nearby Civilians',
            icon = "fa-solid fa-hand-holding",
            params = {
                event =  Config.bossMenuScriptName .. '-gangmenu:client:RecruitMenu',
            }
        }
        gangMenu[#gangMenu + 1] = {
            header = "Storage Access",
            txt = 'Open Stash',
            icon = "fa-solid fa-sack-dollar",
            params = {
                event =  Config.bossMenuScriptName .. '-gangmenu:client:Stash',
            }
        }
        gangMenu[#gangMenu + 1] = {
            header = "Money Management",
            txt = 'Check your Gang Balance',
            icon = "fa-solid fa-sack-dollar",
            params = {
                event =  Config.bossMenuScriptName .. '-gangmenu:client:SocietyMenu',
            }
        }
        gangMenu[#gangMenu + 1] = {
            header = "Close Menu",
            icon = "fa-duotone fa-circle-x",
            params = {
                event = Config.MenuScriptName .. ':closeMenu',
            }
        }
        exports[Config.MenuScriptName]:openMenu(gangMenu)
    end
end)
-- Function to add Boss Menu Zone
local function addBossMenuZone(group, coords, type)
    if Config.UseTarget == "ox" then
        exports.ox_target:addSphereZone({
            coords = coords,
            radius = 1.5,
            options = {
                {
                    name = group .. '_boss_menu',
                    label = 'Open Boss Menu',
                    onSelect = function()
                        TriggerEvent('qb-groups:client:OpenBossMenu')
                    end,
                    canInteract = function(entity, distance, coords, name)
                        return distance < 1.5 and isGroupAllowed(group, type)
                    end
                }
            }
        })
    elseif Config.UseTarget == "qb" then
        exports['qb-target']:AddBoxZone(group .. '_boss_menu', coords, 1.5, 1.5, {
            name = group .. '_boss_menu',
            heading = 0,
            debugPoly = false,
            minZ = coords.z - 1,
            maxZ = coords.z + 1
        }, {
            options = {
                {
                    type = "client",
                    event = "qb-groups:client:OpenBossMenu",
                    icon = "fas fa-box",
                    label = "Open Boss Menu",
                    canInteract = function(entity, distance, coords, name)
                        return distance < 1.5 and isGroupAllowed(group, type)
                    end
                }
            },
            distance = 1.5
        })
    elseif Config.UseTarget == "interact" then
        exports.interact:AddInteraction({
            coords = vector3(coords.x, coords.y, coords.z),
            distance = 8.0,
            interactDst = 1.5,
            id = group .. '_boss_menu',
            name = 'OpenBossMenu',
            groups = {
                [group] = 0, -- ضبط المجموعة المطلوبة هنا
            },
            options = {
                {
                    label = 'Open Boss Menu',
                    action = function(entity, coords, args)
                        if isGroupAllowed(group, type) then
                            TriggerEvent('qb-groups:client:OpenBossMenu')
                        end
                    end,
                },
            }
        })
    end
end


if Config.UseInventory == "old" then
    function addPersonalStashZone(group, coords, type)
        if Config.UseTarget == "ox" then
            exports.ox_target:addSphereZone({
                coords = coords,
                radius = 1.5,
                options = {
                    {
                        name = group .. '_personal_stash',
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
                            return distance < 1.5 and isGroupAllowed(group, type)
                        end
                    }
                }
            })
        elseif Config.UseTarget == "qb" then
            exports['qb-target']:AddBoxZone(group .. '_personal_stash', coords, 1.5, 1.5, {
                name = group .. '_personal_stash',
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
                            return distance < 1.5 and isGroupAllowed(group, type)
                        end
                    }
                },
                distance = 1.5
            })
        elseif Config.UseTarget == "interact" then
            exports.interact:AddInteraction({
                coords = vector3(coords.x, coords.y, coords.z),
                distance = 8.0,
                interactDst = 1.5,
                id = group .. 'personalstash_',
                name = 'personalstash',
                groups = {
                    [group] = 0, -- ضبط المجموعة المطلوبة هنا
                },
                options = {
                    {
                        label = 'Open Personal Stash',
                        action = function(entity, coords, args)
                            if isGroupAllowed(group, type) then
                                local playerData = QBCore.Functions.GetPlayerData()
                                local stashName = "personalstash_" .. playerData.citizenid
                                TriggerEvent("inventory:client:SetCurrentStash", stashName)
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", stashName, {
                                    maxweight = 500000,
                                    slots = 10,
                                })
                            end
                        end,
                    },
                }
            })
        end
    end
elseif Config.UseInventory == "new" then
    function addPersonalStashZone(group, coords, type)
        if Config.UseTarget == "ox" then
            exports.ox_target:addSphereZone({
                coords = coords,
                radius = 1.5,
                options = {
                    {
                        name = group .. '_PersonalStash',
                        label = 'Open personal Stash',
                        onSelect = function()
                            TriggerServerEvent('qb-groups:server:personalStash')
                        end,
                        canInteract = function(entity, distance, coords, name)
                            return distance < 1.5 and isGroupAllowed(group, type)
                        end
                    }
                }
            })
        elseif Config.UseTarget == "qb" then
            exports['qb-target']:AddBoxZone(group .. '_PersonalStash', coords, 1.5, 1.5, {
                name = group .. '_PersonalStash',
                heading = 0,
                debugPoly = false,
                minZ = coords.z - 1,
                maxZ = coords.z + 1
            }, {
                options = {
                    {
                        type = "server",
                        event = "qb-groups:server:personalStash",
                        icon = "fas fa-box",
                        label = "Open personal Stash",
                        canInteract = function(entity, distance, coords, name)
                            return distance < 1.5 and isGroupAllowed(group, type)
                        end
                    }
                },
                distance = 1.5
            })
        elseif Config.UseTarget == "interact" then
            exports.interact:AddInteraction({
                coords = vector3(coords.x, coords.y, coords.z),
                distance = 8.0,
                interactDst = 1.5,
                id = group .. 'personalstash_',
                name = 'personalstash',
                groups = {
                    [group] = 0, -- ضبط المجموعة المطلوبة هنا
                },
                options = {
                    {
                        label = 'Open Personal Stash',
                        action = function(entity, coords, args)
                            if isGroupAllowed(group, type) then
                                TriggerServerEvent('qb-groups:server:personalStash')
                            end
                        end,
                    },
                }
            })
        end
    end
end



-- Function to add Clothing Menu Zone
local function addClothingMenuZone(group, coords, type)
    if Config.UseTarget == "ox" then
        exports.ox_target:addSphereZone({
            coords = coords,
            radius = 1.5,
            options = {
                {
                    name = group .. '_clothing_menu',
                    label = 'Open Outfit Menu',
                    onSelect = function()
                        TriggerEvent('qb-clothing:client:openOutfitMenu')
                    end,
                    canInteract = function(entity, distance, coords, name)
                        return distance < 1.5 and isGroupAllowed(group, type)
                    end
                }
            }
        })
    elseif Config.UseTarget == "qb" then
        exports['qb-target']:AddBoxZone(group .. '_clothing_menu', coords, 1.5, 1.5, {
            name = group .. '_clothing_menu',
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
                        return distance < 1.5 and isGroupAllowed(group, type)
                    end
                }
            },
            distance = 1.5
        })
    elseif Config.UseTarget == "interact" then
        exports.interact:AddInteraction({
            coords = vector3(coords.x, coords.y, coords.z),
            distance = 8.0,
            interactDst = 1.5,
            id = group .. '_clothing_menu',
            name = '_clothing_menu',
            groups = {
                [group] = 0, -- ضبط المجموعة المطلوبة هنا
            },
            options = {
                {
                    label = 'Open Outfit Menu',
                    action = function(entity, coords, args)
                        if isGroupAllowed(group, type) then
                            TriggerEvent('qb-clothing:client:openOutfitMenu')
                        end
                    end,
                },
            }
        })
    end
end

-- Function to add Stash Zone
if Config.UseInventory == "old" then
    function addStashZone(group, coords, type)
        if Config.UseTarget == "ox" then
            exports.ox_target:addSphereZone({
                coords = coords,
                radius = 1.5,
                options = {
                    {
                        name = group .. '_stash',
                        label = 'Open Stash',
                        onSelect = function()
                            TriggerEvent('qb-groups:client:Stash')
                        end,
                        canInteract = function(entity, distance, coords, name)
                            return distance < 1.5 and isGroupAllowed(group, type)
                        end
                    }
                }
            })
        elseif Config.UseTarget == "qb" then
            exports['qb-target']:AddBoxZone(group .. '_stash', coords, 1.5, 1.5, {
                name = group .. '_stash',
                heading = 0,
                debugPoly = false,
                minZ = coords.z - 1,
                maxZ = coords.z + 1
            }, {
                options = {
                    {
                        type = "client",
                        event = "qb-groups:client:Stash",
                        icon = "fas fa-box",
                        label = "Open Stash",
                        canInteract = function(entity, distance, coords, name)
                            return distance < 1.5 and isGroupAllowed(group, type)
                        end
                    }
                },
                distance = 1.5
            })
        elseif Config.UseTarget == "interact" then
            exports.interact:AddInteraction({
                coords = vector3(coords.x, coords.y, coords.z),
                distance = 8.0,
                interactDst = 1.5,
                id = group .. '_stash',
                name = '_stash',
                groups = {
                    [group] = 0, -- ضبط المجموعة المطلوبة هنا
                },
                options = {
                    {
                        label = 'Open Stash',
                        action = function(entity, coords, args)
                            if isGroupAllowed(group, type) then
                                TriggerEvent('qb-groups:client:Stash')
                            end
                        end,
                    },
                }
            })
    end
end
elseif Config.UseInventory == "new" then
    function addStashZone(group, coords, type)
        if Config.UseTarget == "ox" then
            exports.ox_target:addSphereZone({
                coords = coords,
                radius = 1.5,
                options = {
                    {
                        name = group .. '_stash',
                        label = 'Open Stash',
                        onSelect = function()
                            TriggerServerEvent('qb-groups:server:stash')
                        end,
                        canInteract = function(entity, distance, coords, name)
                            return distance < 1.5 and isGroupAllowed(group, type)
                        end
                    }
                }
            })
        elseif Config.UseTarget == "qb" then
            exports['qb-target']:AddBoxZone(group .. '_stash', coords, 1.5, 1.5, {
                name = group .. '_stash',
                heading = 0,
                debugPoly = false,
                minZ = coords.z - 1,
                maxZ = coords.z + 1
            }, {
                options = {
                    {
                        type = "server",
                        event = "qb-groups:server:stash",
                        icon = "fas fa-box",
                        label = "Open Stash",
                        canInteract = function(entity, distance, coords, name)
                            return distance < 1.5 and isGroupAllowed(group, type)
                        end
                    }
                },
                distance = 1.5
            })
        elseif Config.UseTarget == "interact" then
            exports.interact:AddInteraction({
                coords = vector3(coords.x, coords.y, coords.z),
                distance = 8.0,
                interactDst = 1.5,
                id = group .. '_stash',
                name = '_stash',
                groups = {
                    [group] = 0, -- ضبط المجموعة المطلوبة هنا
                },
                options = {
                    {
                        label = 'Open Stash',
                        action = function(entity, coords, args)
                            if isGroupAllowed(group, type) then
                                TriggerServerEvent('qb-groups:server:stash')
                            end
                        end,
                    },
                }
            })
        end
    end
end

local function addVehicleMenuZone(group, coords, type, vehicles, spawnCoords, npcCoords, npcModel, returnCoords)
    -- إنشاء البوت
    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do
        Wait(0)
    end
    local npc = CreatePed(4, npcModel, npcCoords.x, npcCoords.y, npcCoords.z, npcCoords.w, false, true)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)

    -- إنشاء منطقة استخراج السيارات
    if Config.UseTarget == "ox" then
        exports.ox_target:addSphereZone({
            coords = coords,
            radius = 1.5,
            options = {
                {
                    name = group .. '_vehicle_menu',
                    label = 'Open Vehicle Menu',
                    onSelect = function()
                        TriggerEvent('code-vehicle:client:openVehicleMenu', vehicles, spawnCoords)
                    end,
                    canInteract = function(entity, distance, coords, name)
                        return distance < 1.5 and isGroupAllowed(group, type)
                    end
                }
            }
        })
    elseif Config.UseTarget == "qb" then
        exports['qb-target']:AddBoxZone(group .. '_vehicle_menu', coords, 1.5, 1.5, {
            name = group .. '_vehicle_menu',
            heading = 0,
            debugPoly = false,
            minZ = coords.z - 1,
            maxZ = coords.z + 1
        }, {
            options = {
                {
                    type = "client",
                    event = "code-vehicle:client:openVehicleMenu",
                    icon = "fas fa-car",
                    label = "Open Vehicle Menu",
                    canInteract = function(entity, distance, coords, name)
                        return distance < 1.5 and isGroupAllowed(group, type)
                    end,
                    args = {vehicles, spawnCoords}
                }
            },
            distance = 1.5
        })
    elseif Config.UseTarget == "interact" then
        exports.interact:AddInteraction({
            coords = vector3(coords.x, coords.y, coords.z),
            distance = 8.0,
            interactDst = 1.5,
            id = group .. '_stash',
            name = '_stash',
            groups = {
                [group] = 0, -- ضبط المجموعة المطلوبة هنا
            },
            options = {
                {
                    label = 'Open Vehicle Menu',
                    action = function(entity, coords, args)
                        if isGroupAllowed(group, type) then
                            TriggerEvent('code-vehicle:client:openVehicleMenu', vehicles, spawnCoords)
                        end
                    end,
                },
            }
        })
    end

    Citizen.CreateThread(function()
        local textShowing = false
        while true do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = GetDistanceBetweenCoords(playerCoords, returnCoords.x, returnCoords.y, returnCoords.z, true)
            if distance < 10 then
                if distance < 2.0 then
                    if not textShowing then
                        exports[Config.QbCoreScriptName]:DrawText("Return Vehicle", "E")
                        textShowing = true
                    end
                    if IsControlJustPressed(0, 38) then
                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                        if vehicle ~= 0 then
                            QBCore.Functions.DeleteVehicle(vehicle)
                            QBCore.Functions.Notify("Vehicle Returned", "success")
                            exports[Config.QbCoreScriptName]:HideText()
                            textShowing = false
                        end
                    end
                elseif textShowing then
                    exports[Config.QbCoreScriptName]:HideText()
                    textShowing = false
                end
            elseif textShowing then
                exports[Config.QbCoreScriptName]:HideText()
                textShowing = false
            end
            Wait(0)
        end
    end)
end



RegisterNetEvent('code-vehicle:client:openVehicleMenu')
AddEventHandler('code-vehicle:client:openVehicleMenu', function(vehicles, spawnCoords)
    local menuOptions = {}
    for _, vehicle in ipairs(vehicles) do
        table.insert(menuOptions, {
            header = vehicle,
            txt = "Spawn this vehicle",
            params = {
                event = 'code-vehicle:client:spawnVehicle',
                args = {
                    vehicle = vehicle,
                    spawnCoords = spawnCoords
                }
            }
        })
    end

    table.insert(menuOptions, {
        header = "Close",
        txt = "",
        params = {
            event = Config.MenuScriptName .. ':client:closeMenu'
        }
    })

    exports[Config.MenuScriptName]:openMenu(menuOptions)
end)


RegisterNetEvent('code-vehicle:client:spawnVehicle')
AddEventHandler('code-vehicle:client:spawnVehicle', function(data)
    local vehicle = data.vehicle
    local spawnCoords = data.spawnCoords

    QBCore.Functions.SpawnVehicle(vehicle, function(spawnedVehicle)
        SetEntityCoords(spawnedVehicle, spawnCoords.x, spawnCoords.y, spawnCoords.z)
        SetEntityHeading(spawnedVehicle, spawnCoords.w)
        TaskWarpPedIntoVehicle(PlayerPedId(), spawnedVehicle, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(spawnedVehicle))
        exports[Config.MenuScriptName]:closeMenu() -- إغلاق القائمة بعد رسبون المركبة
    end, spawnCoords, true)
end)


RegisterNetEvent("qb-groups:client:Stash", function()
    local playerData = QBCore.Functions.GetPlayerData()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local nearbyStash
    if playerData.gang.name and Config.Stashes[playerData.gang.name] then
        local gangStash = Config.Stashes[playerData.gang.name]
        local gangDistance = #(playerCoords - gangStash.coords)
        if gangDistance < 5.0 then
            nearbyStash = {
                stashName = gangStash.stashName or (playerData.gang.name .. "stash"),
                maxweight = gangStash.maxweight or 4000000,
                slots = gangStash.slots or 500,
                type = "gang"
            }
        end
    end

    if playerData.job.name and Config.Stashes[playerData.job.name] then
        local jobStash = Config.Stashes[playerData.job.name]
        local jobDistance = #(playerCoords - jobStash.coords)
        if jobDistance < 5.0 then
            nearbyStash = {
                stashName = jobStash.stashName or (playerData.job.name .. "stash"),
                maxweight = jobStash.maxweight or 4000000,
                slots = jobStash.slots or 500,
                type = "job"
            }
        end
    end

    -- افتح الخزنة إذا تم العثور على خزنة قريبة
    if nearbyStash then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", nearbyStash.stashName, {
            maxweight = nearbyStash.maxweight,
            slots = nearbyStash.slots,
        })
        TriggerEvent("inventory:client:SetCurrentStash", nearbyStash.stashName)
    else
        QBCore.Functions.Notify('You are not near any stash location', 'error')
    end
end)



Citizen.CreateThread(function()
    for group, data in pairs(Config.bossmenu) do
        addBossMenuZone(group, data.coords, data.type)
    end
 
    for group, data in pairs(Config.clothingMenu) do
        addClothingMenuZone(group, data.coords, data.type)
    end 

    if Config.vehicleMenuEnabled then
        for group, data in pairs(Config.vehicleMenu) do
            addVehicleMenuZone(group, data.coords, data.type, data.vehicles, data.spawnCoords, data.npcCoords, data.npcModel, data.returnCoords)
        end
    end
    
    for group, data in pairs(Config.stash) do
        addStashZone(group, data.coords, data.type)
    end
    
    for group, data in pairs(Config.personalStash) do
        addPersonalStashZone(group, data.coords, data.type)
    end
end)