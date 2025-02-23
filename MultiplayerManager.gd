extends Node

const PORT = 9999
var peer = WebSocketMultiplayerPeer.new()
var players_money = {}

func _ready():
	start_server()

func start_server():
	var err = peer.create_server(PORT)
	if err != OK:
		print("❌ Error al iniciar el servidor WebSocket en el puerto %d. Código: %d" % [PORT, err])
		return

	multiplayer.multiplayer_peer = peer
	print("🟢 Servidor WebSocket iniciado en el puerto %d" % PORT)

func _process(delta):
	peer.poll()  

@rpc("any_peer", "call_local")
func player_ready(player_id):
	if player_id not in players_money:
		players_money[player_id] = 0  
		print("✅ Cliente", player_id, "se ha conectado.")
		print("📋 Lista de jugadores conectados:", players_money.keys())

	for existing_player_id in players_money.keys():
		if existing_player_id != player_id:
			print("📤 Enviando dinero de", existing_player_id, "a nuevo jugador", player_id, "->", players_money[existing_player_id])
			rpc_id(player_id, "sync_money", existing_player_id, players_money[existing_player_id])

@rpc("any_peer", "call_local")
func update_money(player_id, money):
	if player_id in players_money:
		players_money[player_id] = money  
		print("💰 Cliente", player_id, "actualizó su dinero a:", money)

		# 🔄 **Enviar datos a `DevTools`**
		var message = "📩 SERVIDOR: Jugador " + str(player_id) + " tiene $" + str(money)
		send_to_devtools(message)

		for peer_id in peer.get_peer_ids():
			if peer_id != player_id:  
				print("📤 Enviando dinero de", player_id, "a", peer_id, "->", money)
				rpc_id(peer_id, "sync_money", player_id, money)
	else:
		print("⚠️ Cliente", player_id, "no está en la lista de jugadores conectados.")

# 🔥 **Función para Enviar Mensajes a DevTools**
func send_to_devtools(message):
	for peer_id in peer.get_peer_ids():
		peer.get_peer(peer_id).put_packet(message.to_utf8_buffer())
