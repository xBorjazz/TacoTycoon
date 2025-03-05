extends TextureButton

#@onready var client = get_node("/root/Node2D/CanvasLayer/Client")
var new_scene = load("res://Scenes/multiplayer.tscn").instantiate()

func _ready():
	self.pressed.connect(_on_multiplayer_button_pressed)

func _on_multiplayer_button_pressed():
	print("Botón presionado. Iniciando el juego...")  # Verifica que se ejecute la función

	# Eliminar la escena del menú principal
	print("Eliminando la escena del menú principal...")
	#get_tree().root.get_child(0).queue_free()  # Elimina el nodo raíz actual (menú principal)

	# Cambiar a la nueva escena principal del juego
	print("Cambiando a la nueva escena...")
	#get_tree().root.print_tree_pretty()

	get_tree().current_scene.queue_free()  # Elimina la escena actual
	get_tree().root.add_child(new_scene)
	SuppliesUi.restart_ready()
	Spawner.restart_ready()
	PathFollow2d.restart_ready()
	Recipe.restart_ready()
	GradientDescent.restart_ready()
	IngredientsManager.restart_ready()
	GraphPlot.restart_ready()
	client.restart_ready()
	#multiplayer.restart_ready()
	MultiplayerButton.restart_ready()
	LevelManager.restart_ready()
	GlobalProgressBar.restart_ready()
	
	get_tree().current_scene = new_scene  # Define la nueva escena como activa

func restart_ready():
	print("🔄 [Button] Reiniciando _ready() con call_deferred()")
	call_deferred("_ready")
