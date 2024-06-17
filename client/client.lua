ESX = exports['es_extended']:getSharedObject()

Citizen.CreateThread(function()
	ESX.TriggerServerCallback('OnlineJobs:getConnectedPlayers', function(connectedPlayers)
		UpdatePlayerTable(connectedPlayers)
	end)
end)

local showing = true
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlPressed(0, 38) then
            showing = true
        else
            showing = true
        end
    end
end)

Citizen.CreateThread(function()
	Citizen.Wait(500)
	SendNUIMessage({
		action = 'updateServerInfo',
		maxPlayers = GetConvarInt('sv_maxclients', 128),
	})
end)

CreateThread(function()
    while true do
        Wait(100)
        SendNUIMessage({
            showing =  showing,
        })
    end
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)
	SendNUIMessage({
		showing = showing
	})
end)

RegisterNetEvent('OnlineJobs:updateConnectedPlayers')
AddEventHandler('OnlineJobs:updateConnectedPlayers', function(connectedPlayers)
	UpdatePlayerTable(connectedPlayers)
end)

RegisterNetEvent('OnlineJobs:toggleID')
AddEventHandler('OnlineJobs:toggleID', function(state)
	if state then
		idVisable = state
	else
		idVisable = not idVisable
	end

	SendNUIMessage({
		action = 'toggleID',
		state = idVisable
	})
end)


function UpdatePlayerTable(connectedPlayers)
	local formattedPlayerList, num = {}, 1
	local ems, police, taxi, mechanic,bennys, legal1, players = 0, 0, 0, 0, 0, 0, 0, 0 -- Añadir aqui los trabajos

	for k,v in pairs(connectedPlayers) do

		if num == 1 then
			table.insert(formattedPlayerList, ('<tr><td></td><td>%s</td><td></td>'):format(v.id, v.ping))
			num = 2
		elseif num == 2 then
			table.insert(formattedPlayerList, ('<td></td><td>%s</td><td></td></tr>'):format(v.id, v.ping))
			num = 1
		end
 -- Apara añadir mas trabajos al contador copie uno y pegalo, cambia el nombre del trabajo
		players = players + 1
		if v.job == 'ambulance' then
			ems = ems + 1
			if ems > 3 then
				ems = '+3'
			end
		elseif v.job == 'police' or v.job == "sheriff" then
			police = police + 1
			if police > 3 then
				police = '+3'
			end
		elseif v.job == 'taxi' then
			taxi = taxi + 1
			if taxi > 3 then
				taxi = '+3'
			end
		elseif v.job == 'mechanic'  then
			mechanic = mechanic + 1
		elseif v.job == 'legal1' then
			legal1 = legal1 + 1
			if legal1 > 2 then
				legal1 = '+2'
			end
		end
	end

	if num == 1 then
		table.insert(formattedPlayerList, '</tr>')
	end

	SendNUIMessage({
		action  = 'updatePlayerList',
		players = table.concat(formattedPlayerList)
	})

	SendNUIMessage({
		action = 'updatePlayerJobs',
		jobs   = {ems = ems, police = police, taxi = taxi, mechanic = mechanic, legal1 = legal1, player_count = players} -- Esta linea es para que se actualice el contador de trabajos
	})
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		HideHudComponentThisFrame( 2 ) -- Weapon Icon
        HideHudComponentThisFrame( 6 ) -- Vehicle Name
        HideHudComponentThisFrame( 7 ) -- Area Name
        HideHudComponentThisFrame( 8 ) -- Vehicle Class      
        HideHudComponentThisFrame( 9 ) -- Street Name
	end
end)



