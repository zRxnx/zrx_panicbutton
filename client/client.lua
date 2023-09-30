ESX = Config.EsxImport()
COOLDOWN, BLIP_DATA = false, {}

local GetEntityCoords = GetEntityCoords
local GetStreetNameAtCoord = GetStreetNameAtCoord
local GetStreetNameFromHashKey = GetStreetNameFromHashKey
local SetBlipRoute = SetBlipRoute
local RemoveBlip = RemoveBlip
local vector3 = vector3
local DoesBlipExist = DoesBlipExist
local TriggerServerEvent = TriggerServerEvent

RegisterNetEvent('esx:playerLoaded',function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterCommand(Config.CommandName, function()
    if COOLDOWN then
        Config.Notification(nil, Strings.cooldown)
        return
    end
    StartCooldown()

    local pedCoords, streetName
    for k, data in pairs(Config.Templates) do
        if data.mainJob == ESX.PlayerData.job.name then
            pedCoords = GetEntityCoords(cache.ped)
            streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(pedCoords.x, pedCoords.y, pedCoords.z))

            Config.Notification(nil, Strings.send)
            TriggerServerEvent('zrx_panicbutton:server:syncBlip', vector3(pedCoords.x, pedCoords.y, pedCoords.z), k, streetName)
            break
        end
    end
end)
RegisterKeyMapping(Config.CommandName, Strings.keyMapping, 'keyboard', Config.Key)
TriggerEvent('chat:addSuggestion', '/' .. Config.CommandName, Strings.commandSug, {})

RegisterNetEvent('zrx_panicbutton:client:startSyncBlip', function(coords, index)
    BLIP_DATA[#BLIP_DATA + 1] = {
		blip = Config.Templates[index].blip(vector3(coords.x, coords.y, coords.z)),
		time = Config.Templates[index].time,
        index = index
	}

    if Config.Sounds then
        Config.PlaySound()
    end
end)

RegisterNetEvent('zrx_panicbutton:server:removeSyncBlip', function(index, street)
    if DoesBlipExist(BLIP_DATA[index].blip) then
        Config.Notification(nil, (Strings.PanicbuttonEnd):format(street))
        SetBlipRoute(BLIP_DATA[index].blip, false)
        RemoveBlip(BLIP_DATA[index].blip)
        BLIP_DATA[index] = nil
    end
end)

exports('hasCooldown', function()
    return COOLDOWN
end)

exports('activeBlips', function()
    return BLIP_DATA
end)