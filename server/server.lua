ESX, BLIP_DATA, PLAYER_CACHE, PLAYERS = Config.EsxImport(), {}, {}, {}
local TriggerClientEvent = TriggerClientEvent
local GetPlayers = GetPlayers
local vector3 = vector3
local Wait = Wait

RegisterNetEvent('esx:playerLoaded', function(player, xPlayer, isNew)
    PLAYER_CACHE[player] = GetPlayerData(player)
    PLAYERS[player] = true

    for k, data in pairs(BLIP_DATA) do
        if data.jobs[xPlayer.job.name] then
            TriggerClientEvent('zrx_panicbutton:client:startBlip', player, data.coords, data.index)
        end
    end
end)

CreateThread(function()
    for i, data in pairs(GetPlayers()) do
        data = tonumber(data)
        PLAYER_CACHE[data] = GetPlayerData(data)
        PLAYERS[data] = true
    end
end)

AddEventHandler('playerDropped', function()
    PLAYERS[source] = nil
end)

RegisterNetEvent('zrx_panicbutton:server:syncBlip', function(coords, index, street)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not coords or not index or not street or type(coords) ~= 'vector3' or type(index) ~= 'number' or type(street) ~= 'string' then
        return Config.PunishPlayer(xPlayer.source, 'Tried to trigger "zrx_panicbutton:server:syncBlip"')
    end

    if Webhook.Settings.panicbutton then
        DiscordLog(xPlayer.source, Strings.logTitle, Strings.logDesc, 'panicbutton')
    end

    BLIP_DATA[#BLIP_DATA + 1] = {
        jobs = Config.Templates[index].jobs,
        time = Config.Templates[index].time,
        index = index,
        coords = coords,
        street = street
    }

    local xTarget
    for player, state in pairs(PLAYERS) do
        xTarget = ESX.GetPlayerFromId(player)
        if not xTarget then goto continue end

        if Config.Templates[index].jobs[xTarget.job.name] then
            Config.Notification(player, (Strings.panicbutton):format(street, Config.Templates[index].name))
            TriggerClientEvent('zrx_panicbutton:client:startBlip', player, vector3(coords.x, coords.y, coords.z), index)
        end

        ::continue::
    end
end)

CreateThread(function()
	while true do
		for i, data in pairs(BLIP_DATA) do
			if data.time <= 1 then
                for player, state in pairs(PLAYERS) do
                    TriggerClientEvent('zrx_panicbutton:server:removeSyncBlip', player, i, data.street)
                end
				BLIP_DATA[i] = nil
			else
                BLIP_DATA[i].time -= 1
			end
		end

		Wait(1000)
	end
end)

exports('activeBlips', function()
    return BLIP_DATA
end)