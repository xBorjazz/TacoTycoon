extends Node

#var db = load("res://addons/godot-sqlite/gdsqlite.gd").new()
var db : SQLite
var http = HTTPRequest.new()

@onready var nombre = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel8/Nombre")
@onready var puntuacion = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel8/Puntuacion")

func _ready():
	db = SQLite.new()
	db.path = "res://database.sqlite"
	db.open_db()
	#db.query("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT)")
	#db.query("INSERT INTO users (name) VALUES ('Carlos')")
	var result = db.query("SELECT * FROM users")
	print(result)
	#db.close_db()
	add_child(http)
	http.request("http://localhost/api.php")
	
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
