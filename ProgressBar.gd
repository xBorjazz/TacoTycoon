extends Node

# Variables del progreso
var total_money_earned = 0  # Dinero acumulado
var progress_target = 1000  # Meta para llenar la barra

# Referencia a la ProgressBar
@onready var progress_bar = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel/ProgressBar")  # Ajusta la ruta al nodo de tu ProgressBar

func _ready():
	
	# Inicializa la ProgressBar
	progress_bar.value = 0
	progress_bar.max_value = progress_target

# Función para actualizar la ProgressBar
func update_progress(money_gained: int) -> void:
	total_money_earned += money_gained
	Inventory.player_money += money_gained  # Actualiza el dinero del jugador

	# Limitar las ganancias al objetivo
	if total_money_earned > progress_target:
		total_money_earned = progress_target

	# Actualizar la barra de progreso
	progress_bar.value = total_money_earned

	# Verificar si se alcanzó el objetivo
	if total_money_earned >= progress_target:
		on_progress_complete()

# Función para manejar el progreso completado
func on_progress_complete() -> void:
	print("¡Progreso completo! Has ganado $1000.")
	# Aquí puedes realizar acciones adicionales, como desbloquear algo
	
func restart_ready():
	print("Reejecutando _ready() con call_deferred()")
	call_deferred("_ready")  # Esto ejecutará _ready() en el siguiente frame
