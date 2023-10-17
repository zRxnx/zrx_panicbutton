CORE = exports.zrx_utility:GetUtility()
COOLDOWN, BLIP_DATA = false, {}

local SetBlipRoute = SetBlipRoute
local RemoveBlip = RemoveBlip
local vector3 = vector3
local DoesBlipExist = DoesBlipExist

CORE.Client.RegisterKeyMappingCommand(Config.Command, Strings.cmd_desc, Config.Key, function()
    StartPanicbutton()
end)

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
        CORE.Bridge.notification((Strings.Panicbutton_end):format(street))
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