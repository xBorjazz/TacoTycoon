extends TextureProgressBar

@export var tiempo_espera: float = 25.0
@export var max_progress: float = 100.0
@export var segundos_por_ciclo: float = 5.0
@export var total_ciclos: int = 5

# Lista de colores para cada ciclo
@export var colores_modulate: Array[Color] = [
	Color(0.2, 1.0, 0.2),   # Verde
	Color(0.2, 0.7, 1.0),   # Azul
	Color(1.0, 0.9, 0.2),   # Amarillo
	Color(1.0, 0.5, 0.1),   # Naranja
	Color(1.0, 0.2, 0.2)    # Rojo
]

# Animaciones de estrellas (frames por ciclo)
@export var estrellas_anim: Array[String] = ["n5", "n4", "n3", "n2", "n1"]

# Internas
var tiempo_restante := 0.0
var activo := false
var pathfollow_node = null
var ciclo_actual := 0

func _ready():
	visible = false
	set_process(false)
	max_value = max_progress
	value = max_progress
	tiempo_restante = tiempo_espera
	ciclo_actual = 0

	# Asegurar que inicie sin color aplicado (blanco)
	modulate = colores_modulate[0]

	# Buscar cliente (PathFollow2D)
	if get_parent() and get_parent().get_parent():
		var potential_parent = get_parent().get_parent()
		if potential_parent.has_method("cliente_se_va"):
			pathfollow_node = potential_parent

func iniciar_barra():
	visible = true
	set_process(true)
	activo = true
	tiempo_restante = segundos_por_ciclo
	ciclo_actual = 0
	value = max_progress
	actualizar_color_ciclo()
	actualizar_animacion_estrella()

func _process(delta):
	if not activo:
		return

	tiempo_restante -= delta
	value = clamp((tiempo_restante / segundos_por_ciclo) * max_progress, 0, max_progress)

	if value <= 0:
		ciclo_actual += 1

		if ciclo_actual >= total_ciclos:
			activo = false
			set_process(false)
			if pathfollow_node and pathfollow_node.has_method("cliente_se_va"):
				pathfollow_node.cliente_se_va()
			return

		tiempo_restante = segundos_por_ciclo
		value = max_progress
		actualizar_color_ciclo()
		actualizar_animacion_estrella()

func reiniciar_barra():
	visible = false
	set_process(false)
	activo = false
	tiempo_restante = tiempo_espera
	value = max_progress
	ciclo_actual = 0
	actualizar_color_ciclo()

func actualizar_color_ciclo():
	if ciclo_actual < colores_modulate.size():
		modulate = colores_modulate[ciclo_actual]
	else:
		modulate = Color(1, 1, 1)  # Fallback blanco

	print("🎨 Color aplicado (modulate):", modulate)

func actualizar_animacion_estrella():
	if pathfollow_node and pathfollow_node.has_method("actualizar_estrella_desde_barra"):
		pathfollow_node.actualizar_estrella_desde_barra(estrellas_anim[ciclo_actual])
