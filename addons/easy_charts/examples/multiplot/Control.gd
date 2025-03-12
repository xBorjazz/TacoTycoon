extends Control

@onready var chart: Chart = $VBoxContainer/Chart

# Estas 4 series se mostrarán en la gráfica:
var f1: Function   # Dinero Actual
var f2: Function   # Pérdidas
var f3: Function   # Ventas
var f4: Function   # Predicción basada en la receta

# Variable para controlar el tiempo (eje X)
var tiempo_acumulado: float = 0.0

func _ready():
	# Inicializamos arrays con un valor "ficticio" para evitar que estén vacíos
	var x_init: Array = [0.0, 1.0]
	var y1_init: Array = [0.0, 0.0]   # Dinero
	var y2_init: Array = [0.0, 0.0]   # Pérdidas
	var y3_init: Array = [0.0, 0.0]   # Ventas
	var y4_init: Array = [0.0, 0.0]   # Predicción Receta

	# Configuración de ChartProperties
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

	# Creamos las funciones (series) con esos valores iniciales
	f1 = Function.new(x_init, y1_init, "Dinero Actual", { 
		color = Color("#36a2eb"), 
		marker = Function.Marker.NONE, 
		type = Function.Type.AREA, 
		interpolation = Function.Interpolation.STAIR 
	})
	f2 = Function.new(x_init, y2_init, "Pérdidas", { 
		color = Color("#ff6384"), 
		marker = Function.Marker.CROSS 
	})
	f3 = Function.new(x_init, y3_init, "Ventas", { 
		color = Color.GREEN, 
		marker = Function.Marker.CIRCLE 
	})
	f4 = Function.new(x_init, y4_init, "Receta Pred.", {
		color = Color.YELLOW,
		marker = Function.Marker.SQUARE
	})

	# Ploteamos las 4 funciones
	chart.plot([f1, f2, f3, f4], cp)

	# ✅ Desactivamos _process para evitar que se ejecute en cada frame
	set_process(false)

	# ✅ Conectar señales con GrillManager (ya que es Autoload)
	if GrillManager:
		if not GrillManager.sale_made.is_connected(_on_SaleMade):
			GrillManager.sale_made.connect(_on_SaleMade)

	# ✅ Conectar también Spawner (si lo necesitas para la lógica de ventas)
	if Spawner:
		if not Spawner.sale_made.is_connected(_on_SaleMade):
			Spawner.sale_made.connect(_on_SaleMade)

# ✅ Cada vez que se realiza una venta, actualizamos la gráfica
func _on_SaleMade():
	update_chart()

# ✅ Actualiza la gráfica después de cada venta
func update_chart():
	tiempo_acumulado = Time.get_ticks_msec() / 1000.0

	# Datos globales
	var dinero: float = GlobalProgressBar.total_money_earned
	var tacos: float = Inventory.tacos_vendidos

	# Predicción en base al tiempo
	var prediccion: float = predict_gain(tiempo_acumulado)

	# Pérdidas si predicción > dinero
	var perdidas: float = (prediccion - dinero) if prediccion > dinero else 0.0

	# Nueva predicción basada en los ingredientes de la parrilla
	var receta_pred: float = predict_by_ingredients()

	# ✅ Añadimos un punto a cada serie
	f1.add_point(tiempo_acumulado, dinero)
	f2.add_point(tiempo_acumulado, perdidas)
	f3.add_point(tiempo_acumulado, tacos)
	f4.add_point(tiempo_acumulado, receta_pred)

	# ✅ Limitar a 100 puntos para evitar saturación
	if f1.__x.size() > 100:
		f1.remove_point(0)
		f2.remove_point(0)
		f3.remove_point(0)
		f4.remove_point(0)

	# ✅ Redibujamos la gráfica
	chart.queue_redraw()

# ✅ Predicción basada en el tiempo transcurrido
func predict_gain(x: float) -> float:
	return 5.0 * x + 10.0

# ✅ Predicción basada en los ingredientes de la parrilla
func predict_by_ingredients() -> float:
	# Obtenemos los valores desde el GrillManager (autoload)
	var tortillas = GrillManager.count_tortilla
	var carne     = GrillManager.count_carne
	var verdura   = GrillManager.count_verdura
	var salsa     = GrillManager.count_salsa

	# Pesos de ejemplo
	var w1 = 5.0   # Peso para tortillas
	var w2 = 7.0   # Peso para carne
	var w4 = 3.0   # Peso para verdura
	var w5 = 7.0   # Peso para salsa
	var b  = 10.0  # Sesgo

	# Fórmula: w1*tortillas + w2*carne + w4*verdura + w5*salsa + b
	return (w1 * tortillas) + (w2 * carne) + (w4 * verdura) + (w5 * salsa) + b

# ✅ Activa o desactiva la gráfica con el botón
func _on_CheckButton_pressed():
	set_process(not is_processing())
