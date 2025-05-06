# GameProgress.gd
extends Resource
class_name GameProgress

const SAVE_PATH := "user://game_progress.tres"

@export var dinero_actual: int = 150
@export var dia_actual: int = 1
@export var ventas_totales: int = 0
@export var perdidas_totales: int = 0
@export var promedio: float = 0.0
@export var buenas_resenas: int = 0
@export var puntaje_acumulado: int = 0
@export var tutorial_completado := false  # 🆕 Nueva variable
@export var nivel_actual: int = 0  # Nuevo: guarda el índice del nivel
@export var tortillas_total: int = 0  # Nuevo: guarda el índice del nivel
@export var carne_total: int = 0  # Nuevo: guarda el índice del nivel
@export var verdura_total: int = 0  # Nuevo: guarda el índice del nivel
@export var salsa_total: int = 0  # Nuevo: guarda el índice del nivel
@export var taco_coins: int = 0  # Nuevo: guarda el índice del nivel
@export var nivel_no_se_ha_cambiado = true
var user_id: String = ""

func _ready() -> void:
	randomize()
	user_id = generar_uuid()
	print("🆔 ID generado para testeo:", user_id)


func generar_uuid() -> String:
	var chars = "abcdef0123456789"
	var uuid = ""
	for i in range(32):
		if i in [8, 12, 16, 20]:
			uuid += "-"
		uuid += chars[randi() % chars.length()]
	return uuid


func guardar() -> void:
	ResourceSaver.save(self, SAVE_PATH)
	
static func cargar() -> GameProgress:
	if ResourceLoader.exists(SAVE_PATH):
		return ResourceLoader.load(SAVE_PATH) as GameProgress
	return GameProgress.new()

func enviar_progreso_realtime():
	if Supabase.realtime == null:
		print("⚠️ Supabase Realtime no está listo.")
		return

	var payload := {
		"event": "UPDATE",
		"table": "progreso_jugador",
		"schema": "public",
		"data": {
			"id": user_id,
			"dinero_actual": Inventory.player_money,
			"dia_actual": Inventory.dia_actual,
			"ventas_totales": Inventory.tacos_vendidos,
			"perdidas_totales": Inventory.ventas_fallidas,
			"promedio": Inventory.promedio,
			"buenas_resenas": Inventory.total_reseñas,
			"tutorial_completado": true,
			"tortillas_total": Inventory.tortillas_total,
			"carne_total": Inventory.carne_total,
			"verdura_total": Inventory.verdura_total,
			"salsa_total": Inventory.salsa_total,
			"taco_coins": Inventory.taco_coins,
			"puntaje_acumulado": Inventory.puntaje_acumulado,
			"nivel_actual": LevelManager.current_level
		}
	}

	Supabase.realtime.send(payload)
