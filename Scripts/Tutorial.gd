extends Node2D

var step = 11
var typing_speed = 0.04
var waiting_for_action = false
var action_completed = false

var speech_bubble_ref
var tutorial_text_ref
var continue_button_ref
var arrow_ref
var arrow2_ref
var arrow3_ref
var arrow4_ref
var arrow5_ref
var arrow6_ref
var arrow7_ref
var arrow8_ref
var arrow9_ref
var arrow_money_ref  # NUEVO: flecha para el dinero
var taco_tutorial_ref
@onready var start_button = get_node("/root/Node2D/CanvasLayer/Gameplay/StartButton")
@onready var speed_button = get_node("/root/Node2D/CanvasLayer/Gameplay/SpeedButton")

var dialogues = [
	"¡Hola! Bienvenido a Cucei Taco Tycoon.",
	"Aquí aprenderás a administrar tu negocio de tacos.",
	"Primero, veamos cuánto dinero tienes.",
	"Ahora compra ingredientes para preparar tacos. Lo escencial es tortilla y carne.",
	"¡Listo! Ya tienes ingredientes para vender tacos.",
	"Lo siguiente es preparar nuestros tacos con esos ingredientes.",
	"En este menú, vamos a realizar la preparación de nuestros tacos.",
	"Lo primero que vamos a hacer es agregar tortillas a la parrilla.",
	"Puedes invertir tus ganancias en distintas mejoras para tu establecimiento.",
	"Además de completar tareas que aumentarán la puntuación de tu taquería.",
	"Una vez hayas avanzado lo suficiente, podrás expandir tu negocio a nuevas zonas.",
	"Mientras más zonas desbloquees, mejor será tu reputación y serás más exitoso."
]

func _ready():
	assign_tutorial_nodes()

	if speech_bubble_ref and tutorial_text_ref and continue_button_ref:
		speech_bubble_ref.get_ref().visible = true
		continue_button_ref.get_ref().disabled = true
		show_dialogue(0)
	else:
		print("ERROR: No se asignaron correctamente todos los nodos")

func assign_tutorial_nodes():
	var nodes = get_tree().get_nodes_in_group("TutorialNodes")

	for node in nodes:
		match node.name:
			"SpeechBubble": speech_bubble_ref = weakref(node)
			"Label": tutorial_text_ref = weakref(node)
			"ContinueButton": continue_button_ref = weakref(node)
			"Arrow": arrow_ref = weakref(node)
			"Arrow2": arrow2_ref = weakref(node)
			"Arrow3": arrow3_ref = weakref(node)
			"Arrow4": arrow4_ref = weakref(node)
			"Arrow5": arrow5_ref = weakref(node)
			"Arrow6": arrow6_ref = weakref(node)  
			"Arrow7": arrow7_ref = weakref(node)
			"Arrow8": arrow8_ref = weakref(node)
			"Arrow9": arrow9_ref = weakref(node)
			"ArrowMoney": arrow_money_ref = weakref(node)  # NUEVO
			"TacoTutorial": taco_tutorial_ref = weakref(node)

	# Asegurar que todas las flechas están ocultas al inicio
	if arrow_ref: arrow_ref.get_ref().visible = false
	if arrow2_ref: arrow2_ref.get_ref().visible = false
	if arrow3_ref: arrow3_ref.get_ref().visible = false
	if arrow4_ref: arrow4_ref.get_ref().visible = false
	if arrow5_ref: arrow5_ref.get_ref().visible = false
	if arrow6_ref: arrow6_ref.get_ref().visible = false
	if arrow7_ref: arrow7_ref.get_ref().visible = false
	if arrow8_ref: arrow8_ref.get_ref().visible = false
	if arrow9_ref: arrow9_ref.get_ref().visible = false
	if arrow_money_ref: arrow_money_ref.get_ref().visible = false

func show_dialogue(index):
	var tutorial_text = tutorial_text_ref.get_ref()
	if not tutorial_text:
		print("ERROR: tutorial_text fue liberado antes de usarse")
		return

	tutorial_text.text = ""
	var text_to_display = dialogues[index]
	await type_text(text_to_display)

	var continue_button = continue_button_ref.get_ref()

	# EJEMPLO: en el paso == 2 se muestra la flecha de dinero y se oculta TacoTutorial
	if step == 2:
		waiting_for_action = false
		action_completed = false
		if arrow_money_ref:
			arrow_money_ref.get_ref().visible = true
		if taco_tutorial_ref:
			taco_tutorial_ref.get_ref().visible = false
		# Habilitar el botón de continuar si deseas avanzar con un clic normal
		if continue_button:
			continue_button.disabled = false
		return  # Regresamos para evitar que entre a la lógica de "else" de abajo

	if step == 3:
		# Antes de la lógica de "compra ingredientes", ocultamos la flecha de dinero
		if arrow_money_ref:
			arrow_money_ref.get_ref().visible = false

		waiting_for_action = true
		action_completed = false
		if taco_tutorial_ref:
			taco_tutorial_ref.get_ref().visible = false  
		if arrow_ref:
			arrow_ref.get_ref().visible = true  

		var ingredientes_button = get_node("/root/Node2D/CanvasLayer/HBoxContainer3/PanelContainer5/Button5")
		if ingredientes_button and not ingredientes_button.is_connected("pressed", Callable(self, "_on_IngredientesButton_pressed")):
			ingredientes_button.connect("pressed", Callable(self, "_on_IngredientesButton_pressed"))
	else:
		# Pasos especiales para flechas: 5, 8, 9, 10
		if step == 5:
			start_step_5()  # Arrow6
		elif step == 8:
			start_step_8()  # Arrow7
		elif step == 9:
			start_step_9()  # Arrow8
		elif step == 10:
			start_step_10() # Arrow9
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


# ------ LÓGICA ORIGINAL: Flechas 1 → 5 ------
func _on_IngredientesButton_pressed():
	if step != 3 or action_completed:
		return
	
	action_completed = true
	if arrow_ref:
		arrow_ref.get_ref().visible = false
	if arrow2_ref:
		arrow2_ref.get_ref().visible = true

	var suma1_button = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/TortillasSupplies/HBoxContainer2/PlusButton")
	if suma1_button:
		suma1_button.connect("pressed", Callable(self, "_on_Suma1_pressed"), CONNECT_ONE_SHOT)

func _on_Suma1_pressed():
	if arrow2_ref:
		arrow2_ref.get_ref().visible = false
	if arrow3_ref:
		arrow3_ref.get_ref().visible = true

	var carne_button = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/HBoxContainer/CarneButton")
	if carne_button:
		carne_button.connect("pressed", Callable(self, "_on_CarneButton_pressed"), CONNECT_ONE_SHOT)

func _on_CarneButton_pressed():
	if arrow3_ref:
		arrow3_ref.get_ref().visible = false
	if arrow4_ref:
		arrow4_ref.get_ref().visible = true

	var suma2_button = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/CarneSupplies/HBoxContainer/PlusButton")
	if suma2_button:
		suma2_button.connect("pressed", Callable(self, "_on_Suma2_pressed"), CONNECT_ONE_SHOT)

func _on_Suma2_pressed():
	if arrow4_ref:
		arrow4_ref.get_ref().visible = false
	if arrow5_ref:
		arrow5_ref.get_ref().visible = true

	var buy_button = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/BuyButton")
	if buy_button:
		buy_button.connect("pressed", Callable(self, "_on_BuyButton_pressed"), CONNECT_ONE_SHOT)

func _on_BuyButton_pressed():
	if waiting_for_action:
		waiting_for_action = false
		if arrow5_ref:
			arrow5_ref.get_ref().visible = false
		if taco_tutorial_ref:
			taco_tutorial_ref.get_ref().visible = true

		step += 1
		show_dialogue(step)

# ------ Paso 5: Manejo Arrow6 (Receta) ------
func start_step_5():
	waiting_for_action = true
	action_completed = false
	if arrow6_ref:
		arrow6_ref.get_ref().visible = true  

	var receta_button = get_node("/root/Node2D/CanvasLayer/HBoxContainer3/PanelContainer6/Button6")
	if receta_button and not receta_button.is_connected("pressed", Callable(self, "_on_RecetaButton_pressed")):
		receta_button.connect("pressed", Callable(self, "_on_RecetaButton_pressed"))

func _on_RecetaButton_pressed():
	if action_completed:
		return
	
	action_completed = true
	waiting_for_action = false

	if arrow6_ref:
		arrow6_ref.get_ref().visible = false  

	step += 1
	show_dialogue(step)

# ------ Paso 8: Manejo Arrow7 (Mejoras) ------
func start_step_8():
	waiting_for_action = true
	action_completed = false
	if arrow7_ref:
		arrow7_ref.get_ref().visible = true  

	var mejoras_button = get_node("/root/Node2D/CanvasLayer/HBoxContainer2/PanelContainer3/Button3")
	if mejoras_button and not mejoras_button.is_connected("pressed", Callable(self, "_on_MejorasButton_pressed")):
		mejoras_button.connect("pressed", Callable(self, "_on_MejorasButton_pressed"))

func _on_MejorasButton_pressed():
	if action_completed:
		return
	
	action_completed = true
	waiting_for_action = false

	if arrow7_ref:
		arrow7_ref.get_ref().visible = false  

	step += 1
	show_dialogue(step)

# ------ Paso 9: Manejo Arrow8 (Tareas) ------
func start_step_9():
	waiting_for_action = true
	action_completed = false
	if arrow8_ref:
		arrow8_ref.get_ref().visible = true  # Mostrar flecha 8

	# Conectar el botón Tareas
	var tareas_button = get_node("/root/Node2D/CanvasLayer/HBoxContainer2/PanelContainer4/Button4")
	if tareas_button and not tareas_button.is_connected("pressed", Callable(self, "_on_TareasButton_pressed")):
		tareas_button.connect("pressed", Callable(self, "_on_TareasButton_pressed"))

func _on_TareasButton_pressed():
	if action_completed:
		return
	action_completed = true
	waiting_for_action = false

	if arrow8_ref:
		arrow8_ref.get_ref().visible = false

	# Avanzar al siguiente diálogo
	step += 1
	show_dialogue(step)

# ------ Paso 10: Manejo Arrow9 (Niveles) ------
func start_step_10():
	waiting_for_action = true
	action_completed = false
	if arrow9_ref:
		arrow9_ref.get_ref().visible = true

	# Conectar el botón Niveles
	var niveles_button = get_node("/root/Node2D/CanvasLayer/HBoxContainer/PanelContainer/Button")
	if niveles_button and not niveles_button.is_connected("pressed", Callable(self, "_on_NivelesButton_pressed")):
		niveles_button.connect("pressed", Callable(self, "_on_NivelesButton_pressed"))

func _on_NivelesButton_pressed():
	if action_completed:
		return
	action_completed = true
	waiting_for_action = false

	if arrow9_ref:
		arrow9_ref.get_ref().visible = false

	step += 1
	show_dialogue(step)


func type_text(text):
	var tutorial_text = tutorial_text_ref.get_ref()
	if not tutorial_text:
		print("ERROR: tutorial_text fue liberado antes de escribir texto")
		return
	
	tutorial_text.text = ""
	for letter in text:
		tutorial_text.text += letter
		await get_tree().create_timer(typing_speed).timeout

func end_tutorial():
	var tutorial_text = tutorial_text_ref.get_ref()
	if tutorial_text:
		tutorial_text.text = "¡Felicidades! Ahora estás listo para jugar."

	# Esperar un poco para que el jugador vea el mensaje final (opcional)
	await get_tree().create_timer(2).timeout

	# Ocultar el botón "Continuar" y el globo de diálogo
	var continue_button = continue_button_ref.get_ref()
	if continue_button:
		continue_button.disabled = true
		continue_button.visible = false

	var speech_bubble = speech_bubble_ref.get_ref()
	if speech_bubble:
		speech_bubble.visible = false

	# Ocultar el TacoTutorial
	var taco_tutorial_node = get_node("/root/Node2D/CanvasLayer/TacoTutorial")
	if taco_tutorial_node:
		taco_tutorial_node.visible = false

	# Hacer visibles los botones Start y Speed
	if start_button:
		#start_button.visible = true
		pass
	if speed_button:
		#speed_button.visible = true
		pass


func restart_ready():
	print("Reejecutando _ready() con call_deferred()")
	call_deferred("_ready")
