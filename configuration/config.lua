Config = {}

--| Discord Webhook in 'configuration/webhook.lua'
Config.CommandName = 'panicbutton'
Config.Key = 'K' --| Key to start a panic | NOTE: Its a Keymapping
Config.Cooldown = 20 --| Cooldown between panics | In seconds
Config.CheckForUpdates = true --| Check for updates?

Config.Templates = {
    {
        name = 'POLICE PANIC',
        time = 60, --| in seconds
        mainJob = 'police',
        jobs = {
            police = true
        },
        blip = function(coords) --| Change it if you know what you are doing
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
        name = 'SHERIFF PANIC',
        time = 60, --| in seconds
        mainJob = 'sheriff',
        jobs = {
            sheriff = true
        },
        blip = function(coords) --| Change it if you know what you are doing
            local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

            SetBlipSprite(blip, 161)
            SetBlipColour(blip, 1)
            SetBlipScale(blip, 2.0)
            SetBlipAlpha(blip, 255)
            SetBlipAsShortRange(blip, false)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName('Panicbutton: Sheriff')
            EndTextCommandSetBlipName(blip)
            PulseBlip(blip)
            SetBlipRoute(blip, true)
            SetBlipRouteColour(blip, 1)

            return blip
        end,
    },
}

--| Place here your punish actions
Config.PunishPlayer = function(player, reason)
    if not IsDuplicityVersion() then return end
    if Webhook.Settings.punish then
        DiscordLog(player, 'PUNISH', reason, 'punish')
    end

    DropPlayer(player, reason)
end

--| Place here your notification
Config.Notification = function(player, msg)
    if IsDuplicityVersion() then
        TriggerClientEvent('esx:showNotification', player, msg, 'info')
    else
        ESX.ShowNotification(msg)
    end
end

--| Place here your esx Import
Config.EsxImport = function()
	if IsDuplicityVersion() then
		return exports.es_extended:getSharedObject()
	else
		return exports.es_extended:getSharedObject()
	end
end