extends Button

# Referencias a los Paneles de mensaje y etiquetas (labels)
@onready var message_panel = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel")
@onready var message_panel2 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel2")
@onready var message_panel3 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel3")
@onready var message_panel4 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4")
@onready var message_panel5 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5")
@onready var message_panel6 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6")
@onready var message_panel7 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel7")
@onready var message_panel8 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel8")

@onready var message_label = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel/Label")
@onready var message_label2 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel2/Label")
@onready var message_label3 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel3/Label")
@onready var message_label4 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel4/Label")
@onready var message_label5 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/Label")
@onready var message_label6 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/Label")
@onready var message_label7 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel7/Label")
@onready var message_label8 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel8/Label")

@onready var sound_player = get_node("/root/Node2D/CanvasLayer/ButtonPress_Sound")



# Función que será llamada cuando un botón sea presionado
func _on_button_pressed(button_id: int) -> void:
	print("Button pressed with ID: ", button_id)
	match button_id:
		1:
			_show_panel(message_panel, message_label, "Mapas

Expande tu zona de 
ventas desbloqueando
nuevos escenarios

Siguiente Nivel:")
		2:
			_show_panel(message_panel2, message_label2, "Se desbloquea 
			en el nivel 2...")
		3:
			_show_panel(message_panel3, message_label3, "Chihuahua Taco Dog")
		4:
			_show_panel(message_panel4, message_label4, "
			
			
			Tareas
			
						Completa tareas
						 y gana recompensas
						")
		5:
			_show_panel(message_panel5, message_label5, "Ingredientes

Compra los ingredientes necesarios
para preparar tu taquiza")
		6:
			_show_panel(message_panel6, message_label6, "Parrilla

Realiza la preparación de tus
tacos con estos ingredientes")
		7:
			_show_panel(message_panel7, message_label7, "Mejoras

Sube tu negocio al siguiente nivel
desbloqueando nuevas herramientas
que incrementarán tus ganancias ")
		8:
			_show_panel(message_panel8, message_label8, "Rankings

Observa la clasificación de los
mejores jugadores.

Ingresa tu información:
















  Nombre:                Ranking  


  Score:                     
")

# Función para mostrar un panel, actualizar su etiqueta y ocultar los demás
func _show_panel(panel: Control, label: Label, message: String) -> void:
	_hide_all_panels()
	panel.visible = true
	label.text = message

# Función para ocultar todos los paneles
func _hide_all_panels() -> void:
	message_panel.visible = false
	message_panel2.visible = false
	message_panel3.visible = false
	message_panel4.visible = false
	message_panel5.visible = false
	message_panel6.visible = false
	message_panel7.visible = false
	message_panel8.visible = false

# Conexión individual de cada botón (cada botón tiene su propio ID)
func _on_button1_pressed() -> void:
	verify_sound()
	_on_button_pressed(1)

func _on_button2_pressed() -> void:
	verify_sound()
	_on_button_pressed(2)

func _on_button3_pressed() -> void:
	verify_sound()
	_on_button_pressed(3)

func _on_button_4_pressed() -> void:
	verify_sound()
	_on_button_pressed(4)

func _on_button_5_pressed() -> void:
	verify_sound()
	_on_button_pressed(5)

func _on_button_6_pressed() -> void:
	verify_sound()
	_on_button_pressed(6)

func _on_button_7_pressed() -> void:
	verify_sound()
	_on_button_pressed(7)
	
func _on_button_8_pressed() -> void:
	verify_sound()
	_on_button_pressed(8)
	
func verify_sound() -> void:
	if sound_player:
		sound_player.play()

func _on_ComprarLimonesButton_pressed():
	pass # Replace with function body.
