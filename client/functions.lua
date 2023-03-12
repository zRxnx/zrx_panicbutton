Cooldown = function()
	if type(Config.Cooldown) ~= 'number' then return end

	CreateThread(function()
		if COOLDOWN then
			Wait(Config.Cooldown)
			COOLDOWN = false
		end
	end)
end