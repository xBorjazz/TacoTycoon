extends Node

@onready var firebase = get_node("/root/Firebase")

func _ready() -> void:
	# Inicializar Firebase
	firebase.connect("ready", Callable(self, "_on_firebase_ready"))
	firebase.connect("error", Callable(self, "_on_firebase_error"))
	firebase.init()
	
func _on_firebase_ready():
	print("✅ Firebase inicializado correctamente.")

func _on_firebase_error(error_code: int, message: String):
	print("❌ Error al inicializar Firebase:", message)
