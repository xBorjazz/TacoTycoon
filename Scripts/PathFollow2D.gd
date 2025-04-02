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
var client_left = false
var clientes_totales = 0

# Cliente especial
var es_cliente_especial = false
var tiempo_espera = 0.0
var cronometro_activo = false
var current_star_anim = ""

signal sale_made

@onready var taco_stand_zone = get_node("/root/Node2D/CanvasLayer/Gameplay/TacoStandZone")
@onready var sound_player = get_node("/root/Node2D/CanvasLayer/PlayerBuy_Sound")
@onready var day_manager = get_node("/root/Node2D/CanvasLayer/Gameplay/DayControl")

func _ready():
	day_manager.connect("day_ended", Callable(self, "_on_day_ended"))
	if taco_stand_zone:
		taco_stand_zone.connect("body_entered", Callable(self, "_on_taco_stand_zone_body_entered"))
	day_manager.connect("pause_toggled", Callable(self, "_on_pause_toggled"))

func _on_pause_toggled(is_paused: bool):
	if is_paused:
		stop_moving()
		if animated_sprite:
			animated_sprite.stop()
	else:
		if game_started and not has_bought:
			speed = 0.2
			set_process(true)
			if animated_sprite:
				animated_sprite.play("walk_left_down")

func start_game(path2d: Path2D, pathfollow2d: PathFollow2D, pedido: String):
	game_started = true
	path_2d = path2d
	pathfollow = pathfollow2d
	character_sprite = pathfollow.get_child(0)
	animated_sprite = character_sprite.get_node("AnimatedSprite2D")
	bubble = character_sprite.get_node("Bubble")
	taco_order = character_sprite.get_node("TacoOrder")

	# Reset barra circular
	var barra = character_sprite.get_node("TextureProgressBar")
	if barra:
		barra.visible = false
		barra.set_process(false)
		barra.activo = false
		barra.pathfollow_node = self
		barra.reiniciar_barra()

	# Reset estado del cliente
	has_bought = false
	is_buying = false
	client_left = false
	speed = 0.2
	progress_ratio = 0.0
	tiempo_espera = 0.0
	cronometro_activo = false
	current_star_anim = ""

	set_process(true)
	pedido_cliente = pedido
	elegir_taco()
	start_moving()

	if es_cliente_especial:
		var numero = character_sprite.get_node("NumberAnimation")

		if numero:
			numero.visible = false  # Ocultamos al inicio
			numero.stop()
			numero.frame = 0
			numero.play("n5")
			current_star_anim = "n5"
		var estrella = character_sprite.get_node("StarSprite")
		if estrella:
			estrella.visible = true  # Ocultar al inicio

func elegir_taco():
	if taco_order:
		match pedido_cliente:
			"Taco-1": taco_order.play("regular-order")
			"Taco-2": taco_order.play("full-order")
			"Taco-3": taco_order.play("vegan-order")
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
	if not es_cliente_especial:
		set_process(false)
	if animated_sprite:
		animated_sprite.play("idle")

func _process(delta):
	if pathfollow == null or not game_started:
		return

	if speed > 0:
		pathfollow.progress_ratio += speed * delta

	if pathfollow.progress_ratio >= 1.0 and (has_bought or client_left):
		fade_out_anim()

func _on_taco_stand_zone_body_entered(body):
	if body == character_sprite and not has_bought:
		speed = 0
		var barra = character_sprite.get_node("TextureProgressBar")
		if barra and not barra.activo:
			barra.iniciar_barra()
		buying_anim()
		if es_cliente_especial:
			tiempo_espera = 0.0
			cronometro_activo = true

			var numero = character_sprite.get_node("NumberAnimation")
			if numero:
				numero.visible = true  # Ahora sí lo mostramos

func actualizar_estrella_desde_barra(anim_nombre: String):
	var numero = character_sprite.get_node("NumberAnimation")
	if numero and anim_nombre != current_star_anim:
		numero.play(anim_nombre)
		current_star_anim = anim_nombre

func liberar_path():
	if path_2d:
		path_2d.set_meta("occupied", false)

func buying_anim():
	if is_buying or has_bought:
		return
	is_buying = true
	client_left = false
	speed = 0
	if animated_sprite:
		animated_sprite.play("buying")

	while not has_bought and not client_left:
		await get_tree().create_timer(0.1).timeout
		if GrillManager.verificar_taco(pedido_cliente):
			await get_tree().create_timer(0.1).timeout
			if GrillManager.verificar_taco(pedido_cliente):
				break

	if not has_bought and not client_left:
		GrillManager.limpiar_taco(pedido_cliente)
		liberar_path()
		if sale_made.is_connected(_on_sale_made):
			sale_made.disconnect(_on_sale_made)
		sale_made.emit()
		verify_sound()
		Inventory.player_money += Inventory.costo_taco
		SuppliesUi.actualizar_labels_dinero()
		has_bought = true
		_resume_movement()
		_on_buying_complete()

func _on_buying_complete():
	Inventory.player_money += Inventory.costo_taco
	SuppliesUi.actualizar_labels_dinero()
	verify_sound()
	has_bought = true
	GlobalProgressBar.update_progress(25)
	liberar_path()
	
	var estrella = character_sprite.get_node("StarSprite")
	if estrella:
		estrella.visible = false  # Ocultar al inicio

	clientes_totales = Inventory.tacos_vendidos + Inventory.ventas_fallidas
	if clientes_totales % 5 == 0:
		Spawner.liberar_todos_los_paths()

	if es_cliente_especial:
		var estrella_final = 1  # Valor por defecto

		match current_star_anim:
			"n5":
				estrella_final = 5
			"n4":
				estrella_final = 4
			"n3":
				estrella_final = 3
			"n2":
				estrella_final = 2
			"n1":
				estrella_final = 1
			_:
				estrella_final = 1


		Inventory.total_reseñas += 1
		Inventory.puntaje_acumulado += estrella_final
		Inventory.actualizar_promedio_estrellas()
		print("🌟 Cliente especial calificó con", estrella_final, "estrellas.")

		tiempo_espera = 0.0
		cronometro_activo = false

	_resume_movement()
	await fade_out_anim()

func cliente_se_va():
	client_left = true
	Inventory.ventas_fallidas += 1
	SuppliesUi.actualizar_labels_dinero()
	liberar_path()
	await fade_out_anim()

func _on_sale_made(character):
	if not has_bought:
		has_bought = true
		_resume_movement()

func _resume_movement():
	speed = 0.2
	is_buying = false
	if animated_sprite:
		animated_sprite.play("walk_left_down")

func fade_out_anim():
	speed = 0
	if animated_sprite:
		animated_sprite.play("fade_out")
	await get_tree().create_timer(1.0).timeout
	visible = false
	set_process(false)
	liberar_path()

func _on_day_ended():
	stop_moving()
	visible = false

func verify_sound():
	if sound_player:
		sound_player.play()
