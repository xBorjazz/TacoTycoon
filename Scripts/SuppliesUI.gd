extends Node2D

# Referencias a los Labels de suministros
@onready var tortillas_label1 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/TortillasSupplies/VBoxContadores0/TortillasLabel")
@onready var tortillas_label2 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/TortillasSupplies/VBoxContadores0/TortillasLabel2")
@onready var tortillas_label3 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/TortillasSupplies/VBoxContadores0/TortillasLabel3")
@onready var carne_label1 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/CarneSupplies/VBoxContadores0/CarneLabel")
@onready var carne_label2 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/CarneSupplies/VBoxContadores0/CarneLabel2")
@onready var carne_label3 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/CarneSupplies/VBoxContadores0/CarneLabel3")
@onready var cebollas_label1 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/CebollasSupplies/VBoxContadores0/CebollasLabel")
@onready var cebollas_label2 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/CebollasSupplies/VBoxContadores0/CebollasLabel2")
@onready var cebollas_label3 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/CebollasSupplies/VBoxContadores0/CebollasLabel3")
@onready var salsa_label1 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/SalsaSupplies/VBoxContadores0/SalsaLabel")
@onready var salsa_label2 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/SalsaSupplies/VBoxContadores0/SalsaLabel2")
@onready var salsa_label3 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/SalsaSupplies/VBoxContadores0/SalsaLabel3")
@onready var verdura_label1 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/VerduraSupplies/VBoxContadores0/VerduraLabel")
@onready var verdura_label2 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/VerduraSupplies/VBoxContadores0/VerduraLabel2")
@onready var verdura_label3 = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/VerduraSupplies/VBoxContadores0/VerduraLabel3")

@onready var buy_cost_label = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/BuyCost")
@onready var player_money_label = get_node("/root/Node2D/CanvasLayer/Gameplay/PlayerMoneyLabel")
@onready var buy_button = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/BuyButton")

@onready var tortillas_total_label = get_node("/root/Node2D/CanvasLayer/Gameplay/Inventario/Tortillas/TortillasTotalLabel")
@onready var carne_total_label = get_node("/root/Node2D/CanvasLayer/Gameplay/Inventario/Carne/CarneTotalLabel")
@onready var verdura_total_label = get_node("/root/Node2D/CanvasLayer/Gameplay/Inventario/Verdura/VerduraTotalLabel")
@onready var cebolla_total_label = get_node("/root/Node2D/CanvasLayer/Gameplay/Inventario/Cebolla/CebollaTotalLabel")
@onready var salsa_total_label = get_node("/root/Node2D/CanvasLayer/Gameplay/Inventario/Salsas/SalsaTotalLabel")

@onready var ingredients_manager = get_node("/root/IngredientsManager")
@onready var gradient_node = get_node("/root/GradientDescent")
@onready var graph_plot = ("/root/Node2D/CanvasLayer/PanelContainer/Panel2/IngredientsManager")

# Función para actualizar todos los Labels
func actualizar_labels() -> void:
	actualizar_label_tortillas("normal")
	actualizar_label_tortillas("medium")
	actualizar_label_tortillas("large")
	
	actualizar_label_carne("normal")
	actualizar_label_carne("medium")
	actualizar_label_carne("large")
	
	actualizar_label_cebollas("normal")
	actualizar_label_cebollas("medium")
	actualizar_label_cebollas("large")
	
	actualizar_label_salsa("normal")
	actualizar_label_salsa("medium")
	actualizar_label_salsa("large")	
	
	actualizar_label_verdura("normal")
	actualizar_label_verdura("medium")
	actualizar_label_verdura("large")

# Función para actualizar solo el Label correspondiente para Tortillas
func actualizar_label_tortillas(categoria: String) -> void:
	match categoria:
		"normal":
			tortillas_label1.text = str(Inventory.tortillas_normal)
		"medium":
			tortillas_label2.text = str(Inventory.tortillas_medium)
		"large":
			tortillas_label3.text = str(Inventory.tortillas_large)

# Función para actualizar solo el Label correspondiente para Azúcar
func actualizar_label_carne(categoria: String) -> void:
	match categoria:
		"normal":
			carne_label1.text = str(Inventory.carne_normal)
		"medium":
			carne_label2.text = str(Inventory.carne_medium)
		"large":
			carne_label3.text = str(Inventory.carne_large)

# Función para actualizar solo el Label correspondiente para Cebollas
func actualizar_label_cebollas(categoria: String) -> void:
	match categoria:
		"normal":
			cebollas_label1.text = str(Inventory.cebollas_normal)
		"medium":
			cebollas_label2.text = str(Inventory.cebollas_medium)
		"large":
			cebollas_label3.text = str(Inventory.cebollas_large)

# Función para actualizar solo el Label correspondiente para Salsa
func actualizar_label_salsa(categoria: String) -> void:
	match categoria:
		"normal":
			salsa_label1.text = str(Inventory.salsa_normal)
		"medium":
			salsa_label2.text = str(Inventory.salsa_medium)
		"large":
			salsa_label3.text = str(Inventory.salsa_large)

# Función para actualizar solo el Label correspondiente para Salsa
func actualizar_label_verdura(categoria: String) -> void:
	match categoria:
		"normal":
			verdura_label1.text = str(Inventory.verdura_normal)
		"medium":
			verdura_label2.text = str(Inventory.verdura_medium)
		"large":
			verdura_label3.text = str(Inventory.verdura_large)

# Función para actualizar el costo acumulado de las compras
func actualizar_inventario_total() -> void:
	#var total_tortillas = Inventory.tortillas_normal + Inventory.tortillas_medium + Inventory.tortillas_large
	tortillas_total_label.text = str(Inventory.tortillas_total)
	carne_total_label.text = str(Inventory.carne_total)
	verdura_total_label.text = str(Inventory.verdura_total)
	cebolla_total_label.text = str(Inventory.cebolla_total)
	salsa_total_label.text = str(Inventory.salsa_total)
	
	Inventory.tacos_vendidos+= 1

# Función para actualizar el costo acumulado de las compras
func actualizar_buy_cost() -> void:
	buy_cost_label.text = str(Inventory.buy_cost)

func actualizar_labels_dinero() -> void:
	player_money_label.text = str(Inventory.player_money)  # Actualiza el label que muestra el dinero del jugador
	buy_cost_label.text = str(Inventory.buy_cost)  # Actualiza el label de buy_cost

func resetear_labels_recursos() -> void:
	# Resetear las variables de inventario a 0
	Inventory.tortillas_normal = 0
	Inventory.tortillas_medium = 0
	Inventory.tortillas_large = 0
	
	Inventory.carne_normal = 0
	Inventory.carne_medium = 0
	Inventory.carne_large = 0
	
	Inventory.cebollas_normal = 0
	Inventory.cebollas_medium = 0
	Inventory.cebollas_large = 0
	
	Inventory.salsa_normal = 0
	Inventory.salsa_medium = 0
	Inventory.salsa_large = 0	
	
	Inventory.verdura_normal = 0
	Inventory.verdura_medium = 0
	Inventory.verdura_large = 0
	# Actualizar los labels con los nuevos valores
	actualizar_labels()

# Inicializa la interfaz con las cantidades iniciales
func _ready() -> void:
	actualizar_labels()
	actualizar_labels_dinero()
	actualizar_inventario_total()

	
	# Datos de ejemplo (Carne, Salsa, Tortilla) y ganancias reales
	var data = [
		[1, 2, 1],
		[2, 1, 2],
		[3, 2, 1],
		[4, 3, 2]
	]
	var real_ganancias = [10, 15, 20, 25]

	# Entrenamos el modelo
	GradientDescent.train(data, real_ganancias, 1000)

	# Obtenemos la lista de pérdidas y la enviamos al script de la gráfica
	GraphPlot.set_data(gradient_node.loss_values)

	# Ejemplo de predicción usando los ingredientes actuales del jugador
	var ing = ingredients_manager.get_ingredients()
	var ganancia_predicha = gradient_node.predict(ing[0], ing[1], ing[2])
	print("Ganancia predicha con ingredientes actuales:", ganancia_predicha) 
	
func restart_ready():
	print("Reejecutando _ready() con call_deferred()")
	call_deferred("_ready")  # Esto ejecutará _ready() en el siguiente frame
