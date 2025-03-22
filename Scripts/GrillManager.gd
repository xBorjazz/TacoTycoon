extends Node2D


signal sale_made
var ingrediente_actual = "tortilla"
var cuadrantes = [[], [], [], []]
var ingredientes = {}

# Contadores de ingredientes totales (en toda la parrilla)
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

	# Conexión de botones
	button_tortilla.pressed.connect(_on_select_ingredient.bind("tortilla"))
	button_meat.pressed.connect(_on_select_ingredient.bind("carne"))
	button_verdura.pressed.connect(_on_select_ingredient.bind("verdura"))
	button_salsa.pressed.connect(_on_select_ingredient.bind("salsa"))

	button_add.pressed.connect(_on_add_ingredient)
	button_remove.pressed.connect(_on_remove_ingredient)

#
# ------------------ FUNCIONES PRINCIPALES ------------------
#

func verificar_taco(pedido_cliente: String) -> bool:
	var idx = _obtener_cuadrante_valido(pedido_cliente)
	return (idx != -1)

func limpiar_taco(pedido_cliente: String):
	var idx = _obtener_cuadrante_valido(pedido_cliente)
	if idx != -1:
		print("🔥 Limpiando cuadrante", idx, "después de venta.")
		for ingrediente in cuadrantes[idx]:
			if ingredientes.has(ingrediente) and ingredientes[ingrediente][idx] != null:
				ingredientes[ingrediente][idx].visible = false
		cuadrantes[idx].clear()
		# ✅ Incrementar el contador de tacos vendidos en Inventory
		Inventory.tacos_vendidos += 1
		Inventory.tacos_vendidos_mision += 1
		GlobalProgressBar.update_progress(25) # 🔥 Actualiza la barra basado en el progreso
		print("🌮 Taco vendido! Total tacos vendidos:", Inventory.tacos_vendidos)
		
		# ✅ Sumar dinero al jugador y a la misión
		Inventory.dinero_ganado_mision += Inventory.costo_taco
		Inventory.player_money += Inventory.costo_taco
		
		# ✅ Sumar propinas (opcional)
		if randi() % 3 == 0:
			Inventory.propinas_recibidas += 1
		
		# ✅ Revisar si la misión está completa
		Inventory.emit_signal("mision_actualizada")
		verificar_misiones()
		
		update_label()
		# ✅ Emitir la señal para actualizar la gráfica
		sale_made.emit()
		_print_cuadrantes_state()  # Opcional: imprimir luego de limpiar

func verificar_misiones():
	# 🔥 Si completó la misión de tacos vendidos
	if Inventory.tacos_vendidos_mision >= Inventory.TACOS_OBJETIVO:
		completar_mision("tacos")

	# 🔥 Si completó la misión de dinero ganado
	if Inventory.dinero_ganado_mision >= Inventory.DINERO_OBJETIVO:
		completar_mision("dinero")

	# 🔥 Si completó la misión de reseñas
	if Inventory.buenas_resenas >= Inventory.RESENAS_OBJETIVO:
		completar_mision("reseñas")

	# 🔥 Si completó la misión de propinas
	if Inventory.propinas_recibidas >= Inventory.PROPINAS_OBJETIVO:
		completar_mision("propinas")

func completar_mision(tipo):
	match tipo:
		"tacos":
			print("✅ ¡Misión de tacos completada!")
			Inventory.taco_coins += 5
			Inventory.tacos_vendidos_mision = 0
		
		"dinero":
			print("✅ ¡Misión de dinero completada!")
			Inventory.taco_coins += 10
			Inventory.dinero_ganado_mision = 0
		
		"reseñas":
			print("✅ ¡Misión de reseñas completada!")
			Inventory.taco_coins += 3
			Inventory.buenas_resenas = 0
		
		"propinas":
			print("✅ ¡Misión de propinas completada!")
			Inventory.taco_coins += 2
			Inventory.propinas_recibidas = 0

	# ✅ Actualizar la UI después de completar la misión
	Inventory.emit_signal("mision_actualizada")
#
# ------------------ FUNCIONES DE SOPORTE -------------------
#

# ✅ Devuelve el índice del primer cuadrante que coincida con la receta, o -1 si ninguno coincide
func _obtener_cuadrante_valido(pedido_cliente: String) -> int:
	for i in range(4):
		if _es_taco_valido(i, pedido_cliente):
			return i
	return -1

# ✅ Devuelve si el cuadrante "index" coincide con la receta "pedido_cliente"
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
			contenido_pedido = ["tortilla", "verdura"]

	contenido_pedido.sort()

	return contenido == contenido_pedido

# ✅ Imprime el contenido de cada cuadrante (para debug)
func _print_cuadrantes_state():
	print("----- Estado actual de 'cuadrantes' -----")
	for i in range(4):
		print("  Cuadrante", i+1, ":", cuadrantes[i])

#
# ------------------ FUNCIONES DE UI / INGREDIENTES --------------
#

func _on_select_ingredient(ingrediente):
	ingrediente_actual = ingrediente
	
# ---------------------------------------
# Función para recalcular los contadores globales
# ---------------------------------------
func recalc_counts():
	count_tortilla = 0
	count_carne = 0
	count_verdura = 0
	count_salsa = 0
	for i in range(4):
		for ing in cuadrantes[i]:
			match ing:
				"tortilla":
					count_tortilla += 1
				"carne":
					count_carne += 1
				"verdura":
					count_verdura += 1
				"salsa":
					count_salsa += 1

# ---------------------------------------
# Actualizar el label inferior y los contadores
# ---------------------------------------
func update_label():
	recalc_counts()
	# Label de tacos en parrilla: se cuenta el número de cuadrantes que tienen al menos un ingrediente.
	var tacos_en_parrilla = 0
	for i in range(4):
		if cuadrantes[i].size() > 0:
			tacos_en_parrilla += 1
	label_count.text = str(tacos_en_parrilla)
	
	if label_tortilla:
		label_tortilla.text = str(count_tortilla)
	if label_carne:
		label_carne.text = str(count_carne)
	if label_verdura:
		label_verdura.text = str(count_verdura)
	if label_salsa:
		label_salsa.text = str(count_salsa)

	#SuppliesUi.update_labels()

# ---------------------------------------
# Agregar ingrediente: se recorre de 0 a 3 y se agrega en el primer cuadrante apto.
# Para "tortilla" solo se agrega si aún no hay tortilla en ese cuadrante.
# Para "carne", "verdura" y "salsa" se requiere que ya exista una tortilla en ese cuadrante.
# Se respeta el límite global de 4 unidades para cada ingrediente.
# ---------------------------------------
#
func _on_add_ingredient():
	print("➕ Agregando ingrediente:", ingrediente_actual)
	
	# 1) Verificamos que haya ingredientes disponibles en el inventario
	match ingrediente_actual:
		"tortilla":
			if count_tortilla >= 4 or Inventory.tortillas_total <= 0:
				print("⚠️ No hay suficientes tortillas en el inventario.")
				return
		"carne":
			if count_carne >= 4 or Inventory.carne_total <= 0:
				print("⚠️ No hay suficiente carne en el inventario.")
				return
		"verdura":
			if count_verdura >= 4 or Inventory.verdura_total <= 0:
				print("⚠️ No hay suficiente verdura en el inventario.")
				return
		"salsa":
			if count_salsa >= 4 or Inventory.salsa_total <= 0:
				print("⚠️ No hay suficiente salsa en el inventario.")
				return

	# 2) Recorremos cuadrantes 1..4 (índices 0..3) en orden
	for i in range(4):
		# 🔸 Si es tortilla, solo añadir si no hay tortilla en el cuadrante
		if ingrediente_actual == "tortilla":
			if "tortilla" not in cuadrantes[i]:
				if ingredientes["tortilla"][i] != null:
					ingredientes["tortilla"][i].visible = true
					cuadrantes[i].append("tortilla")
					count_tortilla += 1
					Inventory.tortillas_total -= 1
					print("✅ Tortilla añadida en el cuadrante", i + 1)
					break

		else:
			# 🔸 Si ya hay tortilla en el cuadrante
			if "tortilla" in cuadrantes[i]:
				# ❌ NO permitir carne encima de cebolla
				if ingrediente_actual == "carne" and "verdura" in cuadrantes[i]:
					print("❌ No puedes poner carne encima de un taco que ya tiene cebolla.")
					continue

				# ✅ Permitir cebolla encima de tortilla o carne
				if ingrediente_actual == "verdura" and "carne" not in cuadrantes[i]:
					if ingrediente_actual not in cuadrantes[i]:
						if ingredientes[ingrediente_actual][i] != null:
							ingredientes[ingrediente_actual][i].visible = true
							cuadrantes[i].append(ingrediente_actual)
							count_verdura += 1
							Inventory.verdura_total -= 1
							print("✅ Verdura añadida en el cuadrante", i + 1)
							break

				# ✅ Si el ingrediente aún no está en el cuadrante, agregarlo (si es válido)
				if ingrediente_actual not in cuadrantes[i]:
					# 🔸 **Restricción para SALSA**
					if ingrediente_actual == "salsa":
						if not ("tortilla" in cuadrantes[i] and "carne" in cuadrantes[i] and "verdura" in cuadrantes[i]):
							print("❌ No puedes poner salsa en un taco incompleto. Se necesita tortilla, carne y verdura.")
							continue  # Si no hay tortilla, carne y verdura → busca el siguiente cuadrante

					if ingredientes[ingrediente_actual][i] != null:
						ingredientes[ingrediente_actual][i].visible = true
						cuadrantes[i].append(ingrediente_actual)

						match ingrediente_actual:
							"carne":
								count_carne += 1
								Inventory.carne_total -= 1
							"verdura":
								count_verdura += 1
								Inventory.verdura_total -= 1
							"salsa":
								count_salsa += 1
								Inventory.salsa_total -= 1
						print("✅", ingrediente_actual.capitalize(), "añadido en el cuadrante", i + 1)
						break

	update_label()
	SuppliesUi.update_labels()


#
# ==================== _on_remove_ingredient() ====================
#
func _on_remove_ingredient():
	print("➖ Removiendo ingrediente:", ingrediente_actual)

	# ✅ Caso A: quitar "tortilla" => quita toda la pila de ingredientes del último cuadrante (4..1)
	if ingrediente_actual == "tortilla":
		for i in range(3, -1, -1):
			if "tortilla" in cuadrantes[i]:
				# Apagar la visibilidad de todos los ingredientes en el cuadrante
				for ing in cuadrantes[i]:
					if ingredientes[ing][i] != null:
						ingredientes[ing][i].visible = false

					# ✅ Devolver el ingrediente al inventario
					match ing:
						"tortilla":
							count_tortilla -= 1
							Inventory.tortillas_total += 1
						"carne":
							count_carne -= 1
							Inventory.carne_total += 1
						"verdura":
							count_verdura -= 1
							Inventory.verdura_total += 1
						"salsa":
							count_salsa -= 1
							Inventory.salsa_total += 1

				# ✅ Vaciar el cuadrante después de quitar todo
				cuadrantes[i].clear()
				break

	# ✅ Caso B: quitar "carne", "verdura" o "salsa" => solo quita el último ingrediente en el último cuadrante (4..1)
	else:
		for i in range(3, -1, -1):
			if ingrediente_actual in cuadrantes[i]:
				# Buscar el último índice donde está el ingrediente
				var idx = -1
				for j in range(cuadrantes[i].size() - 1, -1, -1):
					if cuadrantes[i][j] == ingrediente_actual:
						idx = j
						break

				if idx != -1:
					# ✅ Eliminar ingrediente del cuadrante
					cuadrantes[i].remove_at(idx)
					if ingredientes[ingrediente_actual][i] != null:
						ingredientes[ingrediente_actual][i].visible = false

					# ✅ Sumar el ingrediente al inventario
					match ingrediente_actual:
						"carne":
							count_carne -= 1
							Inventory.carne_total += 1
						"verdura":
							count_verdura -= 1
							Inventory.verdura_total += 1
						"salsa":
							count_salsa -= 1
							Inventory.salsa_total += 1
					break

	# ✅ Actualizar los contadores y la UI
	update_label()
	SuppliesUi.update_labels()


#
# ------------------ FUNCIONES INICIALES -------------------
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
			
# ✅ Función para verificar si hay 3 tacos completos en la parrilla
func has_3_distinct_tacos() -> bool:
	var tacos_completos = 0
	var recetas_verificadas = []  # Guardará las recetas ya verificadas para evitar duplicados

	# Recetas de tacos (ya definidas en tu código)
	var recetas = {
		"Taco-1": ["tortilla", "carne"],
		"Taco-2": ["tortilla", "carne", "verdura", "salsa"],
		"Taco-3": ["tortilla", "verdura"]
	}

	# Revisar cada cuadrante para ver si hay tacos completos
	for i in range(4):
		if cuadrantes[i].size() > 0:
			var contenido = cuadrantes[i].duplicate()
			contenido.sort()

			for receta in recetas.keys():
				var receta_ordenada = recetas[receta].duplicate()
				receta_ordenada.sort()

				# Si el cuadrante coincide con una receta Y aún no ha sido verificada
				if contenido == receta_ordenada and receta not in recetas_verificadas:
					tacos_completos += 1
					recetas_verificadas.append(receta)  # Registrar receta como verificada
					break

	# ✅ Si hay al menos 3 tacos completos (únicos), regresamos `true`
	if tacos_completos >= 3:
		print("✅ ¡Tres tacos distintos están completos!")
		return true
	
	print("❌ Aún no hay tres tacos completos...")
	return false



#func restart_ready():
	#print("🔁 Reiniciando parrilla...")
	#reset_parrilla()
