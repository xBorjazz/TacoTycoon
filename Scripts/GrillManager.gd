extends Node2D

# Variables de estado
var ingrediente_actual = "tortilla"  # Ingrediente actualmente seleccionado
var cuadrantes = [0, 0, 0, 0]  # Representa qué hay en cada cuadrante (0 = vacío)
var ingredientes = {}  # Diccionario para acceder a los nodos mediante el grupo

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
	reset_parrilla()
	
	# Conectar botones de selección (usando "pressed" en vez de "toggled")
	button_tortilla.pressed.connect(_on_select_ingredient.bind("tortilla"))
	button_meat.pressed.connect(_on_select_ingredient.bind("carne"))
	button_verdura.pressed.connect(_on_select_ingredient.bind("verdura"))
	button_salsa.pressed.connect(_on_select_ingredient.bind("salsa"))

	# Conectar botones de agregar y quitar ingredientes
	button_add.pressed.connect(_on_add_ingredient)
	button_remove.pressed.connect(_on_remove_ingredient)

# ✅ Obtiene todos los nodos de ingredientes usando el grupo "IngredientsContainer"
func obtener_ingredientes():
	for node in get_tree().get_nodes_in_group("IngredientsContainer"):
		var nombre = String(node.name).to_lower()
		var partes = nombre.split("-")

		if partes.size() == 2:
			var tipo = partes[0]  # "tortilla", "carne", etc.
			var indice = int(partes[1]) - 1  # Convierte número del nodo

			if not ingredientes.has(tipo):
				ingredientes[tipo] = [null, null, null, null]  # Inicializa los 4 cuadrantes

			ingredientes[tipo][indice] = node
			print("✅ Registrado:", tipo, "en cuadrante", indice)
		else:
			print("⚠ Error en nombre de nodo:", nombre)  # Depuración

# ✅ Reinicia la parrilla ocultando todos los ingredientes
func reset_parrilla():
	for tipo in ingredientes:
		for i in range(4):
			if ingredientes[tipo][i] != null:  # Verifica que el nodo exista
				ingredientes[tipo][i].visible = false
	cuadrantes = [0, 0, 0, 0]  # Reinicia los cuadrantes
	update_label()

# ✅ Función de selección de ingredientes (ahora con "pressed")
func _on_select_ingredient(ingrediente):
	ingrediente_actual = ingrediente
	print("🍽 Ingrediente seleccionado:", ingrediente_actual)

func _on_add_ingredient():
	var index = -1  # Índice del cuadrante donde agregaremos el ingrediente

	if ingrediente_actual == "tortilla":
		index = cuadrantes.find(0)  # Buscar cuadrante vacío
	elif ingrediente_actual == "carne":
		index = cuadrantes.find("tortilla")  # Buscar cuadrante donde ya hay tortilla
	elif ingrediente_actual == "verdura":
		index = cuadrantes.find("carne")  # Buscar cuadrante donde ya hay carne
	elif ingrediente_actual == "salsa":
		index = cuadrantes.find("verdura")  # Buscar cuadrante donde ya hay verdura

	# Si encontramos un cuadrante válido, agregamos el ingrediente
	if index != -1 and ingrediente_actual in ingredientes:
		if ingredientes[ingrediente_actual][index] != null:
			ingredientes[ingrediente_actual][index].visible = true
			cuadrantes[index] = ingrediente_actual  # Actualizamos el estado del cuadrante
			print("✅", ingrediente_actual.capitalize(), "agregado en cuadrante", index)
		else:
			print("⚠ Error: Nodo de", ingrediente_actual, "en cuadrante", index, "es null")
	else:
		print("⚠ No se pudo agregar", ingrediente_actual, "en ningún cuadrante válido.")

	verificar_taco_completo()
	update_label()



# ✅ Remover último ingrediente agregado (Corrección del error)
func _on_remove_ingredient():
	for i in range(3, -1, -1):  # Recorre en orden inverso
		if typeof(cuadrantes[i]) == TYPE_STRING and cuadrantes[i] != "0":  # Validación correcta
			if ingredientes.has(cuadrantes[i]) and ingredientes[cuadrantes[i]][i] != null:
				ingredientes[cuadrantes[i]][i].visible = false
			
			match cuadrantes[i]:
				"salsa":
					cuadrantes[i] = "verdura"
				"verdura":
					cuadrantes[i] = "carne"
				"carne":
					cuadrantes[i] = "tortilla"
				"tortilla":
					cuadrantes[i] = 0  # Se vuelve un cuadrante vacío
			break  # Sale del bucle al remover el último ingrediente agregado
	
	update_label()

# ✅ Actualiza el label de cantidad de tortillas en la parrilla
func update_label():
	label_count.text = str(cuadrantes.count("tortilla"))

func verificar_taco_completo():
	for i in range(4):
		if typeof(cuadrantes[i]) == TYPE_STRING and cuadrantes[i] == "salsa":
			print("🌮 Taco en cuadrante %d está completo y listo para servir" % (i + 1))


			
func restart_ready():
	pass
