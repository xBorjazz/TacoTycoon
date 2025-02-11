extends Node2D

# Llamado cuando el nodo entra en el árbol de escenas
func _ready():
	print("Iniciando el juego, cargando el menú principal...")

	# Cambiar a la escena main_menu.tscn al iniciar
	get_tree().change_scene_to_file("res://main_menu.tscn")
