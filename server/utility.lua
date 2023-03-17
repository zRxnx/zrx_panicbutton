local curResName = GetCurrentResourceName()
local curVersion = GetResourceMetadata(curResName, 'version')
local resourceName = 'zrx_panicbutton'
local continueCheck = true

CreateThread(function()
    if curResName ~= 'zrx_panicbutton' then
        resourceName = ('zrx_repairkit (%s)'):format(curResName)
    end
end)

AddEventHandler('onResourceStart', function(res)
    if res ~= curResName then return end

    while continueCheck do
        PerformHttpRequest('https://github.com/zRxnx/zrx_panicbutton/releases/latest', CheckVersion, 'GET')
        Wait(3600000)
    end
end)

CheckVersion = function(err, responseText, headers)
    local repoVersion, repoURL = GetRepoInformations()

    CreateThread(function()
        if curVersion ~= repoVersion then
            print(('^0[^3WARNING^0] %s is ^1NOT ^0up to date!'):format(resourceName))
            print(('^0[^3WARNING^0] Your Version: ^2%s^0'):format(curVersion))
            print(('^0[^3WARNING^0] Latest Version: ^2%s^0'):format(repoVersion))
            print(('^0[^3WARNING^0] Get the latest Version from: ^2%s^0'):format(repoURL))
        else
            print(('^0[^2INFO^0] %s is up to date! (^2%s^0)'):format(resourceName, curVersion))
            continueCheck = false
        end
    end)
end

GetRepoInformations = function()
    local repoVersion, repoURL

    PerformHttpRequest('https://api.github.com/repos/zRxnx/zrx_panicbutton/releases/latest', function(err, response, headers)
        if err == 200 then
            local data = json.decode(response)

            repoVersion = data.tag_name
            repoURL = data.html_url
        else
            repoVersion = curVersion
            repoURL = 'https://github.com/zRxnx/zrx_panicbutton'
        end
    end, 'GET')

    repeat
        Wait(500)
    until (repoVersion and repoURL)

    return repoVersion, repoURL
end