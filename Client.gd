extends Node

@onready var label_my_score = get_node_or_null("/root/Node2D/CanvasLayer/Client/LabelMyScore")
@onready var label_opponent_score = get_node_or_null("/root/Node2D/CanvasLayer/Client/LabelOpponentScore")

var peer = WebSocketMultiplayerPeer.new()
var last_money = -1  
var opponent_money = 0  
var connected = false  

func _ready():
	label_my_score.visible = false
	label_opponent_score.visible = false

func connect_to_server():
	if connected:
		print("⚠️ Ya estás conectado al servidor.")
		return  

	var error = peer.create_client("ws://127.0.0.1:9999")
	if error != OK:
		print("❌ Error al conectar al servidor WebSocket. Código:", error)
		return

	multiplayer.multiplayer_peer = peer
	connected = true  
	print("🔵 Conectado al servidor WebSocket.")

	rpc_id(1, "player_ready", multiplayer.get_unique_id())

func update_score():
	if not connected:
		return  

	var my_money = Inventory.player_money  
	if my_money != last_money:  
		last_money = my_money

		if label_my_score != null:
			label_my_score.text = "Mi Dinero: $" + str(my_money)
			label_my_score.visible = true
		else:
			print("❌ Error: No se encontró LabelMyScore en Client.")

		print("📤 Enviando dinero al servidor:", my_money)
		rpc_id(1, "update_money", multiplayer.get_unique_id(), my_money)
		
	if label_opponent_score != null:
		label_opponent_score.text = "Dinero Rival: $" + str(opponent_money)
		label_opponent_score.visible = true
	else:
		print("❌ No se encontró LabelOpponentScore en Client.")

func _process(delta):
	if connected:
		peer.poll()  
		update_score()

@rpc("any_peer", "call_local")
func sync_money(player_id, money):
	print("📥 Recibido dinero del jugador", player_id, "->", money)  

	if player_id != multiplayer.get_unique_id():  
		opponent_money = money  
		if label_opponent_score != null:
			label_opponent_score.text = "Dinero Rival: $" + str(opponent_money)
			label_opponent_score.visible = true
			print("🏆 Dinero del rival actualizado:", opponent_money)
		else:
			print("❌ No se puede actualizar LabelOpponentScore: No existe en la escena.")
