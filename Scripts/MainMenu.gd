extends Node

# Referencia al botón de inicio (ahora de tipo TextureButton)
var game_start_button : TextureButton = null
var new_scene = load("res://Scenes/node_2d.tscn").instantiate()
var tutorial_scene = load("res://Scenes/tutorial.tscn").instantiate()

# Llamado cuando el nodo entra en el árbol de escenas
func _ready():
	# Obtener la referencia al botón de inicio desde el grupo
	var buttons_in_group = get_tree().get_nodes_in_group("GlobalNodes")
	
	# Verificar si hay algún botón en el grupo
	if buttons_in_group.size() > 0:
		game_start_button = buttons_in_group[0]  # Tomar el primer botón
		print("Botón encontrado en el grupo: ", game_start_button.name)  # Verifica si el botón está en el grupo
		
		# Conectar la señal "pressed" del botón GameStart al método _on_game_start_pressed
		game_start_button.connect("pressed", Callable(self, "_on_game_start_pressed"))
		print("Conexión de la señal realizada con éxito.")

# Llamado cuando el botón GameStart es presionado
func _on_game_start_pressed():
	print("Botón presionado. Iniciando el juego...")  # Verifica que se ejecute la función

	# Eliminar la escena del menú principal
	print("Eliminando la escena del menú principal...")
	#get_tree().root.get_child(0).queue_free()  # Elimina el nodo raíz actual (menú principal)

	# Cambiar a la nueva escena principal del juego
	print("Cambiando a la nueva escena...")
	get_tree().root.print_tree_pretty()

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
	#mmultiplayer.restart_ready()
	#MultiplayerButton.restart_ready()
	LevelManager.restart_ready()
	GlobalProgressBar.restart_ready()
	#Tutorial.restart_ready()
	
	get_tree().current_scene = new_scene  # Define la nueva escena como activa
	


func _on_tutorial_pressed() -> void:
	
	get_tree().root.print_tree_pretty()
	#Tutorial.restart_ready()
	get_tree().current_scene.queue_free()  # Elimina la escena actual
	get_tree().root.add_child(tutorial_scene)
	SuppliesUi.restart_ready()
	Spawner.restart_ready()
	PathFollow2d.restart_ready()
	Recipe.restart_ready()
	GradientDescent.restart_ready()
	IngredientsManager.restart_ready()
	GraphPlot.restart_ready()
	client.restart_ready()
	#mmultiplayer.restart_ready()
	#MultiplayerButton.restart_ready()
	LevelManager.restart_ready()
	GlobalProgressBar.restart_ready()
	GrillManager.restart_ready()
	#Tutorial.restart_ready()

	
	get_tree().current_scene = tutorial_scene  # Define la nueva escena como activa
	pass # Replace with function body.
