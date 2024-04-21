---@diagnostic disable: cast-local-type, need-check-nil
CORE = exports.zrx_utility:GetUtility()
BLIP_DATA, PLAYER_CACHE, PLAYERS = {}, {}, {}
local TriggerClientEvent = TriggerClientEvent
local GetPlayers = GetPlayers
local vector3 = vector3
local Wait = Wait

RegisterNetEvent('zrx_utility:bridge:playerLoaded', function(player, xPlayer, isNew)
    PLAYER_CACHE[player] = CORE.Server.GetPlayerCache(player)
    PLAYERS[player] = true

    for k, data in pairs(BLIP_DATA) do
        if data.jobs[xPlayer.job.name] then
            TriggerClientEvent('zrx_panicbutton:client:startBlip', player, data.coords, data.index)
        end
    end
end)

CreateThread(function()
    if Config.CheckForUpdates then
        CORE.Server.CheckVersion('zrx_panicbutton')
    end

    for i, player in pairs(GetPlayers()) do
        player = tonumber(player)
        PLAYER_CACHE[player] = CORE.Server.GetPlayerCache(player)
        PLAYERS[player] = true
    end
end)

AddEventHandler('playerDropped', function()
    PLAYERS[source] = nil
end)

RegisterNetEvent('zrx_panicbutton:server:syncBlip', function(coords, index, street)
    local xPlayer = CORE.Bridge.getPlayerObject(source)

    if not coords or not index or not street or type(coords) ~= 'vector3' or type(index) ~= 'number' or type(street) ~= 'string' then
        return Config.PunishPlayer(xPlayer.player, 'Tried to trigger "zrx_panicbutton:server:syncBlip"')
    end

    BLIP_DATA[#BLIP_DATA + 1] = {
        owner = source,
        jobs = Config.Templates[index].jobs,
        time = Config.Templates[index].time,
        index = index,
        coords = coords,
        street = street
    }

    if Webhook.Links.startPanic:len() > 0 then
        local message = ([[
            The player triggered a panicbutton

            Coords: **%s**
            Street: **%s**
            Blip Index: **%s**
            Config Index: **%s**
        ]]):format(coords, street, index, #BLIP_DATA)

        CORE.Server.DiscordLog(xPlayer.player, 'START PANICBUTTON', message, Webhook.Links.startPanic)
    end

    local xTarget
    for player, state in pairs(PLAYERS) do
        xTarget = CORE.Bridge.getPlayerObject(player)

        if Config.Templates[index].jobs[xTarget.job.name] then
            CORE.Bridge.notification(player, (Strings.panicbutton):format(street, Config.Templates[index].name))
            TriggerClientEvent('zrx_panicbutton:client:startSyncBlip', player, vector3(coords.x, coords.y, coords.z), index)
        end
    end
end)

CreateThread(function()
	while true do
		for i, data in pairs(BLIP_DATA) do
			if data.time == 0 then
                for player, state in pairs(PLAYERS) do
                    TriggerClientEvent('zrx_panicbutton:server:removeSyncBlip', player, i, data.street)

                    if Webhook.Links.endPanic:len() > 0 then
                        local message = ([[
                            The player triggered a panicbutton
                
                            Coords: **%s**
                            Street: **%s**
                            Blip Index: **%s**
                            Config Index: **%s**
                        ]]):format(data.coords, data.street, data.index, i)

                        CORE.Server.DiscordLog(data.owner, 'END PANICBUTTON', message, Webhook.Links.endPanic)
                    end
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