extends Node

# Variable para almacenar la instancia del menú
var main_menu : Node = null  # Instancia del menú principal

# Llamado cuando el nodo entra en el árbol de escenas
func _ready():
	# Verificar si la escena ya fue cargada previamente
	if main_menu == null:
		# Cargar e instanciar la escena del menú principal
		var main_menu_scene = preload("res://main_menu.tscn")
		main_menu = main_menu_scene.instantiate()  # Instanciamos la escena correctamente

		# Añadir la escena del menú principal como hijo de la escena actual
		add_child(main_menu)
