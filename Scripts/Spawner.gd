extends Node2D

@export var spawn_interval: float = 7.0
@export var move_probability: float = 1
@onready var start_button = get_node("/root/Node2D/CanvasLayer/Gameplay/StartButton")
@onready var day_control = get_node("/root/Node2D/CanvasLayer/Gameplay/DayControl")

var character_scene = preload("res://Scenes/path_2d.tscn")
var spawn_timer: Timer
var game_started: bool = false

signal sale_made

func _ready() -> void:
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.set_wait_time(spawn_interval)
	spawn_timer.one_shot = false
	spawn_timer.connect("timeout", Callable(self, "_spawn_character"))

	start_button.connect("pressed", Callable(self, "start_spawning"))
	day_control.connect("day_started", Callable(self, "_on_day_started"))
	day_control.connect("day_ended", Callable(self, "_on_day_ended"))

func start_spawning():
	game_started = true
	spawn_timer.start()
	_spawn_character()
	print("Spawner iniciado.")

func _on_day_started():
	print("Día iniciado.")

func _on_day_ended():
	game_started = false
	spawn_timer.stop()
	print("Día terminado. Deteniendo el spawneo de personajes.")

func _spawn_character():
	if not game_started:
		print("El juego no ha comenzado. No se puede spawnear personajes.")
		return

	var paths = get_tree().get_nodes_in_group("Paths")
	if paths.size() == 0:
		print("No se encontraron Path2D en el grupo 'Paths'.")
		return

	var random_path = paths[randi() % paths.size()]
	var character = random_path.get_node_or_null("PathFollow2D")

	if character == null or not is_instance_valid(character):
		print("❌ Nodo PathFollow2D inválido.")
		return

	# ✅ Elegir una orden aleatoria para el cliente
	var pedido_cliente = ["Taco-1", "Taco-2", "Taco-3"].pick_random()
	print("🍽 Pedido del Cliente:", pedido_cliente)

	character.visible = true
	character.progress_ratio = 0.0
	character.set_process(true)
	character.pedido_cliente = pedido_cliente

	# ✅ Llamar a la función start_game con los 3 parámetros correctos
	character.start_game(character.get_parent(), character, pedido_cliente)

	# ✅ Conectar señal de venta solo si no está conectada
	if not character.sale_made.is_connected(_on_sale_made):
		character.sale_made.connect(_on_sale_made.bind(character))

func _on_sale_made(character):
	if is_instance_valid(character):
		print("✅ Venta completada. Taco eliminado, continuando movimiento.")
		character.fade_out_anim()

func restart_ready():
	print("Reejecutando _ready() con call_deferred()")
	call_deferred("_ready")
