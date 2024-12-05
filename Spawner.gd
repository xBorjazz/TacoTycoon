extends Node2D

@export var spawn_interval: float = 7.0  # Intervalo de spawn en segundos
@export var move_probability: float = 1  # Probabilidad de que el personaje se mueva
@onready var start_button = get_node("/root/Node2D/CanvasLayer/Gameplay/StartButton")
@onready var day_control = get_node("/root/Node2D/CanvasLayer/Gameplay/DayControl")

var character_scene = preload("res://path_2d.tscn")  # La escena del personaje que quieres instanciar
var spawn_timer: Timer
var game_started: bool = false

func _ready() -> void:
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.set_wait_time(spawn_interval)
	spawn_timer.one_shot = false  # Hacer que el timer se repita
	spawn_timer.connect("timeout", Callable(self, "_spawn_character"))
	
	# Conectar el botón para iniciar el spawner
	start_button.connect("pressed", Callable(self, "start_spawning"))
	
	day_control.connect("day_started", Callable(self, "_on_day_started"))
	day_control.connect("day_ended", Callable(self, "_on_day_ended"))

func start_spawning() -> void:
	game_started = true
	spawn_timer.start()  # Comienza el temporizador
	_spawn_character()  # Spawnear el primer personaje inmediatamente
	print("Spawner iniciado.")

func _on_day_started() -> void:
	print("Día iniciado.")

func _on_day_ended() -> void:
	game_started = false
	spawn_timer.stop()  # Detener el temporizador al final del día
	print("Día terminado. Deteniendo el spawneo de personajes.")

# Dentro de _spawn_character()
func _spawn_character() -> void:
	if not game_started:  # Verificar que el juego esté en marcha antes de spawnear
		print("El juego no ha comenzado. No se puede spawnear personajes.")
		return

	# Obtener los nodos Path2D del grupo "paths"
	var paths = get_tree().get_nodes_in_group("Paths")
	
	# Verificar si hay elementos en paths
	if paths.size() == 0:
		print("No se encontraron Path2D en el grupo 'paths'.")
		return

	# Elegir un Path2D aleatorio
	var random_path = paths[randi() % paths.size()]
	print(paths[1])

	# Establecer visibilidad: solo el PathFollow2D seleccionado será visible
	for path in paths:
		var path_follow: PathFollow2D = path.get_node("PathFollow2D")
		if path == random_path:
			# Este es el Path2D seleccionado, lo hacemos visible
			path_follow.visible = true
			print("Path seleccionado: visible.")
			
			# Llamar a la función start_game() del personaje
			PathFollow2d.start_game(random_path, path_follow)
			
			# Resetear la posición inicial en el PathFollow2D
			path_follow.progress_ratio = 0.0  # Cambiado a progress_ratio
		else:
			# Hacer invisibles los otros PathFollow2D
			#path_follow.visible = false
			path_follow.visible = true
			PathFollow2d.speed = 0.4
			print("Path inactivo: invisible.")
	
	print("Nuevo personaje instanciado y asignado a un PathFollow2D.")
