ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local VehicleSpawns = {}

MySQL.ready(function()
	ParkVehicles()
end)

function ParkVehicles()
	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE `stored` = @stored', {
		['@stored'] = false
	}, function(rowsChanged)
		if rowsChanged > 0 then
			print(('esx_advancedgarage: %s vehicle(s) have been stored!'):format(rowsChanged))
		end
	end)
end

ESX.RegisterServerCallback('esx_advancedgarage:getOwnedProperties', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local properties = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE owner = @owner', {
		['@owner'] = xPlayer.getIdentifier()
	}, function(data)
		for _,v in pairs(data) do
			table.insert(properties, v.name)
		end
		cb(properties)
	end)
end)

-- Fetch Owned Cars
ESX.RegisterServerCallback('esx_advancedgarage:getOwnedCars', function(source, cb)
	local ownedCars = {}
	
	if garagesConfig.DontShowPoundCarsInGarage == true then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND `stored` = @stored', {
			['@owner']  = GetPlayerIdentifiers(source)[1],
			['@Type']   = 'car',
			--['@job']    = '',
			['@stored'] = true
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedCars)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type', {
			['@owner']  = GetPlayerIdentifiers(source)[1],
			['@Type']   = 'car',
			--['@job']    = ''
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedCars)
		end)
	end
end)

-- Store Vehicles
ESX.RegisterServerCallback('esx_advancedgarage:storeVehicle', function (source, cb, vehicleProps)
	local ownedCars = {}
	local vehplate = vehicleProps.plate:match("^%s*(.-)%s*$")
	local vehiclemodel = vehicleProps.model
	local xPlayer = ESX.GetPlayerFromId(source)
	
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = vehicleProps.plate
	}, function (result)
		if result[1] ~= nil then
			local originalvehprops = json.decode(result[1].vehicle)
			if originalvehprops.model == vehiclemodel then
				MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE owner = @owner AND plate = @plate', {
					['@owner']  = GetPlayerIdentifiers(source)[1],
					['@vehicle'] = json.encode(vehicleProps),
					['@plate']  = vehicleProps.plate
				}, function (rowsChanged)
					if rowsChanged == 0 then
						print(('esx_advancedgarage: %s attempted to store an vehicle they don\'t own!'):format(GetPlayerIdentifiers(source)[1]))
					end
					cb(true)
				end)
			else
				if garagesConfig.KickPossibleCheaters == true then
					if garagesConfig.UseCustomKickMessage == true then
						print(('esx_advancedgarage: %s attempted to Cheat! Tried Storing: '..vehiclemodel..'. Original Vehicle: '..originalvehprops.model):format(GetPlayerIdentifiers(source)[1]))
						DropPlayer(source, _U("garages:" .. 'custom_kick'))
						cb(false)
					else
						print(('esx_advancedgarage: %s attempted to Cheat! Tried Storing: '..vehiclemodel..'. Original Vehicle: '..originalvehprops.model):format(GetPlayerIdentifiers(source)[1]))
						DropPlayer(source, 'You have been Kicked from the Server for Possible Garage Cheating!!!')
						cb(false)
					end
				else
					print(('esx_advancedgarage: %s attempted to Cheat! Tried Storing: '..vehiclemodel..'. Original Vehicle: '..originalvehprops.model):format(GetPlayerIdentifiers(source)[1]))
					cb(false)
				end
			end
		else
			print(('esx_advancedgarage: %s attempted to store an vehicle they don\'t own!'):format(GetPlayerIdentifiers(source)[1]))
			cb(false)
		end
	end)
end)

-- Fetch Pounded Cars
ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedCars', function(source, cb)
	local ownedCars = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND `stored` = @stored', {
		['@owner'] = GetPlayerIdentifiers(source)[1],
		['@Type']   = 'car',
		--['@job']    = '',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedCars, vehicle)
		end
		cb(ownedCars)
	end)
end)

-- Fetch Pounded Policing Vehicles
ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedPolicingCars', function(source, cb)
	local ownedPolicingCars = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND job = @job AND `stored` = @stored', {
		['@owner'] = GetPlayerIdentifiers(source)[1],
		['@job']    = 'police',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedPolicingCars, vehicle)
		end
		cb(ownedPolicingCars)
	end)
end)

-- Fetch Pounded Ambulance Vehicles
ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedAmbulanceCars', function(source, cb)
	local ownedAmbulanceCars = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND job = @job AND `stored` = @stored', {
		['@owner'] = GetPlayerIdentifiers(source)[1],
		['@job']    = 'ambulance',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedAmbulanceCars, vehicle)
		end
		cb(ownedAmbulanceCars)
	end)
end)

-- Check Money for Pounded Cars
ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyCars', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get('money') >= garagesConfig.CarPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Check Money for Pounded Policing
ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyPolicing', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get('money') >= garagesConfig.PolicingPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Check Money for Pounded Ambulance
ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyAmbulance', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get('money') >= garagesConfig.AmbulancePoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Pay for Pounded Cars
RegisterServerEvent('esx_advancedgarage:payCar')
AddEventHandler('esx_advancedgarage:payCar', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(garagesConfig.CarPoundPrice)
	TriggerClientEvent('esx:showNotification', source, _U("garages:" .. 'you_paid') .. garagesConfig.CarPoundPrice)
end)

-- Pay for Pounded Policing
RegisterServerEvent('esx_advancedgarage:payPolicing')
AddEventHandler('esx_advancedgarage:payPolicing', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(garagesConfig.PolicingPoundPrice)
	TriggerClientEvent('esx:showNotification', source, _U("garages:" .. 'you_paid') .. garagesConfig.PolicingPoundPrice)
end)

-- Pay for Pounded Ambulance
RegisterServerEvent('esx_advancedgarage:payAmbulance')
AddEventHandler('esx_advancedgarage:payAmbulance', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(garagesConfig.AmbulancePoundPrice)
	TriggerClientEvent('esx:showNotification', source, _U("garages:" .. 'you_paid') .. garagesConfig.AmbulancePoundPrice)
end)

-- Pay to Return Broken Vehicles
RegisterServerEvent('esx_advancedgarage:payhealth')
AddEventHandler('esx_advancedgarage:payhealth', function(price)
	if PatchOptions.ProtectEvents then
		if price < 1000 and price > 0 then
			local xPlayer = ESX.GetPlayerFromId(source)
			xPlayer.removeMoney(price)
			TriggerClientEvent('esx:showNotification', source, _U("garages:" .. 'you_paid') .. price)
		else
			if PatchOptions.KickCheater then
				DropPlayer(source, "This resource has been patched by Alv#9999, better luck next time!")
				if PatchOptions.Logs.LogActions then
					DiscordLog("Cheater Kicked", "**"..GetPlayerName(source).."** (ID: "..source..") has been kicked for exploiting.\n**EventName:** 'esx_advancedgarage:payhealth'\n**Resource:** "..GetCurrentResourceName())
				end
			elseif PatchOptions.EasyAdminBan.Enabled then
				TriggerEvent(PatchOptions.EasyAdminBan.EventName, source, "This resource has been patched by Alv#9999, better luck next time! [https://alv.gg/]", false, GetPlayerName(source))
				DiscordLog("Cheater Kicked", "**"..GetPlayerName(source).."** (ID: "..source..") has been EasyAdmin banned for exploiting.\n**EventName:** 'esx_advancedgarage:payhealth'\n**Resource:** "..GetCurrentResourceName())
			elseif PatchOptions.VenomAdminBan.Enabled then
				TriggerEvent(PatchOptions.VenomAdminBan.EventName, source, "This resource has been patched by Alv#9999, better luck next time! [https://alv.gg/]", nil) -- param's = function(player, reason, duration)
				DiscordLog("Cheater Kicked", "**"..GetPlayerName(source).."** (ID: "..source..") has been VenomAdmin banned for exploiting.\n**EventName:** 'esx_advancedgarage:payhealth'\n**Resource:** "..GetCurrentResourceName())
			else
				CancelEvent()
			end
		end
	end
	if not PatchOptions.ProtectEvents then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeMoney(price)
		TriggerClientEvent('esx:showNotification', source, _U("garages:" .. 'you_paid') .. price)
	else
		Citizen.Wait(10000)
		print("!!! ^1 YOU HAVE ESX ADVANCED GARAGE EVENT PROTECTION AS FALSE ^1NAVIGATE TO THE CONFIG TO AMEND THIS !!!")
	end
end)

function DiscordLog(name, msg, col)
	local embed = {
		{
			["color"] = col,
			["title"] = "**"..name.."**",
			["description"] = msg,
			["footer"] = {
				["text"] = "discord.gg/alv"
			},
		}
	}
	PerformHttpRequest(PatchOptions.Logs.Webhook, function(err, text, headers) end, 'POST', json.encode({username = PatchOptions.Logs.BotUsername, embeds = embed, avatar_url = PatchOptions.Logs.BotAvatar}), {['Content-Type'] = 'application/json'})
end

-- Modify State of Vehicles
RegisterServerEvent('esx_advancedgarage:setVehicleState')
AddEventHandler('esx_advancedgarage:setVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate', {
		['@stored'] = state,
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('esx_advancedgarage: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)

function IsEntityPlayerOwned(entity)
    local source = NetworkGetEntityOwner(entity)
    local popType = GetEntityPopulationType(entity)
    local targetPop = {7}
    local popTarget = false
    if (GetPlayerName(source) == nil) then 
        return false
    end
    for i=1, #targetPop do 
        if (popType == targetPop[i]) then 
            popTarget = true
            break
        end
    end
    return popTarget, source
end

AddEventHandler("entityCreating", function(entity)
    if (DoesEntityExist(entity)) then
        local owned, src = IsEntityPlayerOwned(entity)
        if (owned and GetEntityType(entity) == 2) then 
            local spawn = false
            if (VehicleSpawns[src] == nil or os.time() - VehicleSpawns[src] >= garagesConfig.CarCooldown) then 
                VehicleSpawns[src] = os.time()
                spawn = true
            end
            if (not spawn) then 
                TriggerClientEvent("esx:showNotification", src, "You cannot spawn a vehicle in for " .. (garagesConfig.CarCooldown - (os.time() - VehicleSpawns[src])) .. " more second(s).")
                CancelEvent()
            end
        end
    end
end)
