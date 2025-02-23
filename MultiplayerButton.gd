extends TextureButton

@onready var client = get_node_or_null("/root/Node2D/CanvasLayer/Client")
@onready var label_my_score = get_node_or_null("/root/Node2D/CanvasLayer/Client/LabelMyScore")
@onready var label_opponent_score = get_node_or_null("/root/Node2D/CanvasLayer/Client/LabelOpponentScore")

var last_money = -1  

func _ready():
	self.pressed.connect(_on_multiplayer_button_pressed)

func _on_multiplayer_button_pressed():
	print("🔄 Botón Multiplayer presionado.")

	if client == null:
		print("❌ Error: No se encontró el nodo Client.")
		return

	client.connect_to_server()
	print("💰 Mostrando dinero del jugador.")

	var my_money = Inventory.player_money  

	if my_money != last_money:  
		last_money = my_money

		if label_my_score != null:
			label_my_score.text = "Mi Dinero: $" + str(my_money)
			label_my_score.visible = true  
		else:
			print("❌ Error: No se encontró LabelMyScore en Client.")

	print("💰 Mostrando dinero del oponente.")

	if label_opponent_score != null:
		label_opponent_score.visible = true
	else:
		print("❌ No se encontró LabelOpponentScore en Client.")
