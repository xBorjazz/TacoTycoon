extends Control

@onready var chart: Chart = $VBoxContainer/Chart

# Series de datos para graficar:
var f1: Function   # Dinero Actual
var f2: Function   # Pérdidas
var f3: Function   # Ventas
var f4: Function   # Predicción basada en la receta
var f5: Function   # Línea de promedio (regresión lineal)
var f6: Function   # Dinero invertido ✅

# Variables para el cálculo de regresión
var tiempo_acumulado: float = 0.0
var ventas_reales: Array = []  # Guarda ventas reales (tiempo, valor)

# ✅ Nueva variable para contar clientes atendidos (ventas exitosas + fallidas)
var clientes_totales = 0

func _ready():
	var x_init = [0.0, 1.0]
	var y1_init = [0.0, 0.0]
	var y2_init = [0.0, 0.0]
	var y3_init = [0.0, 0.0]
	var y4_init = [0.0, 0.0]
	var y5_init = [0.0, 0.0]
	var y6_init = [0.0, 0.0] # Dinero invertido ✅

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
	f5 = Function.new(x_init, y5_init, "Promedio de Ventas", {color = Color.RED, marker = Function.Marker.NONE, type = Function.Type.LINE})
	f6 = Function.new(x_init, y6_init, "Dinero Invertido", {color = Color.LAWN_GREEN, marker = Function.Marker.SQUARE, type = Function.Type.AREA, interpolation = Function.Interpolation.STAIR})  # ✅ Color naranja para inversión

	chart.plot([f1, f2, f3, f4, f5, f6], cp)

	# ✅ Conectar señales de venta
	if GrillManager and not GrillManager.sale_made.is_connected(_on_SaleMade):
		GrillManager.sale_made.connect(_on_SaleMade)

	if Spawner and not Spawner.sale_made.is_connected(_on_SaleMade):
		Spawner.sale_made.connect(_on_SaleMade)

# ✅ Cada vez que se realiza una venta, actualizamos la gráfica
func _on_SaleMade():
	update_chart()

# ✅ Actualiza la gráfica con datos en tiempo real
func update_chart():
	# ✅ Actualizamos el tiempo en segundos
	tiempo_acumulado = Time.get_ticks_msec() / 1000.0

	# ✅ Datos globales
	var dinero: float = Inventory.player_money   # ✅ Ahora usamos el dinero real del jugador
	var tacos: float = Inventory.tacos_vendidos
	var dinero_invertido: float = Inventory.invested_money   # ✅ Dinero invertido
	clientes_totales = Inventory.tacos_vendidos + Inventory.ventas_fallidas

	# ✅ Predicción basada en el tiempo transcurrido
	var prediccion: float = predict_gain(tiempo_acumulado)

	# ✅ Pérdidas si predicción > dinero
	var perdidas: float = (prediccion - dinero) if prediccion > dinero else 0.0

	# ✅ Nueva predicción basada en el promedio de ventas
	var receta_pred: float = predict_by_ingredients()

	# ✅ Añadir un punto a cada serie
	f1.add_point(tiempo_acumulado, dinero)
	f2.add_point(tiempo_acumulado, perdidas)
	f3.add_point(tiempo_acumulado, tacos)
	f4.add_point(tiempo_acumulado, receta_pred)
	f6.add_point(tiempo_acumulado, dinero_invertido)   # ✅ Graficar dinero invertido

	# ✅ Guardar valores para regresión lineal (promedio)
	ventas_reales.append([tiempo_acumulado, tacos])

	# ✅ Si hay al menos 5 clientes atendidos, actualizamos la línea de promedio
	if clientes_totales >= 5:
		actualizar_promedio()

	# ✅ 🔥 Ajustar la escala del dinero y las demás líneas
	var min_y = min(f1.__y.min(), f6.__y.min()) - 10
	var max_y = max(f1.__y.max(), f6.__y.max()) + 20

	chart.set_x_domain(f1.__x.min(), f1.__x.max() + 10) 
	chart.set_y_domain(min_y, max_y)  

	# ✅ Redibujar la gráfica
	chart.queue_redraw()


# ✅ Calcular y actualizar la línea de tendencia después de 5 ventas
func actualizar_promedio():
	if ventas_reales.size() < 2:
		return

	var x_inicio = ventas_reales[0][0]
	var x_final = ventas_reales[-1][0]

	# ✅ Declarar valores fuera del bloque para que estén disponibles
	var escala_x = 1.0
	var escala_y = 1.0
	var b = 0.0

	# ✅ Media de X y Y
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
		b = y_mean - m * x_mean  

		# ✅ Limpiar datos antiguos de f5
		while f5.__x.size() > 0:
			f5.remove_point(0)

		# ✅ Crear la recta inclinada correctamente
		var x_range = x_final - x_inicio
		var y_range = abs(m * x_range)

		# ✅ Ajustar escala dinámica
		escala_x = max(10, x_range * 1.5)  # Evitar que se quede muy corta
		escala_y = max(5, y_range * 1.5)   # Evitar que sea muy plana

		# ✅ Dibujar la recta con pendiente visible
		f5.add_point(x_inicio, m * x_inicio + b)
		f5.add_point(x_final + escala_x, m * (x_final + escala_x) + b + escala_y)

	# ✅ 🔥 Ajuste de escala solo para la línea de tendencia
	var min_y = min(f1.__y.min(), b - 10)
	var max_y = max(f1.__y.max(), b + escala_y + 20)

	chart.set_x_domain(x_inicio, x_final + escala_x)
	chart.set_y_domain(min_y, max_y)  

	# ✅ Redibujar la gráfica
	chart.queue_redraw()

# ✅ Predicción basada en el promedio de ventas
func predict_gain(x: float) -> float:
	if clientes_totales < 5:
		return 5.0
	else:
		var ventas_totales = Inventory.tacos_vendidos
		var fallidas = Inventory.ventas_fallidas
		var m = 2.0 * (ventas_totales - fallidas) / clientes_totales
		var b = 5.0
		return m * x + b

func predict_by_ingredients() -> float:
	var tortillas = GrillManager.count_tortilla
	var carne = GrillManager.count_carne
	var verdura = GrillManager.count_verdura
	var salsa = GrillManager.count_salsa

	# Pesos de ejemplo
	var w1 = 5.0
	var w2 = 7.0
	var w4 = 3.0
	var w5 = 7.0
	var b = 10.0

	return (w1 * tortillas) + (w2 * carne) + (w4 * verdura) + (w5 * salsa) + b

# ✅ Activa o desactiva la gráfica con el botón
func _on_CheckButton_pressed():
	set_process(!is_processing())
