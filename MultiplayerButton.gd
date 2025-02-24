extends TextureButton

@onready var client = get_node("/root/Node2D/CanvasLayer/Client")

func _ready():
	self.pressed.connect(_on_multiplayer_button_pressed)

func _on_multiplayer_button_pressed():
	print("🔄 Iniciando conexión UDP...")
	client._ready()  # Simular el inicio de la conexión manualmente
