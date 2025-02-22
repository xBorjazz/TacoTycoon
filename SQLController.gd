extends Node

var db = load("res://addons/godot-sqlite/gdsqlite.gd").new()

func _ready():
	db.path = "res://database.sqlite"
	db.open_db()
	db.query("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT)")
	db.query("INSERT INTO users (name) VALUES ('Carlos')")
	var result = db.query("SELECT * FROM users")
	print(result)
	db.close_db()
