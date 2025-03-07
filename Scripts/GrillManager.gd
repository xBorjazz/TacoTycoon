extends Node2D

# Variables de estado
var ingrediente_actual = "tortilla"  # Ingrediente actualmente seleccionado
var cuadrantes = [0, 0, 0, 0]  # Representa qué hay en cada cuadrante (0 = vacío)
var ingredientes = {}  # Diccionario para acceder a los nodos mediante el grupo

# Contadores de ingredientes en la parrilla
var count_tortilla = 0
var count_carne = 0
var count_verdura = 0
var count_salsa = 0

# Labels de cantidad en la parrilla
var label_tortilla = null
var label_carne = null
var label_verdura = null
var label_salsa = null

# Botones UI
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
	
	# Conectar botones de selección
	button_tortilla.pressed.connect(_on_select_ingredient.bind("tortilla"))
	button_meat.pressed.connect(_on_select_ingredient.bind("carne"))
	button_verdura.pressed.connect(_on_select_ingredient.bind("verdura"))
	button_salsa.pressed.connect(_on_select_ingredient.bind("salsa"))

	# Conectar botones de agregar y quitar ingredientes
	button_add.pressed.connect(_on_add_ingredient)
	button_remove.pressed.connect(_on_remove_ingredient)

# ✅ Obtiene referencias a los labels de cantidad desde el grupo "GrillLabels"
func obtener_labels():
	for node in get_tree().get_nodes_in_group("GrillLabels"):
		match node.name:
			"TortillaAmount": label_tortilla = node
			"CarneAmount": label_carne = node
			"VerduraAmount": label_verdura = node
			"SalsaAmount": label_salsa = node

# ✅ Obtiene todos los nodos de ingredientes usando el grupo "IngredientsContainer"
func obtener_ingredientes():
	for node in get_tree().get_nodes_in_group("IngredientsContainer"):
		var nombre = String(node.name).to_lower()
		var partes = nombre.split("-")

		if partes.size() == 2:
			var tipo = partes[0]  # "tortilla", "carne", etc.
			var indice = int(partes[1]) - 1  # Convertimos a índice base 0

			if not ingredientes.has(tipo):
				ingredientes[tipo] = [null, null, null, null]  # Inicializa los 4 cuadrantes

			ingredientes[tipo][indice] = node

# ✅ Reinicia la parrilla ocultando todos los ingredientes
func reset_parrilla():
	for tipo in ingredientes:
		for i in range(4):
			if ingredientes[tipo][i] != null:
				ingredientes[tipo][i].visible = false
	cuadrantes = [0, 0, 0, 0]
	count_tortilla = 0
	count_carne = 0
	count_verdura = 0
	count_salsa = 0
	update_label()

# ✅ Función de selección de ingredientes
func _on_select_ingredient(ingrediente):
	ingrediente_actual = ingrediente

# Almacena el nivel de Z actual, siempre empezamos en 1 porque la tortilla es 0
var current_z_index = 1

# ✅ Agregar ingrediente con validación de tortilla
func _on_add_ingredient():
	if ingrediente_actual == "tortilla" and count_tortilla < 4:
		ingredientes["tortilla"][count_tortilla].visible = true
		ingredientes["tortilla"][count_tortilla].z_index = 0  # Siempre la tortilla es la base
		count_tortilla += 1
	elif ingrediente_actual == "carne" and count_carne < count_tortilla:
		# ✅ Verificamos que haya tortilla en este cuadrante antes de agregar carne
		if ingredientes["tortilla"][count_carne].visible:
			ingredientes["carne"][count_carne].visible = true
			ingredientes["carne"][count_carne].z_index = current_z_index
			count_carne += 1
		else:
			print("⚠ No puedes agregar carne sin una tortilla debajo.")
	elif ingrediente_actual == "verdura" and count_verdura < count_carne:
		# ✅ Verificamos que haya tortilla en este cuadrante antes de agregar verdura
		if ingredientes["tortilla"][count_verdura].visible:
			ingredientes["verdura"][count_verdura].visible = true
			ingredientes["verdura"][count_verdura].z_index = current_z_index
			count_verdura += 1
		else:
			print("⚠ No puedes agregar verdura sin una tortilla debajo.")
	elif ingrediente_actual == "salsa" and count_salsa < count_verdura:
		# ✅ Verificamos que haya tortilla en este cuadrante antes de agregar salsa
		if ingredientes["tortilla"][count_salsa].visible:
			ingredientes["salsa"][count_salsa].visible = true
			ingredientes["salsa"][count_salsa].z_index = current_z_index
			count_salsa += 1
		else:
			print("⚠ No puedes agregar salsa sin una tortilla debajo.")

	# Aumentamos `z_index` para que el siguiente ingrediente esté encima
	current_z_index += 1
	update_label()


# ✅ Modificado para reducir `z_index` al eliminar ingredientes
func _on_remove_ingredient():
	if ingrediente_actual == "salsa" and count_salsa > 0:
		count_salsa -= 1
		ingredientes["salsa"][count_salsa].visible = false
	elif ingrediente_actual == "verdura" and count_verdura > 0:
		count_verdura -= 1
		ingredientes["verdura"][count_verdura].visible = false
	elif ingrediente_actual == "carne" and count_carne > 0:
		count_carne -= 1
		ingredientes["carne"][count_carne].visible = false
	elif ingrediente_actual == "tortilla" and count_tortilla > 0:
		count_tortilla -= 1
		ingredientes["tortilla"][count_tortilla].visible = false

		# Si eliminamos la tortilla, eliminamos también los ingredientes en ese taco
		if count_carne > count_tortilla:
			count_carne -= 1
			ingredientes["carne"][count_carne].visible = false
		if count_verdura > count_carne:
			count_verdura -= 1
			ingredientes["verdura"][count_verdura].visible = false
		if count_salsa > count_verdura:
			count_salsa -= 1
			ingredientes["salsa"][count_salsa].visible = false

	# Reducimos `z_index` cuando se elimina un ingrediente
	if current_z_index > 1:
		current_z_index -= 1

	update_label()


# ✅ Actualiza los labels de cantidad en la parrilla y los botones
func update_label():
	label_count.text = str(count_tortilla)

	# Si los labels existen, los actualizamos
	if label_tortilla: label_tortilla.text = str(count_tortilla)
	if label_carne: label_carne.text = str(count_carne)
	if label_verdura: label_verdura.text = str(count_verdura)
	if label_salsa: label_salsa.text = str(count_salsa)


# ✅ Verifica si un taco está completo
func verificar_taco_completo():
	for i in range(4):
		if typeof(cuadrantes[i]) == TYPE_STRING and cuadrantes[i] == "salsa":
			print("🌮 Taco en cuadrante %d está completo y listo para servir" % (i + 1))
		
func restart_ready():
	pass
