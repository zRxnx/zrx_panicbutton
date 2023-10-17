Config = {}

--| Discord Webhook in 'configuration/webhook.lua'
Config.Command = 'panicbutton'
Config.Key = 'K' --| Key to start a panic | NOTE: Its a Keymapping
Config.Cooldown = 20 --| Cooldown between panics | In seconds
Config.Sounds = true --| Activate sound
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

--| Place here your sound actions
Config.PlaySound = function()
    for i = 1, 5, 1 do
        PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
        Wait(1000)
    end
end

--| Place here your punish actions
Config.PunishPlayer = function(player, reason)
    if not IsDuplicityVersion() then return end
    if Webhook.Links.punish:len() > 0 then
        local message = ([[
            The player got punished

            Reason: **%s**
        ]]):format(reason)

        CORE.Server.DiscordLog(player, 'PUNISH', message, Webhook.Links.punish)
    end

    DropPlayer(player, reason)
end