extends Node2D

var user_id: String = ""

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

# ✅ Método para actualizar las etiquetas del inventario
func update_labels():
	tortillas_total_label.text = str(Inventory.tortillas_total)
	carne_total_label.text = str(Inventory.carne_total)
	verdura_total_label.text = str(Inventory.verdura_total)
	salsa_total_label.text = str(Inventory.salsa_total)

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
	
	#Inventory.tacos_vendidos+= 1

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

# Esperar a que Supabase.database esté listo
func _guardar_progreso_cuando_este_listo(user_id) -> void:
	var data := {
		"id": user_id,
		"dinero_actual": Inventory.player_money,
		"dia_actual": Inventory.dia_actual,
		"ventas_totales": Inventory.tacos_vendidos,
		"perdidas_totales": Inventory.ventas_fallidas,
		"promedio": Inventory.promedio,
		"buenas_resenas": Inventory.total_reseñas,
		"tutorial_completado": true,
		"tortillas_total": Inventory.tortillas_total,
		"carne_total": Inventory.carne_total,
		"verdura_total": Inventory.verdura_total,
		"salsa_total": Inventory.salsa_total,
		"taco_coins": Inventory.taco_coins,
		"puntaje_acumulado": Inventory.puntaje_acumulado,
		"nivel_actual": LevelManager.current_level
	}

	var query := SupabaseQuery.new()
	query.from("progreso_jugador").insert([data])

	# Escucha la respuesta
	Supabase.database.connect("selected", Callable(self, "_on_progreso_guardado"))
	Supabase.database.query(query)

func guardar_progreso_realtime():
	if Supabase.database == null:
		print("❌ Supabase.database no está listo.")
		return

	var data := {
		"id": user_id,
		"dinero_actual": Inventory.player_money,
		"dia_actual": Inventory.dia_actual,
		"ventas_totales": Inventory.tacos_vendidos,
		"perdidas_totales": Inventory.ventas_fallidas,
		"promedio": Inventory.promedio,
		"buenas_resenas": Inventory.total_reseñas,
		"tutorial_completado": true,
		"tortillas_total": Inventory.tortillas_total,
		"carne_total": Inventory.carne_total,
		"verdura_total": Inventory.verdura_total,
		"salsa_total": Inventory.salsa_total,
		"taco_coins": Inventory.taco_coins,
		"puntaje_acumulado": Inventory.puntaje_acumulado,
		"nivel_actual": LevelManager.current_level
	}

	var query := SupabaseQuery.new()
	query.from("progreso_jugador").update(data).eq("id", user_id)

	Supabase.database.query(query)


# Guardar en Supabase
func guardar_progreso_remoto(user_id: String) -> void:
	var data := {
		"id": user_id,
		"dinero_actual": Inventory.player_money,
		"dia_actual": Inventory.dia_actual,
		"ventas_totales": Inventory.tacos_vendidos,
		"perdidas_totales": Inventory.ventas_fallidas,
		"promedio": Inventory.promedio,
		"buenas_resenas": Inventory.total_reseñas,
		"tutorial_completado": true,
		"tortillas_total": Inventory.tortillas_total,
		"carne_total": Inventory.carne_total,
		"verdura_total": Inventory.verdura_total,
		"salsa_total": Inventory.salsa_total,
		"taco_coins": Inventory.taco_coins,
		"puntaje_acumulado": Inventory.puntaje_acumulado,
		"nivel_actual": LevelManager.current_level
	}

	var query := SupabaseQuery.new()
	query.from("progreso_jugador").insert([data])

	# Escucha la respuesta
	Supabase.database.connect("selected", Callable(self, "_on_progreso_guardado"))
	Supabase.database.query(query)

# Respuesta
func _on_progreso_guardado(response):
	if response.has("error") and response.error != null:
		print("❌ Error al guardar progreso:", response.error)
	else:
		print("✅ Progreso guardado correctamente en Supabase para ID:", user_id)

func generar_uuid() -> String:
	var hex = "0123456789abcdef"
	var uuid = ""
	var sections = [8, 4, 4, 4, 12]
	
	for section in sections:
		for i in range(section):
			uuid += hex[randi() % hex.length()]
		if section != 12:
			uuid += "-"
	
	return uuid


func enviar_progreso_realtime():
	if Supabase.realtime == null:
		print("⚠️ Supabase Realtime no está listo.")
		return

	var payload := {
		"event": "UPDATE",
		"table": "progreso_jugador",
		"schema": "public",
		"data": {
			"id": user_id,
			"dinero_actual": Inventory.player_money,
			"dia_actual": Inventory.dia_actual,
			"ventas_totales": Inventory.tacos_vendidos,
			"perdidas_totales": Inventory.ventas_fallidas,
			"promedio": Inventory.promedio,
			"buenas_resenas": Inventory.total_reseñas,
			"tutorial_completado": true,
			"tortillas_total": Inventory.tortillas_total,
			"carne_total": Inventory.carne_total,
			"verdura_total": Inventory.verdura_total,
			"salsa_total": Inventory.salsa_total,
			"taco_coins": Inventory.taco_coins,
			"puntaje_acumulado": Inventory.puntaje_acumulado,
			"nivel_actual": LevelManager.current_level
		}
	}

	Supabase.realtime.send(payload)

func _ready() -> void:
	randomize()
	#user_id = "9736ec65-08db-4b76-ba45-927069ff9de4"
	#print("🆔 ID generado para testeo:", user_id)
	#user_id = generar_uuid()
	#print("🆔 ID generado para testeo:", user_id)

	#call_deferred("_guardar_progreso_cuando_este_listo")

	# También puedes cargar el progreso local aquí como ya haces
	var progreso := GameProgress.cargar()
	if progreso != null:
		Inventory.player_money = progreso.dinero_actual
		Inventory.tacos_vendidos = progreso.ventas_totales
		Inventory.ventas_fallidas = progreso.perdidas_totales
		Inventory.promedio = progreso.promedio
		Inventory.total_reseñas = progreso.buenas_resenas
		Inventory.dia_actual = progreso.dia_actual
		Inventory.tortillas_total = progreso.tortillas_total
		Inventory.carne_total = progreso.carne_total
		Inventory.verdura_total = progreso.verdura_total
		Inventory.salsa_total = progreso.salsa_total
		Inventory.taco_coins = progreso.taco_coins
		print("📂 Progreso cargado correctamente.")
	else:
		print("⚠️ No se encontró archivo de progreso.")

	actualizar_labels()
	actualizar_labels_dinero()
	actualizar_inventario_total()
	
func restart_ready():
	print("Reejecutando _ready() con call_deferred()")
	call_deferred("_ready")  # Esto ejecutará _ready() en el siguiente frame
