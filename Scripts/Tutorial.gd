extends Node2D

var step = 0
var typing_speed = 0.02
var waiting_for_action = false
var action_completed = false

# Referencias al HUD del tutorial
var speech_bubble_ref
var tutorial_text_ref
var continue_button_ref
var taco_tutorial_ref

# Flechas renombradas
var arrow1_ingredients_ref
var arrow2_tortilla_add_ref
var arrow3_carne_ref
var arrow4_carne_add_ref
var arrow5_buy_ref
var arrow6_grill_ref
var arrow7_tortilla_button_ref
var arrow8_tortilla_add_ref
var arrow_levels_ref
var arrow_money_ref
var arrow_grill_tortilla_add_ref
var arrow_start_ref

var add_press_count = 0

# Opcional: Botones Start/Speed
@onready var start_button = get_node("/root/Node2D/CanvasLayer/Gameplay/StartButton")
@onready var speed_button = get_node("/root/Node2D/CanvasLayer/Gameplay/SpeedButton")
@onready var day_control = get_node("/root/Node2D/CanvasLayer/Gameplay/DayControl")

# Diálogos 0..11, sin acortar
var dialogues = [
	"¡Hola! Bienvenido a Cucei Taco Tycoon.",                                                 #Step 0
	"Aquí aprenderás a administrar tu negocio de tacos.",                                    #Step 1
	"Primero, veamos cuánto dinero tienes.",                                                 #Step 2
	"Ahora compra ingredientes para preparar tacos. Lo escencial es tortilla y carne.",      #Step 3
	"¡Listo! Ya tienes ingredientes para vender tacos.",                                     #Step 4
	"Lo siguiente es preparar nuestros tacos con esos ingredientes.",                        #Step 5
	"En este menú, vamos a realizar la preparación de nuestros tacos.",                      #Step 6
	"Lo primero que vamos a hacer es llenar de tortillas la parrilla.",                      #Step 7
	"En este punto, nos estamos preparando para atender las órdenes de nuestros clientes.",  #Step 8
	"Agregaremos ingredientes según las órdenes de los clientes que vayan llegando.		 ",  #Step 9
	"Es hora de iniciar la venta de tacos!",  												#Step 10
	"¡Bienvenido a la parte 2 del tutorial!\nSe pausará el juego automáticamente en 1 segundo.", #Step 11
	"Debes preparar:\n• Taco-1: 🌮 + 🥩\n• Taco-2: 🌮 + 🥩 + 🥦 + 🌶\n• Taco-3: 🌮 + 🥦\n", #Step 12
	"¡Perfecto! Has completado estos tacos.\nPresiona Continuar para reanudar el juego." 	#Step 13
]

func _ready():
	assign_tutorial_nodes()

	# (Opcional) Ocultar Start/Speed al inicio
	if start_button:
		start_button.visible = false
	if speed_button:
		speed_button.visible = false

	if speech_bubble_ref and tutorial_text_ref and continue_button_ref:
		speech_bubble_ref.get_ref().visible = true
		continue_button_ref.get_ref().disabled = true
		show_dialogue(0)
	else:
		print("ERROR: No se asignaron correctamente los nodos del tutorial")

func assign_tutorial_nodes():
	var nodes = get_tree().get_nodes_in_group("TutorialNodes")

	for node in nodes:
		match node.name:
			"SpeechBubble":           speech_bubble_ref = weakref(node)
			"Label":                  tutorial_text_ref = weakref(node)
			"ContinueButton":         continue_button_ref = weakref(node)
			"TacoTutorial":           taco_tutorial_ref = weakref(node)

			"Arrow1Ingredients":      arrow1_ingredients_ref = weakref(node)
			"Arrow2TortillaAdd":      arrow2_tortilla_add_ref = weakref(node)
			"Arrow3Carne":            arrow3_carne_ref = weakref(node)
			"Arrow4CarneAdd":         arrow4_carne_add_ref = weakref(node)
			"Arrow5Buy":              arrow5_buy_ref = weakref(node)
			"Arrow6Grill":            arrow6_grill_ref = weakref(node)
			"Arrow7TortillaButton":   arrow7_tortilla_button_ref = weakref(node)
			"Arrow8TortillaAdd":      arrow8_tortilla_add_ref = weakref(node)
			"ArrowLevels":            arrow_levels_ref = weakref(node)
			"ArrowMoney":             arrow_money_ref = weakref(node)
			"ArrowGrillTortillaAdd":  arrow_grill_tortilla_add_ref = weakref(node)
			"ArrowSTART":  			  arrow_start_ref = weakref(node)

	# Ocultar todas las flechas
	if arrow1_ingredients_ref:      arrow1_ingredients_ref.get_ref().visible = false
	if arrow2_tortilla_add_ref:     arrow2_tortilla_add_ref.get_ref().visible = false
	if arrow3_carne_ref:            arrow3_carne_ref.get_ref().visible = false
	if arrow4_carne_add_ref:        arrow4_carne_add_ref.get_ref().visible = false
	if arrow5_buy_ref:              arrow5_buy_ref.get_ref().visible = false
	if arrow6_grill_ref:            arrow6_grill_ref.get_ref().visible = false
	if arrow7_tortilla_button_ref:  arrow7_tortilla_button_ref.get_ref().visible = false
	if arrow8_tortilla_add_ref:     arrow8_tortilla_add_ref.get_ref().visible = false
	if arrow_levels_ref:            arrow_levels_ref.get_ref().visible = false
	if arrow_money_ref:             arrow_money_ref.get_ref().visible = false
	if arrow_grill_tortilla_add_ref: arrow_grill_tortilla_add_ref.get_ref().visible = false
	if arrow_start_ref: 			arrow_start_ref.get_ref().visible = false

func show_dialogue(index):
	var tutorial_text = tutorial_text_ref.get_ref()
	if not tutorial_text:
		print("ERROR: tutorial_text fue liberado antes de usarse")
		return

	# Borrar texto previo
	tutorial_text.text = ""
	var text_to_display = dialogues[index]

	await type_text(text_to_display)

	var continue_button = continue_button_ref.get_ref()

	if step == 2:
		# Ejemplo: flecha dinero
		waiting_for_action = false
		action_completed = false
		if arrow_money_ref:
			arrow_money_ref.get_ref().visible = true
		if taco_tutorial_ref:
			taco_tutorial_ref.get_ref().visible = false
		if continue_button:
			continue_button.disabled = false
		return
	elif step == 3:
		# Mostrar flecha arrow1
		if arrow_money_ref:
			arrow_money_ref.get_ref().visible = false
		waiting_for_action = true
		action_completed = false
		if arrow1_ingredients_ref:
			arrow1_ingredients_ref.get_ref().visible = true

		# Conectar el botón "Ingredientes"
		# Ajusta la ruta a tu botón real
		var ingredientes_button = get_node("/root/Node2D/CanvasLayer/HBoxContainer3/PanelContainer5/Button5")
		if ingredientes_button and not ingredientes_button.is_connected("pressed", Callable(self, "_on_IngredientesButton_pressed")):
			ingredientes_button.connect("pressed", Callable(self, "_on_IngredientesButton_pressed"))
	else:
		# Pasos especiales
		if step == 5:
			start_step_5()
			print("DEBUG: Avanzando a paso", step)  # <--- IMPRIME EL NUEVO STEP
		elif step == 6:
			start_step_6()
			print("DEBUG: Avanzando a paso", step)  # <--- IMPRIME EL NUEVO STEP
		elif step == 7:
			start_step_7()
			print("DEBUG: Avanzando a paso", step)  # <--- IMPRIME EL NUEVO STEP
		elif step == 8:
			start_step_8()
			print("DEBUG: Avanzando a paso", step)  # <--- IMPRIME EL NUEVO STEP
		elif step == 9:
			start_step_9()
			print("DEBUG: Avanzando a paso", step)  # <--- IMPRIME EL NUEVO STEP
		elif step == 10:
			start_step_10()
			print("DEBUG: Avanzando a paso", step)  # <--- IMPRIME EL NUEVO STEP
		elif step == 11:
			start_step_11()
			print("DEBUG: Avanzando a paso", step)  # <--- IMPRIME EL NUEVO STEP
		else:
			waiting_for_action = false
			if continue_button:
				continue_button.disabled = false

func _on_ContinueButton_pressed():
	if waiting_for_action:
		return

	var continue_button = continue_button_ref.get_ref()
	if continue_button:
		continue_button.disabled = true
		
	step += 1
	if step < dialogues.size():
		show_dialogue(step)
	else:
		end_tutorial()

# ------------------------------------
# type_text: animación letra por letra
# ------------------------------------
func type_text(text):
	var tutorial_text = tutorial_text_ref.get_ref()
	if not tutorial_text:
		print("ERROR: tutorial_text fue liberado antes de escribir texto")
		return

	tutorial_text.text = ""
	for letter in text:
		tutorial_text.text += letter
		await get_tree().create_timer(typing_speed).timeout

# -------------------------------------------------------------------
# FUNCIONES QUE MANEJAN LAS FLECHAS Y BOTONES
# -------------------------------------------------------------------

# 1) Al presionar Botón Ingredientes
func _on_IngredientesButton_pressed():
	# Ocultar Arrow1
	if arrow1_ingredients_ref:
		arrow1_ingredients_ref.get_ref().visible = false

	# Mostrar Arrow2
	if arrow2_tortilla_add_ref:
		arrow2_tortilla_add_ref.get_ref().visible = true

	# Conectar el botón de "TortillaAdd"
	var tortilla_add_button = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/TortillasSupplies/HBoxContainer2/PlusButton")
	if tortilla_add_button and not tortilla_add_button.is_connected("pressed", Callable(self, "_on_TortillaAddButton_pressed")):
		tortilla_add_button.connect("pressed", Callable(self, "_on_TortillaAddButton_pressed"))

# 2) Al presionar Botón TortillaAdd
func _on_TortillaAddButton_pressed():
	if arrow2_tortilla_add_ref:
		arrow2_tortilla_add_ref.get_ref().visible = false

	# Mostrar Arrow3Carne
	if arrow3_carne_ref:
		arrow3_carne_ref.get_ref().visible = true

	# Conectar botón Carne
	var carne_button = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/HBoxContainer/CarneButton")
	if carne_button and not carne_button.is_connected("pressed", Callable(self, "_on_CarneButton_pressed")):
		carne_button.connect("pressed", Callable(self, "_on_CarneButton_pressed"))

# 3) Al presionar Botón Carne
func _on_CarneButton_pressed():
	if arrow3_carne_ref:
		arrow3_carne_ref.get_ref().visible = false

	# Mostrar Arrow4CarneAdd
	if arrow4_carne_add_ref:
		arrow4_carne_add_ref.get_ref().visible = true

	# Conectar botón PlusCarne (HBoxContainer?)
	var plus_carne = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/CarneSupplies/HBoxContainer/PlusButton")
	if plus_carne and not plus_carne.is_connected("pressed", Callable(self, "_on_CarneAddButton_pressed")):
		plus_carne.connect("pressed", Callable(self, "_on_CarneAddButton_pressed"))

# 4) Al presionar Botón CarneAdd
func _on_CarneAddButton_pressed():
	if arrow4_carne_add_ref:
		arrow4_carne_add_ref.get_ref().visible = false

	# Mostrar Arrow5Buy
	if arrow5_buy_ref:
		arrow5_buy_ref.get_ref().visible = true

	# Conectar botón Buy
	var buy_button = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/BuyButton")
	if buy_button and not buy_button.is_connected("pressed", Callable(self, "_on_BuyButton_pressed")):
		buy_button.connect("pressed", Callable(self, "_on_BuyButton_pressed"))

# 5) Al presionar Botón Buy
func _on_BuyButton_pressed():
	if arrow5_buy_ref:
		arrow5_buy_ref.get_ref().visible = false

	# Liberar la espera y avanzar
	waiting_for_action = false
	action_completed = true
	step += 1
	show_dialogue(step)

# -------------------------------------------------------------------
# start_step_5 -> EJEMPLO Arrow6Grill
# -------------------------------------------------------------------
func start_step_5():
	waiting_for_action = true
	action_completed = false
	# Muestra arrow6
	if arrow6_grill_ref:
		arrow6_grill_ref.get_ref().visible = true

	# Conecta un botón de grill si procede
	var grill_button = get_node("/root/Node2D/CanvasLayer/HBoxContainer3/PanelContainer6/Button6")
	if grill_button and not grill_button.is_connected("pressed", Callable(self, "_on_GrillButton_pressed")):
		grill_button.connect("pressed", Callable(self, "_on_GrillButton_pressed"))

func _on_GrillButton_pressed():
	if arrow6_grill_ref:
		arrow6_grill_ref.get_ref().visible = false

	# Mostrar la flecha 7 (p.ej. Arrow7TortillaButton)
	if arrow7_tortilla_button_ref:
		arrow7_tortilla_button_ref.get_ref().visible = true

	# Conectar el TortillaButton
	var tortilla_button = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/TortillasContainer/TortillaButton")
	if tortilla_button and not tortilla_button.is_connected("pressed", Callable(self, "_on_TortillaButton_pressed")):
		tortilla_button.connect("pressed", Callable(self, "_on_TortillaButton_pressed"))

	# AÑADIR estas líneas para avanzar el tutorial
	waiting_for_action = false
	action_completed = true
	step += 1
	show_dialogue(step)


# -------------------------------------------------------------------
# start_step_6 -> Manejo de la siguiente flecha (Arrow7TortillaButton)
# -------------------------------------------------------------------
func start_step_6():
	waiting_for_action = true
	action_completed = false
	
	# Mostrar flecha 7
	if arrow7_tortilla_button_ref:
		arrow7_tortilla_button_ref.get_ref().visible = true

	# Conectar el TortillaButton (por si no lo hiciste antes)
	var tortilla_button = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/TortillasContainer/TortillaButton")
	if tortilla_button and not tortilla_button.is_connected("pressed", Callable(self, "_on_TortillaButton_pressed")):
		tortilla_button.connect("pressed", Callable(self, "_on_TortillaButton_pressed"))

# Al presionar TortillaButton
func _on_TortillaButton_pressed():
	# Ocultar flecha 7
	if arrow7_tortilla_button_ref:
		arrow7_tortilla_button_ref.get_ref().visible = false

	# Mostrar flecha 8
	if arrow8_tortilla_add_ref:
		arrow8_tortilla_add_ref.get_ref().visible = true

	# Conectar el botón Add
	var add_button = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/AddButton")
	if add_button and not add_button.is_connected("pressed", Callable(self, "_on_add_button_pressed")):
		add_button.connect("pressed", Callable(self, "_on_add_button_pressed"))

	# Inicializamos el contador de tortillas presionadas
	add_press_count = 0
	# AÑADIR estas líneas para avanzar el tutorial
	waiting_for_action = false
	action_completed = true
	step += 1
	show_dialogue(step)

func _on_add_button_pressed():
	# Cada vez que el jugador presiona "AddButton", incrementamos
	add_press_count += 1
	print("Tortillas añadidas:", add_press_count)

	if add_press_count >= 4:
		# Si llegó a 4, ocultamos flecha 8
		if arrow8_tortilla_add_ref:
			arrow8_tortilla_add_ref.get_ref().visible = false

		# AÑADIR estas líneas para avanzar el tutorial
		waiting_for_action = false
		action_completed = true
		step += 1
		show_dialogue(step)



# -------------------------------------------------------------------
# start_step_7 -> Ejemplo: flecha7
# -------------------------------------------------------------------
func start_step_7():
	print(" Aquí terminamos con grill creo ?")
	waiting_for_action = true
	action_completed = false
	
	print("DEBUG: Avanzando a paso", step)  # <--- IMPRIME EL NUEVO STEP
	
	
	# EJEMPLO: Muestra arrow7TortillaButton
	#if arrow7_tortilla_button_ref:
		#arrow7_tortilla_button_ref.get_ref().visible = true

	# Conectar el TortillaButton, etc.

# -------------------------------------------------------------------
# start_step_8 -> Muestra arrow8TortillaAdd o arrowLevels
# -------------------------------------------------------------------
func start_step_8():
	waiting_for_action = true
	action_completed = false
	#if arrow_levels_ref:
		#arrow_levels_ref.get_ref().visible = true

	# AÑADIR estas líneas para avanzar el tutorial
	waiting_for_action = false
	action_completed = true
	step += 1
	show_dialogue(step)

func _on_LevelsButton_pressed():
	if arrow_levels_ref:
		arrow_levels_ref.get_ref().visible = false

	waiting_for_action = false
	action_completed = true
	step += 1
	show_dialogue(step)

# -------------------------------------------------------------------
# start_step_9
# -------------------------------------------------------------------
func start_step_9():
	print("DEBUG: start_step_9 => step=", step)
	waiting_for_action = false  # <-- Permitir que ContinueButton funcione
	action_completed = false

	var continue_button = continue_button_ref.get_ref()
	if continue_button:
		continue_button.disabled = false


func start_step_10():
	waiting_for_action = true
	action_completed = false

	# Ocultar el botón de "Continuar"
	var continue_button = continue_button_ref.get_ref()
	if continue_button:
		continue_button.visible = false

	# Mostrar la flecha que apunta al botón Start (si la usas)
	if arrow_start_ref:
		arrow_start_ref.get_ref().visible = true

	# Ocultar el globo de diálogo
	if speech_bubble_ref:
		speech_bubble_ref.get_ref().visible = false

	# Hacer visible el botón Start, y conectar su señal "pressed"
	if start_button:
		start_button.visible = true
		# Conecta la señal solo si no está ya conectada
		if not start_button.is_connected("pressed", Callable(self, "_on_StartButton_pressed")):
			start_button.connect("pressed", Callable(self, "_on_StartButton_pressed"))

func _on_StartButton_pressed():
	# Cuando se presiona Start, finalizamos la parte 1 del tutorial
	if arrow_start_ref:
		arrow_start_ref.get_ref().visible = false
	disconnect_tutorial_signals()
	start_step_11()

func start_step_11():
	print("DEBUG: Entrando a step_11 => Pausa automática tras 1s")

	# Esperamos 1 segundo para que el jugador vea las órdenes
	var t = get_tree().create_timer(1.0)
	await t.timeout

	# Llamar a day_manager para pausar el juego
	if day_control and day_control.has_method("_on_pause_pressed"):
		day_control._on_pause_pressed()
	else:
		print("No se encontró DayManager._on_pause_pressed()")
		
	

	# ✅ Mostrar mensaje de instrucciones para step_11
	show_dialogue(11)

	# ✅ Comenzar la verificación constante
	_check_3_tacos()

# ✅ Verificación constante de tacos completos
func _check_3_tacos():
	print("✅ Verificando si los tacos están completos...")

	# Si hay 3 tacos completos, avanzamos al siguiente paso
	if GrillManager.has_3_distinct_tacos():
		print("🔥 Tacos completos detectados. Avanzando al siguiente paso...")

		# ✅ Habilitar el botón de continuar
		var continue_button = continue_button_ref.get_ref()
		if continue_button:
			continue_button.disabled = false

		# ✅ Desactivar la verificación constante para evitar loops
		waiting_for_action = false
		action_completed = true

		# ✅ Avanzar al siguiente paso
		step += 1
		show_dialogue(step)
	else:
		# ✅ Si aún no están completos, esperar y volver a verificar
		var t = get_tree().create_timer(0.5)  # Verificamos cada 0.5 segundos
		await t.timeout
		_check_3_tacos()


	
# -------------------------------------------------------------------
# end_tutorial: No se cambia de escena, se oculta HUD
# -------------------------------------------------------------------
func end_tutorial():
	print("TUTORIAL TERMINADO: Fin de la Parte 1")

	# Ocultar flecha de Start, si la había
	if arrow_start_ref:
		arrow_start_ref.get_ref().visible = false

	# Mensaje final (opcional)
	var tutorial_text = tutorial_text_ref.get_ref()
	if tutorial_text:
		tutorial_text.text = "¡Felicidades! Parte 1 del tutorial completada."

	# Esperar 2 segundos
	await get_tree().create_timer(2).timeout

	# Deshabilitar/ocultar el botón de continuar
	var continue_button = continue_button_ref.get_ref()
	if continue_button:
		continue_button.disabled = true
		continue_button.visible = false

	# Ocultar el globo de diálogo
	if speech_bubble_ref:
		speech_bubble_ref.get_ref().visible = false

	# Ocultar el sprite del taco (si lo usabas)
	var taco_tutorial_node = get_node("/root/Node2D/CanvasLayer/TacoTutorial")
	if taco_tutorial_node:
		taco_tutorial_node.visible = false

	# También ocultar el botón Start
	if start_button:
		start_button.visible = false

	# Llamar a la función que desconecta todas las señales
	disconnect_tutorial_signals()

	print("Parte 1 del tutorial finalizada. ¡Listo para la parte 2!")

func disconnect_tutorial_signals():
	# Desconecta todas las señales que se conectaron manualmente en este tutorial
	print("Desconectando todas las señales del tutorial...")

	var ing_button = get_node_or_null("/root/Node2D/CanvasLayer/HBoxContainer3/PanelContainer5/Button5")
	if ing_button and ing_button.is_connected("pressed", Callable(self, "_on_IngredientesButton_pressed")):
		ing_button.disconnect("pressed", Callable(self, "_on_IngredientesButton_pressed"))

	var tortilla_add_button = get_node_or_null("/root/Node2D/CanvasLayer/PanelContainer/Panel5/TortillasSupplies/HBoxContainer2/PlusButton")
	if tortilla_add_button and tortilla_add_button.is_connected("pressed", Callable(self, "_on_TortillaAddButton_pressed")):
		tortilla_add_button.disconnect("pressed", Callable(self, "_on_TortillaAddButton_pressed"))

	var carne_button = get_node_or_null("/root/Node2D/CanvasLayer/PanelContainer/Panel5/HBoxContainer/CarneButton")
	if carne_button and carne_button.is_connected("pressed", Callable(self, "_on_CarneButton_pressed")):
		carne_button.disconnect("pressed", Callable(self, "_on_CarneButton_pressed"))

	var plus_carne = get_node_or_null("/root/Node2D/CanvasLayer/PanelContainer/Panel5/CarneSupplies/HBoxContainer/PlusButton")
	if plus_carne and plus_carne.is_connected("pressed", Callable(self, "_on_CarneAddButton_pressed")):
		plus_carne.disconnect("pressed", Callable(self, "_on_CarneAddButton_pressed"))

	var buy_button = get_node_or_null("/root/Node2D/CanvasLayer/PanelContainer/Panel5/BuyButton")
	if buy_button and buy_button.is_connected("pressed", Callable(self, "_on_BuyButton_pressed")):
		buy_button.disconnect("pressed", Callable(self, "_on_BuyButton_pressed"))

	var grill_button = get_node_or_null("/root/Node2D/CanvasLayer/HBoxContainer3/PanelContainer6/Button6")
	if grill_button and grill_button.is_connected("pressed", Callable(self, "_on_GrillButton_pressed")):
		grill_button.disconnect("pressed", Callable(self, "_on_GrillButton_pressed"))

	var tortilla_button = get_node_or_null("/root/Node2D/CanvasLayer/PanelContainer/Panel6/TortillasContainer/TortillaButton")
	if tortilla_button and tortilla_button.is_connected("pressed", Callable(self, "_on_TortillaButton_pressed")):
		tortilla_button.disconnect("pressed", Callable(self, "_on_TortillaButton_pressed"))

	var add_button = get_node_or_null("/root/Node2D/CanvasLayer/PanelContainer/Panel6/AddButton")
	if add_button and add_button.is_connected("pressed", Callable(self, "_on_add_button_pressed")):
		add_button.disconnect("pressed", Callable(self, "_on_add_button_pressed"))

	# Desconecta el botón Start
	if start_button and start_button.is_connected("pressed", Callable(self, "_on_StartButton_pressed")):
		start_button.disconnect("pressed", Callable(self, "_on_StartButton_pressed"))

	print("Todas las señales del tutorial han sido desconectadas.")

func restart_ready():
	print("Reejecutando _ready() con call_deferred()")
	call_deferred("_ready")
