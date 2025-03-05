extends Button

var is_fast = false  # Variable para rastrear el estado de la velocidad

func _ready():
	connect("pressed", Callable(self, "_toggle_speed"))

func _toggle_speed():
	if is_fast:
		Engine.time_scale = 1.0  # Regresar a la velocidad normal
		text = "Acelerar"
	else:
		Engine.time_scale = 2.0  # Duplicar la velocidad
		text = "Normal"
	is_fast = !is_fast  # Alternar estado
