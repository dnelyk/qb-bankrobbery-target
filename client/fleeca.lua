QBCore = exports['qb-core']:GetCoreObject()

local closestBank = nil
local banktype = nil
local inRange
local requiredItemsShowed = false
local copsCalled = false
local PlayerJob = {}
local refreshed = false
hacking = false
currentThermiteGate = 0
CurrentCops = 0
isgrabbingfleeca = false
isgrabbingpaleto = false
isgrabbingpacific = false

-- Functions

local function ResetBankDoors()
    for k, v in pairs(Config.SmallBanks) do
        local object = GetClosestObjectOfType(Config.SmallBanks[k]["coords"]["x"], Config.SmallBanks[k]["coords"]["y"], Config.SmallBanks[k]["coords"]["z"], 5.0, Config.SmallBanks[k]["object"], false, false, false)
        if not Config.SmallBanks[k]["isOpened"] then
            SetEntityHeading(object, Config.SmallBanks[k]["heading"].closed)
        else
            SetEntityHeading(object, Config.SmallBanks[k]["heading"].open)
        end
    end
    if not Config.BigBanks["paleto"]["isOpened"] then
        local paletoObject = GetClosestObjectOfType(Config.BigBanks["paleto"]["coords"]["x"], Config.BigBanks["paleto"]["coords"]["y"], Config.BigBanks["paleto"]["coords"]["z"], 5.0, Config.BigBanks["paleto"]["object"], false, false, false)
        SetEntityHeading(paletoObject, Config.BigBanks["paleto"]["heading"].closed)
    else
        local paletoObject = GetClosestObjectOfType(Config.BigBanks["paleto"]["coords"]["x"], Config.BigBanks["paleto"]["coords"]["y"], Config.BigBanks["paleto"]["coords"]["z"], 5.0, Config.BigBanks["paleto"]["object"], false, false, false)
        SetEntityHeading(paletoObject, Config.BigBanks["paleto"]["heading"].open)
    end

    if not Config.BigBanks["pacific"]["isOpened"] then
        local pacificObject = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
        SetEntityHeading(pacificObject, Config.BigBanks["pacific"]["heading"].closed)
    else
        local pacificObject = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
        SetEntityHeading(pacificObject, Config.BigBanks["pacific"]["heading"].open)
    end
end

local function SpawnTrolleys(data, name)
    RequestModel("hei_prop_hei_cash_trolly_01")
    while not HasModelLoaded("hei_prop_hei_cash_trolly_01") do
        Citizen.Wait(1)
    end
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    if Config.SmallBanks[closestBank]["label"] == "Legion Square" and Config.SmallBanks[closestBank]["isOpened"] == false then

        TrolleyLegionBank = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), 150.81, -1046.54, 28.35, 1, 1, 0)

    elseif Config.SmallBanks[closestBank]["label"] == "Pink Cage" and Config.SmallBanks[closestBank]["isOpened"] == false then   
        
        TrolleyPinkCageBank = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), 315.21, -284.86, 53.14, 1, 1, 0) -- OG Height (54.14)
        
    elseif Config.SmallBanks[closestBank]["label"] == "Hawick Ave" and Config.SmallBanks[closestBank]["isOpened"] == false then      

        TrolleyHawickBank = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), -349.73, -55.73, 48.01, 1, 1, 0)
        
    elseif Config.SmallBanks[closestBank]["label"] == "Del Perro Blvd" and Config.SmallBanks[closestBank]["isOpened"] == false then      

        TrolleyDelPerroBank = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), -1207.68, -333.8, 36.76, 1, 1, 0)
        
    elseif Config.SmallBanks[closestBank]["label"] == "Great Ocean Hwy" and Config.SmallBanks[closestBank]["isOpened"] == false then

        TrolleyGreatOceanBank = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), -2957.37, 485.84, 14.68, 1, 1, 0)
    
    elseif Config.SmallBanks[closestBank]["label"] == "East" and Config.SmallBanks[closestBank]["isOpened"] == false then

        TrolleyEastBank = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), 1172.15, 2711.97, 38.07, 1, 1, 0)
    else

        QBCore.Functions.Notify('Error!', "error")
    end

    local h1 = GetEntityHeading(TrolleyLegionBank)
    local h2 = GetEntityHeading(TrolleyPinkCageBank)
    local h3 = GetEntityHeading(TrolleyHawickBank)
    local h4 = GetEntityHeading(TrolleyDelPerroBank)
    local h5 = GetEntityHeading(TrolleyGreatOceanBank)
    local h6 = GetEntityHeading(TrolleyEastBank)


    SetEntityHeading(TrolleyLegionBank, h1 + 67.5)
    SetEntityHeading(TrolleyPinkCageBank, h2 + 66.25)
    SetEntityHeading(TrolleyHawickBank, h3 + 75.33)
    SetEntityHeading(TrolleyDelPerroBank, h4 + 115.94)
    SetEntityHeading(TrolleyGreatOceanBank, h5 + 174.95)
    SetEntityHeading(TrolleyEastBank, h6 + 270.19)

    done = false
end

RegisterCommand('testpayout', function()
    Payout()
    TriggerEvent("mhacking:show")
    TriggerEvent("mhacking:start", math.random(6, 7), math.random(12, 15), OnHackDone)

end, false)

function Payout()
    -- if Config.SmallBanks[closestBank]["label"] == "Legion Square" then
    --     banktype = "fleeca"
    -- elseif Config.SmallBanks[closestBank]["label"] == "Pink Cage" then   
    --     banktype = "fleeca"
    -- elseif Config.SmallBanks[closestBank]["label"] == "Hawick Ave" then      
    --     banktype = "fleeca"
    -- elseif Config.SmallBanks[closestBank]["label"] == "Del Perro Blvd" then      
    --     banktype = "fleeca"
    -- elseif Config.SmallBanks[closestBank]["label"] == "Great Ocean Hwy" then
    --     banktype = "fleeca"
    -- elseif Config.SmallBanks[closestBank]["label"] == "East" then
    --     banktype = "fleeca"
    -- end

    Citizen.Wait(100)

    if banktype == "fleeca" then
        local itemamount = Config.RandomItemAmount -- math.random(13, 19)

        TriggerServerEvent("QBCore:Server:AddItem", Config.FleecaItem, itemamount)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.FleecaItem], "add")
    else
        local itemamount = Config.RandomItemAmount -- math.random(13, 19)

        TriggerServerEvent("QBCore:Server:AddItem", "weapon_rpk16", itemamount)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["weapon_rpk16"], "add")
        print('Payout set for: Paleto Bank')
    end

end


local function StartGrab()
    if not isgrabbing then

        -- if Config.SmallBanks[closestBank]["label"] == "Legion Square" then
        --     banktype = "fleeca"
        -- elseif Config.SmallBanks[closestBank]["label"] == "Pink Cage" then   
        --     banktype = "fleeca"
        -- elseif Config.SmallBanks[closestBank]["label"] == "Hawick Ave" then      
        --     banktype = "fleeca"
        -- elseif Config.SmallBanks[closestBank]["label"] == "Del Perro Blvd" then      
        --     banktype = "fleeca"
        -- elseif Config.SmallBanks[closestBank]["label"] == "Great Ocean Hwy" then
        --     banktype = "fleeca"
        -- elseif Config.SmallBanks[closestBank]["label"] == "East" then
        --     banktype = "fleeca"
        -- else
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local dist = #(pos - Config.PaletoCoords)
            if dist < 15.5 then
                banktype = "paleto"
            else
                banktype = "fleeca"
            end
        -- end

        print(banktype)

        print('---- Bank Types ----')
        if isgrabbing then
            print('Grabbing Fleeca Tray')
        end

        if Config.Stress then
            QBCore.Functions.Notify('Stress Gained', "error")
            TriggerServerEvent('hud:server:GainStress', Config.StressAmount)
        end
        disableinput = true
        local ped = PlayerPedId()
        local model = "hei_prop_heist_cash_pile"
        LocalPlayer.state:set("inv_busy", true, true) -- Busy

        Trolley = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, GetHashKey("hei_prop_hei_cash_trolly_01"), false, false, false)
        local CashAppear = function()
            local pedCoords = GetEntityCoords(ped)
            local grabmodel = GetHashKey(model)

            RequestModel(grabmodel)
            while not HasModelLoaded(grabmodel) do
                Citizen.Wait(100)
            end
            local grabobj = CreateObject(grabmodel, pedCoords, true)

            FreezeEntityPosition(grabobj, true)
            SetEntityInvincible(grabobj, true)
            SetEntityNoCollisionEntity(grabobj, ped)
            SetEntityVisible(grabobj, false, false)
            AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
            local startedGrabbing = GetGameTimer()

            Citizen.CreateThread(function()
                while GetGameTimer() - startedGrabbing < 37000 do
                    Citizen.Wait(1)
                    DisableControlAction(0, 73, true)
                    if HasAnimEventFired(ped, GetHashKey("CASH_APPEAR")) then
                        if not IsEntityVisible(grabobj) then
                            SetEntityVisible(grabobj, true, false)
                        end
                    end
                    if HasAnimEventFired(ped, GetHashKey("RELEASE_CASH_DESTROY")) then
                        if IsEntityVisible(grabobj) then
                            SetEntityVisible(grabobj, false, false)
                        end
                    end
                end
                DeleteObject(grabobj)
            end)
        end
        local trollyobj = Trolley
        local emptyobj = GetHashKey("hei_prop_hei_cash_trolly_03")

        if IsEntityPlayingAnim(trollyobj, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
            return
        end
        local baghash = GetHashKey("hei_p_m_bag_var22_arm_s")

        RequestAnimDict("anim@heists@ornate_bank@grab_cash")
        RequestModel(baghash)
        RequestModel(emptyobj)
        while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and not HasModelLoaded(baghash) do
            Citizen.Wait(100)
        end
        while not NetworkHasControlOfEntity(trollyobj) do
            Citizen.Wait(1)
            NetworkRequestControlOfEntity(trollyobj)
        end
        local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), GetEntityCoords(PlayerPedId()), true, false, false)
        local scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

        NetworkAddPedToSynchronisedScene(ped, scene1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(bag, scene1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        NetworkStartSynchronisedScene(scene1)
        Citizen.Wait(1500)
        CashAppear()
        local scene2 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

        NetworkAddPedToSynchronisedScene(ped, scene2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(bag, scene2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(trollyobj, scene2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
        NetworkStartSynchronisedScene(scene2)
        Citizen.Wait(37000)
        local scene3 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

        NetworkAddPedToSynchronisedScene(ped, scene3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(bag, scene3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
        NetworkStartSynchronisedScene(scene3)
        NewTrolley = CreateObject(emptyobj, GetEntityCoords(trollyobj) + vector3(0.0, 0.0, - 0.985), true)
        SetEntityRotation(NewTrolley, GetEntityRotation(trollyobj))
        while not NetworkHasControlOfEntity(trollyobj) do
            Citizen.Wait(1)
            NetworkRequestControlOfEntity(trollyobj)
        end
        DeleteObject(trollyobj)
        PlaceObjectOnGroundProperly(NewTrolley)
        Citizen.Wait(1800)
        DeleteObject(bag)
        SetPedComponentVariation(ped, 5, 45, 0, 0)
        RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
        SetModelAsNoLongerNeeded(emptyobj)
        SetModelAsNoLongerNeeded(GetHashKey("hei_p_m_bag_var22_arm_s"))


        LocalPlayer.state:set("inv_busy", false, true) -- Not Busy

        --  Give Items --

        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)                    


        Citizen.Wait(100)

        if banktype == "fleeca" then
            local itemamount = Config.RandomItemAmount -- math.random(13, 19)
            print('Grant items for Fleeca')
            TriggerServerEvent("QBCore:Server:AddItem", Config.FleecaItem, itemamount)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.FleecaItem], "add")
        else
            print('Grant items for Paleto')
            local itemamount = Config.RandomItemAmount -- math.random(13, 19)
            TriggerServerEvent("QBCore:Server:AddItem", Config.PaletoItem, itemamount)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.PaletoItem], "add")

            if Config.PaletoRareItemEnabled then
                TriggerServerEvent("QBCore:Server:AddItem", Config.PaletoRareItem, Config.PaletoRareItemAmount)
                TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.PaletoRareItem], "add")
            end
        end


        isgrabbing = false

        disableinput = false

        Citizen.Wait(10000)
        DeleteObject(NewTrolley)
    else
        QBCore.Functions.Notify('Someone is already grabbing the money.', "error")
    end
end

-- Events 

RegisterNetEvent('GetThatMoney', function()
 StartGrab()
end)


---- QB-Target Tray Grabber ---

local MoneyTray = {
    "hei_prop_hei_cash_trolly_01",
}
exports['qb-target']:AddTargetModel(MoneyTray, {
	options = {
		{
			event = "GetThatMoney",
			icon = "fas fa-money-bill",
			label = "Grab marked money!",
        },    
	},
	distance = 2.5,

})


AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        ResetBankDoors()
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = true
end)

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    QBCore.Functions.TriggerCallback('qb-bankrobbery:server:GetConfig', function(config)
        Config = config
    end)
    onDuty = true
    ResetBankDoors()
end)

-- More Functions

function DrawText3Ds(x, y, z, text) -- Globally used
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function OpenPaletoDoor()
    TriggerServerEvent('qb-doorlock:server:updateState', 85, false)
    local object = GetClosestObjectOfType(Config.BigBanks["paleto"]["coords"]["x"], Config.BigBanks["paleto"]["coords"]["y"], Config.BigBanks["paleto"]["coords"]["z"], 5.0, Config.BigBanks["paleto"]["object"], false, false, false)
    local timeOut = 10
    local entHeading = Config.BigBanks["paleto"]["heading"].closed

    if object ~= 0 then
        SetEntityHeading(object, Config.BigBanks["paleto"]["heading"].open)
    end
end

local function OpenPacificDoor()
    local object = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
    local timeOut = 10
    local entHeading = Config.BigBanks["pacific"]["heading"].closed

    if object ~= 0 then
        CreateThread(function()
            while true do

                if entHeading > Config.BigBanks["pacific"]["heading"].open then
                    SetEntityHeading(object, entHeading - 10)
                    entHeading = entHeading - 0.5
                else
                    break
                end

                Wait(10)
            end
        end)
    end
end

--- mHacking OnHackDone func
local function OnHackDone(success)
    if success then
        TriggerEvent('mhacking:hide')
        QBCore.Functions.Notify('Done! Give it some time to open.', "success")
        local ped = PlayerPedId()
        local playerPos = GetEntityCoords(ped)
        Citizen.Wait(Config.WaitTime)
        TriggerServerEvent('qb-bankrobbery:server:setBankState', closestBank, true)
    else
        QBCore.Functions.Notify('You failed the hack.', "error")
		TriggerEvent('mhacking:hide')
	end
end

local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local function OpenBankDoor(bankId)
    local object = GetClosestObjectOfType(Config.SmallBanks[bankId]["coords"]["x"], Config.SmallBanks[bankId]["coords"]["y"], Config.SmallBanks[bankId]["coords"]["z"], 5.0, Config.SmallBanks[bankId]["object"], false, false, false)
    local timeOut = 10
    local entHeading = Config.SmallBanks[bankId]["heading"].closed
    if object ~= 0 then
        CreateThread(function()
            while true do

                if entHeading ~= Config.SmallBanks[bankId]["heading"].open then
                    SetEntityHeading(object, entHeading - 10)
                    entHeading = entHeading - 0.5
                else
                    break
                end

                Wait(10)
            end
        end)
    end
end

function IsWearingHandshoes() -- Globally Used
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    if model == `mp_m_freemode_01` then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

-- Events

RegisterNetEvent('electronickit:UseElectronickit', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    if closestBank ~= nil then
        QBCore.Functions.TriggerCallback('qb-bankrobbery:server:isRobberyActive', function(isBusy)
            if not isBusy then
                if closestBank ~= nil then
                    local dist = #(pos - Config.SmallBanks[closestBank]["coords"])
                    if dist < 1.5 then
                        if CurrentCops >= Config.MinimumFleecaPolice then
                            if not Config.SmallBanks[closestBank]["isOpened"] then
                                local progtime = math.random(5000, 10000)
                                QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
                                    if result then
                                        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                                        QBCore.Functions.Progressbar("hack_gate", "Connecting the hacking device ..", progtime, false, true, {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                        }, {
                                            animDict = "anim@gangops@facility@servers@",
                                            anim = "hotwire",
                                            flags = 16,
                                        }, {}, {}, function() -- Done
                                            StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                                            -- Removing Items
                                            TriggerServerEvent("QBCore:Server:RemoveItem", "electronickit", 1)
                                            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["electronickit"], "remove")
                                            TriggerServerEvent("QBCore:Server:RemoveItem", "trojan_usb", 1)
                                            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["trojan_usb"], "remove")
                                            --------------

                                            -- Starting player hack

                                            if Config.TwoHack then
                                                local randomnum = math.random(1,100)
                                                local randomtime = math.random(420069, 500000)
                                                if randomnum <= 20 then
                                                    Wait(randomnum)
                                                    TriggerEvent("mhacking:show")
                                                    TriggerEvent("mhacking:start", math.random(6, 7), math.random(12, 15), OnHackDone)

                                                else

                                                    TriggerEvent("open:minigame")

                                                    exports["hacking"]:hacking(
                                                    function() -- success
                                                        local ped = PlayerPedId()
                                                        local playerPos = GetEntityCoords(ped)

                                                        QBCore.Functions.Notify('Done! Give it some time to crack.', "success")
                                                        SpawnTrolleys(data, name)
                                                        Wait(25)
                                                        Citizen.Wait(Config.WaitTime)
                                                        QBCore.Functions.Notify('Its open!', "success")
                                                        TriggerServerEvent('qb-bankrobbery:server:setBankState', closestBank, true)
                                                        Citizen.Wait(Config.CopCallTime)
                                                        TriggerEvent('qb-bankrobbery:client:robberyCall')
                                                    end,

                                                    function() -- failure

                                                        QBCore.Functions.Notify('You failed the hack.', "error")
                                                        
                                                    end)         
                                                end
                                            else
                                                TriggerEvent("hacking:setdifficulty", "fleeca")
                                                Wait(randomnum)
                                                TriggerEvent("open:minigame")
                                                exports["hacking"]:hacking(
                                                function() -- success
                                                    local ped = PlayerPedId()
                                                    local playerPos = GetEntityCoords(ped)
                                                    QBCore.Functions.Notify('Done! Give it some time to crack it.', "success")
                                                    SpawnTrolleys(data, name)
                                                    Wait(25)
                                                    Citizen.Wait(Config.WaitTime)
                                                    QBCore.Functions.Notify('Its Open!', "success")
                                                    TriggerServerEvent('qb-bankrobbery:server:setBankState', closestBank, true)

                                                end,

                                                function() -- failure
                                                    QBCore.Functions.Notify('You failed the hack.', "error")
                                                end)
                                            end
                                        end)



                                

                                    else
                                        QBCore.Functions.Notify("You're missing an item ..", "error")
                                    end
                                end, "trojan_usb")
                            else
                                QBCore.Functions.Notify("Looks like the bank is already open ..", "error")
                            end
                        else
                            QBCore.Functions.Notify('Minimum Of '..Config.MinimumFleecaPolice..' Police Needed', "error")
                        end
                    end
                end
            else
                QBCore.Functions.Notify("The security lock is active, opening the door is currently not possible.", "error", 5500)
            end
        end)
    end
end)

RegisterNetEvent('qb-bankrobbery:client:setBankState', function(bankId, state)
    if bankId == "paleto" then
        Config.BigBanks["paleto"]["isOpened"] = state
        if state then
            OpenPaletoDoor()
        end
    elseif bankId == "pacific" then
        Config.BigBanks["pacific"]["isOpened"] = state
        if state then
            OpenPacificDoor()
        end
    else
        Config.SmallBanks[bankId]["isOpened"] = state
        if state then
            OpenBankDoor(bankId)
        end
    end
end)

RegisterNetEvent('qb-bankrobbery:client:enableAllBankSecurity', function()
    for k, v in pairs(Config.SmallBanks) do
        Config.SmallBanks[k]["alarm"] = true
    end
end)

RegisterNetEvent('qb-bankrobbery:client:disableAllBankSecurity', function()
    for k, v in pairs(Config.SmallBanks) do
        Config.SmallBanks[k]["alarm"] = false
    end
end)

RegisterNetEvent('qb-bankrobbery:client:BankSecurity', function(key, status)
    Config.SmallBanks[key]["alarm"] = status
end)

RegisterNetEvent('qb-bankrobbery:client:setLockerState', function(bankId, lockerId, state, bool)
    if bankId == "paleto" then
        Config.BigBanks["paleto"]["lockers"][lockerId][state] = bool
    elseif bankId == "pacific" then
        Config.BigBanks["pacific"]["lockers"][lockerId][state] = bool
    else
        Config.SmallBanks[bankId]["lockers"][lockerId][state] = bool
    end
end)

RegisterNetEvent('qb-bankrobbery:client:ResetFleecaLockers', function(BankId)
    Config.SmallBanks[BankId]["isOpened"] = false
    for k,_ in pairs(Config.SmallBanks[BankId]["lockers"]) do
        Config.SmallBanks[BankId]["lockers"][k]["isOpened"] = false
        Config.SmallBanks[BankId]["lockers"][k]["isBusy"] = false
    end
end)

RegisterNetEvent('qb-bankrobbery:client:robberyCall', function(type, key, streetLabel, coords)
    if PlayerJob.name == "police" and onDuty then
        local cameraId = 4
        local bank = "Fleeca"
        if type == "small" then
            cameraId = Config.SmallBanks[key]["camId"]
            bank = "Fleeca"
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            TriggerEvent('qb-policealerts:client:AddPoliceAlert', {
                timeOut = 10000,
                alertTitle = "Fleeca bank robbery attempt",
                coords = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                },
                details = {
                    [1] = {
                        icon = '<i class="fas fa-university"></i>',
                        detail = bank,
                    },
                    [2] = {
                        icon = '<i class="fas fa-video"></i>',
                        detail = cameraId,
                    },
                    [3] = {
                        icon = '<i class="fas fa-globe-europe"></i>',
                        detail = streetLabel,
                    },
                },
                callSign = QBCore.Functions.GetPlayerData().metadata["callsign"],
            })
        elseif type == "paleto" then
            cameraId = Config.BigBanks["paleto"]["camId"]
            bank = "Blaine County Savings"
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            Wait(100)
            PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
            Wait(100)
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            Wait(100)
            PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
            TriggerEvent('qb-policealerts:client:AddPoliceAlert', {
                timeOut = 10000,
                alertTitle = "Blain County Savings bank robbery attempt",
                coords = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                },
                details = {
                    [1] = {
                        icon = '<i class="fas fa-university"></i>',
                        detail = bank,
                    },
                    [2] = {
                        icon = '<i class="fas fa-video"></i>',
                        detail = cameraId,
                    },
                },
                callSign = QBCore.Functions.GetPlayerData().metadata["callsign"],
            })
        elseif type == "pacific" then
            bank = "Pacific Standard Bank"
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            Wait(100)
            PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
            Wait(100)
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            Wait(100)
            PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
            TriggerEvent('qb-policealerts:client:AddPoliceAlert', {
                timeOut = 10000,
                alertTitle = "Pacific Standard Bank robbery attempt",
                coords = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                },
                details = {
                    [1] = {
                        icon = '<i class="fas fa-university"></i>',
                        detail = bank,
                    },
                    [2] = {
                        icon = '<i class="fas fa-video"></i>',
                        detail = "1 | 2 | 3",
                    },
                    [3] = {
                        icon = '<i class="fas fa-globe-europe"></i>',
                        detail = "Alta St",
                    },
                },
                callSign = QBCore.Functions.GetPlayerData().metadata["callsign"],
            })
        end
        local transG = 250
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 487)
        SetBlipColour(blip, 4)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 1.2)
        SetBlipFlashes(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("10-90: Bank Robbery")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)

-- Threads

CreateThread(function()
    while true do
        Wait(1000 * 60 * 5)
        if copsCalled then
            copsCalled = false
        end
    end
end)

CreateThread(function()
    Wait(500)
    if QBCore.Functions.GetPlayerData() ~= nil then
        PlayerJob = QBCore.Functions.GetPlayerData().job
        onDuty = true
    end
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
    onDuty = duty
end)

CreateThread(function()
    while true do
        Wait(1000)
        if inRange then
            if not refreshed then
                ResetBankDoors()
                refreshed = true
            end
        else
            refreshed = false
        end
    end
end)

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist

        if QBCore ~= nil then
            inRange = false

            for k, v in pairs(Config.SmallBanks) do
                dist = #(pos - Config.SmallBanks[k]["coords"])
                if dist < 15 then
                    closestBank = k
                    inRange = true
                end
            end

            if not inRange then
                Wait(2000)
                closestBank = nil
            end
        end

        Wait(3)
    end
end)
