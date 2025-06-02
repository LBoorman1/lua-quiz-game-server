local socket = require("socket")
local ServerHelpers = require("helpers.server")
local udp = socket.udp()

local PORT_NUMBER = 12345
local MAX_PLAYERS_PER_ROOM = 4
local rooms = {}

udp:setsockname("*", PORT_NUMBER)
udp:settimeout(0)

print(string.format("NAT punch server started on port %s", PORT_NUMBER))

while true do
	local data, ip, port = udp:receivefrom()

	if data then
		print(string.format("Received from %s:%d: %s", ip, port, data))

		-- Parse the command and room code i.e "JOIN abcde123"
		local command, room_code = data:match("^(%S+)%s+(%S+)")

		if command == "JOIN" and room_code then
			ServerHelpers:join_room(rooms, room_code, ip, port)
			ServerHelpers:broadcast_players(rooms, room_code, udp)
		end
	end
end
