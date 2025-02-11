extends Node2D

@export var spawn_interval: float = 7.0
@export var move_probability: float = 1
@onready var node_2d: Node = null
@onready var start_button: TextureButton = null
@onready var day_control: Node = null

var character_scene = preload("res://path_2d.tscn")
var spawn_timer: Timer
var game_started: bool = false

func _ready() -> void:
	# Cargar el nodo Node2D dinámicamente
	node_2d = get_tree().get_root().get_node("Node2D")
	if node_2d == null:
		print("Error: Node2D no encontrado.")
		return

	# Deferir la conexión de nodos hijos
	call_deferred("_initialize_nodes")


func _initialize_nodes() -> void:
	# Localizar StartButton y DayControl una vez que Node2D esté completamente cargado
	start_button = node_2d.get_node("CanvasLayer/Gameplay/StartButton")
	day_control = node_2d.get_node("CanvasLayer/Gameplay/DayControl")

	if start_button == null:
		print("Error: StartButton no encontrado en la ruta especificada.")
		return

	if day_control == null:
		print("Error: DayControl no encontrado en la ruta especificada.")
		return

	# Inicializar el temporizador
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.set_wait_time(spawn_interval)
	spawn_timer.one_shot = false

	# Conectar señales
	spawn_timer.timeout.connect(Callable(self, "_spawn_character"))
	start_button.pressed.connect(Callable(self, "start_spawning"))
	day_control.connect("day_started", Callable(self, "_on_day_started"))
	day_control.connect("day_ended", Callable(self, "_on_day_ended"))

	print("Spawner inicializado correctamente.")


func start_spawning() -> void:
	game_started = true
	spawn_timer.start()
	_spawn_character()
	print("Spawner iniciado.")


func _on_day_started() -> void:
	print("Día iniciado.")


func _on_day_ended() -> void:
	game_started = false
	spawn_timer.stop()
	print("Día terminado. Deteniendo el spawneo de personajes.")


func _spawn_character() -> void:
	if not game_started:
		print("El juego no ha comenzado. No se puede spawnear personajes.")
		return

	var paths = get_tree().get_nodes_in_group("Paths")
	if paths.size() == 0:
		print("No se encontraron Path2D en el grupo 'paths'.")
		return

	var random_path = paths[randi() % paths.size()]
	for path in paths:
		var path_follow: PathFollow2D = path.get_node("PathFollow2D")
		if path == random_path:
			path_follow.visible = true
			print("Path seleccionado: visible.")
			PathFollow2d.start_game(random_path, path_follow)
			path_follow.progress_ratio = 0.0
		else:
			path_follow.visible = false
			PathFollow2d.speed = 0.4
			print("Path inactivo: invisible.")

	print("Nuevo personaje instanciado y asignado a un PathFollow2D.")
