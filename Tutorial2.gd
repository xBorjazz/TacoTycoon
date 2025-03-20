#extends Node2D
#
##"""
##Tutorial2.gd
##Segunda parte del tutorial de Cucei Taco Tycoon.
##
##Objetivos clave:
##1) Al iniciar esta parte del tutorial (step 0), forzamos el Spawner a crear tres clientes con pedidos Taco-1, Taco-2 y Taco-3.
##2) Pausamos la simulación (get_tree().paused = true) para que los clientes no avancen hasta que el jugador prepare un taco de cada tipo en la parrilla.
##3) Cuando GrillManager verifique que hay un Taco-1, Taco-2 y Taco-3 listos, se desbloquea el “Continuar” (o simplemente reanudamos la simulación).
##4) Al llegar a step 1 (o el siguiente step que gustes), se retoma (get_tree().paused = false) y sigue el tutorial.
##
##Este script asume que has agregado/ajustado en Spawner.gd una función 
##spawn_specific_tacos(taco_types: Array), o que hagas “spawn” manual 
##de cada uno. También asume que GrillManager.gd tenga una forma de 
##verificar la existencia de 1 taco de cada tipo (p.ej. has_3_distinct_tacos()).
##
##Ajusta los nombres de funciones, rutas y checks según tu proyecto real.
##"""
#
#@onready var spawner := get_node("/root/Node2D/Spawner")
#@onready var grill_manager := get_node("/root/Node2D/GrillManager")
#
## Paso actual del tutorial
#var step := 0
#var typing_speed := 0.02
#var waiting_for_action := false
#var action_completed := false
#
## Referencias a la UI del tutorial (p.ej. un Label, un Botón de “Continuar”, etc.)
#var speech_bubble_ref
#var tutorial_text_ref
#var continue_button_ref
#
## Array con los textos de esta parte 2 del tutorial (puedes ampliarlo)
#var dialogues2 := [
	#"¡Bienvenido a la segunda parte del tutorial!\n Ahora veremos cómo atender pedidos específicos.",
	#"Primero, prepárate para hacer 3 tacos distintos.",
	#"¡Listo! Ya dominaste estos tacos especiales. Continúa para más."
#]
#
#func _ready():
	#assign_tutorial2_nodes()
	#show_dialogue(0)
#
#func assign_tutorial2_nodes():
	## Ajusta esta lógica a cómo obtengas tus nodos de la interfaz 
	## (p.ej. un group "Tutorial2Nodes", o rutas directas).
	## Ejemplo genérico:
	## var nodes = get_tree().get_nodes_in_group("Tutorial2Nodes")
	## for node in nodes:
	##     match node.name:
	##         "SpeechBubble2": speech_bubble_ref = weakref(node)
	##         "Label2": tutorial_text_ref = weakref(node)
	##         "ContinueButton2": continue_button_ref = weakref(node)
	#pass
#
#func show_dialogue(index: int) -> void:
	#if index >= dialogues2.size():
		## Si supera el array de diálogos, concluye la parte 2
		#end_tutorial_part2()
		#return
	#
	## Muestra el texto actual
	#var text := dialogues2[index]
	#_show_text_on_label(text)
#
	## Según step, despachamos la lógica
	#match step:
		#0:
			#start_step_0()
		#1:
			#start_step_1()
		#_:
			## Cierra el tutorial si no hay más pasos
			#end_tutorial_part2()
#
## -------------------------------------------------------------------
## Ejemplo: Step 0 => Forzar spawn de Taco-1, Taco-2, Taco-3 y pausar
## -------------------------------------------------------------------
#func start_step_0():
	#print("Tutorial2 => Step 0. Spawneamos 3 clientes: Taco-1, Taco-2, Taco-3")
#
	## Forzamos la aparición de 3 clientes con pedidos distintos
	#if spawner and spawner.has_method("spawn_specific_tacos"):
		#spawner.spawn_specific_tacos(["Taco-1","Taco-2","Taco-3"])
	#else:
		## En caso de no tener spawn_specific_tacos, llamamos 3 veces a un spawn manual
		#print("No existe 'spawn_specific_tacos'; se intentará spawn manual 3 veces")
		#if spawner:
			## Llamar 3 veces a _spawn_character() con algún hack para forzar
			## (Debes modificar Spawner.gd si quieres forzar un pedido específico.)
			#pass
#
	## Pausar la simulación para que los clientes no avancen
	#get_tree().paused = true
#
	#waiting_for_action = true
	#action_completed = false
#
#func start_step_1():
	#print("Tutorial2 => Step 1. Verificar si hay 1 Taco-1, 1 Taco-2 y 1 Taco-3 en la parrilla")
#
	## Chequea en GrillManager si el jugador ya preparó (Taco-1, Taco-2, Taco-3).
	## Asume que has implementado una función "has_3_distinct_tacos()" en GrillManager 
	## o algo similar. Ajusta a tu lógica real.
	#if grill_manager and grill_manager.has_method("has_3_distinct_tacos"):
		#var ok := grill_manager.has_3_distinct_tacos()
		#if ok:
			#print("Tutorial2 => ¡El jugador preparó 1 Taco-1, 1 Taco-2 y 1 Taco-3!")
			## Despausamos y permitimos avanzar
			#get_tree().paused = false
#
			#waiting_for_action = false
			#action_completed = true
			#step += 1
			#show_dialogue(step)
		#else:
			#print("Tutorial2 => Aún no hay 3 tacos distintos en la parrilla. Revisamos en 1s")
			#var timer := get_tree().create_timer(1.0)
			#await timer.timeout
			#start_step_1()  # reintenta
	#else:
		#print("WARNING: GrillManager no tiene 'has_3_distinct_tacos'. Ajusta lógica.")
		## For demo: deja el tutorial abierto
		#waiting_for_action = false
		#action_completed = true
#
#func _on_ContinueButton_pressed():
	#if waiting_for_action:
		#return
#
	#step += 1
	#show_dialogue(step)
#
#func end_tutorial_part2():
	#print("Tutorial2 => Fin de la segunda parte. Desconectamos señales y ocultamos tutorial.")
	#disconnect_tutorial_signals_part2()
#
	## Oculta UI
	#_hide_tutorial2_ui()
	## Reanuda la simulación por si seguía pausado
	#get_tree().paused = false
#
#func disconnect_tutorial_signals_part2():
	#print("Tutorial2 => Desconectando las señales conectadas en la parte 2")
	## Ejemplo si conectaste algo en spawner / grill:
	## if spawner and spawner.is_connected("some_signal", Callable(self, "_on_SomeSignal")):
	##     spawner.disconnect("some_signal", Callable(self, "_on_SomeSignal"))
	## ...
	## Deja sin implementar o ajusta según lo que hayas connectado manualmente.
	#pass
#
#func _hide_tutorial2_ui():
	## Oculta Label, etc. 
	#if speech_bubble_ref:
		#speech_bubble_ref.get_ref().visible = false
	#if tutorial_text_ref:
		#tutorial_text_ref.get_ref().text = ""
	#if continue_button_ref:
		#continue_button_ref.get_ref().visible = false
#
#func _show_text_on_label(text: String):
	## Asume que tutorial_text_ref es un Label/ RichTextLabel
	#if tutorial_text_ref:
		#tutorial_text_ref.get_ref().text = text
#
#
##
## EJEMPLO: Lógica de Step 2 y Step 3, si deseas mas pasos
##
#func start_step_2():
	#print("Tutorial2 => Step 2. Mensaje de confirmación de tortillas, etc.")
	## ...
#func start_step_3():
	#print("Tutorial2 => Step 3. Final o continuar ...")
	## ...
