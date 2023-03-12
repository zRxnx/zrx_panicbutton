local seconds, minutes = 1000, 60000
Config = {}

Config.CommandName = 'panicbutton'
Config.Key = 'K' --| Key to start a panic // NOTE: Its a Keymapping
Config.Cooldown = 20 * seconds --| How long should the blip on the map?
--| Discord Webhook in 'server/server.lua'

Config.PanicButtons = {
    {
        time = 30, --| in seconds
        job = 'police',
        blip = function(coords) -- change it if you know what you are doing
            local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
            SetBlipSprite(blip, 161)
            SetBlipColour(blip, 1)
            SetBlipScale(blip, 2.0)
            SetBlipAlpha(blip, 255)
            SetBlipAsShortRange(blip, false)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName('Panicbutton: Police')
            EndTextCommandSetBlipName(blip)
            PulseBlip(blip)
            SetBlipRoute(blip, true)
            SetBlipRouteColour(blip, 1)

            return blip
        end,
    },
    {
        time = 10, --| in seconds
        job = 'amublance',
        blip = function(coords) -- change it if you know what you are doing
            local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
            SetBlipSprite(blip, 161)
            SetBlipColour(blip, 1)
            SetBlipScale(blip, 2.0)
            SetBlipAlpha(blip, 255)
            SetBlipAsShortRange(blip, false)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName('Panicbutton: Ambulance')
            EndTextCommandSetBlipName(blip)
            PulseBlip(blip)
            SetBlipRoute(blip, true)
            SetBlipRouteColour(blip, 1)

            return blip
        end,
    }
}

--| Place your notification here
Config.Notification = function(source, msg)
    if IsDuplicityVersion() then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.showNotification(msg)
    else
        ESX.ShowNotification(msg)
    end
end

--| Place your esx Import here
Config.esxImport = function()
	if IsDuplicityVersion() then
		return exports['es_extended']:getSharedObject()
	else
		return exports['es_extended']:getSharedObject()
	end
end