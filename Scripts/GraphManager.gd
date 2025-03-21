extends Node  # O extends Control, si prefieres, pero "Node" basta

@onready var ganancias_button = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel2/GananciasButton")
@onready var prediccion_button = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel2/PrediccionButton")

@onready var ganancias_graph = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel2/Control/Control2")
@onready var prediccion_graph = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel2/Regresion/Regresion2")


func _ready():
	# Conectamos las señales de los botones
	ganancias_button.connect("pressed", Callable(self, "_on_GananciasButton_pressed"))
	prediccion_button.connect("pressed", Callable(self, "_on_PrediccionButton_pressed"))

	# Mostramos la gráfica de Ganancias por defecto y ocultamos la de Predicción
	ganancias_graph.visible = true
	prediccion_graph.visible = false

func _on_GananciasButton_pressed():
	# Muestra la gráfica de Ganancias, oculta la de Predicción
	ganancias_graph.visible = true
	prediccion_graph.visible = false

func _on_PrediccionButton_pressed():
	# Muestra la gráfica de Predicción (GD), oculta la de Ganancias
	ganancias_graph.visible = false
	prediccion_graph.visible = true
