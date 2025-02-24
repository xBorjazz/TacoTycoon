extends Node

@onready var label_my_score = get_node_or_null("/root/Node2D/CanvasLayer/Client/LabelMyScore")
@onready var label_opponent_score = get_node_or_null("/root/Node2D/CanvasLayer/Client/LabelOpponentScore")
@onready var sync = get_node_or_null("/root/Node2D/CanvasLayer/Client/Sync")

@export var player_money: int = 0 : set = set_money  # 🔥 Sincronizar con MultiplayerSynchronizer

var peer = ENetMultiplayerPeer.new()  # 🔥 Se agregó la declaración de `peer`
var connected = false  

func _ready():
	label_my_score.visible = false
	label_opponent_score.visible = false

	# 🔄 Iniciar la sincronización del dinero con el inventario
	player_money = Inventory.player_money

func connect_to_server():
	if connected:
		print("⚠️ Ya estás conectado al servidor.")
		return  

	var error = peer.create_client("127.0.0.1", 9999)
	if error != OK:
		print("❌ Error al conectar al servidor ENet. Código:", error)
		return

	multiplayer.multiplayer_peer = peer
	connected = true  
	print("🔵 Conectado al servidor ENet.")

	await get_tree().create_timer(1.0).timeout

	if multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
		print("✅ Conexión establecida con el servidor.")
	else:
		print("❌ No se pudo conectar al servidor.")
		connected = false

func update_score():
	if not connected:
		return  

	# 🔄 Actualizar `player_money` con el valor del inventario
	player_money = Inventory.player_money  

	if label_my_score != null:
		label_my_score.text = "Mi Dinero: $" + str(player_money)
		label_my_score.visible = true

	if label_opponent_score != null:
		label_opponent_score.text = "Dinero Rival: $" + str(player_money)  # 🔄 Se actualizará automáticamente con MultiplayerSynchronizer
		label_opponent_score.visible = true

func set_money(value):
	player_money = value
	Inventory.player_money = value  # 🔄 Asegurar que el dinero también se refleje en el inventario

func _process(delta):
	if connected:
		update_score()
