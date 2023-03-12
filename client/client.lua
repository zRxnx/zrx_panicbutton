ESX = Config.esxImport()
COOLDOWN, BLIP_DATA = false, {}

RegisterNetEvent('esx:playerLoaded',function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterCommand(Config.CommandName, function()
    local job = ESX.PlayerData.job.name:lower()
    for k, data in pairs(Config.PanicButtons) do
        if job == data.job:lower() then
            if COOLDOWN then
                Config.Notification(nil, Strings.cooldown)
                break
            else
                local ped = PlayerPedId()
                local pedCoords = GetEntityCoords(ped)
                local street = GetStreetNameAtCoord(pedCoords.x, pedCoords.y, pedCoords.z)
                local streetName = GetStreetNameFromHashKey(street)

                COOLDOWN = true
                Cooldown()
                Config.Notification(nil, Strings.send)
                TriggerServerEvent('zrx_panicbutton:server:syncBlip', vector3(pedCoords.x, pedCoords.y, pedCoords.z), k, streetName)
                break
            end
        end
    end
end)
RegisterKeyMapping(Config.CommandName, Strings.keyMapping, 'keyboard', Config.Key)
TriggerEvent('chat:addSuggestion', '/' .. Config.CommandName, Strings.commandSug, {})

RegisterNetEvent('zrx_panicbutton:client:startBlip', function(coords, index)
    BLIP_DATA[#BLIP_DATA + 1] = {
		blip = Config.PanicButtons[index].blip(vector3(coords.x, coords.y, coords.z)),
		time = Config.PanicButtons[index].time
	}
end)

CreateThread(function()
	::loop::
		for k, data in pairs(BLIP_DATA) do
			if data.time <= 1 then
				SetBlipRoute(data.blip, false)
				RemoveBlip(data.blip)
				BLIP_DATA[k] = nil
			else
				BLIP_DATA[k] = {
					blip = data.blip,
					time = data.time - 1
				}
			end
		end
		Wait(1000)
	goto loop
end)

exports('isOnCooldown', function()
    return COOLDOWN
end)

exports('activeBlips', function()
    return BLIP_DATA
end)