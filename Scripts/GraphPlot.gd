extends GridContainer

var data_points: Array = []  # Datos de dinero ganado
var days: Array = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"]  # Días de la semana
var current_day: int = 0  # Índice del día actual

@export var line_width: int = 5
@export var line_color: Color = Color.WHITE
@export var bg_color: Color = Color.BLACK
@export var x_label: String = "Día"
@export var y_label: String = "Dinero Ganado"

var margin: float = 20.0  # Margen de la gráfica
var max_val: float = 1.0  # Máximo valor de referencia

func set_data(new_data: Array):
	data_points = new_data
	queue_redraw()  # Redibuja la gráfica con los nuevos valores

func _ready():
	# Inicializar con valores vacíos para toda la semana
	data_points.resize(7)
	data_points.fill(0)

	# Conectar señal para actualizar la gráfica en tiempo real
	var inventory = get_node("/root/Inventory")
	inventory.connect("venta_realizada", Callable(self, "_on_venta_realizada"))

func _draw():
	if data_points.size() < 2:
		return

	var width = size.x - 2 * margin
	var height = size.y - 2 * margin

	# Encontrar el máximo valor de referencia
	max_val = max(1, data_points.max())  # Evita valores negativos o cero

	var step_x = width / float(data_points.size() - 1)  # Espaciado entre puntos

	# Dibujar la línea
	for i in range(data_points.size() - 1):
		var x1 = margin + i * step_x
		var y1 = margin + height - (data_points[i] / max_val) * height
		var x2 = margin + (i + 1) * step_x
		var y2 = margin + height - (data_points[i + 1] / max_val) * height

		draw_line(Vector2(x1, y1), Vector2(x2, y2), line_color, line_width)

	# Dibujar etiquetas del eje X
	for i in range(data_points.size()):
		var x = margin + i * step_x
		draw_string(get_theme_font("font"), Vector2(x - 10, size.y - 5), days[i], HORIZONTAL_ALIGNMENT_CENTER)

	# Dibujar etiquetas del eje Y
	for i in range(5):
		var y = margin + height - (i / 4.0) * height
		var value = int(max_val * (i / 4.0))
		draw_string(get_theme_font("font"), Vector2(5, y), str(value), HORIZONTAL_ALIGNMENT_LEFT)

# Función que se ejecuta cuando se realiza una venta
func _on_venta_realizada():
	var inventory = get_node("/root/Inventory")
	data_points[current_day] = Inventory.player_money  # Actualiza el dinero del día actual
	queue_redraw()  # Redibuja la gráfica en pantalla

# Avanza al siguiente día (debería llamarse al finalizar el día en el juego)
func avanzar_dia():
	current_day = (current_day + 1) % 7  # Avanza al siguiente día y reinicia en lunes si es necesario
	data_points[current_day] = 0  # Reinicia el dinero ganado para el nuevo día
	queue_redraw()
	
func restart_ready():
	print("Reejecutando _ready() con call_deferred()")
	call_deferred("_ready")  # Esto ejecutará _ready() en el siguiente frame
