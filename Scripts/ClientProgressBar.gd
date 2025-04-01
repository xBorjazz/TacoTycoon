extends TextureProgressBar

@export var tiempo_espera: float = 8.0  # Tiempo total de espera
@export var max_progress: float = 65.0  # Valor máximo de la barra

var tiempo_restante: float = 0.0
var activo: bool = false
var pathfollow_node = null  # Referencia a PathFollow2D (el cliente)

func _ready():
	# La barra inicia oculta y sin actualizar
	visible = false
	set_process(false)
	max_value = max_progress
	value = max_progress
	tiempo_restante = tiempo_espera
	activo = false

	# Intentamos obtener el PathFollow2D si está a 2 niveles arriba
	# (CharacterSprite -> PathFollow2D). Ajusta si tu jerarquía es distinta.
	if get_parent() and get_parent().get_parent():
		var potential_parent = get_parent().get_parent()
		if potential_parent.has_method("cliente_se_va"):
			pathfollow_node = potential_parent

func iniciar_barra():
	# Se llama cuando el cliente entra a la zona de ventas
	visible = true
	set_process(true)
	activo = true
	tiempo_restante = tiempo_espera
	value = max_progress

func _process(delta):
	if not activo:
		return

	# Elimina o comenta la siguiente línea para que la barra siga decrementándose:
	# if pathfollow_node and (pathfollow_node.has_bought or pathfollow_node.is_buying):
	#     return

	tiempo_restante -= delta
	var progress_value = clamp((tiempo_restante / tiempo_espera) * max_progress, 0, max_progress)
	value = progress_value

	if value <= 0:
		activo = false
		set_process(false)
		if pathfollow_node and pathfollow_node.has_method("cliente_se_va"):
			pathfollow_node.cliente_se_va()



func reiniciar_barra():
	# En caso de necesitar reiniciar la barra (por reutilización o reset)
	tiempo_restante = tiempo_espera
	value = max_progress
	activo = true
	visible = true
	set_process(true)
