extends Node

# Variables del progreso
var total_money_earned = 0  # Dinero acumulado
var progress_target = 1000  # Meta para llenar la barra

# Referencia a la ProgressBar (se buscará en la escena actual)
var progress_bar = null

# Timer para buscar la ProgressBar
var search_timer := Timer.new()

func _ready():
	# Agregar el Timer como hijo y configurarlo para buscar la ProgressBar cada 0.5 segundos
	add_child(search_timer)
	search_timer.wait_time = 0.5
	search_timer.one_shot = false
	search_timer.connect("timeout", Callable(self, "initialize_progress_bar"))
	search_timer.start()
	#update_progress(999) #DEBUG quitaaaar
	print("🔄 Iniciando búsqueda de ProgressBar...")

func initialize_progress_bar():
	# Intentar obtener la ProgressBar con la ruta actual
	progress_bar = get_node_or_null("/root/Node2D/CanvasLayer/PanelContainer/Panel/ProgressBar")
	if progress_bar:
		progress_bar.value = total_money_earned
		progress_bar.max_value = progress_target
		# Conectar la señal value_changed si aún no está conectada
		if not progress_bar.is_connected("value_changed", Callable(self, "_on_progress_changed")):
			progress_bar.connect("value_changed", Callable(self, "_on_progress_changed"))
		print("✅ ProgressBar encontrada y conectada:", progress_bar)
		search_timer.stop()  # Detener el timer al encontrar la referencia
	else:
		pass
		#print("❌ ProgressBar no encontrada, reintentando...")

func update_progress(money_gained: int) -> void:
	#total_money_earned = 999 #DEBUG: Quitar para volver a la normalidad
	total_money_earned += money_gained
	Inventory.player_money += money_gained  # Actualiza el dinero del jugador

	# Limitar las ganancias al objetivo
	if total_money_earned > progress_target:
		total_money_earned = progress_target

	# Actualizar la barra de progreso si está disponible
	if progress_bar:
		progress_bar.value = total_money_earned
	else:
		print("⚠️ Advertencia: ProgressBar es NULL, intentando reinicializar...")
		initialize_progress_bar()

	# Verificar si se alcanzó el objetivo
	if total_money_earned >= progress_target:
		on_progress_complete()

func on_progress_complete() -> void:
	print("🏆 ¡Progreso completo! Has ganado $1000.")
	# Aquí puedes agregar acciones adicionales

func _on_progress_changed(value):
	print("📊 La ProgressBar ha cambiado a:", value)

func restart_ready():
	print("🔄 Reiniciando ProgressBar con call_deferred()")
	call_deferred("_ready")
