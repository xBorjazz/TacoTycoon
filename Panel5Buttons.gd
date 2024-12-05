extends TextureButton

# Referencias a los Paneles de mensaje y etiquetas (labels)
@onready var TortillasSupplies = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/TortillasSupplies")
@onready var CarneSupplies = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/CarneSupplies")
@onready var CebollasSupplies = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/CebollasSupplies")
@onready var SalsaSupplies = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/SalsaSupplies")
@onready var VerduraSupplies = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/VerduraSupplies")

@onready var tortillas_button = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/HBoxContainer/TortillasButton")
@onready var carne_button = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/HBoxContainer/CarneButton")
@onready var verdura_button = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/HBoxContainer/VerduraButton")
@onready var salsa_button = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/HBoxContainer/SalsaButton")

@onready var sound_player = get_node("/root/Node2D/CanvasLayer/TextureButtonPress_Sound")

func _ready():
	# Asegurarse de que todos los Paneles estén ocultos inicialmente
	pass

# Función que será llamada cuando un botón sea presionado
func _on_button_pressed(button_id: int) -> void:
	match button_id:
		1:
			_show_panel(TortillasSupplies)
		2:
			_show_panel(CarneSupplies)
		3:
			_show_panel(CebollasSupplies)
		4:
			_show_panel(SalsaSupplies)
		5:
			_show_panel(VerduraSupplies)

# Función para mostrar un panel, actualizar su etiqueta y ocultar los demás
func _show_panel(panel: Control) -> void:
	_hide_all_panels()
	panel.visible = true
	#label.text = message

# Función para ocultar todos los paneles
func _hide_all_panels() -> void:
	TortillasSupplies.visible = false
	CarneSupplies.visible = false
	VerduraSupplies.visible = false
	CebollasSupplies.visible = false
	SalsaSupplies.visible = false
	
# Conexión individual de cada botón (cada botón tiene su propio ID)
func _on_tortillas_button_pressed() -> void:
	verify_sound()
	_on_button_pressed(1)

func _on_carne_button_pressed() -> void:
	verify_sound()
	_on_button_pressed(2)

func _on_cebollas_button_pressed() -> void:
	verify_sound()
	_on_button_pressed(3)

func _on_salsa_button_pressed() -> void:
	verify_sound()
	_on_button_pressed(4)

func _on_verdura_button_pressed() -> void:
	verify_sound()
	_on_button_pressed(5)

func verify_sound() -> void:
	if sound_player:
		sound_player.play()

func _on_pressed():
	pass # Replace with function body.
