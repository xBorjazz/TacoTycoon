extends Node

# ✅ Señal para actualizar misiones
signal mision_actualizada

# ✅ Objetivos de las misiones
var TACOS_OBJETIVO = 30
var DINERO_OBJETIVO = 500
var RESENAS_OBJETIVO = 5
var PROPINAS_OBJETIVO = 10
var INVESTED_OBJETIVO = 800

# ✅ Estado actual
var tacos_vendidos_mision = 0
var dinero_ganado_mision = 0
var buenas_resenas = 0
var total_reseñas = 0
var propinas_recibidas = 0
var taco_coins = 0
var promedio := 0.0
var dia_actual = 1
var soda_machine_unlocked : bool = false
var taco_dog_unlocked : bool = false


# Variables para los suministros
var tortillas_total = 0
var carne_total = 0
var verdura_total = 0
var cebolla_total = 0
var salsa_total = 0
var tacos_vendidos = 0
var tacos_especiales_vendidos = 0
var ventas_fallidas = 0

var costo_taco = 35
var buy_cost = 0.0  # Costo acumulado de las compras
var player_money = 150
var opponent_money = 150
var invested_money = 0

var puntaje_acumulado = 0


# Contadores individuales
var tortillas_normal = 0
var tortillas_medium = 0
var tortillas_large = 0

var carne_normal = 0
var carne_medium = 0
var carne_large = 0

var cebollas_normal = 0
var cebollas_medium = 0
var cebollas_large = 0

var verdura_normal = 0
var verdura_medium = 0
var verdura_large = 0

var salsa_normal = 0
var salsa_medium = 0
var salsa_large = 0


# Precios de los suministros
const PRECIOS = {
	"tortillas_normal": 10.00,
	"tortillas_medium": 20.00,
	"tortillas_large": 30.00,
	"carne_normal": 45.00,
	"carne_medium": 65.00,
	"carne_large": 120.00,
	"cebollas_normal": 10.00,
	"cebollas_medium": 30.00,
	"cebollas_large": 50.00,
	"salsa_normal": 15.00,
	"salsa_medium": 20.00,
	"salsa_large": 25.00,
	"verdura_normal": 5.00,
	"verdura_medium": 30.00,
	"verdura_large": 60.00
}

func _ready():
	var progreso := GameProgress.cargar()
	Inventory.total_reseñas = progreso.buenas_resenas
	Inventory.puntaje_acumulado = progreso.puntaje_acumulado
	actualizar_promedio_estrellas()

func actualizar_promedio_estrellas():
	if total_reseñas > 0:
		promedio = float(puntaje_acumulado) / total_reseñas
	else:
		promedio = 5.0

	print("⭐ Nuevo promedio:", promedio)
	var label = get_node_or_null("/root/Node2D/CanvasLayer/Gameplay/StarRatingLabel")
	if label:
		label.text = str("%.1f" % promedio)

# Funciones para SUMAR suministros
func add_suministro(categoria: String, tipo: String, cantidad: float) -> void:
	match tipo:
		"tortillas":
			add_tortillas(categoria, cantidad)
		"carne":
			add_carne(categoria, cantidad)
		"cebollas":
			add_cebollas(categoria, cantidad)
		"salsa":
			add_salsa(categoria, cantidad)
		"verdura":
			add_verdura(categoria, cantidad)
	
	var key = tipo + "_" + categoria
	buy_cost += PRECIOS.get(key, 0)  # Actualiza el costo acumulado
	SuppliesUi.actualizar_buy_cost()  # Actualiza el label de costo

func restar_suministro(categoria: String, tipo: String, cantidad: float) -> void:
	match tipo:
		"tortillas":
			restar_tortillas(categoria, cantidad)
		"carne":
			restar_carne(categoria, cantidad)
		"cebollas":
			restar_cebollas(categoria, cantidad)
		"salsa":
			restar_salsa(categoria, cantidad)
		"verdura":
			restar_verdura(categoria, cantidad)
	
	var key = tipo + "_" + categoria
	buy_cost -= PRECIOS.get(key, 0)  # Reduce el costo acumulado
	SuppliesUi.actualizar_buy_cost()

# ✅ Método para restar ingredientes globalmente
func restar_ingrediente(tipo):
	match tipo:
		"tortilla":
			if tortillas_total > 0:
				tortillas_total -= 1
		"carne":
			if carne_total > 0:
				carne_total -= 1
		"verdura":
			if verdura_total > 0:
				verdura_total -= 1
		"salsa":
			if salsa_total > 0:
				salsa_total -= 1

# Funciones para SUMAR suministros
func add_tortillas(categoria: String, cantidad: int) -> void:
	tortillas_total+= 0
	match categoria:
		"normal":
			tortillas_normal += cantidad
		"medium":
			tortillas_medium += cantidad
		"large":
			tortillas_large += cantidad

func add_carne(categoria: String, cantidad: float) -> void:
	carne_total+= 0
	match categoria:
		"normal":
			carne_normal += cantidad
		"medium":
			carne_medium += cantidad
		"large":
			carne_large += cantidad

func add_cebollas(categoria: String, cantidad: int) -> void:
	cebolla_total+= 0
	match categoria:
		"normal":
			cebollas_normal += cantidad
		"medium":
			cebollas_medium += cantidad
		"large":
			cebollas_large += cantidad

func add_salsa(categoria: String, cantidad: int) -> void:
	salsa_total+= 0
	match categoria:
		"normal":
			salsa_normal += cantidad
		"medium":
			salsa_medium += cantidad
		"large":
			salsa_large += cantidad
			
func add_verdura(categoria: String, cantidad: int) -> void:
	verdura_total+= 0
	match categoria:
		"normal":
			verdura_normal += cantidad
		"medium":
			verdura_medium += cantidad
		"large":
			verdura_large += cantidad

# Funciones para RESTAR suministros
func restar_tortillas(categoria: String, cantidad: int) -> void:
	tortillas_total-= 0
	match categoria:
		"normal":
			tortillas_normal -= cantidad
		"medium":
			tortillas_medium -= cantidad
		"large":
			tortillas_large -= cantidad

func restar_carne(categoria: String, cantidad: float) -> void:
	carne_total-= 0
	match categoria:
		"normal":
			carne_normal -= cantidad
		"medium":
			carne_medium -= cantidad
		"large":
			carne_large -= cantidad

func restar_cebollas(categoria: String, cantidad: int) -> void:
	cebolla_total-= 0
	match categoria:
		"normal":
			cebollas_normal -= cantidad
		"medium":
			cebollas_medium -= cantidad
		"large":
			cebollas_large -= cantidad

func restar_salsa(categoria: String, cantidad: int) -> void:
	salsa_total-= 0
	match categoria:
		"normal":
			salsa_normal -= cantidad
		"medium":
			salsa_medium -= cantidad
		"large":
			salsa_large -= cantidad

func restar_verdura(categoria: String, cantidad: int) -> void:
	verdura_total-= 0
	match categoria:
		"normal":
			verdura_normal -= cantidad
		"medium":
			verdura_medium -= cantidad
		"large":
			verdura_large -= cantidad

# Nueva función para restar los totales de ingredientes
func restar_totales(tortillas, carne, cebolla, verdura, salsa):
	tortillas_total -= tortillas
	carne_total -= carne
	cebolla_total -= cebolla
	verdura_total -= verdura
	salsa_total -= salsa

	# Asegurarse de que los totales no sean negativos
	tortillas_total = max(tortillas_total, 0)
	carne_total = max(carne_total, 0)
	cebolla_total = max(cebolla_total, 0)
	verdura_total = max(verdura_total, 0)
	salsa_total = max(salsa_total, 0)
	
	print("Restación de totales")

	# Actualizar UI o realizar otras acciones si es necesario
	SuppliesUi.actualizar_inventario_total()  # Suponiendo que tienes una función para actualizar la UI
