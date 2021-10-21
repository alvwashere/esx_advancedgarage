local garagesLocales = {
	-- Global
	['custom_kick'] = 'auto kicked for garage exploiting',
	['blip_garage'] = 'Garage | Public',
	['blip_garage_private'] = 'Garage | Private',
	['blip_pound'] = 'Garage | Pound',
	['blip_police_pound'] = 'Garage | Policing Pound',
	['blip_ambulance_pound'] = 'Garage | Ambulance Pound',
	['garage'] = 'Garage',
	['loc_garage'] = 'Parked in Garage',
	['loc_pound'] = 'At the Impound',
	['return'] = 'Return',
	['store_vehicles'] = 'Store Vehicle in Garage.',
	['press_to_enter'] = 'Press ~INPUT_PICKUP~ to take Vehicle out of Garage.',
	['press_to_delete'] = 'Press ~INPUT_PICKUP~ to store Vehicle in the Garage.',
	['press_to_impound'] = 'Press ~INPUT_PICKUP~ to access the Impound.',
	['spacer1'] = 'If Vehicle is NOT here Check Impound!!!',
	['spacer2'] = '| Plate | Vehicle Name | Location |',
	['spacer3'] = '| Plate | Vehicle Name |',
	['you_paid'] = 'You paid $',
	['not_enough_money'] = 'You do not have enough money!',
	['return_vehicle'] = 'Store Vehicle.',
	['see_mechanic'] = 'Visit Mechanic.',
	['damaged_vehicle'] = 'Vehicle Damaged!',
	['visit_mechanic'] = 'Visit the Mechanic or Repair yourself.',
	['cannot_store_vehicle'] = 'You can not store this Vehicle!',
	['no_vehicle_to_enter'] = 'There is no Vehicle to store in the Garage.',
	['vehicle_in_garage'] = 'Your Vehicle is stored in the Garage.',
	-- Cars
	['garage_cars'] = 'Car Garage',
	['pound_cars'] = 'Car Pound',
	['list_owned_cars'] = 'List Owned Cars.',
	['store_owned_cars'] = 'Store Owned Car in Garage.',
	['return_owned_cars'] = 'Return Owned Cars.',
	['garage_nocars'] = 'You dont own any Cars!',
	['car_is_impounded'] = 'Your Car is at the Impound.',
	-- Boats
	['garage_boats'] = 'Boat Garage',
	['pound_boats'] = 'Boat Pound',
	['list_owned_boats'] = 'List Owned Boats.',
	['store_owned_boats'] = 'Store Owned Boat in Garage.',
	['return_owned_boats'] = 'Return Owned Boat.',
	['garage_noboats'] = 'You dont own any Boats!',
	['boat_is_impounded'] = 'Your Boat is at the Impound.',
	-- Aircrafts
	['garage_aircrafts'] = 'Aircraft Garage',
	['pound_aircrafts'] = 'Aircraft Pound',
	['list_owned_aircrafts'] = 'List Owned Aircrafts.',
	['store_owned_aircrafts'] = 'Store Owned Aircraft in Garage.',
	['return_owned_aircrafts'] = 'Return Owned Aircraft.',
	['garage_noaircrafts'] = 'You dont own any Aircrafts!',
	['aircraft_is_impounded'] = 'Your Aircraft is at the Impound.',
	-- Jobs
	['pound_police'] = 'Police Pound',
	['pound_ambulance'] = 'Ambulance Pound',
	['return_owned_policing'] = 'Return Owned Policing Vehicles.',
	['return_owned_ambulance'] = 'Return Owned Ambulance Vehicles.',
}
if Locales["en"] == nil then Locales["en"] = {}; end
for k, v in pairs(garagesLocales) do
    Locales['en']["garages:" .. k] = v
end


garagesConfig = {}
garagesConfig.Locale = 'en'

garagesConfig.CarCooldown = 10

garagesConfig.KickPossibleCheaters = true -- If true it will kick the player that tries store a vehicle that they changed the Hash or Plate.
garagesConfig.UseCustomKickMessage = true -- If KickPossibleCheaters is true you can set a Custom Kick Message in the locales.

PatchOptions = {
	ProtectEvents = true,
	KickCheater = true,
	Logs = {
		LogActions = true,
		BotUsername = 'Alv',
		BotAvatar = 'URL HERE',
-- Moved to stop dumping
	},
	EasyAdminBan = {
		Enabled = true,
		EventName = "EasyAdmin:banPlayer"
	},
	VenomAdminBan = {
		Enabled = false,
		EventName = 'venomadmin:banplayer'
	}
}

garagesConfig.UseDamageMult = true -- If true it costs more to store a Broken Vehicle.
garagesConfig.DamageMult = 1.5 -- Higher Number = Higher Repair Price.

garagesConfig.CarPoundPrice = 300 

garagesConfig.CarRepairPrice = 800 

garagesConfig.KickPossibleCheaters = true
garagesConfig.UseCustomKickMessage = false

garagesConfig.DontShowPoundCarsInGarage = false -- If set to true it won't show Cars at the Pound in the Garage.
garagesConfig.ShowVehicleLocation = true -- If set to true it will show the Location of the Vehicle in the Pound/Garage in the Garage menu.
garagesConfig.UseVehicleNamesLua = true -- Must setup a vehicle_names.lua for Custom Addon Vehicles.

garagesConfig.ShowGarageSpacer1 = true -- If true it shows Spacer 1 in the List.
garagesConfig.ShowGarageSpacer2 = false -- If true it shows Spacer 2 in the List | Don't use if spacer3 is set to true.
garagesConfig.ShowGarageSpacer3 = true -- If true it shows Spacer 3 in the List | Don't use if Spacer2 is set to true.

garagesConfig.ShowPoundSpacer2 = false -- If true it shows Spacer 2 in the List | Don't use if spacer3 is set to true.
garagesConfig.ShowPoundSpacer3 = true -- If true it shows Spacer 3 in the List | Don't use if Spacer2 is set to true.

garagesConfig.BlipGarage = {
	Sprite = 50, 
	Color = 1,
	Display = 2,
	Scale = 0.8
}

garagesConfig.BlipPound = {
	Sprite = 68,
	Color = 72, 
	Display = 2,
	Scale = 0.7
}

garagesConfig.GangGarages = {
	OTF = {
		GaragePoint = { x = 1207.88, y = -3116.03, z = 5.54 },
		SpawnPoint = { x = 1212.78, y = -3090.2, z = 5.8, h = 87.38 },
		DeletePoint = { x = 1189.42, y = -3106.44, z = 5.61 },
		Gang = 'otf'
	},
}

garagesConfig.CarGarages = {
	Garage_NorthLS = {
		GaragePoint = { x = -340.92, y = 266.93, z = 84.70 },
		SpawnPoint = { x = -335.07, y = 283.37, z = 85.36, h = 176.9 },
		DeletePoint = { x = -334.93, y = 280.15, z = 85.05 }
	},
	Garage_EBKGarage = {
		GaragePoint = { x = -2610.44, y = 1685.18, z = 141.87 },
		SpawnPoint = { x = -2603.02, y = 1676.53, z = 141.87, h = 223.43 },
		DeletePoint = { x = -2594.44, y = 1682.26, z = 141.87 }
	},
	Garage_KushhhGarage = {
		GaragePoint = { x = -3212.23, y = 841.52, z = 8.93 },
		SpawnPoint = { x = -3192.84, y = 799.7, z = 8.94, h = 209.5 },
		DeletePoint = { x = -3205.08, y = 812.89, z = 8.93 }
	},
	Garage_KushTrack = {
		GaragePoint = { x = 1732.55, y = 3291.13, z = 41.15 },
		SpawnPoint = { x = 1769.49, y = 3240.53, z = 42.09, h = 62.82 },
		DeletePoint = { x = 1764.94, y = 3307.73, z = 41.17}
	},
	Garage_MidLS = {
		GaragePoint = { x = 31.89, y = -903.16, z = 29.18 },
		SpawnPoint = { x = 40.87, y = -902.77, z = 29.74, h = 350.03 },
		DeletePoint = { x = 34.77, y = -904.66, z = 29.49 }
	},
	Garage_Grove = {
		GaragePoint = { x = 100.58, y = -1073.37, z = 29.37 },
		SpawnPoint = { x =  105.35, y = -1070.75, z = 29.22, h = 68.4 },
		DeletePoint = { x = 117.74, y = -1081.23, z = 29.22 }
	},
	Garage_AnotherKush = {
		GaragePoint = { x = -1459.68, y = -505.91, z = 32.08 },
		SpawnPoint = { x = -1456.01, y = -490.19, z = 33.84, h = 306.98 },
		DeletePoint = { x = -1477.58, y = -493.62, z = 32.81 }
	},
	Garage_WestLS = {
		GaragePoint = { x = -1603.62, y = -831.52, z = 9.27 },
		SpawnPoint = { x = -1639.48, y = -815.35, z = 9.17, h = 138.57 },
		DeletePoint = { x = -1617.63, y = -814.24, z = 9.27 }
	},
	Garage_MP = {
		GaragePoint = { x = 1036.13, y = -763.41, z = 57.01 },
		SpawnPoint = { x = 1046.8, y = -774.33, z = 57.58, h = 92.46 },
		DeletePoint = { x = 1042.02, y = -791.72, z = 57.01 }
	},
	Garage_ParkingGarageByGrove = {
		GaragePoint = { x = 386.21, y = -1680.92, z = 32.53 - 0.9 },
		SpawnPoint = { x = 391.71, y = -1666.52, z = 32.53, h = 49.25 },
		DeletePoint = { x = 372.42, y = -1686.58, z = 32.53 - 0.9 }
	},
	Garage_Integrity = {
		GaragePoint = { x = 275.32, y = -344.73, z = 44.20 },
		SpawnPoint = { x = 275.18, y = -326.06, z = 44.92, h = 165.44 },
		DeletePoint = { x = 293.29, y = -334.23, z = 44.10 }
	},
	Garage_RedzoneSpawn = {
		GaragePoint = { x = 723.16, y = -2017.15, z = 29.29 - 0.95 },
		SpawnPoint = { x = 732.99, y = -2033.04, z = 29.27, h = 356.26 },
		DeletePoint = { x = 725.37, y = -2032.69, z = 29.28 - 0.9 }
	},
	Garage_NearPD = {
		GaragePoint = { x = 472.1, y = -1112.84, z = 29.2 - 0.9 },
		SpawnPoint = { x = 464.63, y = -1106.19, z = 29.2, h = 177.71 },
		DeletePoint = { x = 479.26, y = -1106.84, z = 29.2 - 0.9 }
	},
	Garage_NearWeedField = {
		GaragePoint = { x = -325.37, y = -1356.33, z = 31.3 - 0.9 },
		SpawnPoint = { x = -345.07, y = -1350.46, z = 31.27, h = 173.89 },
		DeletePoint = { x = -348.98, y = -1373.13, z = 31.39 - 0.9 }
	},
	Garage_Legion = {
		GaragePoint = { x = 213.55, y = -809.2, z = 31.01 - 0.95 },
		SpawnPoint = { x = 232.23, y = -794.33, z = 30.58, h = 160.82 },
		DeletePoint = { x = 214.18, y = -793.64, z = 30.85 - 0.9 }
	},
	Garage_LittleSeoul = {
		GaragePoint = { x = -451.48, y = -793.98, z = 30.54 - 0.95 },
		SpawnPoint = { x = -472.33, y = -808.44, z = 30.54, h = 178.43 },
		DeletePoint = { x = -444.4, y = -808.81, z = 30.54 - 0.9 }
	},
	Garage_NearChurch = {
		GaragePoint = { x = -1809.23, y = -343.5, z = 43.6 - 0.95 },
		SpawnPoint = { x = -1808.92, y = -336.02, z = 43.56, h = 316.44 },
		DeletePoint = { x = -1818.98, y = -330.55, z = 43.42 - 0.9 }
	},
	Garage_Hotel = {
		GaragePoint = { x = -1303.63, y = 278.12, z = 64.26 - 0.95 },
		SpawnPoint = { x = -1301.33, y = 252.84, z = 62.66, h = 5.54 },
		DeletePoint = { x = -1288.98, y = 266.45, z = 64.11 - 0.9 }
	},
	Garage_NearPacificBankRight = {
		GaragePoint = { x = 598.97, y = 90.69, z = 92.83 - 0.95 },
		SpawnPoint = { x = 621.7, y = 103.95, z = 92.44, h = 163.02 },
		DeletePoint = { x = 605.29, y = 105.61, z = 92.88 - 0.9 }
	},
	Garage_Airport = {
		GaragePoint = { x = -1093.06, y = -2227.47, z = 13.23 - 0.95 },
		SpawnPoint = { x = -1063.3, y = -2248.43, z = 11.63, h = 262.13 },
		DeletePoint = { x = -1095.79, y = -2208.74, z = 13.27 - 0.9 }
	},
	Garage_SniperRZ = {
		GaragePoint = { x = 1348.82, y = 1145.78, z = 113.76 - 0.95 },
		SpawnPoint = { x = 1339.34, y = 1189.24, z = 109.77, h = 109.77 },
		DeletePoint = { x = 1354.96, y = 1188.35, z = 112.2 - 0.9 }
	},
	Garage_Beach = {
		GaragePoint = { x = -1184.05, y = -1509.65, z = 4.65 - 0.95 },
		SpawnPoint = { x = -1180.95, y = -1480.7, z = 4.38, h = 211.04 },
		DeletePoint = { x = -1191.93, y = -1492.74, z = 4.38 - 0.9 }
	},
	Garage_Kush = {
		GaragePoint = { x = -1122.73, y = -1708.22, z = 4.45 },
		SpawnPoint = { x = -1144.89, y = -1752.05, z = 4.02, h = 305.05 },
		DeletePoint = { x = -1141.0, y = -1710.43, z = 4.46 },
	},
}

garagesConfig.CarPounds = {
	Pound_LosSantos = {
		PoundPoint = { x = 408.61, y = -1625.47, z = 28.39 },
		SpawnPoint = { x = 405.64, y = -1643.4, z = 27.61, h = 229.54 }
	},
	Pound_KushGangK = {
		PoundPoint = { x = -1454.02, y = -499.04, z = 32.45 },
		SpawnPoint = { x = -1456.01, y = -490.19, z = 33.84, h = 306.98 }
	},
	Pound_KushMansion = {
		PoundPoint = { x = -3189.56, y = 811.53, z = 8.93 },
		SpawnPoint = { x = -3192.84, y = 799.7, z = 8.94, h = 209.5 }
	},
	Pound_KushTrack = {
		PoundPoint = { x = 1757.3, y = 3298.29, z = 41.15 },
		SpawnPoint = { x = 1787.83, y = 3246.33, z = 42.49, h = 83.82 }
	},
	Pound_KushDealer = {
		PoundPoint = { x = -1176.81, y = -1737.06, z = 4.58 },
		SpawnPoint = { x = -1157.14, y = -1778.25, z = 4.43, h = 58.75 }
	},
	Pound_Grove = {
		PoundPoint = { x = -76.96, y = -1830.54, z = 26.0 },
		SpawnPoint = { x = -54.81, y = -1847.4, z = 25.94, h = 319.95 }
	},
	Pound_PillBox = {
		PoundPoint = { x = 56.26, y = -876.56, z = 29.68 },
		SpawnPoint = { x = 22.72, y = -889.36, z = 29.61, h = 284.59 }
	},
	Pound_MP = {
		PoundPoint = { x = 1034.36, y = -767.28, z = 57.02 },
		SpawnPoint = { x = 1029.58, y = -763.97, z = 56.57, h = 55.71 }
	},
	Pound_ParkingGarageByGrove = {
		PoundPoint = { x = 391.45, y = -1675.86, z = 32.53 - 0.9 },
		SpawnPoint = { x = 391.71, y = -1666.52, z = 32.53, h = 49.25 }
	},
	Pound_Beach = {
		PoundPoint = { x = -1585.1, y = -838.55, z = 8.98 },
		SpawnPoint = { x = -1602.9, y = -817.75, z = 8.57, h = 141.01 }
	},
	Pound_Integrity = {
		PoundPoint = { x = 276.63, y = -341.88, z = 43.95 },
		SpawnPoint = { x = 275.18, y = -326.06, z = 44.92, h = 165.44 }
	},
	Pound_North = {
		PoundPoint = { x = -341.53, y = 270.92, z = 84.58 },
		SpawnPoint = { x = -344.99, y = 298.22, z = 84.76, h = 181.55 }
	},
	Pound_RedzoneSpawn = {
		PoundPoint = { x = 724.55, y = -2008.56, z = 29.29 - 0.95 },
		SpawnPoint = { x = 732.99, y = -2033.04, z = 29.27, h = 356.26 }
	},
	Pound_NearPD = {
		PoundPoint = { x = 457.62, y = -1103.68, z = 29.2 - 0.9 },
		SpawnPoint = { x = 464.63, y = -1106.19, z = 29.2, h = 177.71 }
	},
	Pound_NearWeedField = {
		PoundPoint = { x = -325.98, y = -1348.26, z = 31.35 - 0.9 },
		SpawnPoint = { x = -345.07, y = -1350.46, z = 31.27, h = 173.89 }
	},
	Pound_Legion = {
		PoundPoint = { x = 215.13, y = -805.48, z = 30.81 - 0.9 },
		SpawnPoint = { x = 232.23, y = -794.33, z = 30.58, h = 160.82 }
	},
	Pound_LittleSeoul = {
		PoundPoint = { x = -447.58, y = -797.38, z = 30.55 - 0.9 },
		SpawnPoint = { x = -472.33, y = -808.44, z = 30.54, h = 178.43 }
	},
	Pound_NearChurch = {
		PoundPoint = { x = -1811.69, y = -331.12, z = 43.47 - 0.9 },
		SpawnPoint = { x = -1808.92, y = -336.02, z = 43.56, h = 316.44 }
	},
	Pound_Hotel = {
		PoundPoint = { x = -1293.29, y = 272.12, z = 64.32 - 0.9 },
		SpawnPoint = { x = -1301.33, y = 252.84, z = 62.66, h = 5.54 }
	},
	Pound_NearPacificBankRight = {
		PoundPoint = { x = 596.17, y = 95.4, z = 92.9 - 0.9 },
		SpawnPoint = { x = 621.7, y = 103.95, z = 92.44, h = 163.02 }
	},
	Pound_Airport = {
		PoundPoint = { x = -1079.03, y = -2242.12, z = 13.23 - 0.9 },
		SpawnPoint = { x = -1063.3, y = -2248.43, z = 11.63, h = 262.13 }
	},
	Pound_pd = {
		PoundPoint = { x = 457.4, y = -1010.63, z = 28.32 - 0.9 },
		SpawnPoint = { x = 440.78, y = -1019.8, z = 28.68, h = 90.72 }
	},
	Pound_SniperRZ = {
		PoundPoint = { x = 1349.04, y = 1143.4, z = 113.76 - 0.9 },
		SpawnPoint = { x = 1343.74, y = 1188.37, z = 110.65, h = 110.65 }
	},
	Pound_Beach = {
		PoundPoint = { x = -1192.47, y = -1504.97, z = 4.36 - 0.9 },
		SpawnPoint = { x = -1180.95, y = -1480.7, z = 4.38, h = 211.04 }
	},
}


