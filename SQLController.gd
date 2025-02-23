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

# Configurar las columnas del Tree (Nombre - Puntuación)
func setup_ranking_tree():
	ranking_tree.columns = 2  # Asegurar que tenga 2 columnas
	ranking_tree.set_column_title(0, "Nombre")
	ranking_tree.set_column_title(1, "Puntuación")
	ranking_tree.set_column_expand(0, true)
	ranking_tree.set_column_expand(1, true)

	# 📌 Asegurar que `Tree` tiene tamaño
	ranking_tree.custom_minimum_size = Vector2(300, 200)
	ranking_tree.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ranking_tree.size_flags_vertical = Control.SIZE_EXPAND_FILL


# Cargar datos desde SQLite y agregarlos al `Tree`
func cargar_datos_ranking():
	ranking_tree.clear()  # Limpiar datos previos
	var root = ranking_tree.create_item()  # Crear raíz de la tabla
	var datos = db.select_rows("players", "", ["name", "score"])  # Obtener datos

	print("📌 Datos en la BD:", datos)  # Depuración: Ver si hay datos en la base de datos

	for jugador in datos:
		var item = ranking_tree.create_item(root)
		item.set_text(0, jugador["name"		])  # Columna 1: Nombre
		item.set_text(1, str(jugador["score"]))  # Columna 2: Puntuación
	
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

func _on_insertar_datos_button_down() -> void:
	var data  = {
		"name" : nombre.text,
		"score" : int(puntuacion.text)
	}
	db.insert_row("players", data)
	pass # Replace with function body.

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
