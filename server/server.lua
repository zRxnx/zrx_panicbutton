ESX = Config.esxImport()
WEBHOOK = ''

RegisterNetEvent('zrx_panicbutton:server:syncBlip', function(coords, index, street)
    if type(coords) ~= 'vector3' or type(index) ~= 'number' or type(street) ~= 'string' then
        PunishPlayer(source, Strings.exploit)
        return
    end

    DiscordLog(source, Strings.logTitle, Strings.logDesc)
    for k, data in pairs(Config.PanicButtons) do
        for v, data3 in pairs(GetPlayers()) do
            local xTarget = ESX.GetPlayerFromId(data3)

            if data.job == xTarget.job.name then
                if xTarget.source ~= source then
                    Config.Notification(data3, (Strings.panicbutton):format(street))
                end
                TriggerClientEvent('zrx_panicbutton:client:startBlip', data3, vector3(coords.x, coords.y, coords.z), index)
            end
        end
    end
end)