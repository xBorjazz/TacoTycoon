extends Node2D

var step = 0
var typing_speed = 0.05

var speech_bubble_ref
var tutorial_text_ref
var continue_button_ref

var dialogues = [
	"¡Hola! Bienvenido a Cucei Taco Tycoon.",
	"Aquí aprenderás a administrar tu negocio de tacos.",
	"Primero, veamos cuánto dinero tienes.",
	"Ahora compra ingredientes para preparar tacos.",
	"¡Listo! Ya estás preparado para vender tacos."
]

func _ready():
	assign_tutorial_nodes()

	# Depuración: Verifica qué nodos se han asignado
	print("speech_bubble_ref: ", speech_bubble_ref)
	print("tutorial_text_ref: ", tutorial_text_ref)
	print("continue_button_ref: ", continue_button_ref)

	# Verificar si todos los nodos fueron encontrados antes de usarlos
	if speech_bubble_ref and tutorial_text_ref and continue_button_ref:
		speech_bubble_ref.get_ref().visible = true
		continue_button_ref.get_ref().disabled = true
		show_dialogue(0)
	else:
		print("ERROR: No se asignaron correctamente todos los nodos")

func assign_tutorial_nodes():
	var nodes = get_tree().get_nodes_in_group("TutorialNodes")
	
	print("Nodos en grupo TutorialNodes:", nodes)

	for node in nodes:
		print("Nodo encontrado en grupo:", node.name, "Tipo:", node.get_class())
		match node.name:
			"SpeechBubble":
				speech_bubble_ref = weakref(node)
			"Label":
				tutorial_text_ref = weakref(node)
			"ContinueButton":
				continue_button_ref = weakref(node)

	# Verificar si se asignaron correctamente
	if not speech_bubble_ref:
		print("ERROR: No se encontró SpeechBubble en el grupo TutorialNodes")
	if not tutorial_text_ref:
		print("ERROR: No se encontró Label en el grupo TutorialNodes")
	if not continue_button_ref:
		print("ERROR: No se encontró ContinueButton en el grupo TutorialNodes")

func show_dialogue(index):
	var tutorial_text = tutorial_text_ref.get_ref()
	if not tutorial_text:
		print("ERROR: tutorial_text fue liberado antes de usarse")
		return

	tutorial_text.text = ""
	var text_to_display = dialogues[index]
	await type_text(text_to_display)

	var continue_button = continue_button_ref.get_ref()
	if continue_button:
		continue_button.disabled = false

func _on_ContinueButton_pressed():
	var continue_button = continue_button_ref.get_ref()
	if continue_button:
		continue_button.disabled = true

	step += 1
	if step < dialogues.size():
		show_dialogue(step)
	else:
		end_tutorial()

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
	call_deferred("_ready")  # Esto ejecutará _ready() en el siguiente frame
