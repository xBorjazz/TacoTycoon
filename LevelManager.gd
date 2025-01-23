extends Node

@onready var level_selector = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel/LevelSelector")
@onready var left_arrow = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel/LevelSelector/LeftArrow")
@onready var right_arrow = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel/LevelSelector/RightArrow")

var levels = ["res://node_2d.tscn", "res://level_2.tscn", "res://betas_level.tscn"]
var current_level = 0  # Nivel inicial

var level_buttons = []

func _ready():
	# Cargar los botones de nivel
	level_buttons = level_selector.get_children()
	
	# Inicializar la visibilidad
	update_level_buttons_visibility()

	# Conectar las señales de las flechas
	left_arrow.connect("pressed", Callable(self, "_on_left_arrow_pressed"))
	right_arrow.connect("pressed", Callable(self, "_on_right_arrow_pressed"))

func update_level_buttons_visibility():
	# Asegurarse de que los botones de nivel estén en el estado correcto
	for i in range(level_buttons.size()):
		if i == current_level:
			level_buttons[i].visible = true  # Mostrar el nivel actual
		else:
			level_buttons[i].visible = false  # Ocultar otros niveles
	
	# Actualizar las flechas
	update_arrow_visibility()

func update_arrow_visibility():
	# Mostrar o esconder las flechas según el nivel actual
	if current_level == 0:
		left_arrow.visible = false  # No mostrar la flecha izquierda en el primer nivel
		right_arrow.visible = true  # Mostrar la flecha derecha
	elif current_level == levels.size() - 1:
		left_arrow.visible = true  # Mostrar la flecha izquierda en el último nivel
		right_arrow.visible = false  # No mostrar la flecha derecha
	else:
		left_arrow.visible = true  # Mostrar flechas en niveles intermedios
		right_arrow.visible = true

# Función para cambiar al nivel anterior
func _on_left_arrow_pressed():
	current_level -= 1
	if current_level < 0:
		current_level = levels.size() - 1  # Volver al último nivel si estamos en el primero
	update_level_buttons_visibility()

# Función para cambiar al siguiente nivel
func _on_right_arrow_pressed():
	current_level += 1
	if current_level >= levels.size():
		current_level = 0  # Volver al primer nivel si estamos en el último
	update_level_buttons_visibility()

func _on_chedraui_button_pressed():
	get_tree().change_scene_to_file(levels[0])

func _on_matute_button_pressed():
	get_tree().change_scene_to_file(levels[1])

func _on_betas_button_pressed():
	get_tree().change_scene_to_file(levels[2])  # Cambiar al tercer nivel
