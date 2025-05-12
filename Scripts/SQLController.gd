extends Node

#var db = load("res://addons/godot-sqlite/gdsqlite.gd").new()
var db : SQLite
var http = HTTPRequest.new()

@onready var nombre = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel8/Nombre")
@onready var puntuacion = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel8/Puntuacion")
@onready var ranking_tree = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel8/RankingTree")

func _ready():
	db = SQLite.new()
	db.path = "res://database.sqlite"
	db.open_db()
	#db.query("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT)")
	#db.query("INSERT INTO users (name) VALUES ('Carlos')")
	var result = db.query("SELECT * FROM users")
	print(result)
	#db.close_db()
	setup_ranking_tree()  # Configurar columnas de la tabla
	cargar_datos_ranking()  # Cargar datos desde SQLite
	ranking_tree.queue_redraw()
	ranking_tree.propagate_call("queue_redraw")
	add_child(http)
	http.request("http://localhost/api.php")

func setup_ranking_tree():
	ranking_tree.columns = 4
	ranking_tree.set_column_title(0, "Nombre")
	ranking_tree.set_column_title(1, "Ventas")
	ranking_tree.set_column_title(2, "Estrellas")
	ranking_tree.set_column_title(3, "Dinero")

	# ✅ Solo expandir la columna del nombre
	ranking_tree.set_column_expand(0, true)
#
	## ❌ No expandir las demás (dejar tamaño mínimo)
	#for i in range(1, 5):
		#ranking_tree.set_column_expand(i, false)

	# 📏 Asegurar buen tamaño visual del Tree
	ranking_tree.custom_minimum_size = Vector2(700, 300)
	#ranking_tree.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#ranking_tree.size_flags_vertical = Control.SIZE_EXPAND_FILL



func cargar_datos_ranking():
	ranking_tree.clear()
	var root = ranking_tree.create_item()

	var query := SupabaseQuery.new()
	query.from("progreso_jugador").select(PackedStringArray([
		"ventas_totales",
		"promedio",
		"dinero_actual",
		"usuarios(nombre)"
	]))

	Supabase.database.connect("selected", Callable(self, "_on_datos_ranking_obtenidos"))
	Supabase.database.query(query)

func _on_datos_ranking_obtenidos(data):
	if data is Array and data.size() > 0:
		var root = ranking_tree.create_item()
		
		for fila in data:
			var item = ranking_tree.create_item(root)
			
			var nombre = fila.get("usuarios")["nombre"] if fila.has("usuarios") else "Desconocido"
			item.set_text(0, nombre)
			item.set_text(1, str(fila.get("ventas_totales", 0)))
			item.set_text(2, str(fila.get("promedio", 0.0)))
			item.set_text(3, str(fila.get("dinero_actual", 0)))
	else:
		print("⚠ No se encontraron datos o la respuesta fue inválida:", data)

	
func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var data = JSON.parse_string(body.get_string_from_utf8())
		print(data)  # Muestra los datos de la base de datos en la consola

func _on_crear_tabla_button_down() -> void:
	var table = {
		"id" : {"data_type" : "int", "primary_key" : true, "not_null" : true, "auto_increment" : true },
		"name" : {"data_type" : "text"},
		"score" : {"data_type" : "int"},
	}
	db.create_table("players", table)
	print("Tabla de DB Creada!")
	pass # Replace with function body.

func generar_uuid() -> String:
		var hex = "0123456789abcdef"
		var uuid = ""
		var sections = [8, 4, 4, 4, 12]
		
		for section in sections:
			for i in range(section):
				uuid += hex[randi() % hex.length()]
			if section != 12:
				uuid += "-"
		print("UIIIID GENERADOOOO:", uuid)
		return uuid

func _on_insertar_datos_button_down() -> void:
	# Generar UUID

	var user_id := generar_uuid()
	var user_name: String = nombre.text


	# Crear registro en tabla "usuarios"
	var user_data := {
		"id": user_id,
		"nombre": user_name
	}

	var query := SupabaseQuery.new()
	query.from("usuarios").insert([user_data])

	# Enviar el query
	Supabase.database.query(query)

	# Guardar progreso correspondiente a este nuevo usuario
	
	if Supabase.database != null:
		SuppliesUi._guardar_progreso_cuando_este_listo(user_id)
	else:
		print("⏳ Esperando que Supabase.database esté listo...")
		await get_tree().create_timer(0.2).timeout
		#SuppliesUi._guardar_progreso_cuando_este_listo.call()

	#SuppliesUi._guardar_progreso_cuando_este_listo.call()


func _on_seleccionar_datos_button_down() -> void:
	print(db.select_rows("players", "score > 10", ["*"]))
	pass # Replace with function body.

func _on_actualizar_datos_button_down() -> void:
	db.update_rows("players", "name = '" + nombre.text + "'", {"score" : int(puntuacion.text)}) #modificaicon en video
	pass # Replace with function body.
	
func _on_borrar_datos_button_down() -> void:
	db.delete_rows("players", "name = '" + nombre.text + "'")
	pass # Replace with function body.

func _on_seleccionar_persona_button_down() -> void:
	pass # Replace with function body.


func _on_web_data_base_button_pressed() -> void:
	OS.shell_open("http://localhost/api.php")
	pass # Replace with function body.
