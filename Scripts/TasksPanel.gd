extends Control

# --- Nodos de UI ---
@onready var label_tacos     = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/Label7")
@onready var progress_dinero = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/MoneyProgressBar")
@onready var progress_resenas= get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/ReviewsProgressBar")
@onready var label_propinas  = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/Label9")
@onready var taco_coins_label= get_node("/root/Node2D/CanvasLayer/Taco-coins/Taco-Coins-Label")

# --- CheckBoxes (solo visuales, deshabilitados) ---
@onready var check_tacos     = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/CheckBox")
@onready var check_dinero    = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/CheckBox3")
@onready var check_resenas   = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/CheckBox4")
@onready var check_propinas  = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/CheckBox5")

# --- Botones Tick (para reclamar misión) ---
@onready var tick_tacos    = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/TickButton1")
@onready var tick_dinero   = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/TickButton2")
@onready var tick_resenas  = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/TickButton3")
@onready var tick_propinas = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/TickButton4")

# --- Timers para parpadeo ---
var blinking_timers = {}

# --- Flags para saber si la misión está completada y pendiente de reclamar ---
var tacos_completados    = false
var dinero_completado    = false
var resenas_completadas  = false
var propinas_completadas = false

func _ready():
	# Conectar la señal de actualización de misión (emitida desde Inventory)
	Inventory.connect("mision_actualizada", Callable(self, "_actualizar_misiones"))
	
	# Conectar manualmente los botones tick
	tick_tacos.connect("pressed", Callable(self, "_on_tick_tacos_pressed"))
	tick_dinero.connect("pressed", Callable(self, "_on_tick_dinero_pressed"))
	tick_resenas.connect("pressed", Callable(self, "_on_tick_resenas_pressed"))
	tick_propinas.connect("pressed", Callable(self, "_on_tick_propinas_pressed"))
	
	_actualizar_misiones()

# --------------------------------------------------------------------------
# ACTUALIZAR LA UI DE MISIÓN
# --------------------------------------------------------------------------
func _actualizar_misiones():
	# Para cada misión, si aún no se ha reclamado, se muestra el progreso real;
	# si ya se completó (pendiente de reclamar), se "congela" en 100% (o en la meta)
	if tacos_completados:
		label_tacos.text = "%d/%d" % [Inventory.TACOS_OBJETIVO, Inventory.TACOS_OBJETIVO]
	else:
		label_tacos.text = "%d/%d" % [Inventory.tacos_vendidos_mision, Inventory.TACOS_OBJETIVO]

	if dinero_completado:
		progress_dinero.value = 100
	else:
		progress_dinero.value = float(Inventory.dinero_ganado_mision) / float(Inventory.DINERO_OBJETIVO) * 100

	if resenas_completadas:
		progress_resenas.value = 100
	else:
		progress_resenas.value = float(Inventory.buenas_resenas) / float(Inventory.RESENAS_OBJETIVO) * 100

	if propinas_completadas:
		label_propinas.text = "%d/%d" % [Inventory.PROPINAS_OBJETIVO, Inventory.PROPINAS_OBJETIVO]
	else:
		label_propinas.text = "%d/%d" % [Inventory.propinas_recibidas, Inventory.PROPINAS_OBJETIVO]

	# Activamos el blinking de cada misión si se cumplió y aún no fue reclamada
	if Inventory.tacos_vendidos_mision >= Inventory.TACOS_OBJETIVO and not tacos_completados:
		tacos_completados = true
		_toggle_blink(tick_tacos, true)

	if Inventory.dinero_ganado_mision >= Inventory.DINERO_OBJETIVO and not dinero_completado:
		dinero_completado = true
		_toggle_blink(tick_dinero, true)

	if Inventory.buenas_resenas >= Inventory.RESENAS_OBJETIVO and not resenas_completadas:
		resenas_completadas = true
		_toggle_blink(tick_resenas, true)

	if Inventory.propinas_recibidas >= Inventory.PROPINAS_OBJETIVO and not propinas_completadas:
		propinas_completadas = true
		_toggle_blink(tick_propinas, true)

	# Mostrar u ocultar los botones tick según corresponda
	tick_tacos.visible = tacos_completados
	tick_dinero.visible = dinero_completado
	tick_resenas.visible = resenas_completadas
	tick_propinas.visible = propinas_completadas

	# Actualizar también la etiqueta de Taco Coins
	_actualizar_taco_coins()

# --------------------------------------------------------------------------
# FUNCIONES DE BLINKING
# --------------------------------------------------------------------------
func _toggle_blink(btn: TextureButton, enable: bool):
	if enable:
		if not blinking_timers.has(btn):
			var t = Timer.new()
			t.wait_time = 0.3
			t.one_shot = false
			t.connect("timeout", Callable(self, "_on_blink_timeout").bind(btn))
			add_child(t)
			blinking_timers[btn] = t
			t.start()
		btn.visible = true
		#btn.modulate = Color(1,1,0)  # Amarillo
	else:
		if blinking_timers.has(btn):
			blinking_timers[btn].stop()
			blinking_timers[btn].queue_free()
			blinking_timers.erase(btn)
		btn.visible = false
		btn.modulate = Color(1,1,1)

func _on_blink_timeout(btn: TextureButton):
	# Alternar entre amarillo y blanco para crear efecto de parpadeo
	if btn.modulate == Color(1,1,0):
		btn.modulate = Color(1,1,1)
	else:
		#btn.modulate = Color(1,1,0)
		pass

# --------------------------------------------------------------------------
# FUNCIONES PARA RECLAMAR MISIÓN (al presionar el botón Tick)
# --------------------------------------------------------------------------
func _on_tick_tacos_pressed():
	if tacos_completados:
		Inventory.taco_coins += 5
		_actualizar_taco_coins()
		# Esperar 3 segundos (mientras se mantiene el 100% y parpadea)
		await get_tree().create_timer(3.0).timeout
		_toggle_blink(tick_tacos, false)
		tacos_completados = false
		_asignar_nueva_mision_tacos()
		_actualizar_misiones()

func _on_tick_dinero_pressed():
	if dinero_completado:
		Inventory.taco_coins += 10
		_actualizar_taco_coins()
		await get_tree().create_timer(3.0).timeout
		_toggle_blink(tick_dinero, false)
		dinero_completado = false
		_asignar_nueva_mision_dinero()
		_actualizar_misiones()

func _on_tick_resenas_pressed():
	if resenas_completadas:
		Inventory.taco_coins += 5
		_actualizar_taco_coins()
		await get_tree().create_timer(3.0).timeout
		_toggle_blink(tick_resenas, false)
		resenas_completadas = false
		_asignar_nueva_mision_resenas()
		_actualizar_misiones()

func _on_tick_propinas_pressed():
	if propinas_completadas:
		Inventory.taco_coins += 5
		_actualizar_taco_coins()
		await get_tree().create_timer(3.0).timeout
		_toggle_blink(tick_propinas, false)
		propinas_completadas = false
		_asignar_nueva_mision_propinas()
		_actualizar_misiones()

# --------------------------------------------------------------------------
# ASIGNAR NUEVAS MISIONES (Al reclamar, se actualiza solo la meta, no se reinicia el progreso logrado)
# --------------------------------------------------------------------------
func _asignar_nueva_mision_tacos():
	if Inventory.TACOS_OBJETIVO == 30:
		Inventory.TACOS_OBJETIVO = 100
	elif Inventory.TACOS_OBJETIVO == 100:
		Inventory.TACOS_OBJETIVO = 500
	# No se reinicia Inventory.tacos_vendidos_mision para conservar el progreso
	_actualizar_misiones()

func _asignar_nueva_mision_dinero():
	if Inventory.DINERO_OBJETIVO == 500:
		Inventory.DINERO_OBJETIVO = 1000
	elif Inventory.DINERO_OBJETIVO == 1000:
		Inventory.DINERO_OBJETIVO = 3000
	Inventory.dinero_ganado_mision = 0  # Reiniciamos solo el progreso ganado en este día
	_actualizar_misiones()

func _asignar_nueva_mision_resenas():
	if Inventory.RESENAS_OBJETIVO == 5:
		Inventory.RESENAS_OBJETIVO = 10
	elif Inventory.RESENAS_OBJETIVO == 10:
		Inventory.RESENAS_OBJETIVO = 20
	Inventory.buenas_resenas = 0
	_actualizar_misiones()

func _asignar_nueva_mision_propinas():
	if Inventory.PROPINAS_OBJETIVO == 10:
		Inventory.PROPINAS_OBJETIVO = 20
	elif Inventory.PROPINAS_OBJETIVO == 20:
		Inventory.PROPINAS_OBJETIVO = 50
	elif Inventory.PROPINAS_OBJETIVO == 50:
		Inventory.PROPINAS_OBJETIVO = 100
	Inventory.propinas_recibidas = 0
	_actualizar_misiones()

# --------------------------------------------------------------------------
# ACTUALIZAR EL LABEL DE TACO COINS
# --------------------------------------------------------------------------
func _actualizar_taco_coins():
	taco_coins_label.text = str(Inventory.taco_coins)
