extends Node

# Referencia al botón de inicio (ahora de tipo TextureButton)
var game_start_button : TextureButton = null

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
	else:
		print("No se encontró ningún botón en el grupo 'GlobalNodes'.")

# Llamado cuando el botón GameStart es presionado
func _on_game_start_pressed():
	print("Botón presionado. Iniciando el juego...")  # Verifica que se ejecute la función

	# Eliminar la escena del menú principal
	print("Eliminando la escena del menú principal...")
	get_tree().root.get_child(0).queue_free()  # Elimina el nodo raíz actual (menú principal)

	# Cambiar a la nueva escena principal del juego
	print("Cambiando a la nueva escena...")
	get_tree().change_scene_to_file("res://node_2d.tscn")  # Cambiamos a la nueva escena
