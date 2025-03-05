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
@export var line_color: Color = Color.RED      # Línea de regresión (roja)
@export var scatter_color: Color = Color.BLUE  # Puntos en la gráfica
@export var bg_color: Color

@export var x_ticks = 7
@export var y_ticks = 7

var x_numerical = true
var y_numerical = true
var min_x
var max_x
var min_y
var max_y

var line_rect_width: float = 0.0
var line_rect_height: float = 0.0
var line_rect_x: float = 0.0
var line_rect_y: float = 0.0

# Rutas para la parte gráfica
@onready var line_container = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel2/line_chart/line_container")
@onready var x_label = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel2/line_chart/x_label")
@onready var y_label = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel2/line_chart/y_label")
@onready var background = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel2/line_chart/line_container/background")
@onready var x_ticks_container = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel2/line_chart/x_ticks_container")
@onready var y_ticks_container = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel2/line_chart/y_ticks_container")

var initial_data = [
	{"tortillas": 1, "carne": 1, "cebolla": 1, "verdura": 1, "salsa": 1, "earnings": 35.0},
	{"tortillas": 1, "carne": 1, "cebolla": 1, "verdura": 1, "salsa": 2, "earnings": 38.0},
	{"tortillas": 1, "carne": 1, "cebolla": 1, "verdura": 2, "salsa": 1, "earnings": 37.0},
	{"tortillas": 1, "carne": 1, "cebolla": 2, "verdura": 1, "salsa": 1, "earnings": 36.0},
	{"tortillas": 1, "carne": 2, "cebolla": 1, "verdura": 1, "salsa": 1, "earnings": 37.0},
	{"tortillas": 2, "carne": 1, "cebolla": 1, "verdura": 1, "salsa": 1, "earnings": 38.0},
	{"tortillas": 2, "carne": 2, "cebolla": 1, "verdura": 1, "salsa": 1, "earnings": 40.0},
	{"tortillas": 1, "carne": 2, "cebolla": 2, "verdura": 1, "salsa": 1, "earnings": 39.0},
	{"tortillas": 1, "carne": 1, "cebolla": 2, "verdura": 2, "salsa": 1, "earnings": 38.0},
	{"tortillas": 2, "carne": 1, "cebolla": 1, "verdura": 2, "salsa": 1, "earnings": 39.0},
	{"tortillas": 2, "carne": 2, "cebolla": 2, "verdura": 1, "salsa": 1, "earnings": 41.0},
	{"tortillas": 2, "carne": 2, "cebolla": 1, "verdura": 2, "salsa": 1, "earnings": 41.0},
	{"tortillas": 1, "carne": 2, "cebolla": 1, "verdura": 2, "salsa": 2, "earnings": 42.0},
	{"tortillas": 2, "carne": 1, "cebolla": 2, "verdura": 1, "salsa": 2, "earnings": 42.0},
	{"tortillas": 3, "carne": 1, "cebolla": 1, "verdura": 1, "salsa": 1, "earnings": 40.0},
	{"tortillas": 1, "carne": 3, "cebolla": 1, "verdura": 1, "salsa": 1, "earnings": 40.0},
	{"tortillas": 1, "carne": 1, "cebolla": 3, "verdura": 1, "salsa": 1, "earnings": 40.0},
	{"tortillas": 1, "carne": 1, "cebolla": 1, "verdura": 3, "salsa": 1, "earnings": 40.0},
	{"tortillas": 1, "carne": 1, "cebolla": 1, "verdura": 1, "salsa": 3, "earnings": 40.0},
	{"tortillas": 3, "carne": 3, "cebolla": 3, "verdura": 3, "salsa": 3, "earnings": 85.0},
	{"tortillas": 2, "carne": 3, "cebolla": 2, "verdura": 3, "salsa": 2, "earnings": 75.0},
	{"tortillas": 3, "carne": 2, "cebolla": 3, "verdura": 2, "salsa": 3, "earnings": 80.0},
	{"tortillas": 2, "carne": 2, "cebolla": 3, "verdura": 2, "salsa": 2, "earnings": 70.0},
	{"tortillas": 2, "carne": 3, "cebolla": 2, "verdura": 2, "salsa": 3, "earnings": 72.0},
	{"tortillas": 1, "carne": 2, "cebolla": 2, "verdura": 2, "salsa": 2, "earnings": 65.0},
	{"tortillas": 2, "carne": 1, "cebolla": 2, "verdura": 2, "salsa": 2, "earnings": 64.0},
	{"tortillas": 1, "carne": 2, "cebolla": 1, "verdura": 2, "salsa": 3, "earnings": 68.0},
	{"tortillas": 3, "carne": 1, "cebolla": 2, "verdura": 3, "salsa": 1, "earnings": 70.0},
	{"tortillas": 2, "carne": 1, "cebolla": 3, "verdura": 1, "salsa": 2, "earnings": 66.0},
	{"tortillas": 3, "carne": 2, "cebolla": 1, "verdura": 2, "salsa": 2, "earnings": 69.0}
]
# Array de puntos para la gráfica: (x = suma de ingredientes, y = ganancia)
var data: Array = []

# Constante para forzar el "corte" (NaN) en la Line2D
const BREAK_POINT = Vector2(float("nan"), float("nan"))

func _ready():
	# 1) Convertir initial_data a 'data'
	data.clear()
	for ex in initial_data:
		var sum_ingredients = ex["tortillas"] + ex["carne"] + ex["cebolla"] + ex["verdura"] + ex["salsa"]
		data.append({"x": sum_ingredients, "y": ex["earnings"]})

	# 2) Limpiar contenedores de ejes
	for child in x_ticks_container.get_children():
		child.queue_free()
	for child in y_ticks_container.get_children():
		child.queue_free()

	# 3) Eliminar nodos de line_container menos el fondo
	for child in line_container.get_children():
		if child != background:
			child.queue_free()
	background.color = bg_color

	# 4) Determinar si x,y son numéricos y reiniciar min/max
	x_numerical = true
	y_numerical = true
	min_x = null
	max_x = null
	min_y = null
	max_y = null
	for entry in data:
		if not [TYPE_INT, TYPE_FLOAT].has(typeof(entry["x"])):
			x_numerical = false
		if not [TYPE_INT, TYPE_FLOAT].has(typeof(entry["y"])):
			y_numerical = false

	# 5) Calcular min_x, max_x, min_y, max_y
	for i in range(data.size()):
		var x_val = get_val(data[i]["x"], i)
		var y_val = get_val(data[i]["y"], i)
		if min_x == null or x_val < min_x:
			min_x = x_val
		if max_x == null or x_val > max_x:
			max_x = x_val
		if min_y == null or y_val < min_y:
			min_y = y_val
		if max_y == null or y_val > max_y:
			max_y = y_val

	# 6) Crear etiquetas en X e Y
	_create_x_ticks()
	_create_y_ticks()

	# 7) Esperar un frame y calcular dimensiones
	await get_tree().process_frame
	line_rect_width = line_container.size.x
	line_rect_height = line_container.size.y
	line_rect_x = line_rect_width / x_ticks
	line_rect_y = line_rect_height / y_ticks
	line_rect_width = line_rect_x * (x_ticks - 1)
	line_rect_height = line_rect_y * (y_ticks - 1)

	# 8) Dibujar PUNTOS sueltos (scatter)
	_draw_scatter_points()

	# 9) Dibujar línea de regresión
	_draw_regression_line()

	# 10) Rotar y_label vertical
	y_label.rotation_degrees = -90
	y_label.pivot_offset = y_label.size * 0.5
	y_label.position = Vector2(20, line_container.size.y / 2)

# ----------------------------------------------------------------
# Crear etiquetas en el eje X
# ----------------------------------------------------------------
func _create_x_ticks():
	for i in range(x_ticks):
		var x_tick = Label.new()
		x_tick.size_flags_horizontal = SIZE_EXPAND_FILL
		x_tick.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		if x_numerical:
			var x_val_num = round(i * (max_x - min_x) / float(x_ticks - 1) + min_x)
			x_tick.text = str(x_val_num)
		else:
			if i < data.size():
				x_tick.text = str(data[i]["x"])
			else:
				x_tick.text = ""
		x_ticks_container.add_child(x_tick)

# ----------------------------------------------------------------
# Crear etiquetas en el eje Y
# ----------------------------------------------------------------
func _create_y_ticks():
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
				y_tick.text = str(data[index]["y"])
			else:
				y_tick.text = ""
		y_ticks_container.add_child(y_tick)

# ----------------------------------------------------------------
# Dibujar puntos azules (scatter) sin trazar líneas entre ellos
# ----------------------------------------------------------------
func _draw_scatter_points():
	var scatter_line = Line2D.new()
	scatter_line.width = 4
	scatter_line.default_color = scatter_color
	scatter_line.joint_mode = Line2D.LineJointMode.LINE_JOINT_ROUND
	scatter_line.begin_cap_mode = Line2D.LineCapMode.LINE_CAP_ROUND
	scatter_line.end_cap_mode = Line2D.LineCapMode.LINE_CAP_ROUND
	line_container.add_child(scatter_line)

	# Para cada punto, añadimos un "segmento" de longitud cero + un corte (NaN, NaN)
	for i in range(data.size()):
		var px = scale_x(get_val(data[i]["x"], i))
		var py = scale_y(get_val(data[i]["y"], i))
		# 1) Duplicamos el punto para que sea un pequeño círculo
		scatter_line.add_point(Vector2(px, py))
		scatter_line.add_point(Vector2(px, py))
		# 2) Insertamos un punto con coordenadas NaN para "romper" la línea
		scatter_line.add_point(BREAK_POINT)

# ----------------------------------------------------------------
# Dibujar línea de regresión (roja)
# ----------------------------------------------------------------
func _draw_regression_line():
	var reg_line = Line2D.new()
	reg_line.width = line_width
	reg_line.default_color = line_color
	line_container.add_child(reg_line)

	var px1 = scale_x(min_x)
	var py1 = scale_y(predict_gain(min_x))
	var px2 = scale_x(max_x)
	var py2 = scale_y(predict_gain(max_x))

	reg_line.add_point(Vector2(px1, py1))
	reg_line.add_point(Vector2(px2, py2))

# ----------------------------------------------------------------
# Función de predicción (Placeholder)
# ----------------------------------------------------------------
func predict_gain(x: int) -> float:
	return 5.0 * float(x) + 10.0

# ----------------------------------------------------------------
# Funciones auxiliares
# ----------------------------------------------------------------
func scale_x(val):
	if val == null:
		return 0
	if min_x == null or line_rect_width == null or line_rect_x == null:
		return 0
	var dx = max_x - min_x
	if dx == 0:
		return line_rect_x / 2
	return ((val - min_x) * line_rect_width / dx) + line_rect_x / 2

func scale_y(val):
	if val == null:
		return 0
	if min_y == null or max_y == null:
		return 0
	if line_rect_height == null or line_rect_y == null:
		return 0
	var dy = max_y - min_y
	if dy == 0:
		return line_rect_y / 2
	return line_rect_height - ((val - min_y) * line_rect_height / dy) + line_rect_y / 2

func get_val(val, idx):
	if [TYPE_INT, TYPE_FLOAT].has(typeof(val)):
		return val
	return idx
