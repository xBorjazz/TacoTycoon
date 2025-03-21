extends Control

@onready var chart: Chart = $VBoxContainer/Chart

# Series de datos para graficar:
var f1: Function   # Dinero Actual
var f2: Function   # Pérdidas
var f3: Function   # Ventas
var f4: Function   # Predicción por Ventas (puntos)
var f5: Function   # Recta de regresión lineal (GD)
var f6: Function   # Dinero Invertido ✅

# Lista de puntos para la regresión con GD: [x, y]
# x = tiempo escalado, y = tacos_vendidos - ventas_fallidas
var sells_points: Array = []

# Variables globales para Gradiente Descendiente (GD)
var m: float = 0.0     # Pendiente
var b: float = 0.0     # Intersección
var alpha: float = 0.001  # Tasa de aprendizaje (ajusta según convenga)

# Nueva variable para contar clientes atendidos (ventas exitosas + fallidas)
var clientes_totales = 0

func _ready():
	var x_init = [0.0, 1.0]
	var y_init = [0.0, 0.0]
	
	# Inicializamos todas las series, aunque solo graficaremos f4 y f5.
	f1 = Function.new(x_init, y_init, "Dinero Actual", {
		color = Color("#36a2eb"),
		marker = Function.Marker.NONE,
		type = Function.Type.AREA,
		interpolation = Function.Interpolation.STAIR
	})
	f2 = Function.new(x_init, y_init, "Pérdidas", {
		color = Color("#ff6384"),
		marker = Function.Marker.CROSS
	})
	f3 = Function.new(x_init, y_init, "Ventas", {
		color = Color.GREEN,
		marker = Function.Marker.CIRCLE
	})
	f4 = Function.new(x_init, y_init, "Predicción por Ventas", {
		color = Color.CYAN,
		marker = Function.Marker.SQUARE
	})
	f5 = Function.new(x_init, y_init, "Promedio de Ventas", {
		color = Color.RED,
		marker = Function.Marker.NONE,
		type = Function.Type.LINE
	})
	f6 = Function.new(x_init, y_init, "Dinero Invertido", {
		color = Color.LAWN_GREEN,
		marker = Function.Marker.SQUARE,
		type = Function.Type.AREA
	})
	
	var cp = ChartProperties.new()
	cp.colors.frame = Color("#161a1d")
	cp.colors.background = Color.TRANSPARENT
	cp.colors.grid = Color("#283442")
	cp.colors.ticks = Color("#283442")
	cp.colors.text = Color.WHITE_SMOKE
	cp.draw_bounding_box = false
	cp.show_legend = true
	cp.title = "Regresión Ventas con GD"
	cp.x_label = "Tiempo Escalado"
	cp.y_label = "Ventas Netas"
	cp.x_scale = 5
	cp.y_scale = 10
	cp.interactive = true

	# Solo graficamos f4 y f5 (puntos y la recta)
	chart.plot([f4, f5], cp)

	# Conectar señales de venta (las demás funciones siguen disponibles en el código)
	if GrillManager and not GrillManager.sale_made.is_connected(_on_SaleMade):
		GrillManager.sale_made.connect(_on_SaleMade)
	if Spawner and not Spawner.sale_made.is_connected(_on_SaleMade):
		Spawner.sale_made.connect(_on_SaleMade)


# Cada vez que se realiza una venta, actualizamos la gráfica
func _on_SaleMade():
	update_chart()


func update_chart():
	# 1) Tiempo en segundos y escalado para mejorar la pendiente visual.
	var tiempo = Time.get_ticks_msec() / 1000.0
	var x_scaled = tiempo / 10.0  # Ajusta este factor según convenga

	# 2) Datos globales de juego.
	var dinero: float = Inventory.player_money
	var tacos: float = Inventory.tacos_vendidos
	var fallidas: float = Inventory.ventas_fallidas
	var dinero_invertido: float = Inventory.invested_money

	clientes_totales = tacos + fallidas

	# Actualizamos las series que no se plotean (f1, f2, f3, f6):
	f1.add_point(tiempo, dinero)
	f2.add_point(tiempo, (predict_gain(tiempo) - dinero) if predict_gain(tiempo) > dinero else 0.0)
	f3.add_point(tiempo, tacos)
	f6.add_point(tiempo, dinero_invertido)

	# 3) Calculamos ventas netas: (ventas exitosas - fallidas)
	var y_sells = tacos - fallidas

	# Agregamos el nuevo punto a f4 y a sells_points.
	f4.add_point(x_scaled, y_sells)
	sells_points.append([x_scaled, y_sells])

	# 4) Entrenamos con gradiente descendiente: iteramos varias veces para ajustar m y b.
	for epoch in range(50):  # 50 iteraciones (ajusta este número según sea necesario)
		train_gd_epoch()

	# 5) Actualizamos la recta de regresión (f5) usando los parámetros m y b.
	var min_x = f4.__x.min()
	var max_x = f4.__x.max()
	while f5.__x.size() > 0:
		f5.remove_point(0)
	f5.add_point(min_x, m * min_x + b)
	f5.add_point(max_x, m * max_x + b)

	# 6) Ajustamos el dominio de la gráfica solo en función de f4 y f5.
	var min_x_domain = min_x
	var max_x_domain = max_x + 1
	var min_y = min(f4.__y.min(), f5.__y.min()) - 1
	var max_y = max(f4.__y.max(), f5.__y.max()) + 1
	chart.set_x_domain(min_x_domain, max_x_domain)
	chart.set_y_domain(min_y, max_y)

	chart.queue_redraw()


# Función que realiza una iteración de entrenamiento por GD sobre todos los puntos.
func train_gd_epoch():
	for point in sells_points:
		var x = point[0]
		var y = point[1]
		var y_pred = m * x + b
		var error = y_pred - y
		# Gradientes parciales del error (usando error cuadrático medio)
		var dm = error * x
		var db = error
		m -= alpha * dm
		b -= alpha * db


# Ejemplo de predicción basada en el tiempo (no GD)
func predict_gain(x: float) -> float:
	if clientes_totales < 5:
		return 5.0
	else:
		var ventas_totales = Inventory.tacos_vendidos
		var fallidas = Inventory.ventas_fallidas
		var m_gain = 2.0 * (ventas_totales - fallidas) / clientes_totales
		var b_gain = 5.0
		return m_gain * x + b_gain


# Botón para pausar o reanudar la gráfica
func _on_CheckButton_pressed():
	set_process(!is_processing())
