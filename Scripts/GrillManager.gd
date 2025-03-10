extends Node2D

var ingrediente_actual = "tortilla"
var cuadrantes = [[], [], [], []]
var ingredientes = {}

# Contadores de ingredientes
var count_tortilla = 0
var count_carne = 0
var count_verdura = 0
var count_salsa = 0

# Labels
var label_tortilla = null
var label_carne = null
var label_verdura = null
var label_salsa = null

@onready var button_tortilla = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/TortillasContainer/TortillaButton")
@onready var button_meat = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/CarneContainer/MeatButton")
@onready var button_verdura = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/VerduraContainer/VerduraButton")
@onready var button_salsa = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/SalsaContainer/SalsaButton")
@onready var button_add = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/AddButton")
@onready var button_remove = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/RemoveButton")
@onready var label_count = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/IngredientCountLabel")

func _ready():
	obtener_ingredientes()
	obtener_labels()
	reset_parrilla()

	button_tortilla.pressed.connect(_on_select_ingredient.bind("tortilla"))
	button_meat.pressed.connect(_on_select_ingredient.bind("carne"))
	button_verdura.pressed.connect(_on_select_ingredient.bind("verdura"))
	button_salsa.pressed.connect(_on_select_ingredient.bind("salsa"))

	button_add.pressed.connect(_on_add_ingredient)
	button_remove.pressed.connect(_on_remove_ingredient)

#
# -----------------------  FUNCIONES PRINCIPALES  -------------------------
#

func verificar_taco(pedido_cliente: String) -> bool:
	# ✅ Devuelve true si al menos un cuadrante coincide,
	# pero NO lo limpia todavía.
	var idx = obtener_cuadrante_valido(pedido_cliente)
	return (idx != -1)

func limpiar_taco(pedido_cliente: String):
	# ✅ Limpia solo el primer cuadrante que coincide con la receta,
	# y no toca los demás.
	var idx = obtener_cuadrante_valido(pedido_cliente)
	if idx != -1:
		print("🔥 Limpiando cuadrante después de venta:", idx)
		for ingrediente in cuadrantes[idx]:
			if ingredientes.has(ingrediente) and ingredientes[ingrediente][idx] != null:
				ingredientes[ingrediente][idx].visible = false
		cuadrantes[idx].clear()
		update_label()

#
# -----------------------  FUNCIONES DE SOPORTE  -------------------------
#

func obtener_cuadrante_valido(pedido_cliente: String) -> int:
	# ✅ Retorna el índice (0..3) del primer cuadrante válido, o -1 si no hay coincidencia.
	for i in range(4):
		if _es_taco_valido(i, pedido_cliente):
			return i
	return -1

func _es_taco_valido(index: int, pedido_cliente: String) -> bool:
	if cuadrantes[index].size() == 0:
		return false

	var contenido = cuadrantes[index].duplicate()
	contenido.sort()

	var contenido_pedido = []
	match pedido_cliente:
		"Taco-1":
			contenido_pedido = ["carne", "tortilla"]
		"Taco-2":
			contenido_pedido = ["carne", "salsa", "tortilla", "verdura"]
		"Taco-3":
			contenido_pedido = ["tortilla"]

	contenido_pedido.sort()

	return contenido == contenido_pedido

#
# -----------------------  FUNCIONES UI E INGREDIENTES -------------------
#

func _on_select_ingredient(ingrediente):
	ingrediente_actual = ingrediente

func _on_add_ingredient():
	for i in range(4):
		if cuadrantes[i].size() == 0 or cuadrantes[i][-1] != ingrediente_actual:
			if ingrediente_actual == "tortilla" and count_tortilla < 4:
				ingredientes["tortilla"][i].visible = true
				cuadrantes[i].append("tortilla")
				count_tortilla += 1
				break
			elif ingrediente_actual == "carne" and count_carne < count_tortilla:
				ingredientes["carne"][i].visible = true
				cuadrantes[i].append("carne")
				count_carne += 1
				break
			elif ingrediente_actual == "verdura" and count_verdura < count_carne:
				ingredientes["verdura"][i].visible = true
				cuadrantes[i].append("verdura")
				count_verdura += 1
				break
			elif ingrediente_actual == "salsa" and count_salsa < count_verdura:
				ingredientes["salsa"][i].visible = true
				cuadrantes[i].append("salsa")
				count_salsa += 1
				break
	update_label()

func _on_remove_ingredient():
	for i in range(4):
		if cuadrantes[i].size() > 0:
			var ingrediente_a_quitar = cuadrantes[i].pop_back()
			if ingredientes[ingrediente_a_quitar][i] != null:
				ingredientes[ingrediente_a_quitar][i].visible = false

			match ingrediente_a_quitar:
				"tortilla":
					count_tortilla -= 1
				"carne":
					count_carne -= 1
				"verdura":
					count_verdura -= 1
				"salsa":
					count_salsa -= 1
			break
	update_label()

func update_label():
	label_count.text = str(count_tortilla)
	if label_tortilla:
		label_tortilla.text = str(count_tortilla)
	if label_carne:
		label_carne.text = str(count_carne)
	if label_verdura:
		label_verdura.text = str(count_verdura)
	if label_salsa:
		label_salsa.text = str(count_salsa)

#
# ----------------------  FUNCIONES INICIALES  ---------------------------
#

func reset_parrilla():
	for tipo in ingredientes:
		for i in range(4):
			if ingredientes[tipo][i] != null:
				ingredientes[tipo][i].visible = false

	cuadrantes = [[], [], [], []]
	count_tortilla = 0
	count_carne = 0
	count_verdura = 0
	count_salsa = 0
	update_label()

func obtener_labels():
	for node in get_tree().get_nodes_in_group("GrillLabels"):
		match node.name:
			"TortillaAmount": label_tortilla = node
			"CarneAmount": label_carne = node
			"VerduraAmount": label_verdura = node
			"SalsaAmount": label_salsa = node

func obtener_ingredientes():
	for node in get_tree().get_nodes_in_group("IngredientsContainer"):
		var nombre = String(node.name).to_lower()
		var partes = nombre.split("-")
		if partes.size() == 2:
			var tipo = partes[0]
			var indice = int(partes[1]) - 1
			if not ingredientes.has(tipo):
				ingredientes[tipo] = [null, null, null, null]
			ingredientes[tipo][indice] = node


func restart_ready():
	print("🔁 Reiniciando parrilla...")
	reset_parrilla()
