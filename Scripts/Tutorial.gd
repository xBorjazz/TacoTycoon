extends Node2D

var step = 0
var typing_speed = 0.05
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
var taco_tutorial_ref

var dialogues = [
	"¡Hola! Bienvenido a Cucei Taco Tycoon.",
	"Aquí aprenderás a administrar tu negocio de tacos.",
	"Primero, veamos cuánto dinero tienes.",
	"Ahora compra ingredientes para preparar tacos.\nLo esencial es tortilla y carne.",
	"¡Listo! Ya estás preparado para vender tacos.",
	"Si quieres, puedes ajustar la receta de tus tacos.",
	"Mientras más ingredientes uses, gastarás más suministros, pero también conseguirás más ganancias.",
	"A medida que avances en tu negocio, irás descubriendo las mejores combinaciones para tu receta según las circunstancias.",
	"Puedes invertir tus ganancias en distintas mejoras para tu establecimiento,\ncomo incrementar los clientes que llegan o conseguir que dejen propina.",
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
			"TacoTutorial": taco_tutorial_ref = weakref(node)

	# Asegurar que todas las flechas están ocultas al inicio
	if arrow_ref: arrow_ref.get_ref().visible = false
	if arrow2_ref: arrow2_ref.get_ref().visible = false
	if arrow3_ref: arrow3_ref.get_ref().visible = false
	if arrow4_ref: arrow4_ref.get_ref().visible = false
	if arrow5_ref: arrow5_ref.get_ref().visible = false

func show_dialogue(index):
	var tutorial_text = tutorial_text_ref.get_ref()
	if not tutorial_text:
		print("ERROR: tutorial_text fue liberado antes de usarse")
		return

	tutorial_text.text = ""
	var text_to_display = dialogues[index]
	await type_text(text_to_display)

	var continue_button = continue_button_ref.get_ref()

	if step == 3:
		waiting_for_action = true
		action_completed = false
		if taco_tutorial_ref:
			taco_tutorial_ref.get_ref().visible = false  
		if arrow_ref:
			arrow_ref.get_ref().visible = true  

		# Conectar evento al botón de ingredientes
		var ingredientes_button = get_node("/root/Node2D/CanvasLayer/HBoxContainer3/PanelContainer5/Button5")
		if ingredientes_button and not ingredientes_button.is_connected("pressed", Callable(self, "_on_IngredientesButton_pressed")):
			ingredientes_button.connect("pressed", Callable(self, "_on_IngredientesButton_pressed"))
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

func _on_IngredientesButton_pressed():
	if step != 3 or action_completed:
		return
	
	action_completed = true
	if arrow_ref:
		arrow_ref.get_ref().visible = false
	if arrow2_ref:
		arrow2_ref.get_ref().visible = true

	# Conectar siguiente evento
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

	var continue_button = continue_button_ref.get_ref()
	if continue_button:
		continue_button.disabled = true

	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://node_2d.tscn")

func restart_ready():
	print("Reejecutando _ready() con call_deferred()")
	call_deferred("_ready")
