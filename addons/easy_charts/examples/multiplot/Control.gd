extends Control

@onready var chart: Chart = $VBoxContainer/Chart

# Estas 3 series se mostrarán en la gráfica:
var f1: Function   # Dinero Actual
var f2: Function   # Perdidas (Ventas perdidas)
var f3: Function   # Ventas (Tacos vendidos)

# Variable para controlar el tiempo (eje X)
var tiempo_acumulado: float = 0.0

func _ready():
	# Vamos a crear un conjunto de valores de ejemplo para X (no se usará directamente, ya que se irán agregando puntos en update_chart)
	var x: Array = ArrayOperations.multiply_float(range(-10, 11, 1), 0.5)
	
	# Valores iniciales para Y, Y2, Y3 (solo de ejemplo; luego se actualizarán)
	var y: Array = ArrayOperations.multiply_int(ArrayOperations.cos(x), 20)
	var y2: Array = ArrayOperations.add_float(ArrayOperations.multiply_int(ArrayOperations.sin(x), 20), 20)
	var y3: Array = ArrayOperations.add_float(ArrayOperations.multiply_int(ArrayOperations.cos(x), 5), -3)
	
	# Configuración de ChartProperties (personaliza a tu gusto)
	var cp: ChartProperties = ChartProperties.new()
	cp.colors.frame = Color("#161a1d")
	cp.colors.background = Color.TRANSPARENT
	cp.colors.grid = Color("#283442")
	cp.colors.ticks = Color("#283442")
	cp.colors.text = Color.WHITE_SMOKE
	cp.draw_bounding_box = false
	cp.show_legend = true
	cp.title = "Gráfica de predicción de Ganancias"
	cp.x_label = "Tiempo"
	cp.y_label = "Ganancias"
	cp.x_scale = 5
	cp.y_scale = 10
	cp.interactive = true
	
	# Creamos las funciones (series) iniciales:
	f1 = Function.new(x, y, "Dinero Actual", { 
		color = Color("#36a2eb"), 
		marker = Function.Marker.NONE, 
		type = Function.Type.AREA, 
		interpolation = Function.Interpolation.STAIR 
	})
	f2 = Function.new(x, y2, "Perdidas", { 
		color = Color("#ff6384"), 
		marker = Function.Marker.CROSS 
	})
	f3 = Function.new(x, y3, "Ventas", { 
		color = Color.GREEN, 
		marker = Function.Marker.CIRCLE 
	})
	
	chart.plot([f1, f2, f3], cp)
	
	# No actualizamos en cada frame
	set_process(false)

	# Conectar la señal "day_started" (o "day_ended") del DayManager
	var day_manager = get_node("/root/Node2D/CanvasLayer/Gameplay/DayControl")
	var spawner_node = get_node("/root/Node2D/CanvasLayer/Gameplay/CharacterSpawner")
	#day_manager.connect("day_started", Callable(self, "_on_SaleMade"))
	#day_manager.connect("day_ended", Callable(self, "_on_SaleMade"))
	spawner_node.connect("sale_made", Callable(self, "_on_SaleMade"))
	
func _on_SaleMade():
	# Cada vez que se realice una venta (o inicie/termine un día), actualizamos la gráfica.
	update_chart()
	
func update_chart():
	# Actualizamos el tiempo (por ejemplo, en segundos)
	tiempo_acumulado = Time.get_ticks_msec() / 1000.0

	# Obtener datos globales:
	var dinero: float = GlobalProgressBar.total_money_earned
	var tacos: float = Inventory.tacos_vendidos

	# Calculamos la predicción (usa tu modelo real; aquí es un placeholder)
	var prediccion: float = predict_gain(tiempo_acumulado)
	# Calculamos las pérdidas: si la predicción es mayor que el dinero real, la diferencia, de lo contrario 0.
	var perdidas: float = (prediccion - dinero) if prediccion > dinero else 0.0

	# Actualizamos las series:
	f1.add_point(tiempo_acumulado, dinero)
	f2.add_point(tiempo_acumulado, perdidas)
	f3.add_point(tiempo_acumulado, tacos)

	# Forzamos la actualización del Chart
	chart.queue_redraw()
	
# Función de predicción (placeholder; reemplaza por tu modelo de IA)
func predict_gain(x: float) -> float:
	return 5.0 * x + 10.0

func _process(delta: float):
	# No usamos _process() para actualizar la gráfica en tiempo real,
	# sino que se actualiza al emitir la señal de venta.
	pass

func _on_CheckButton_pressed():
	set_process(not is_processing())
