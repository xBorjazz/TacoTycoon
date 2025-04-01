extends Node2D

@export var spawn_interval: float = 7.0
@export var move_probability: float = 1

@onready var start_button = get_node("/root/Node2D/CanvasLayer/Gameplay/StartButton")
@onready var day_control = get_node("/root/Node2D/CanvasLayer/Gameplay/DayControl")

var spawn_timer: Timer
var game_started: bool = false

# Para saber si ya hicimos el spawn “especial” del primer día
var first_day_spawn_done: bool = false

signal sale_made

func _ready():
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.connect("timeout", Callable(self, "_spawn_character"))

	start_button.connect("pressed", Callable(self, "start_spawning"))
	day_control.connect("day_started", Callable(self, "_on_day_started"))
	day_control.connect("day_ended", Callable(self, "_on_day_ended"))

	# Señal de pausa
	day_control.connect("pause_toggled", Callable(self, "_on_pause_toggled"))

func _on_pause_toggled(is_paused: bool):
	if is_paused:
		print("Spawner => Pausando spawn_timer")
		spawn_timer.stop()
	else:
		if game_started:
			print("Spawner => Reanudando spawn_timer")
			spawn_timer.start()

func start_spawning():
	game_started = true

	# SOLO LA PRIMERA VEZ: generamos 3 clientes con Taco-1, Taco-2 y Taco-3
	if not first_day_spawn_done:
		await _spawn_first_day_customers()
		first_day_spawn_done = true
	else:
		# Llamamos al spawn normal
		_spawn_character()

	# Comenzamos el timer para seguir spawneando al azar
	spawn_timer.start()
	print("Spawner iniciado.")

func _on_day_started():
	print("Día iniciado.")

func _on_day_ended():
	game_started = false
	spawn_timer.stop()
	print("Día terminado. Deteniendo el spawneo de personajes.")

	# Si quieres que cada día repita la mecánica, podrías:
	# first_day_spawn_done = false

func _spawn_character():
	if not game_started:
		print("El juego no ha comenzado. No se puede spawnear personajes.")
		return

	var random_taco = ["Taco-1", "Taco-2", "Taco-3"].pick_random()
	_spawn_single_customer(random_taco)

func _on_sale_made(character):
	if is_instance_valid(character):
		print("✅ Venta completada. Taco eliminado, continuando movimiento.")
		character.fade_out_anim()

# -----------------------------------------------------------------------
# spawn de UN cliente cualquiera
# -----------------------------------------------------------------------
func _spawn_single_customer(taco_type: String):
	var all_paths = get_tree().get_nodes_in_group("Paths")
	var available_paths = []
	for path in all_paths:
		if not path.has_meta("occupied") or path.get_meta("occupied") == false:
			available_paths.append(path)
	
	if available_paths.is_empty():
		print("No hay paths disponibles (todos ocupados).")
		return
	
	available_paths.shuffle()
	var chosen_path = available_paths[0]
	_spawn_character_forced(taco_type, chosen_path)


# -----------------------------------------------------------------------
# NUEVA FUNCIÓN: genera EXACTAMENTE un cliente en un path forzado
# -----------------------------------------------------------------------
func _spawn_character_forced(taco_type: String, chosen_path: Node):
	if not game_started:
		print("El juego no ha comenzado. No se puede spawnear personajes forzados.")
		return

	if not chosen_path or not chosen_path is Path2D:
		print("❌ El 'chosen_path' no es válido o no es Path2D.")
		return

	var character = chosen_path.get_node_or_null("PathFollow2D")
	if character == null or not is_instance_valid(character):
		print("❌ No se encontró PathFollow2D en:", chosen_path.name)
		return

	print("🍽 Generando cliente con pedido:", taco_type, "en path:", chosen_path.name)

	# Marcar el path como ocupado
	chosen_path.set_meta("occupied", true)

	character.visible = true
	character.progress_ratio = 0.0
	character.set_process(true)
	character.pedido_cliente = taco_type

	character.start_game(chosen_path, character, taco_type)

	if not character.sale_made.is_connected(_on_sale_made):
		character.sale_made.connect(_on_sale_made.bind(character))


# -----------------------------------------------------------------------
# _spawn_first_day_customers() => genera Taco-1, Taco-2, Taco-3
# cada uno en un path distinto con retardo
# -----------------------------------------------------------------------
func _spawn_first_day_customers():
	var forced_tacos = ["Taco-1","Taco-2","Taco-3"]
	var available_paths = get_tree().get_nodes_in_group("Paths").duplicate(true)

	if available_paths.size() < forced_tacos.size():
		print("⚠️ No hay paths suficientes para 3 clientes distintos. Se reusarán algunos.")

	# Barajamos los paths
	available_paths.shuffle()

	# Recorremos los 3 tacos obligatorios
	for i in range(forced_tacos.size()):
		var taco_type = forced_tacos[i]

		if available_paths.size() > 0:
			# Sacamos un path de la lista (así no se repite)
			var chosen_path = available_paths.pop_back()
			_spawn_character_forced(taco_type, chosen_path)
		else:
			# Si no hay paths suficientes, reusamos uno aleatorio
			_spawn_single_customer(taco_type)

		# Retardo de 0.2s entre cada spawn
		#await get_tree().create_timer(0.2).timeout
