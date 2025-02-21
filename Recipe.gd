extends Node

# Variables para guardar la receta seleccionada
var tortillas_por_taco = 1
var carne_por_taco = 1
var cebolla_por_taco = 1
var verdura_por_taco = 1
var salsa_por_taco = 1

signal sale_made

# Referencias a los nodos de la interfaz para seleccionar la cantidad de cada ingrediente
@onready var tortillas_slider = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/TortillasSlider")
@onready var carne_slider = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/CarneSlider")
@onready var cebolla_slider = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/CebollasSlider")
@onready var verdura_slider = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/VerduraSlider")
@onready var salsa_slider = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/SalsaSlider")

# Referencias a los labels de la cantidad actual por taco
@onready var tortillas_label = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/TortillasContainer/Button6/TortillaAmount")
@onready var carne_label = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/CarneContainer/Button6/CarneAmount")
@onready var cebolla_label = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/CebollaContainer/Button6/CebollasAmount")
@onready var verdura_label = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/VerduraContainer/Button6/VerduraAmount")
@onready var salsa_label = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/SalsaContainer/Button6/SalsaAmount")

# Variables para las categorías (nada, poco, mediano, mucho)
const CATEGORIAS = {0: "nada", 1: "normal", 2: "medium", 3: "large"}

# Actualiza los valores de la receta con base en los sliders
func _ready():
	# Conectamos los sliders a las funciones para actualizar las cantidades
	tortillas_slider.connect("value_changed", Callable(self, "_on_tortillas_slider_value_changed"))
	carne_slider.connect("value_changed", Callable(self, "_on_carne_slider_value_changed"))
	cebolla_slider.connect("value_changed", Callable(self, "_on_cebolla_slider_value_changed"))
	verdura_slider.connect("value_changed", Callable(self, "_on_verdura_slider_value_changed"))
	salsa_slider.connect("value_changed", Callable(self, "_on_salsa_slider_value_changed"))

	# Inicializar con valores por defecto
	_actualizar_labels()
	
	print_tree_pretty()

# Funciones para manejar cambios en los sliders
func _on_tortillas_slider_value_changed(value):
	tortillas_por_taco = int(value)
	_actualizar_labels()

func _on_carne_slider_value_changed(value):
	carne_por_taco = int(value)
	_actualizar_labels()

func _on_cebolla_slider_value_changed(value):
	cebolla_por_taco = int(value)
	_actualizar_labels()

func _on_verdura_slider_value_changed(value):
	verdura_por_taco = int(value)
	_actualizar_labels()

func _on_salsa_slider_value_changed(value):
	salsa_por_taco = int(value)
	_actualizar_labels()

# Función para actualizar los labels que muestran la cantidad de cada ingrediente por taco
func _actualizar_labels():
	tortillas_label.text = str(tortillas_por_taco)
	carne_label.text = str(carne_por_taco)
	cebolla_label.text = str(cebolla_por_taco)
	verdura_label.text = str(verdura_por_taco)
	salsa_label.text = str(salsa_por_taco)

func aplicar_receta():
	var total_tortillas = tortillas_por_taco
	var total_carne = carne_por_taco
	var total_cebolla = cebolla_por_taco
	var total_verdura = verdura_por_taco
	var total_salsa = salsa_por_taco

	# Llamar a la nueva función para restar los totales
	Inventory.restar_totales(total_tortillas, total_carne, total_cebolla, total_verdura, total_salsa)

	# Actualizar los labels de suministros totales en la UI
	SuppliesUi.actualizar_labels()
	
	emit_signal("sale_made")


# Función auxiliar para determinar la categoría en función del valor del slider
func _categoria_por_valor(valor):
	match valor:
		0:
			return "nada"
		1:
			return "normal"
		2:
			return "medium"
		3:
			return "large"
		_:
			return "normal"  # Valor por defecto
			
func restart_ready():
	print("Reejecutando _ready() con call_deferred()")
	call_deferred("_ready")  # Esto ejecutará _ready() en el siguiente frame
