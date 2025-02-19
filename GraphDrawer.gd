extends GridContainer

# Constantes de alineación para Godot 4
const HORIZONTAL_ALIGNMENT_LEFT = 0
const HORIZONTAL_ALIGNMENT_CENTER = 1
const HORIZONTAL_ALIGNMENT_RIGHT = 2
const HORIZONTAL_ALIGNMENT_FILL = 3

const VERTICAL_ALIGNMENT_TOP = 0
const VERTICAL_ALIGNMENT_CENTER = 1
const VERTICAL_ALIGNMENT_BOTTOM = 2
const VERTICAL_ALIGNMENT_FILL = 3

@export var line_width = 5
@export var line_color: Color
@export var bg_color: Color

@export var x_ticks = 7
@export var y_ticks = 7

var x_numerical = true
var y_numerical = true

var min_x
var min_y
var max_x
var max_y

var line_rect_width
var line_rect_height
var line_rect_x
var line_rect_y

# Ajusta las rutas si tus nodos están en otra parte de la jerarquía
@onready var line_container = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel2/line_chart/line_container")
@onready var x_label = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel2/line_chart/x_label")
@onready var y_label = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel2/line_chart/y_label")
@onready var background = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel2/line_chart/line_container/background")
@onready var x_ticks_container = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel2/line_chart/x_ticks_container")
@onready var y_ticks_container = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel2/line_chart/y_ticks_container")

# Datos de ejemplo
var data = [
	{'x': 'L', 'y': 7.0},
	{'x': 'M', 'y': 8.0},
	{'x': 'Mi', 'y': 3.0},
	{'x': 'J', 'y': 5.0},
	{'x': 'V', 'y': 4.0},
	{'x': 'S', 'y': 6.0},
	{'x': 'D', 'y': 1.0},
]

func _ready():
	# 1) Limpiar contenedores de ticks para evitar duplicados
	for child in x_ticks_container.get_children():
		child.queue_free()
	for child in y_ticks_container.get_children():
		child.queue_free()

	# 2) Crear la línea y asignar estilos
	var line = Line2D.new()
	line.width = line_width
	line.default_color = line_color
	line_container.add_child(line)

	background.color = bg_color

	# 3) Comprobar si los valores son numéricos
	x_numerical = true
	y_numerical = true
	min_x = null
	max_x = null
	min_y = null
	max_y = null

	for val in data:
		if not [TYPE_INT, TYPE_FLOAT].has(typeof(val['x'])):
			x_numerical = false
		if not [TYPE_INT, TYPE_FLOAT].has(typeof(val['y'])):
			y_numerical = false

	# 4) Calcular mínimos y máximos (x,y)
	for i in range(len(data)):
		var x_val = get_val(data[i]['x'], i)
		var y_val = get_val(data[i]['y'], i)

		if min_x == null or x_val < min_x:
			min_x = x_val
		if max_x == null or x_val > max_x:
			max_x = x_val
		if min_y == null or y_val < min_y:
			min_y = y_val
		if max_y == null or y_val > max_y:
			max_y = y_val

	# 5) Añadir etiquetas (ticks) al eje X
	for i in range(x_ticks):
		var x_tick = Label.new()
		x_tick.size_flags_horizontal = SIZE_EXPAND_FILL
		x_tick.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		if x_numerical:
			var x_val_num = round(i * (max_x - min_x) / float(x_ticks - 1) + min_x)
			x_tick.text = str(x_val_num)
		else:
			# Si hay menos elementos que x_ticks, evita indexar fuera de rango
			if i < data.size():
				x_tick.text = str(data[i]['x'])
			else:
				x_tick.text = ""
		x_ticks_container.add_child(x_tick)

	# 6) Añadir etiquetas (ticks) al eje Y (se dibujan en orden inverso)
	for i in range(y_ticks - 1, -1, -1):
		var y_tick = Label.new()
		y_tick.size_flags_vertical = SIZE_EXPAND_FILL
		y_tick.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

		if y_numerical:
			var y_val_num = round(i * (max_y - min_y) / float(y_ticks - 1) + min_y)
			y_tick.text = str(y_val_num)
		else:
			var index = y_ticks - i - 1
			if index < data.size():
				y_tick.text = str(data[index]['y'])
			else:
				y_tick.text = ""
		y_ticks_container.add_child(y_tick)

	# 7) Esperar un frame para actualizar tamaño de contenedores
	await get_tree().process_frame

	# 8) Calcular dimensiones y posicionar los puntos
	line_rect_width = line_container.size.x
	line_rect_height = line_container.size.y

	line_rect_x = line_rect_width / x_ticks
	line_rect_y = line_rect_height / y_ticks

	line_rect_width = line_rect_x * (x_ticks - 1)
	line_rect_height = line_rect_y * (y_ticks - 1)

	for i in range(len(data)):
		var scaled_x = scale_x(get_val(data[i]['x'], i))
		var scaled_y = scale_y(get_val(data[i]['y'], i))
		line.add_point(Vector2(scaled_x, scaled_y))

	# 9) Rotar la etiqueta del eje Y a 90 grados
	#    Ajusta la posición/pivote según tu layout
	y_label.rotation_degrees = -90
	y_label.pivot_offset = y_label.size * 0.5
	# Ejemplo de posición (puede variar según tu interfaz):
	y_label.position = Vector2(20, line_container.size.y / 2)

# ----------------------------------------------------------------
# FUNCIONES AUXILIARES
# ----------------------------------------------------------------

func scale_x(val):
	var dx = max_x - min_x
	if dx == 0:
		return line_rect_x / 2
	return ((val - min_x) * line_rect_width / dx) + line_rect_x / 2

func scale_y(val):
	var dy = max_y - min_y
	if dy == 0:
		return line_rect_y / 2
	# Invertir Y para que el 0 quede abajo
	return line_rect_height - ((val - min_y) * line_rect_height / dy) + line_rect_y / 2

func get_val(val, idx):
	# Si es numérico, úsalo tal cual, si no, se usará 'idx'
	if [TYPE_INT, TYPE_FLOAT].has(typeof(val)):
		return val
	return idx
