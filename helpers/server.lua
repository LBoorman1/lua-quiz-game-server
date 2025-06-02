local server = {}

-- allow client to join a room, if not exists create one
function server:join_room(rooms, room_code, ip, port)
	rooms[room_code] = rooms[room_code] or {}

	-- Check if client already in room
	local already_in_room = false
	for _, client in ipairs(rooms[room_code]) do
		if client.ip == ip and client.port == port then
			already_in_room = true
			break
		end
	end

	-- Add new client if not already in room
	if not already_in_room then
		table.insert(rooms[room_code], { ip = ip, port = port })
		print(string.format("Added client to room %s (%d/%d)", room_code, #rooms[room_code]))
	end
end

-- Broadcast all clients to each client
function server:broadcast_players(rooms, room_code, socket)
	local players = rooms[room_code]

	for i, client in ipairs(players) do
		local peers = {}
		for j, other_player in ipairs(players) do
			if i ~= j then
				table.insert(peers, other_player.ip .. " " .. other_player.port)
			end
		end

		-- Create CSV data for peers
		local peer_data = "PEERS " .. table.concat(peers, ",")
		socket:sendto(peer_data, client.ip, client.port)
		print(string.format("BROADCAST: sent peers data to CLIENT: %s", client.ip .. ":" .. client.port))
	end
end

return server
