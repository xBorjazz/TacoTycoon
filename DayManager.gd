extends Node

# Variables para el sistema de días
var current_day: int = 1  # Día inicial
@export var day_duration: float = 45.0  # Duración de cada día en segundos
var remaining_time: float = 0.0  # Tiempo restante del día
var is_game_running: bool = false  # Indica si el juego está corriendo

# Señales
signal day_started
signal day_ended

# Referencias a los nodos
@onready var day_timer = $DayTimer
@onready var day_label = $DayLabel
@onready var start_button = get_node("/root/Node2D/CanvasLayer/Gameplay/StartButton")  # Botón de inicio

func _ready() -> void:
	remaining_time = day_duration
	update_day_label()

	# Conectar el botón START para iniciar el juego
	start_button.connect("pressed", Callable(self, "_on_start_pressed"))

	# Conectar la señal "timeout" del Timer a la función que actualiza el contador
	day_timer.connect("timeout", Callable(self, "_on_timer_tick"))

	# Asegurarse de que el temporizador esté detenido al inicio
	day_timer.stop()

func _on_start_pressed() -> void:
	# Reiniciar el tiempo restante
	remaining_time = day_duration
	update_day_label()

	# Comenzar el temporizador
	day_timer.set_wait_time(1.0)
	day_timer.start()
	is_game_running = true

	# Emitir la señal para indicar que el día ha comenzado
	emit_signal("day_started")

	# Deshabilitar el botón START mientras el juego corre
	start_button.disabled = true
	start_button.visible = false

func _on_timer_tick() -> void:
	remaining_time -= 1
	update_day_label()

	if remaining_time <= 0:
		_on_day_end()

func _on_day_end() -> void:
	day_timer.stop()
	update_day_label()
	is_game_running = false

	# Emitir la señal para indicar que el día ha terminado
	emit_signal("day_ended")

	start_button.disabled = false
	start_button.visible = true
	PathFollow2d.stop_moving()
	# Emitir señal para detener el movimiento del personaje
	emit_signal("stop_movement")
	
	current_day += 1

func update_day_label() -> void:
	day_label.text = " %s
 	
	%s
	
	
	%s" % [str(current_day), str(int(remaining_time)), str(Inventory.tacos_vendidos)]
