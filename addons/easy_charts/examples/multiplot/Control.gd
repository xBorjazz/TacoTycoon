extends Control

@onready var chart: Chart = $VBoxContainer/Chart

# Estas 4 series se mostrarán en la gráfica:
var f1: Function   # Dinero Actual
var f2: Function   # Pérdidas
var f3: Function   # Ventas
var f4: Function   # Predicción basada en la receta

# Variable para controlar el tiempo (eje X)
var tiempo_acumulado: float = 0.0

# Referencia al nodo de la Receta
@onready var recipe_node = get_node("/root/Node2D/CanvasLayer/Gameplay/RecipeControl")

func _ready():
	# Inicializamos arrays con un valor "ficticio" para evitar que estén vacíos
	var x_init: Array = [0.0]
	var y1_init: Array = [0.0]   # Dinero
	var y2_init: Array = [0.0]   # Pérdidas
	var y3_init: Array = [0.0]   # Ventas
	var y4_init: Array = [0.0]   # Predicción Receta

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

	# Desactivamos _process() si no queremos actualizar en cada frame
	set_process(false)

	# Conectar la señal "sale_made" (o "day_started", etc.)
	var spawner_node = get_node("/root/Node2D/CanvasLayer/Gameplay/CharacterSpawner")
	spawner_node.connect("sale_made", Callable(self, "_on_SaleMade"))

func _on_SaleMade():
	# Cada vez que se realice una venta, actualizamos la gráfica
	update_chart()

func update_chart():
	# Actualizamos el tiempo en segundos
	tiempo_acumulado = Time.get_ticks_msec() / 1000.0

	# Datos globales
	var dinero: float = GlobalProgressBar.total_money_earned
	var tacos: float = Inventory.tacos_vendidos

	# Predicción (placeholder) en base al tiempo
	var prediccion: float = predict_gain(tiempo_acumulado)
	# Pérdidas si predicción > dinero
	var perdidas: float = (prediccion - dinero) if prediccion > dinero else 0.0

	# Nueva predicción basada en los ingredientes de la receta
	var receta_pred: float = predict_by_ingredients()

	# Añadimos un punto a cada serie
	f1.add_point(tiempo_acumulado, dinero)
	f2.add_point(tiempo_acumulado, perdidas)
	f3.add_point(tiempo_acumulado, tacos)
	f4.add_point(tiempo_acumulado, receta_pred)

	# Redibujamos la gráfica
	chart.queue_redraw()

# Función de predicción (placeholder) basado en x
func predict_gain(x: float) -> float:
	return 5.0 * x + 10.0

# Predicción en base a la receta (5 ingredientes)
func predict_by_ingredients() -> float:
	# Obtenemos los valores de la Receta
	var tortillas = 1#int(recipe_node.tortillas_label.text)
	var carne     = 1#int(recipe_node.carne_label.text)
	var cebolla   = 1#int(recipe_node.cebolla_label.text)
	var verdura   = 1#int(recipe_node.verdura_label.text)
	var salsa     = 1#int(recipe_node.salsa_label.text)

	# Pesos de ejemplo
	var w1 = 5.0
	var w2 = 7.0
	var w3 = 3.0
	var w4 = 3.0
	var w5 = 7.0
	var b  = 10.0

	# Fórmula: w1*tortillas + w2*carne + w3*cebolla + w4*verdura + w5*salsa + b
	return (w1 * tortillas) + (w2 * carne) + (w3 * cebolla) + (w4 * verdura) + (w5 * salsa) + b

func _process(delta: float):
	pass

func _on_CheckButton_pressed():
	set_process(not is_processing())
