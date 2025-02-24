extends Node

const PORT = 9999
var udp_server = PacketPeerUDP.new()
var players = {}  # 🔥 Diccionario para almacenar la IP y el dinero de cada jugador

func _ready():
	var err = udp_server.bind(PORT)
	if err != OK:
		print("❌ Error al iniciar el servidor UDP. Código:", err)
		return
	print("🟢 Servidor UDP iniciado en el puerto", PORT)

func _process(delta):
	while udp_server.get_available_packet_count() > 0:
		var packet = udp_server.get_packet().get_string_from_utf8()
		var parts = packet.split(":")

		if parts[0] == "JOIN":
			var player_id = parts[1]
			players[player_id] = {"money": 0, "ip": udp_server.get_packet_ip(), "port": udp_server.get_packet_port()}
			print("✅ Jugador conectado:", player_id, "IP:", players[player_id]["ip"])

		elif parts[0] == "MONEY":
			var player_id = parts[1]
			var money = int(parts[2])

			if player_id in players:
				players[player_id]["money"] = money  # 🔥 Guardar dinero del jugador
				print("💰 Recibido dinero del jugador", player_id, "->", money)
				sync_money_with_clients(player_id, money)

func sync_money_with_clients(player_id, money):
	for id in players.keys():
		if id != player_id:
			var msg = "SYNC:" + str(player_id) + ":" + str(money)
			udp_server.set_dest_address(players[id]["ip"], players[id]["port"])
			udp_server.put_packet(msg.to_utf8_buffer())
