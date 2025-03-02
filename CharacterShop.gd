extends Node

@onready var tacodog_buy_button = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel3/BuyTacoDogButton")
@onready var taco_dog = get_node("/root/Node2D/CanvasLayer/Gameplay/TacoStandZone/Taco-Dog")
const TACO_DOG_COST = 500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_buy_taco_dog_button_pressed() -> void:
	if Inventory.player_money >= TACO_DOG_COST:
		Inventory.player_money -= TACO_DOG_COST
		taco_dog.visible = true  # Hacer visible Taco-Dog
		tacodog_buy_button.disabled = true  # Deshabilitar el botón para que no se vuelva a comprar
		#save_purchase() # Funcion para Guardar progreso
