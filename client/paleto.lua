local QBCore = exports['qb-core']:GetCoreObject()
local copsCalled = false


-- testing

RegisterCommand('testlaptop', function()
    print('penis 1')
    TriggerEvent('qb-bankrobbery:use:laptop')
    
end, false)

RegisterCommand('testthermite', function()
    print('penis 1')
    TriggerEvent('qb-bankrobbery:paleto:thermitegate')
    
end, false)



--- Functions


local function SpawnTrolleys(data, name)
    RequestModel("hei_prop_hei_cash_trolly_01")
    while not HasModelLoaded("hei_prop_hei_cash_trolly_01") do
        Citizen.Wait(1)
    end
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    TrolleyPaletoBank = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), -103.47, 6477.78, 30.63, 1, 1, 0) -- vector4(-103.47, 6477.78, 31.63, 46.18)

    local h1 = GetEntityHeading(TrolleyPaletoBank)


    SetEntityHeading(TrolleyPaletoBank, h1 + 46.18)

    done = false
end


local function RemoveItem(itemname, amount)
    TriggerServerEvent("QBCore:Server:RemoveItem", itemname, amount)
    TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[itemname], "remove")
end

function OpenThermiteGate()
    TriggerServerEvent('qb-doorlock:server:updateState', 5, false, false, false, true, false, false)
end

local function OpenVault()
    QBCore.Functions.Notify('Give it some time to open!', 'success', 5000)
    Citizen.Wait(Config.PaletoTime)
    SpawnTrolleys(data, name)
    TriggerServerEvent('qb-doorlock:server:updateState', 4, false, false, false, true, false, false)
    TriggerServerEvent('qb-bankrobbery:server:setBankState', "paleto", true)
end

local function callPolice()
    local PaletoCoords = -110.35, 6466.69, 31.63
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    Citizen.Wait(Config.CopCallTime)
    if copsCalled or not Config.BigBanks["paleto"]["alarm"] then return end
    if Config.Dispatch == "default" then
        TriggerServerEvent("qb-bankrobbery:server:callCops", "paleto", 0, streetLabel, pos)
    elseif Config.Dispatch == "core_dispatch"  then
        TriggerServerEvent("core_dispatch:addCall", "10-90", "Paleto Savings Bank", PaletoCoords, "police", "5000", "11", "5")
    elseif Config.Dispatch == "other" then
        -- This is where you insert your dispatch event. 
    else 
        print("Error, please send this to the server owner and report a bug.") -- This means you have incorrectly defined your dispatch system.
    end

    copsCalled = true
end


local function OnHackDone(success)
    if success then
        TriggerEvent('mhacking:hide')
        RemoveItem(Config.PaletoRequiredItem, 1)
        OpenVault()
        callPolice()
    else
        QBCore.Functions.Notify('You failed the hack.', "error")
		TriggerEvent('mhacking:hide')
	end
end

-- Events

RegisterNetEvent('qb-bankrobbery:use:laptop', function()
    print('penis 2')
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    if math.random(1, 100) <= 85 and not QBCore.Functions.IsWearingGloves() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    local dist = #(pos - Config.PaletoCoords)
    if dist < 1.5 then
        QBCore.Functions.TriggerCallback('qb-bankrobbery:server:isRobberyActive', function(isBusy)
            if not isBusy then
                if CurrentCops >= Config.MinimumPaletoPolice then

                    if not Config.BigBanks["paleto"]["isOpened"] then
                        QBCore.Functions.TriggerCallback('QBCore:HasItem', function(hasItem)
                            if hasItem then
                                TriggerEvent('inventory:client:requiredItems', nil, false)
                                print('Penis 3')
                                QBCore.Functions.Progressbar("security_pass", Config.PaletoProgressMessage, math.random(5000, 10000), false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "anim@gangops@facility@servers@",
                                    anim = "hotwire",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    StopAnimTask(ped, "anim@gangops@facility@servers@", "hotwire", 1.0)
                                    if Config.HackType == "hacking" then 
                                        exports["hacking"]:hacking(
                                        function() -- success
                                            RemoveItem(Config.PaletoRequiredItem, 1)
                                            local ped = PlayerPedId()
                                            local playerPos = GetEntityCoords(ped)
                                            QBCore.Functions.Notify('Done! Give it some time to crack it.', "success")
                                            OpenVault()
                                            callPolice()
                                        end,

                                        function() -- failure
                                            QBCore.Functions.Notify('You failed the hack.', "error")
                                            RemoveItem(Config.PaletoRequiredItem, 1)
                                        end)
                                    elseif Config.HackType == "mhacking" then
                                        TriggerEvent("mhacking:show")
                                        TriggerEvent("mhacking:start", math.random(6, 7), math.random(12, 15), OnHackDone)
                                    end
                                    
                                end, function() -- Cancel
                                    StopAnimTask(ped, "anim@gangops@facility@servers@", "hotwire", 1.0)
                                    QBCore.Functions.Notify("Canceled..", "error")
                                end)
                            else
                                QBCore.Functions.Notify("You don't have the items required.", "error")
                            end
                        end, Config.PaletoRequiredItem)
                        
                    else
                        QBCore.Functions.Notify("It looks like the bank is already opened..", "error")
                    end
                else
                    QBCore.Functions.Notify('Minimum Of '..Config.MinimumPaletoPolice..' Police Needed', "error")
                end
            else
                QBCore.Functions.Notify("The security lock is active, the door cannot be opened at the moment..", "error", 5500)
            end
        end)
    else
        if dist < 3 then
            QBCore.Functions.Notify("You are too far to plug it in.", "error", 5500)
        else
            QBCore.Functions.Notify("I dont see anywhere to plug it in.", "error", 5500)

        end
    end
end)

RegisterNetEvent('qb-bankrobbery:use:thermite', function()
    local ped = PlayerPedId()
    local loc = GetEntityCoords(ped)
    local pos = GetEntityCoords(ped)
    local dist = #(pos - vector3(-106.15, 6475.25, 30.63))
    if dist < 2.5 then
        TriggerEvent("qb-bankrobbery:paleto:thermitegate")
    else
        TriggerEvent("qb-bankrobbery:pacific:thermitegate")
    end
end)

RegisterNetEvent('qb-bankrobbery:paleto:thermitegate', function()
    local ped = PlayerPedId()
    local loc = GetEntityCoords(ped)
    local pos = GetEntityCoords(ped)
    if math.random(1, 100) <= 85 and not QBCore.Functions.IsWearingGloves() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    local dist = #(pos - vector3(-106.15, 6475.25, 30.63))
    if dist < 1.5 then
        QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
            if HasItem then
                
                if thermited then
                    TriggerEvent('notification', 'Seems to be burnt already.', 2, 3500)
                else

                    print('Paleto Gate Thermite: In Progress')
                    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
                    RequestModel("hei_p_m_bag_var22_arm_s")
                    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") do
                        Citizen.Wait(0)
                    end
                    local ped = PlayerPedId()
                    SetEntityCoords(ped, -105.85, 6474.95, 31.63) -- vector3(-105.85, 6474.95, 31.63)
                    SetEntityHeading(ped, 307.86)
                    Citizen.Wait(500)
                    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
                    local bagscene = NetworkCreateSynchronisedScene(loc.x + 0.2, loc.y + 0.2, loc.z + 0.2, rotx, roty, rotz + 0.0, 2, false, false, 1065353216, 0, 1.3)
                    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), loc.x + 0.2, loc.y + 0.2, loc.z + 0.2,  true,  true, false)
                    SetEntityCollision(bag, false, true)
                    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
                    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
                    local curVar = GetPedDrawableVariation(ped, 5)
                    SetPedComponentVariation(ped, 5, 0, 0, 0)
                    NetworkStartSynchronisedScene(bagscene)
                    Citizen.Wait(1500)
                    local x, y, z = table.unpack(GetEntityCoords(ped))
                    local charge = CreateObject(GetHashKey("hei_prop_heist_thermite"), x+ 0.2 , y+ 0.2, z + 0.2,  true,  true, true)
                    SetEntityCollision(charge, false, false)
                    AttachEntityToEntity(charge, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
                    Citizen.Wait(4000)
                    DeleteObject(bag)
                    if curVar > 0 then
                        SetPedComponentVariation(ped, 5, curVar, 0, 0)
                    end

                    DetachEntity(charge, 1, 1)
                    SetEntityCoords(charge, -105.42, 6475.02, 32.05)
                    FreezeEntityPosition(charge, true)
                    NetworkStopSynchronisedScene(bagscene)
                    exports["qb-bankrobbery-target"]:thermiteminigame(10, 3, 3, 6,

                    function() -- success
                        thermited = true
                        RemoveItem(Config.PaletoThermiteItem, 1)
                        TriggerEvent('notification', 'Stay there and make sure it burns!', 1, 3500)
                        TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
                        TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 6000, 49, 1, 0, 0, 0)
                        Citizen.Wait(500)
                        AddExplosion(-105.42, 6475.02, 32.05, 22, 2.0, false, false, 5.0) -- vector3(-105.42, 6475.18, 32.95) -- Code 22: 50 seconds, Flare (BEST VISUAL) == 
                        Citizen.Wait(50000)
                        ClearPedTasks(ped)
                        DeleteObject(charge)
                        OpenThermiteGate()
                        local PlayerData = QBCore.Functions.GetPlayerData()
                        local PlayerID = PlayerData.citizenid
                        print('Citizen ID: '..PlayerID..' Has Successfully Thermited the Paleto Interior Gate!')
                        Citizen.Wait(600000)

                    end,

                    function() -- failure
                        TriggerEvent('notification', 'Failed.', 2, 3500)
                        DeleteObject(charge)
                        ClearPedTasks(ped)
                        RemoveItem(Config.PaletoThermiteItem, 1)
                    end)

                end
            else
                QBCore.Functions.Notify('A lockpick cant open this!', 'error', 7500)
            end
        end, 'thermite')
    else
        QBCore.Functions.Notify('I cant set the charge this far away.', 'error', 7500)
    end

end)
