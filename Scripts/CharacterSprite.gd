extends CharacterBody2D

# Velocidad de movimiento Inicial del personaje
var speed = 2.5
# Direcciones predefinidas
var directionrd = Vector2(1, 0.5)    # Derecha-abajo
var directionld = Vector2(-1, 0.5)   # Izquierda-abajo
var direction = directionrd          # Dirección inicial (hacia la derecha-abajo)
var stopped = false # FALTA PROGRAMAR QUE DE FORMA RANDOM EL PERSONAJE SE DETENGA
@onready var animated_sprite = $AnimatedSprite2D  # Accedemos al nodo AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D  # Accedemos al nodo CollisionShape2D
@onready var gameplay_panel = get_node("/root/Node2D/CanvasLayer/Gameplay")
@onready var raycast = get_node("/root/Node2D/CanvasLayer/Gameplay/RayCast2D")

# Crear una lista de posibles animaciones con sus respectivas direcciones
var animations = [
	{"name": "walk_right", "direction": directionrd},
	{"name": "walk_left_down", "direction": directionld},
	{"name": "buying", "direction": Vector2.ZERO},  # Dirección nula porque se queda quieto
	{"name": "fade_out", "direction": Vector2.ZERO}  # Desvanecerse al final
]

# Función que controla el movimiento del personaje
func _ready() -> void:
	animated_sprite.play("walk_right") 
	_movement_sequence()  # Iniciar la secuencia de movimiento

# Secuencia de movimiento: primero derecha, luego izquierda-abajo
func _movement_sequence() -> void:
	# Mover hacia la derecha por 3 segundos
	
	await get_tree().create_timer(2.0).timeout	# Mover por 3 segundos con la animación walk_left_down
	left_down_anim()
	random_animation()  # Se queda quieto comprando con animación buying

	# Esperar 2 segundos mientras el personaje está quieto
	#await get_tree().create_timer(2.0).timeout
	#left_down_anim()  # Reanudar el movimiento

# Función que pausa el movimiento del personaje
func buying_anim() -> void:
	stopped = true
	speed = 0  # Detiene el movimiento
	animated_sprite.play("buying")  # Reproduce la buying

	# Crear un temporizador para esperar 2 segundos antes de reanudar el movimiento
	var timer = Timer.new()
	timer.wait_time = 2.0  # Espera 2 segundos
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_resume_movement"))
	add_child(timer)
	timer.start()

# Función que reanuda el movimiento del personaje
func _resume_movement() -> void:
	left_down_anim()  # Cambia a la animación de caminar hacia la izquierda-abajo

# Función que reanuda el movimiento del personaje
func left_down_anim() -> void:
	stopped = false
	speed = 5  # Restaura la velocidad original
	direction = directionld
	animated_sprite.play("walk_left_down")  # Reanuda la animación de caminar hacia la izquierda-abajo
	
# Función que selecciona aleatoriamente una animación para el personaje
func random_animation() -> Dictionary:
	# Seleccionar una animación al azar
	var random_choice = randi() % animations.size()
	# Obtener la animación seleccionada
	var chosen_animation = animations[random_choice]
	# Retornar las variables en un diccionario
	return {"random_choice": random_choice, "chosen_animation": chosen_animation}

# Función que controla el movimiento continuo del personaje
func _process(delta: float) -> void:
	# Verifica si el personaje no está detenido
	if not stopped:
		# Movimiento constante en la dirección seleccionada
		position += direction * speed * delta
		
		# Verifica si el RayCast2D está colisionando
		if raycast.is_colliding():
			var collision_object = raycast.get_collider()  # Obtener el objeto con el que colisiona el raycast

			# Verifica si el objeto con el que colisiona es la zona de venta
			if collision_object.name == "Character":
				print("Personaje en zona de ventas")
				buying_anim()  # Ejecuta la animación de comprar y detiene el personaje
			else:
				# Si no colisiona con la zona de ventas, sigue verificando cambio de dirección
				_change_direction()  # Cambia la dirección si llega a los bordes del mapa
		else:
			# Si no hay colisión, sigue verificando cambio de dirección
			_change_direction()  # Cambia la dirección si llega a los bordes del mapa


# Función que cambia la dirección en base a las condiciones de posición dentro del panel
func _change_direction():
	# Obtener el tamaño del panel
	var panel_size = gameplay_panel.size
	
	if position.y > 37:  # Si llega al borde inferior del Panel 
		fade_out_anim()
		print("Primera Condición, Borde Inferior Alcanzado")
	elif position.x > panel_size.x:  # Si llega al borde derecho del Panel
		# CREAR UNA FUNCIÓN PARA ACORTAR ESTE CACHO
		var result = random_animation()
		var random_choice = result["random_choice"]
		var chosen_animation = result["chosen_animation"]
		
		direction = chosen_animation["direction"]
		animated_sprite.play(chosen_animation["name"])
		print("Segunda Condición, Borde Derecho Alcanzado")
	elif position.x < 0:  # Si llega al borde izquierdo del Panel
		direction = directionrd  # Cambia a moverse hacia la derecha-abajo
		animated_sprite.play("walk_right_up")
		print("Tercera Condición")

func fade_out_anim() -> void:
		animated_sprite.play("fade_out")  # Inicia la animación de desvanecimiento
		print("El personaje ha comenzado a desvanecerse")
		# Crear un temporizador para esperar que la animación termine
		var timer = Timer.new()
		timer.wait_time = 1.0  # Duración de la animación
		timer.one_shot = true
		timer.connect("timeout", Callable(self, "_on_fade_out_complete"))
		add_child(timer)
		timer.start()

# Función que se llama cuando el temporizador termina
func _on_fade_out_complete() -> void:
	print("El personaje ha salido del mapa")
	queue_free()  # Elimina el personaje de la escena

func _on_lemonade_car_zone_body_entered(body):
	if body.name == "CharacterSprite":  # Asegúrate de que es el personaje
		print("Personaje ha entrado en la zona de ventas")
		body.buying_anim()  # Llama a la función para detener al personaje
		animated_sprite.play("buying")  # Reproduce la animación de compra


func _on_button1_pressed():
	pass # Replace with function body.
