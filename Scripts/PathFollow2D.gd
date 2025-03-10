extends PathFollow2D

var speed = 0.1
var is_buying = false
var has_bought = false
var game_started = false
var pathfollow: PathFollow2D
var path_2d: Path2D
var animated_sprite: AnimatedSprite2D
var collision_shape: CollisionShape2D
var character_sprite: CharacterBody2D
var path_2d_scene = preload("res://Scenes/path_2d.tscn")

#signal day_ended
signal sale_made

@onready var taco_stand_zone = get_node("/root/Node2D/CanvasLayer/Gameplay/TacoStandZone")
@onready var sound_player = get_node("/root/Node2D/CanvasLayer/PlayerBuy_Sound")
@onready var day_manager = get_node("/root/Node2D/CanvasLayer/Gameplay/DayControl")

func start_game(path2d: Path2D, pathfollow2d: PathFollow2D) -> void:
	game_started = true
	path2d.visible = true
	path_2d = path2d
	pathfollow = pathfollow2d
	character_sprite = pathfollow.get_child(0)

	animated_sprite = character_sprite.get_child(0)
	has_bought = false

	start_moving(path2d, pathfollow2d)

func start_moving(path2d: Path2D, pathfollow2d: PathFollow2D) -> void:
	speed = 0.2
	pathfollow2d.progress_ratio = 0
	set_process(true)
	set_visible(true)

func stop_moving() -> void: #cambiar nombre a resume_moving
	speed = 0.3
	#set_process(false)
	#set_visible(false)
	#game_started = false

func end_day() -> void:
	emit_signal("day_ended")

func _on_day_ended() -> void:
	stop_moving()  # Detener el movimiento del personaje
	print("El dia se acabo")
	set_visible(false)
	self.visible = false
	hide()

func _ready() -> void:
	# Conectar la señal day_ended para ocultar el personaje
	day_manager.connect("day_ended", Callable(self, "_on_day_ended"))
	
	if taco_stand_zone:
		taco_stand_zone.connect("body_entered", Callable(self, "_on_taco_stand_zone_body_entered"))
	else:
		print("El nodo LemonadeCarZone no se encontró.")

func _process(delta: float) -> void:


	if pathfollow == null:
		return

	pathfollow.progress_ratio += speed * delta


	if pathfollow.progress_ratio >= 1.0:
		fade_out_anim()

	pathfollow.position = pathfollow.get_position()
	var curve = path_2d.curve
	
	#print("Progress ratio:", progress_ratio, "Speed:", speed)

	if curve.get_point_count() > 3:
		var point_position = curve.get_point_position(3)
		var distance_to_point = global_position.distance_to(point_position)

		if distance_to_point < 10:
			if not animated_sprite.is_playing() or animated_sprite.animation != "walk_right":
				#print("Cerca del punto 3, animación: walk_right")
				animated_sprite.play("walk_right")
		else:
			if not animated_sprite.is_playing() or animated_sprite.animation != "walk_left_down":
				#print("Lejos del punto 3, animación: walk_left_down")
				animated_sprite.play("walk_left_down")

func fade_out_anim() -> void:
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_fade_out_complete"))
	add_child(timer)
	timer.start()

func _on_fade_out_complete() -> void:
	#print("El personaje ha salido del mapa")
	stop_moving()
	hide()

func _on_taco_stand_zone_body_entered(body):
	if body == character_sprite:
		print("Personaje ha entrado en la zona de ventas")
		
		# Verificamos si hay suficientes suministros para vender tacos
		if Inventory.tortillas_total > 0 and Inventory.carne_total > 0:
			if not has_bought:
				buying_anim()
		else:
			print("No hay suficientes suministros para vender tacos. El cliente se va.")


func buying_anim() -> void:
	if not animated_sprite.visible:
		print("El personaje no es visible, no puede comprar.")
		return

	is_buying = true
	speed = 0

	if animated_sprite:
		animated_sprite.play("buying")
		#print("Comprando")

	var timer = Timer.new()
	timer.wait_time = 2.0
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_buying_complete"))
	add_child(timer)
	timer.start()

func _on_buying_complete() -> void:
	if not has_bought:
		Inventory.player_money += Inventory.costo_taco
		print("Dinero del jugador ahora es: ", Inventory.player_money)
		SuppliesUi.actualizar_labels_dinero() 
		verify_sound()
		has_bought = true
		GlobalProgressBar.update_progress(25) #Actualiza 2.5% de avance en el juego
		Recipe.aplicar_receta()
		_resume_movement()

func _resume_movement() -> void:
	if not animated_sprite.visible:
		print("El personaje no es visible, no puede reanudar movimiento.")
		return

	speed = 0.2
	is_buying = false
	if animated_sprite:
		animated_sprite.play("walk_right")

func verify_sound() -> void:
	if sound_player:
		sound_player.play()
		
func restart_ready():
	print("Reejecutando _ready() con call_deferred()")
	call_deferred("_ready")  # Esto ejecutará _ready() en el siguiente frame
