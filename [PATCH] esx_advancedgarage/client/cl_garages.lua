Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

local PlayerData              = {}
local JobBlips                = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local userProperties          = {}
local this_Garage             = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) 
			ESX = obj 
		end)
		Citizen.Wait(4)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	refreshBlips()
	Citizen.Wait(5000)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	refreshBlips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
	refreshBlips()
end)

local function has_value (tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	return false
end

function OpenMenuGarage(PointType)
	ESX.UI.Menu.CloseAll()
	
	local elements = {}
	
	if PointType == 'car_garage_point' then
		table.insert(elements, {label = _U("garages:" .. 'list_owned_cars'), value = 'list_owned_cars'})
	elseif PointType == 'car_store_point' then
		table.insert(elements, {label = _U("garages:" .. 'store_owned_cars'), value = 'store_owned_cars'})
	elseif PointType == 'car_pound_point' then
		table.insert(elements, {label = _U("garages:" .. 'return_owned_cars').." ($"..garagesConfig.CarPoundPrice..")", value = 'return_owned_cars'})
	end
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garage_menu', {
		title    = _U("garages:" .. 'garage'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()
		local action = data.current.value
		
		if action == 'list_owned_cars' then
			ListOwnedCarsMenu()
		elseif action== 'store_owned_cars' then
			StoreOwnedCarsMenu()
		elseif action == 'return_owned_cars' then
			ReturnOwnedCarsMenu()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function ListOwnedCarsMenu()
	local elements = {}
	
	if garagesConfig.ShowGarageSpacer1 then
		table.insert(elements, {label = _U("garages:" .. 'spacer1')})
	end
	
	if garagesConfig.ShowGarageSpacer2 then
		table.insert(elements, {label = _U("garages:" .. 'spacer2')})
	end
	
	if garagesConfig.ShowGarageSpacer3 then
		table.insert(elements, {label = _U("garages:" .. 'spacer3')})
	end
	
	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedCars', function(ownedCars)
		if #ownedCars == 0 then
			ESX.ShowNotification(_U("garages:" .. 'garage_nocars'))
		else
			for _,v in pairs(ownedCars) do
				if garagesConfig.UseVehicleNamesLua then
					local hashVehicule = v.vehicle.model
					local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
					local vehicleName  = GetLabelText(aheadVehName)
					local plate        = v.plate
					local labelvehicle
					
					if garagesConfig.ShowVehicleLocation then
						if v.stored then
							labelvehicle = '| '..plate..' | '..vehicleName..' | '.._U("garages:" .. 'loc_garage')..' |'
						else
							labelvehicle = '| '..plate..' | '..vehicleName..' | '.._U("garages:" .. 'loc_pound')..' |'
						end
					else
						if v.stored then
							labelvehicle = '| '..plate..' | '..vehicleName..' |'
						else
							labelvehicle = '| '..plate..' | '..vehicleName..' |'
						end
					end
					
					table.insert(elements, {label = labelvehicle, value = v})
				else
					local hashVehicule = v.vehicle.model
					local vehicleName  = GetDisplayNameFromVehicleModel(hashVehicule)
					local plate        = v.plate
					local labelvehicle
					
					if garagesConfig.ShowVehicleLocation then
						if v.stored then
							labelvehicle = '| '..plate..' | '..vehicleName..' | '.._U("garages:" .. 'loc_garage')..' |'
						else
							labelvehicle = '| '..plate..' | '..vehicleName..' | '.._U("garages:" .. 'loc_pound')..' |'
						end
					else
						if v.stored then
							labelvehicle = '| '..plate..' | '..vehicleName..' |'
						else
							labelvehicle = '| '..plate..' | '..vehicleName..' |'
						end
					end
					
					table.insert(elements, {label = labelvehicle, value = v})
				end
			end
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_car', {
			title    = _U("garages:" .. 'garage_cars'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value.stored then
				menu.close()
				SpawnVehicle(data.current.value.vehicle, data.current.value.plate)
			else
				ESX.ShowNotification(_U("garages:" .. 'car_is_impounded'))
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function StoreOwnedCarsMenu()
	local playerPed  = PlayerPedId()
	if IsPedInAnyVehicle(playerPed,  false) then
		local playerPed    = PlayerPedId()
		local coords       = GetEntityCoords(playerPed)
		local vehicle      = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local current 	   = GetPlayersLastVehicle(PlayerPedId(), true)
		local engineHealth = GetVehicleEngineHealth(current)
		local plate        = vehicleProps.plate
		
		ESX.TriggerServerCallback('esx_advancedgarage:storeVehicle', function(valid)
			if valid then
				if engineHealth < 990 then
					if garagesConfig.UseDamageMult then
						local apprasial = math.floor((1000 - engineHealth)/1000*garagesConfig.CarPoundPrice*garagesConfig.DamageMult)
						reparation(apprasial, vehicle, vehicleProps)
					else
						local apprasial = math.floor((1000 - engineHealth)/1000*garagesConfig.CarPoundPrice)
						reparation(apprasial, vehicle, vehicleProps)
					end
				else
					putaway(vehicle, vehicleProps)
				end	
			else
				ESX.ShowNotification(_U("garages:" .. 'cannot_store_vehicle'))
			end
		end, vehicleProps)
	else
		ESX.ShowNotification(_U("garages:" .. 'no_vehicle_to_enter'))
	end
end

-- Pound Owned Cars Menu
function ReturnOwnedCarsMenu()
	ESX.TriggerServerCallback('esx_advancedgarage:getOutOwnedCars', function(ownedCars)
		local elements = {}
		
		if garagesConfig.ShowPoundSpacer2 then
			table.insert(elements, {label = _U("garages:" .. 'spacer2')})
		end
		
		if garagesConfig.ShowPoundSpacer3 then
			table.insert(elements, {label = _U("garages:" .. 'spacer3')})
		end
		
		for _,v in pairs(ownedCars) do
			if garagesConfig.UseVehicleNamesLua then
				local hashVehicule = v.model
				local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
				local vehicleName  = GetLabelText(aheadVehName)
				local plate        = v.plate
				local labelvehicle
				
				labelvehicle = '| '..plate..' | '..vehicleName..' | '.._U("garages:" .. 'return')..' |'
				
				table.insert(elements, {label = labelvehicle, value = v})
			else
				local hashVehicule = v.model
				local vehicleName  = GetDisplayNameFromVehicleModel(hashVehicule)
				local plate        = v.plate
				local labelvehicle
				
				labelvehicle = '| '..plate..' | '..vehicleName..' | '.._U("garages:" .. 'return')..' |'
				
				table.insert(elements, {label = labelvehicle, value = v})
			end
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'return_owned_car', {
			title    = _U("garages:" .. 'pound_cars'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			ESX.TriggerServerCallback('esx_advancedgarage:checkMoneyCars', function(hasEnoughMoney)
				if hasEnoughMoney then
					TriggerServerEvent('esx_advancedgarage:payCar')
					SpawnPoundedVehicle(data.current.value, data.current.value.plate)
				else
					ESX.ShowNotification(_U("garages:" .. 'not_enough_money'))
				end
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function reparation(vehicle, vehicleProps)
	ESX.UI.Menu.CloseAll()
	
	local elements = {
		{label = _U("garages:" .. 'return_vehicle').." ($"..garagesConfig.CarRepairPrice..")", value = 'yes'},
		--{label = _U("garages:" .. 'return_vehicle').." ($"..apprasial..")", value = 'yes'},
		{label = _U("garages:" .. 'see_mechanic'), value = 'no'}
	}
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'delete_menu', {
		title    = _U("garages:" .. 'damaged_vehicle'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()
		
		if data.current.value == 'yes' then
			TriggerServerEvent('esx_advancedgarage:payhealth', garagesConfig.CarRepairPrice)
			putaway(vehicle, vehicleProps)
		elseif data.current.value == 'no' then
			ESX.ShowNotification(_U("garages:" .. 'visit_mechanic'))
		end
	end, function(data, menu)
		menu.close()
	end)
end

function putaway(vehicle, vehicleProps)
	ESX.Game.DeleteVehicle(vehicle)
	TriggerServerEvent('esx_advancedgarage:setVehicleState', vehicleProps.plate, true)
	ESX.ShowNotification(_U("garages:" .. 'vehicle_in_garage'))
end

function SpawnVehicle(vehicle, plate)
	ESX.Game.SpawnVehicle(vehicle.model, {
		x = this_Garage.SpawnPoint.x,
		y = this_Garage.SpawnPoint.y,
		z = this_Garage.SpawnPoint.z + 1
	}, this_Garage.SpawnPoint.h, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
	end)
	
	TriggerServerEvent('esx_advancedgarage:setVehicleState', plate, false)
end

function SpawnPoundedVehicle(vehicle, plate)
	ESX.Game.SpawnVehicle(vehicle.model, {
		x = this_Garage.SpawnPoint.x,
		y = this_Garage.SpawnPoint.y,
		z = this_Garage.SpawnPoint.z + 1
	}, this_Garage.SpawnPoint.h, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
	end)
	
	TriggerServerEvent('esx_advancedgarage:setVehicleState', plate, false)
end

AddEventHandler('esx_advancedgarage:hasEnteredMarker', function(zone)
	if zone == 'car_garage_point' then
		CurrentAction     = 'car_garage_point'
		CurrentActionData = {}
	elseif zone == 'car_store_point' then
		CurrentAction = 'car_store_point'
		CurrentActionData = {}
	elseif zone == 'car_pound_point' then
		CurrentAction     = 'car_pound_point'
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_advancedgarage:hasExitedMarker', function()
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

local rvb = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		ESX.TriggerServerCallback('esx_vehicleshop:getPlayerGang', function(gang)
			if gang == 'rvb' then
				rvb = true
			else
				rvb = false
			end
		end, GetPlayerServerId(PlayerId()))
	end
end)

Citizen.CreateThread(function()
	local currentZone = 'garage'
	while true do
		local threadone = 1500
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local inVeh = IsPedInAnyVehicle(ped, false)
		local isInMarker = false
		for k, v in pairs(garagesConfig.CarGarages) do
			if GetDistanceBetweenCoords(coords, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, true) < 7.5 then
				if not inVeh then
					threadone = 4
					Draw3DText(v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z + 1.0, "[E] - Garage")
					DrawMarker(27, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 0, 0, 150, false, true, 2, true, false, false, false)
					if GetDistanceBetweenCoords(coords, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, true) < 1.5 then
						isInMarker  = true
						this_Garage = v
						currentZone = 'car_garage_point'
					end	
					break
				end
			end

			if GetDistanceBetweenCoords(coords, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, true) < 15.0 then
				if inVeh then
					threadone = 4
					Draw3DText(v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z + 1.0, "[E] - Store")
					DrawMarker(27, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 255, 0, 0, 150, false, true, 2, true, false, false, false)	
					if GetDistanceBetweenCoords(coords, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, true) < 3.0 then
						isInMarker  = true
						this_Garage = v
						currentZone = 'car_store_point'
					end	
					break
				end
			end
		end

		for k, v in pairs(garagesConfig.CarPounds) do
			if GetDistanceBetweenCoords(coords, v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z, true) < 7.5 then
				if not inVeh then
					threadone = 4
					Draw3DText(v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z + 1.0, "[E] - Impound")
					DrawMarker(27, v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 165, 0, 150, false, true, 2, true, false, false, false)	
					if GetDistanceBetweenCoords(coords, v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z, true) < 1.5 then
						isInMarker  = true
						this_Garage = v
						currentZone = 'car_pound_point'
					end	
					break
				end
			end
		end

		for k, v in pairs(garagesConfig.GangGarages) do
			if v.Gang == 'rvb' then
				if rvb then
					if GetDistanceBetweenCoords(coords, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, true) < 7.5 then
						if not inVeh then
							threadone = 4
							Draw3DText(v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z + 1.0, "[E] - Garage")
							DrawMarker(27, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 0, 0, 150, false, true, 2, false, false, false, false)	
							if GetDistanceBetweenCoords(coords, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, true) < 1.5 then
								isInMarker  = true
								this_Garage = v
								currentZone = 'car_garage_point'
							end	
							break
						end
					end

					if GetDistanceBetweenCoords(coords, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, true) < 15.0 then
						if inVeh then
							threadone = 4
							Draw3DText(v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z + 1.0, "[E] - Store")
							DrawMarker(27, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 255, 0, 0, 150, false, true, 2, false, false, false, false)	
							if GetDistanceBetweenCoords(coords, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, true) < 3.0 then
								isInMarker  = true
								this_Garage = v
								currentZone = 'car_store_point'
							end	
							break
						end
					end
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('esx_advancedgarage:hasEnteredMarker', currentZone)
		end
		
		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_advancedgarage:hasExitedMarker', LastZone)
		end

		Citizen.Wait(threadone)
	end
end)

function Draw3DText(x, y, z, text)
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

Citizen.CreateThread(function()
	while true do
		if CurrentAction ~= nil then
			if IsControlJustReleased(0, Keys['E']) then
				if CurrentAction == 'car_garage_point' then
					OpenMenuGarage('car_garage_point')
				elseif CurrentAction == 'car_store_point' then
					OpenMenuGarage('car_store_point')
				elseif CurrentAction == 'car_pound_point' then
					OpenMenuGarage('car_pound_point')
				end
				CurrentAction = nil
			end
		else
			Citizen.Wait(900)
		end
		Citizen.Wait(4)
	end
end)

function refreshBlips()
	local blipList = {}

	for k,v in pairs(garagesConfig.CarGarages) do
		table.insert(blipList, {
			coords = { v.GaragePoint.x, v.GaragePoint.y },
			text   = _U("garages:" .. 'blip_garage'),
			sprite = garagesConfig.BlipGarage.Sprite,
			color  = garagesConfig.BlipGarage.Color,
			scale  = garagesConfig.BlipGarage.Scale
		})
	end
	--[[
	for k,v in pairs(garagesConfig.CarPounds) do
		table.insert(blipList, {
			coords = { v.PoundPoint.x, v.PoundPoint.y },
			text   = _U("garages:" .. 'blip_pound'),
			sprite = garagesConfig.BlipPound.Sprite,
			color  = garagesConfig.BlipPound.Color,
			scale  = garagesConfig.BlipPound.Scale
		})
	end
	--]]
	for i=1, #blipList, 1 do
		CreateBlip(blipList[i].coords, blipList[i].text, blipList[i].sprite, blipList[i].color, blipList[i].scale)
	end
end

function CreateBlip(coords, text, sprite, color, scale)
	local blip = AddBlipForCoord(table.unpack(coords))
	
	SetBlipSprite(blip, sprite)
	SetBlipScale(blip, scale)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandSetBlipName(blip)
	table.insert(JobBlips, blip)
end
