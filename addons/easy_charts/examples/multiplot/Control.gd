extends Control

@onready var chart: Chart = $VBoxContainer/Chart

# Series de datos para graficar:
var f1: Function   # Dinero Actual
var f2: Function   # Pérdidas
var f3: Function   # Ventas
var f4: Function   # Predicción basada en la receta
var f5: Function   # Línea de promedio (regresión lineal)

# Variables para el cálculo de regresión
var tiempo_acumulado: float = 0.0
var ventas_reales: Array = []  # Guarda ventas reales (tiempo, valor)

# Parámetro para controlar la inclinación de la línea
const VENTAS_OBJETIVO = 10
const SCALE_FACTOR = 0.5

func _ready():
	var x_init = [0.0, 1.0]
	var y1_init = [0.0, 0.0]
	var y2_init = [0.0, 0.0]
	var y3_init = [0.0, 0.0]
	var y4_init = [0.0, 0.0]
	var y5_init = [0.0, 0.0]

	var cp = ChartProperties.new()
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

	# Series de datos
	f1 = Function.new(x_init, y1_init, "Dinero Actual", {color = Color("#36a2eb"), marker = Function.Marker.NONE, type = Function.Type.AREA, interpolation = Function.Interpolation.STAIR})
	f2 = Function.new(x_init, y2_init, "Pérdidas", {color = Color("#ff6384"), marker = Function.Marker.CROSS})
	f3 = Function.new(x_init, y3_init, "Ventas", {color = Color.GREEN, marker = Function.Marker.CIRCLE})
	f4 = Function.new(x_init, y4_init, "Receta Pred.", {color = Color.PURPLE, marker = Function.Marker.SQUARE})
	f5 = Function.new(x_init, y5_init, "Promedio de Ventas", {color = Color.YELLOW, marker = Function.Marker.NONE, type = Function.Type.LINE})

	chart.plot([f1, f2, f3, f4, f5], cp)

	set_process(false)

	# Conectar señales de venta
	if GrillManager and not GrillManager.sale_made.is_connected(_on_SaleMade):
		GrillManager.sale_made.connect(_on_SaleMade)

	if Spawner and not Spawner.sale_made.is_connected(_on_SaleMade):
		Spawner.sale_made.connect(_on_SaleMade)

# ✅ Cada vez que se realiza una venta, actualizamos la gráfica
func _on_SaleMade():
	update_chart()

# ✅ Actualiza la gráfica después de cada venta
func update_chart():
	tiempo_acumulado = Time.get_ticks_msec() / 1000.0
	var dinero: float = GlobalProgressBar.total_money_earned
	var tacos: float = Inventory.tacos_vendidos
	var prediccion: float = predict_gain(tiempo_acumulado)
	var perdidas: float = (prediccion - dinero) if prediccion > dinero else 0.0
	var receta_pred: float = predict_by_ingredients()

	# ✅ Añadir puntos a las series
	f1.add_point(tiempo_acumulado, dinero)
	f2.add_point(tiempo_acumulado, perdidas)
	f3.add_point(tiempo_acumulado, tacos)
	f4.add_point(tiempo_acumulado, receta_pred)

	# ✅ Guardar ventas reales (tiempo, valor)
	ventas_reales.append([tiempo_acumulado, dinero])

	# ✅ Si hay 10 ventas, recalcular la línea de tendencia
	if ventas_reales.size() >= 10:
		actualizar_promedio()

	# ✅ Limitar a 100 puntos para evitar saturación
	if f1.__x.size() > 100:
		f1.remove_point(0)
		f2.remove_point(0)
		f3.remove_point(0)
		f4.remove_point(0)

	chart.queue_redraw()

# ✅ Calcular y actualizar la línea de tendencia después de 10 ventas
func actualizar_promedio():
	if ventas_reales.size() < 2:
		return

	var x_mean = 0.0
	var y_mean = 0.0

	for v in ventas_reales:
		x_mean += v[0]
		y_mean += v[1]

	x_mean /= ventas_reales.size()
	y_mean /= ventas_reales.size()

	var numerador = 0.0
	var denominador = 0.0

	for v in ventas_reales:
		numerador += (v[0] - x_mean) * (v[1] - y_mean)
		denominador += (v[0] - x_mean) ** 2

	if denominador != 0:
		var m = numerador / denominador
		var b = y_mean - m * x_mean

		# 🔥 Ajuste de la pendiente (inclinación)
		if ventas_reales.size() >= VENTAS_OBJETIVO:
			m *= SCALE_FACTOR
		else:
			m *= SCALE_FACTOR * 1.5

		# ✅ Limpiar datos antiguos de f5
		while f5.__x.size() > 0:
			f5.remove_point(0)

		var x_inicio = ventas_reales[0][0]
		var x_final = ventas_reales[-1][0]

		# ✅ Crear línea de regresión (promedio)
		f5.add_point(x_inicio, m * x_inicio + b)
		f5.add_point(x_final, m * x_final + b)

	# ✅ Si hay más de 10 ventas, eliminar las más antiguas
	if ventas_reales.size() > 100:
		ventas_reales.pop_front()

# ✅ Predicción basada en el tiempo transcurrido
func predict_gain(x: float) -> float:
	return 5.0 * x + 10.0

# ✅ Predicción basada en ingredientes
func predict_by_ingredients() -> float:
	var tortillas = GrillManager.count_tortilla
	var carne = GrillManager.count_carne
	var verdura = GrillManager.count_verdura
	var salsa = GrillManager.count_salsa

	var w1 = 5.0
	var w2 = 7.0
	var w4 = 3.0
	var w5 = 7.0
	var b = 10.0

	return (w1 * tortillas) + (w2 * carne) + (w4 * verdura) + (w5 * salsa) + b

# ✅ Activar o desactivar la gráfica con el botón
func _on_CheckButton_pressed():
	set_process(!is_processing())
