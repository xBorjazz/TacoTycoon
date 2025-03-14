extends PathFollow2D

var speed = 0.1
var is_buying = false
var has_bought = false
var game_started = false
var pedido_cliente = ""

var pathfollow: PathFollow2D
var path_2d: Path2D
var animated_sprite: AnimatedSprite2D
var collision_shape: CollisionShape2D
var character_sprite: CharacterBody2D
var taco_order: AnimatedSprite2D
var bubble: AnimatedSprite2D

signal sale_made

@onready var taco_stand_zone = get_node("/root/Node2D/CanvasLayer/Gameplay/TacoStandZone")
@onready var sound_player = get_node("/root/Node2D/CanvasLayer/PlayerBuy_Sound")
@onready var day_manager = get_node("/root/Node2D/CanvasLayer/Gameplay/DayControl")

func _ready():
	day_manager.connect("day_ended", Callable(self, "_on_day_ended"))
	if taco_stand_zone:
		taco_stand_zone.connect("body_entered", Callable(self, "_on_taco_stand_zone_body_entered"))
		
	day_manager.connect("day_ended", Callable(self, "_on_day_ended"))

	# NUEVO: escuchar pause_toggled
	day_manager.connect("pause_toggled", Callable(self, "_on_pause_toggled"))

	if taco_stand_zone:
		taco_stand_zone.connect("body_entered", Callable(self, "_on_taco_stand_zone_body_entered"))

func _on_pause_toggled(is_paused: bool):
	if is_paused:
		# 1. Detener la velocidad y el _process
		stop_moving()
		
		# 2. Detener la animación completamente,
		if animated_sprite:

			animated_sprite.stop()
	else:
		# Reanudar
		if game_started and not has_bought:
			speed = 0.2
			set_process(true)
			if animated_sprite:
				# Reproducir la animación de caminar
				animated_sprite.play("walk_left_down")

func start_game(path2d: Path2D, pathfollow2d: PathFollow2D, pedido: String):
	game_started = true
	path2d.visible = true

	path_2d = path2d
	pathfollow = pathfollow2d

	character_sprite = pathfollow.get_child(0)
	animated_sprite = character_sprite.get_node("AnimatedSprite2D")
	collision_shape = character_sprite.get_node("CollisionShape2D")
	bubble = character_sprite.get_node("Bubble") as AnimatedSprite2D
	taco_order = character_sprite.get_node("TacoOrder") as AnimatedSprite2D

	has_bought = false
	speed = 0.2
	progress_ratio = 0.0
	set_process(true)

	pedido_cliente = pedido

	elegir_taco()
	start_moving()

func elegir_taco():
	if taco_order:
		match pedido_cliente:
			"Taco-1":
				taco_order.play("regular-order")
			"Taco-2":
				taco_order.play("full-order")
			"Taco-3":
				taco_order.play("vegan-order")
	if bubble:
		bubble.visible = true
		bubble.play("default")

func start_moving():
	speed = 0.2
	set_process(true)
	visible = true
	if animated_sprite:
		animated_sprite.play("walk_left_down")

func stop_moving():
	speed = 0
	set_process(false)
	if animated_sprite:
		animated_sprite.play("idle")

func _process(delta):
	if pathfollow == null or not game_started:
		return
	pathfollow.progress_ratio += speed * delta

	if pathfollow.progress_ratio >= 1.0:
		fade_out_anim()

func _on_taco_stand_zone_body_entered(body):
	if body == character_sprite and not has_bought:
		speed = 0
		buying_anim()

func buying_anim():
	if is_buying or has_bought:
		return
	is_buying = true
	speed = 0

	if animated_sprite:
		animated_sprite.play("buying")

	await get_tree().create_timer(2.0).timeout

	if not has_bought:
		if GrillManager.verificar_taco(pedido_cliente):
			print("✅ Taco entregado correctamente")
			GrillManager.limpiar_taco(pedido_cliente)

			if sale_made.is_connected(_on_sale_made):
				sale_made.disconnect(_on_sale_made)

			sale_made.emit()
			has_bought = true
			_resume_movement()
	
	#var timer = Timer.new()
	#timer.wait_time = 2.0
	#timer.one_shot = true
	#timer.connect("timeout", Callable(self, "_on_buying_complete"))
	#add_child(timer)
	#timer.start()
	_on_buying_complete()
			
func _on_buying_complete() -> void:
	Inventory.player_money += Inventory.costo_taco
	print("Dinero del jugador ahora es: ", Inventory.player_money)
	SuppliesUi.actualizar_labels_dinero() 
	verify_sound()
	has_bought = true
	GlobalProgressBar.update_progress(25) #Actualiza 2.5% de avance en el juego
	#Recipe.aplicar_receta()
	_resume_movement()

func _on_sale_made(character):
	if not has_bought:
		print("✅ Venta confirmada.")
		has_bought = true
		_resume_movement()

func verify_sound() -> void:
	if sound_player:
		sound_player.play()

func _resume_movement():
	speed = 0.2
	is_buying = false
	if animated_sprite:
		animated_sprite.play("walk_right")

func fade_out_anim():
	speed = 0
	if animated_sprite:
		animated_sprite.play("fade_out")
	await get_tree().create_timer(1.0).timeout
	visible = false
	set_process(false)

func _on_day_ended():
	stop_moving()
	visible = false
