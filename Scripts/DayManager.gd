extends Node

# Referencia al progreso del juego
var game_progress: GameProgress

# Variables de Nakama
var client: NakamaClient
var session: NakamaSession

var current_day = Inventory.dia_actual
@export var day_duration: float = 60.0
var remaining_time: float = 0.0
var is_game_running: bool = false
var is_fast = false

signal day_started
signal day_ended
signal stop_movement
signal pause_toggled(paused: bool)  # ← NUEVA SEÑAL

@onready var day_timer = $DayTimer
@onready var day_label = $DayLabel
@onready var start_button = get_node("/root/Node2D/CanvasLayer/Gameplay/StartButton")
@onready var speed_button = get_node("/root/Node2D/CanvasLayer/Gameplay/SpeedButton")

# NUEVO BOTÓN DE PAUSA
@onready var pause_button = get_node("/root/Node2D/CanvasLayer/Gameplay/PauseButton")

var paused: bool = false  # Para saber si estamos en pausa

func _ready() -> void:
	# Inicializar Nakama (asegúrate de que client y session estén configurados)
	client = Nakama.create_client("defaultkey", "127.0.0.1", 7350, "http")
	session = await client.authenticate_email_async("test@gmail.com", "password")

	# Cargar el progreso del juego
	game_progress = GameProgress.cargar()
	game_progress.inicializar_nakama(client, session)
	
	remaining_time = day_duration
	#Actualizar el día guardado
	var progreso := GameProgress.cargar()
	current_day = progreso.dia_actual
	update_day_label()

	var day_manager = get_node("/root/Node2D/CanvasLayer/Gameplay/DayControl")
	if day_manager:
		day_manager.connect("day_started", Callable(self, "_on_day_started"))
		day_manager.connect("day_ended", Callable(self, "_on_day_ended"))
		day_manager.connect("stop_movement", Callable(self, "_on_stop_movement"))

	# Conectar el botón START y SPEED
	start_button.connect("pressed", Callable(self, "_on_start_pressed"))
	speed_button.connect("pressed", Callable(self, "_toggle_speed"))
	speed_button.toggle_mode = true
	speed_button.disabled = true
	speed_button.visible = false

	# Conectar el Timer
	day_timer.connect("timeout", Callable(self, "_on_timer_tick"))
	day_timer.stop()

	# NUEVO: Conectar el botón PAUSE
	pause_button.connect("pressed", Callable(self, "_on_pause_pressed"))
	


func _on_start_pressed() -> void:
	remaining_time = day_duration
	update_day_label()

	day_timer.set_wait_time(1.0)
	day_timer.start()
	is_game_running = true

	emit_signal("day_started")

	start_button.disabled = true
	start_button.visible = false

	speed_button.disabled = false
	speed_button.visible = true
	
		# Actualizar los datos en GameProgress
	game_progress.dia_actual = current_day
	game_progress.dinero_actual = Inventory.player_money
	#game_progress.tacos_vendidos = Inventory.tacos_vendidos
	#game_progress.taco_coins = Inventory.taco_coins
	# Guardar el progreso en Nakama
	var save_result = await game_progress.guardar_en_nakama()
	if save_result == OK:
		print("✅ Progreso guardado automáticamente al EMPEZAR el día.")
	else:
		print("❌ Error al guardar el progreso en Nakama:", save_result)
	

func _on_timer_tick() -> void:
	if not paused:  # Solo decrementamos si no está en pausa
		remaining_time -= 1
		update_day_label()

		if remaining_time <= 0:
			_on_day_end()

func _toggle_speed():
	if is_fast:
		Engine.time_scale = 1.0
	else:
		Engine.time_scale = 2.0
	is_fast = !is_fast

func _on_day_end() -> void:
	# Detener el temporizador y actualizar el estado del juego
	day_timer.stop()
	is_game_running = false

	emit_signal("day_ended")

	# Actualizar botones
	start_button.disabled = false
	start_button.visible = true

	speed_button.disabled = true
	speed_button.visible = false
	
	# Actualizar el progreso del día
	current_day += 1
	Inventory.dia_actual = current_day
	update_day_label()
	


	emit_signal("stop_movement")
	
	
	# Guardar progreso localmente (opcional)
	SuppliesUi.guardar_progreso()

	# Liberar recursos del día
	Spawner.liberar_todos_los_paths()

func update_day_label() -> void:
	day_label.text = " %s
 	
	%s
	
	
	%s" % [str(current_day), str(int(remaining_time)), str(Inventory.tacos_vendidos)]

func _on_day_started():
	print("¡El día ha comenzado!")

func _on_day_ended():
	print("¡El día ha terminado!")

func _on_stop_movement():
	print("Deteniendo movimiento personaje (señal).")

# -------------------------------
# NUEVO: Lógica del Botón de Pausa
# -------------------------------
func _on_pause_pressed():
	# Cambiamos la bandera local
	paused = not paused

	if paused:
		print("Juego en PAUSA.")
		# Detenemos day_timer para que no siga tick
		day_timer.stop()
	else:
		print("Reanudando juego.")
		# Si el día no terminó, reanudamos Timer
		if is_game_running:
			day_timer.start()

	# Emitimos la señal con el estado actual de pausa
	emit_signal("pause_toggled", paused)
