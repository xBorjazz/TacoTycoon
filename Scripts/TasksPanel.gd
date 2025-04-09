extends Control

# --- Nodos de UI ---
@onready var label_tacos     = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/Label7")
@onready var progress_dinero = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/MoneyProgressBar")
@onready var progress_invest = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/InvestmentProgressBar") 
@onready var label_propinas  = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/Label9")
@onready var taco_coins_label= get_node("/root/Node2D/CanvasLayer/Taco-coins/Taco-Coins-Label")

# --- CheckBoxes (solo visuales) ---
@onready var check_tacos     = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/CheckBox")
@onready var check_dinero    = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/CheckBox3")
@onready var check_invest    = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/CheckBox4")   # <--- Inversión
@onready var check_propinas  = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/CheckBox5")

# --- Botones Tick (para reclamar cada misión) ---
@onready var tick_tacos    = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/TickButton1")
@onready var tick_dinero   = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/TickButton2")
@onready var tick_invest   = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/TickButton3")  # <--- Inversión
@onready var tick_propinas = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/TickButton4")

# --- Banderas de misión completada (pendiente de reclamar) ---
var tacos_completados    = false
var dinero_completado    = false
var invest_completado    = false   # <--- En lugar de resenas_completadas
var propinas_completadas = false

func _ready():
	_actualizar_taco_coins()
	# Conectar la señal "mision_actualizada" (cuando cambian valores en Inventory)
	Inventory.connect("mision_actualizada", Callable(self, "_actualizar_misiones"))

	# Conectar manualmente botones Tick (si no se hace en Inspector)
	tick_tacos.connect("pressed", Callable(self, "_on_tick_tacos_pressed"))
	tick_dinero.connect("pressed", Callable(self, "_on_tick_dinero_pressed"))
	tick_invest.connect("pressed", Callable(self, "_on_tick_invest_pressed"))     # <--- Botón para inversión)
	tick_propinas.connect("pressed", Callable(self, "_on_tick_propinas_pressed"))

	# Ocultamos botones al inicio
	tick_tacos.visible    = false
	tick_dinero.visible   = false
	tick_invest.visible   = false
	tick_propinas.visible = false

	_actualizar_misiones()

# --------------------------------------------------------------------------
# ACTUALIZAR LA UI DE LAS MISIONES
# --------------------------------------------------------------------------
func _actualizar_misiones():
	# Misión de tacos
	if tacos_completados:
		# Congelar en la meta
		label_tacos.text = "%d/%d" % [Inventory.TACOS_OBJETIVO, Inventory.TACOS_OBJETIVO]
	else:
		label_tacos.text = "%d/%d" % [Inventory.tacos_vendidos_mision, Inventory.TACOS_OBJETIVO]

	# Misión de dinero
	if dinero_completado:
		progress_dinero.value = 100
	else:
		progress_dinero.value = float(Inventory.dinero_ganado_mision) / float(Inventory.DINERO_OBJETIVO) * 100

	# Misión de inversión
	if invest_completado:
		progress_invest.value = 100
	else:
		progress_invest.value = float(Inventory.invested_money) / float(Inventory.INVESTED_OBJETIVO) * 100

	# Misión de propinas
	if propinas_completadas:
		label_propinas.text = "%d/%d" % [Inventory.PROPINAS_OBJETIVO, Inventory.PROPINAS_OBJETIVO]
	else:
		label_propinas.text = "%d/%d" % [Inventory.propinas_recibidas, Inventory.PROPINAS_OBJETIVO]

	# Comprobar si se cumplen las misiones (y no se habían marcado antes)
	if Inventory.tacos_vendidos_mision >= Inventory.TACOS_OBJETIVO and not tacos_completados:
		tacos_completados = true
		tick_tacos.visible = true

	if Inventory.dinero_ganado_mision >= Inventory.DINERO_OBJETIVO and not dinero_completado:
		dinero_completado = true
		tick_dinero.visible = true

	if Inventory.invested_money >= Inventory.INVESTED_OBJETIVO and not invest_completado:
		invest_completado = true
		tick_invest.visible = true

	if Inventory.propinas_recibidas >= Inventory.PROPINAS_OBJETIVO and not propinas_completadas:
		propinas_completadas = true
		tick_propinas.visible = true

	# Actualizar label de taco_coins
	_actualizar_taco_coins()

# --------------------------------------------------------------------------
# RECLAMAR MISIONES (cuando se presiona el botón Tick)
# --------------------------------------------------------------------------
func _on_tick_tacos_pressed():
	if tacos_completados:
		# Recompensa
		Inventory.taco_coins += 5
		_actualizar_taco_coins()

		# Esperar 3s y reset
		await get_tree().create_timer(3.0).timeout
		tick_tacos.visible = false
		tacos_completados = false

		_asignar_nueva_mision_tacos()
		_actualizar_misiones()

func _on_tick_dinero_pressed():
	if dinero_completado:
		Inventory.taco_coins += 10
		_actualizar_taco_coins()

		await get_tree().create_timer(3.0).timeout
		tick_dinero.visible = false
		dinero_completado = false

		_asignar_nueva_mision_dinero()
		_actualizar_misiones()

func _on_tick_invest_pressed():
	if invest_completado:
		# Ejemplo: +5 taco_coins
		Inventory.taco_coins += 5
		_actualizar_taco_coins()

		await get_tree().create_timer(3.0).timeout
		tick_invest.visible = false
		invest_completado = false

		_asignar_nueva_mision_invest()
		_actualizar_misiones()

func _on_tick_propinas_pressed():
	if propinas_completadas:
		Inventory.taco_coins += 5
		_actualizar_taco_coins()

		await get_tree().create_timer(3.0).timeout
		tick_propinas.visible = false
		propinas_completadas = false

		_asignar_nueva_mision_propinas()
		_actualizar_misiones()

# --------------------------------------------------------------------------
# ASIGNAR NUEVAS MISIONES (opcional)
# --------------------------------------------------------------------------
func _asignar_nueva_mision_tacos():
	if Inventory.TACOS_OBJETIVO == 30:
		Inventory.TACOS_OBJETIVO = 100
	elif Inventory.TACOS_OBJETIVO == 100:
		Inventory.TACOS_OBJETIVO = 500
	# No reiniciamos la variable 'tacos_vendidos_mision' 
	# si queremos que continúe acumulando. Ajusta según tu diseño.

func _asignar_nueva_mision_dinero():
	if Inventory.DINERO_OBJETIVO == 500:
		Inventory.DINERO_OBJETIVO = 1000
	elif Inventory.DINERO_OBJETIVO == 1000:
		Inventory.DINERO_OBJETIVO = 3000
	# etc.

func _asignar_nueva_mision_invest():
	# Ajusta según tus metas
	if Inventory.INVESTED_OBJETIVO == 800:
		Inventory.INVESTED_OBJETIVO = 2000
	elif Inventory.INVESTED_OBJETIVO == 2000:
		Inventory.INVESTED_OBJETIVO = 5000
	# etc.

func _asignar_nueva_mision_propinas():
	if Inventory.PROPINAS_OBJETIVO == 10:
		Inventory.PROPINAS_OBJETIVO = 20
	elif Inventory.PROPINAS_OBJETIVO == 20:
		Inventory.PROPINAS_OBJETIVO = 50
	# etc.

# --------------------------------------------------------------------------
# ACTUALIZAR LABEL DE TACO COINS
# --------------------------------------------------------------------------
func _actualizar_taco_coins():
	taco_coins_label.text = str(Inventory.taco_coins)
