extends Node

@onready var level_selector = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel/LevelSelector")
@onready var left_arrow = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel/LeftArrow")
@onready var right_arrow = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel/RightArrow")
@onready var progress_bar = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel/ProgressBar")

var visible_buttons = []  # solo los botones distintos al nivel actual
var nav_index = 0  # índice de navegación actual


# Sprites de cada nivel en orden correcto visual: Matute, Beta, Globo, Chedraui
@onready var level_sprites = [
	get_node("/root/Node2D/CanvasLayer/Gameplay/Chedraui"),
	get_node("/root/Node2D/CanvasLayer/Gameplay/Matute"),
	get_node("/root/Node2D/CanvasLayer/Gameplay/Beta"),
	get_node("/root/Node2D/CanvasLayer/Gameplay/Globo")
]

var progress = 0
var current_level = 0 #Chedraui Level inicial
var level_buttons = []

func _ready():	
	var progreso := GameProgress.cargar()
	current_level = progreso.nivel_actual

	
	# Cargar botones
	level_buttons = level_selector.get_children()
	
		
		# 👇 Aquí llamamos la función una sola vez para evitar mostrar el mismo nivel
	saltar_si_esta_en_nivel_actual()
	
	update_level_buttons_visibility()
	update_level_sprite_visibility()

	left_arrow.connect("pressed", Callable(self, "_on_left_arrow_pressed"))
	right_arrow.connect("pressed", Callable(self, "_on_right_arrow_pressed"))
	progress_bar.connect("value_changed", Callable(self, "_on_progress_changed"))
	_on_progress_changed(progress_bar.value)

func _on_progress_changed(value):
	# Si el progreso es menor a 100, deshabilitar los botones
	if value < 1000:
		for button in level_buttons:
			if button is TextureButton:
				button.disabled = true
	else:
		# Si el progreso es 100 o más, habilitar los botones
		for button in level_buttons:
			if button is TextureButton:
				button.disabled = false

func update_level_buttons_visibility():
	for i in range(level_buttons.size()):
		level_buttons[i].visible = (i == current_level)
	update_arrow_visibility()

func update_arrow_visibility():
	left_arrow.visible = current_level > 0
	right_arrow.visible = current_level < level_sprites.size() - 1
	
func saltar_si_esta_en_nivel_actual():
	# Solo ocurre si el botón visible actualmente es el mismo que el nivel actual del jugador
	if level_buttons[current_level].visible:
		var total := level_buttons.size()

		# Buscar el primer botón visible que NO sea el del nivel actual
		for offset in range(1, total):
			var next_index: int = (current_level + offset) % total
			if not level_buttons[next_index].disabled:
				# Mostrar este botón en lugar del actual
				for i in range(total):
					level_buttons[i].visible = (i == next_index)
				break


func update_level_sprite_visibility():
	#var progreso := GameProgress.cargar()
	#if progreso.tutorial_completado == false:
		#level_sprites[3].visible
		#return
		
	for i in range(level_sprites.size()):
		level_sprites[i].visible = (i == current_level)

func _on_left_arrow_pressed():
	current_level = (current_level - 1 + level_sprites.size()) % level_sprites.size()
	update_level_buttons_visibility()
	#update_level_sprite_visibility()

func _on_right_arrow_pressed():
	current_level = (current_level + 1) % level_sprites.size()
	update_level_buttons_visibility()
	#update_level_sprite_visibility()

func _on_chedraui_button_pressed():
	current_level = 0
	save_current_level()
	reset_progress()
	update_level_sprite_visibility()
	GlobalProgressBar.total_money_earned = 0
	
	SuppliesUi.guardar_progreso()

	

func _on_matute_button_pressed():
	current_level = 1
	save_current_level()
	reset_progress()
	update_level_sprite_visibility()
	GlobalProgressBar.total_money_earned = 0
	
	SuppliesUi.guardar_progreso()

func _on_betas_button_pressed():
	current_level = 2
	save_current_level()
	reset_progress()
	update_level_sprite_visibility()
	GlobalProgressBar.total_money_earned = 0
	
	SuppliesUi.guardar_progreso()


func _on_globo_button_pressed():
	current_level = 3
	save_current_level()
	reset_progress()
	update_level_sprite_visibility()
	GlobalProgressBar.total_money_earned = 0
	
	SuppliesUi.guardar_progreso()


func reset_progress():
	progress = 0
	progress_bar.value = 0

func save_current_level():
	var progreso := GameProgress.cargar()
	progreso.nivel_actual = current_level
	progreso.guardar()

func restart_ready():
	print("Reejecutando _ready() con call_deferred()")
	call_deferred("_ready")
