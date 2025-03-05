extends Node

var carne_amount: float = 1.0
var salsa_amount: float = 1.0
var tortilla_amount: float = 1.0

func get_ingredients() -> Array:
	return [carne_amount, salsa_amount, tortilla_amount]

func restart_ready():
	print("Reejecutando _ready() con call_deferred()")
	call_deferred("_ready")  # Esto ejecutará _ready() en el siguiente frame
