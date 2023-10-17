local GetEntityCoords = GetEntityCoords
local GetStreetNameAtCoord = GetStreetNameAtCoord
local GetStreetNameFromHashKey = GetStreetNameFromHashKey
local TriggerServerEvent = TriggerServerEvent
local vector3 = vector3

StartPanicbutton = function()
    if COOLDOWN then
        CORE.Bridge.notification(Strings.cooldown)
        return
    end
    StartCooldown()

    local pedCoords, streetName
    for k, data in pairs(Config.Templates) do
        if data.mainJob == CORE.Bridge.getVariables().job.name then
            pedCoords = GetEntityCoords(cache.ped)
            streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(pedCoords.x, pedCoords.y, pedCoords.z))

            CORE.Bridge.notification(Strings.send)
            TriggerServerEvent('zrx_panicbutton:server:syncBlip', vector3(pedCoords.x, pedCoords.y, pedCoords.z), k, streetName)
            break
        end
    end
end

StartCooldown = function()
    if not Config.Cooldown then return end
    COOLDOWN = true

    CreateThread(function()
        SetTimeout(Config.Cooldown * 1000, function()
            COOLDOWN = false
        end)
    end)
end