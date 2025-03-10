extends Node2D

var ingrediente_actual = "tortilla"
var cuadrantes = [[], [], [], []] 
var ingredientes = {} 
var parrilla = [] 

var count_tortilla = 0
var count_carne = 0
var count_verdura = 0
var count_salsa = 0

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

# ✅ Obtener etiquetas de la parrilla
func obtener_labels():
	for node in get_tree().get_nodes_in_group("GrillLabels"):
		match node.name:
			"TortillaAmount": label_tortilla = node
			"CarneAmount": label_carne = node
			"VerduraAmount": label_verdura = node
			"SalsaAmount": label_salsa = node

# ✅ Obtener ingredientes desde el grupo
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

# ✅ Reiniciar parrilla
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

# ✅ Seleccionar ingrediente
func _on_select_ingredient(ingrediente):
	ingrediente_actual = ingrediente

# ✅ Añadir ingrediente a la parrilla
func _on_add_ingredient():
	for i in range(4):
		if len(cuadrantes[i]) == 0 or cuadrantes[i][-1] != ingrediente_actual:
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

# ✅ Quitar ingrediente de la parrilla
func _on_remove_ingredient():
	for i in range(4):
		if cuadrantes[i].size() > 0:
			var ingrediente_a_quitar = cuadrantes[i].pop_back()
			if ingredientes[ingrediente_a_quitar][i] != null:
				ingredientes[ingrediente_a_quitar][i].visible = false

			match ingrediente_a_quitar:
				"tortilla": count_tortilla -= 1
				"carne": count_carne -= 1
				"verdura": count_verdura -= 1
				"salsa": count_salsa -= 1
			break

	update_label()

# ✅ Actualizar las etiquetas
func update_label():
	label_count.text = str(count_tortilla)
	if label_tortilla: label_tortilla.text = str(count_tortilla)
	if label_carne: label_carne.text = str(count_carne)
	if label_verdura: label_verdura.text = str(count_verdura)
	if label_salsa: label_salsa.text = str(count_salsa)

# ✅ Verificar si el taco coincide con el pedido
func verificar_taco(pedido_cliente):
	print("🍽 Pedido del cliente:", pedido_cliente)
	print("👉 Estado actual de cuadrantes:", cuadrantes)

	for i in range(4):
		if _es_taco_valido(i, pedido_cliente):
			print("✅ Taco entregado correctamente")
			limpiar_taco(pedido_cliente)
			return true

	print("❌ El taco no coincide con el pedido.")
	return false

# ✅ Limpiar taco después de venta
func limpiar_taco(pedido_cliente):
	for i in range(4):
		if _es_taco_valido(i, pedido_cliente):
			print("🔥 Limpiando cuadrante después de venta:", i)
			for ingrediente in cuadrantes[i]:
				if ingredientes[ingrediente][i] != null:
					ingredientes[ingrediente][i].visible = false

			cuadrantes[i].clear()
			update_label()
			break

# ✅ Verificar si el taco es válido
func _es_taco_valido(index, pedido_cliente):
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

# ✅ Reiniciar parrilla
func restart_ready():
	print("🔁 Reiniciando parrilla...")
	reset_parrilla()
